package com.burtbeckwith.grails.plugins.appinfo

import groovy.xml.StreamingMarkupBuilder

import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.LogManager

import org.springframework.beans.PropertyAccessorFactory

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class Log4jControllerMixin {

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
	 * Logging management page.
	 */
	def logging = {
		def sortedLoggers = LogManager.currentLoggers.toList().sort { logger1, logger2 ->
			if (!logger1.name || !logger2.name) {
				return 0
			}
			logger1.name <=> logger2.name
		}

		def loggers = []
		for (logger in sortedLoggers) {
			loggers << [name: logger.name, level: logger.effectiveLevel.toString()]
		}

		render view: '/appinfo/logging',
		       model: [loggers: loggers, allLevels: LOG_LEVELS.keySet(), log4jXml: estimateLog4j()]
	}

	/**
	 * Ajax call to update the log level of the specified logger.
	 */
	def setLogLevel = {

		Level level = LOG_LEVELS[params.level]
		LogManager.getLogger(params.logger).level = level

		if (request.xhr) {
			render 'ok'
		}
		else {
			redirect action: 'logging', controller: params.controller
		}
	}

	private String estimateLog4j() {

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

				for (app in rootLogger.allAppenders) {
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

	private Map extractValues(o, newInstance, ignoreNames = []) {
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
