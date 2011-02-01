package grails.plugins.appinfo

import groovy.xml.StreamingMarkupBuilder

import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.LogManager

import org.springframework.beans.PropertyAccessorFactory

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class Log4jInfoService {

	boolean transactional = false

	static final Map LOG_LEVELS = [
		ALL:   Level.ALL,
		TRACE: Level.TRACE,
		DEBUG: Level.DEBUG,
		INFO:  Level.INFO,
		WARN:  Level.WARN,
		ERROR: Level.ERROR,
		FATAL: Level.FATAL,
		OFF:   Level.OFF]

	/**
	 * Partition loggers into groups: spring, hibernate, codec, controller, controllerMixin,
	 *	domain, filters, service, taglib, grails, groovy, and misc.
	 * Each subset is sorted by name.
	 *
	 * @return the partitioned loggers
	 */
	Map<String, List<Logger>> getLoggers() {

		def codec = []
		def controller = []
		def controllerMixin = []
		def domain = []
		def filters = []
		def service = []
		def taglib = []
		def grails = []
		def groovy = []
		def hibernate = []
		def spring = []
		def misc = []
		for (logger in sortedLoggers) {
			String name = logger.name
			def info = [name: name, level: logger.effectiveLevel.toString()]
			if (name.startsWith('grails.app.codec')) {
				codec << info
			}
			else if (name.startsWith('grails.app.controllerMixin')) {
				controllerMixin << info
			}
			else if (name.startsWith('grails.app.controller')) {
				controller << info
			}
			else if (name.startsWith('grails.app.domain')) {
				domain << info
			}
			else if (name.startsWith('grails.app.filters')) {
				filters << info
			}
			else if (name.startsWith('grails.app.service')) {
				service << info
			}
			else if (name.startsWith('grails.app.tagLib')) {
				taglib << info
			}
			else if (name == 'grails' || name.startsWith('grails.') || name.startsWith('org.codehaus.groovy.grails.')) {
				grails << info
			}
			else if (name == 'groovy.' || name.startsWith('groovy.') || name.startsWith('org.codehaus.groovy.')) {
				groovy << info
			}
			else if (name.startsWith('org.hibernate')) {
				hibernate << info
			}
			else if (name.startsWith('org.springframework')) {
				spring << info
			}
			else {
				misc << info
			}
		}

		[spring: spring, hibernate: hibernate, codec: codec, controller: controller,
		 controllerMixin: controllerMixin, domain: domain, filters: filters,
		 service: service, taglib: taglib, grails: grails, groovy: groovy, misc: misc]
	}

	/**
	 * Get all current loggers sorted by name.
	 * @return the loggers
	 */
	List<Logger> getSortedLoggers() {
		LogManager.currentLoggers.toList().sort { logger1, logger2 ->
			if (!logger1.name || !logger2.name) {
				return 0
			}
			logger1.name <=> logger2.name
		}
	}

	/**
	 * Set a logger's level.
	 *
	 * @param loggerName the logger name
	 * @param levelName one of ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF
	 */
	void setLogLevel(String loggerName, String levelName) {
		Level level = LOG_LEVELS[levelName]
		LogManager.getLogger(loggerName).level = level
	}

	/**
	 * Reverse engineer an approximation of the log4j.xml that corresponds to the current Log4j configuration.
	 *
	 * @return the XML
	 */
	String estimateLog4j() {

		Set allAppenders = []
		def rootLogger = LogManager.rootLogger
		if (rootLogger.allAppenders) {
			allAppenders.addAll rootLogger.allAppenders.toList()
		}

		for (logger in LogManager.currentLoggers) {
			if (logger.allAppenders) {
				allAppenders.addAll(logger.allAppenders.toList())
			}
		}

		def builder = new StreamingMarkupBuilder()
		builder.encoding = 'UTF-8'

		def xml = builder.bind {
			mkp.xmlDeclaration()
			mkp.declareNamespace(log4j: 'http://jakarta.apache.org/log4j/')
			log4j.configuration(debug: false) {

				for (app in allAppenders) {
					def values = extractValues(app, app.getClass().newInstance(), ['layout', 'errorHandler'])
					appender(name: app.name, 'class': app.getClass().name) {
						values.each { k, v ->
							param(name: k, value: v.toString())
						}
						if (app.layout) {
							values = extractValues(app.layout, app.layout.getClass().newInstance())
							layout('class': app.layout.getClass().name) {
								values.each { k, v ->
									param(name: k, value: v.toString())
								}
							}
						}
					}
				}

				// loggers that have an explicit level set, or at least one appender
				for (l in LogManager.currentLoggers.toList().sort { it.name }) {
					if (l.allAppenders || l.level == l.effectiveLevel) {
						def params = [name: l.name]
						if (!l.additivity) {
							params.additivity = false
						}
						logger(params) {
							if (l.level) {
								level(value: l.level.toString())
							}
							for (appender in l.allAppenders) {
								'appender-ref'(ref: appender.name)
							}
						}
					}
				}

				root {
					level(value: rootLogger.level.toString())
					for (appender in rootLogger.allAppenders) {
						'appender-ref'(ref: appender.name)
					}
				}
			}
		}

		def sw = new StringWriter()
		def printer = new XmlNodePrinter(new PrintWriter(sw), '   ')
		printer.preserveWhitespace = true
		printer.print new XmlParser().parseText(xml.toString())
		"""<?xml version='1.0' encoding='UTF-8' ?>
<!DOCTYPE log4j:configuration SYSTEM 'log4j.dtd'>

$sw"""
	}

	/**
	 * Extract all non-default getter values for an object excluding 'getClass()' and any names in ignoreNames.
	 * @param o the object
	 * @param newInstance a new instance for comparison; only values that differ from initial values are returned
	 * @return the values
	 */
	Map<String, Object> extractValues(o, newInstance, ignoreNames = []) {
		def values = [:]
		def wrapper = PropertyAccessorFactory.forBeanPropertyAccess(o)
		def newInstanceWrapper = PropertyAccessorFactory.forBeanPropertyAccess(newInstance)
		def names = wrapper.propertyDescriptors.collect { it.name }.sort()
		names -= 'class'
		for (name in names) {
			if (!ignoreNames.contains(name) && wrapper.isReadableProperty(name)) {
				def value = wrapper.getPropertyValue(name)
				if (value != null) {
					def newInstanceValue = newInstanceWrapper.getPropertyValue(name)
					// exclude default values to cut down on noise
					if (newInstanceValue != value) {
						values[name] = value
					}
				}
			}
		}
		values
	}
}
