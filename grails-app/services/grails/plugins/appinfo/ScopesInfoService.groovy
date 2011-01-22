package grails.plugins.appinfo

import com.burtbeckwith.grails.plugins.appinfo.ContextListener

import com.burtbeckwith.grails.plugins.dynamiccontroller.DynamicControllerManager
import com.burtbeckwith.grails.plugins.dynamiccontroller.DynamicDelegateController

import org.apache.commons.lang.time.DurationFormatUtils

import org.springframework.beans.BeanWrapper
import org.springframework.beans.PropertyAccessorFactory

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class ScopesInfoService {

	boolean transactional = false

	def grailsApplication
	def servletContext

	static final List<String> REQUEST_IGNORED_NAMES = [
		'getCookies', 'getInputStream', 'getParameterMap',
		'getAttributeNames', 'getContentLength', 'getHeaderNames', 'getLocales',
		'getParameterNames', 'getReader', 'getSession']

	/**
	 * Builds a list of maps containing controller 'property' name, full name, and a sorted
	 * list of action names.
	 *
	 * @return the info
	 */
	List<Map<String, Object>> getControllerInfo() {
		def data = []
		for (controller in grailsApplication.controllerClasses) {
			if (controller.clazz.name == DynamicDelegateController.name) {
				continue
			}
			def controllerInfo = [:]
			controllerInfo.controller = controller.logicalPropertyName
			controllerInfo.controllerName = controller.fullName
			List actions = []
			BeanWrapper beanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(controller.newInstance())
			for (pd in beanWrapper.propertyDescriptors) {
				String closureClassName = controller.getPropertyOrStaticPropertyOrFieldValue(pd.name, Closure)?.class?.name
				if (closureClassName) {
					actions << pd.name
				}
			}
			actions.addAll DynamicControllerManager.getDynamicActions(controller.clazz.name)
			controllerInfo.actions = actions.sort()
			data << controllerInfo
		}
		data
	}

	/**
	 * Extract ServletContext (application-scope) attributes as a Map.
	 * @return  the values
	 */
	Map<String, Object> getServletContextValues() {
		def attrNamesAndValues = [:]
		servletContext.attributeNames.each { name ->
			attrNamesAndValues[name] = servletContext.getAttribute(name)
		}
		attrNamesAndValues
	}

	/**
	 * Extract ServletContext init params as a Map.
	 * @return  the values
	 */
	Map getServletContextInitParams() {
		def initParamNamesAndValues = [:]
		servletContext.initParameterNames.each { name ->
			initParamNamesAndValues[name] = servletContext.getInitParameter(name)
		}
		initParamNamesAndValues
	}

	/**
	 * Builds a map of valid request properties.
	 * @return the info
	 */
	Map<String, Object> getRequestInfo(request) {
		def props = [:]
		BeanWrapper beanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(request)
		for (pd in beanWrapper.propertyDescriptors.sort { it.name }) {
			if (pd.readMethod && !REQUEST_IGNORED_NAMES.contains(pd.readMethod.name)) {
				try {
					pd.readMethod.accessible = true
					props[pd.readMethod.name] = pd.readMethod.invoke(request)
				}
				catch (e) {
					props[pd.readMethod.name] = 'An error occurred reading the value'
				}
			}
		}
		props
	}

	/**
	 * Builds a list of maps containing each session, its age as a String, and its maxInactiveInterval as a String.
	 * @return the info
	 */
	List<Map<String, Object>> getSessionsInfo() {
		ContextListener.instance()?.sessions?.collect {
			[session: it,
			 age: DurationFormatUtils.formatDurationWords(it.lastAccessedTime - it.creationTime, true, true),
			 maxInactive: DurationFormatUtils.formatDurationWords(it.maxInactiveInterval * 1000, true, true)]
		}
	}

	/**
	 * Manually invalidate a session. This will unauthenticate the user.
	 * @param sessionId the session id
	 */
	void invalidateSession(String sessionId) {
		ContextListener.instance().getSession(sessionId)?.invalidate()
	}
}
