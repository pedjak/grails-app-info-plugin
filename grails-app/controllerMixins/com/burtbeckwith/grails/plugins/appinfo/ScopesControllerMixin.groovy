package com.burtbeckwith.grails.plugins.appinfo

import com.burtbeckwith.grails.plugins.dynamiccontroller.DynamicControllerManager
import com.burtbeckwith.grails.plugins.dynamiccontroller.DynamicDelegateController

import org.apache.commons.lang.time.DurationFormatUtils

import org.springframework.beans.BeanWrapper
import org.springframework.beans.PropertyAccessorFactory

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class ScopesControllerMixin {

	def grailsApplication

	/**
	 * Controller list page.
	 */
	def controllers = {
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
		render view: '/appinfo/controllers', model: [data: data]
	}

	/**
	 * Application-scope attribute page.
	 */
	def applicationInfo = {
		def attrNamesAndValues = [:]
		servletContext.attributeNames.each { name ->
			def value = servletContext.getAttribute(name)
			if (value?.getClass()?.isArray()) {
				value = Arrays.toString(value)
			}
			attrNamesAndValues[name] = value
		}

		def initParamNamesAndValues = [:]
		servletContext.initParameterNames.each { name ->
			def value = servletContext.getInitParameter(name)
			if (value?.getClass()?.isArray()) {
				value = Arrays.toString(value)
			}
			initParamNamesAndValues[name] = value
		}

		render view: '/appinfo/applicationInfo',
		       model: [servletContext: servletContext,
		               attrNamesAndValues: attrNamesAndValues,
		               initParamNamesAndValues: initParamNamesAndValues]
	}

	/**
	 * Session-scope attribute page.
	 */
	def sessionInfo = {
		render view: '/appinfo/sessionInfo'
	}

	/**
	 * Request-scope attribute page.
	 */
	def requestInfo = {
		def ignored = ['getCookies', 'getInputStream', 'getParameterMap',
		               'getAttributeNames', 'getContentLength', 'getHeaderNames', 'getLocales',
		               'getParameterNames', 'getReader', 'getSession']
		def props = [:]
		BeanWrapper beanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(request)
		for (pd in beanWrapper.propertyDescriptors.sort { it.name }) {
			if (pd.readMethod && !ignored.contains(pd.readMethod.name)) {
				props[pd.readMethod.name] = pd.readMethod.invoke(request)
			}
		}
		render view: '/appinfo/requestInfo', model: [props: props]
	}

	/**
	 * Shows the sessions page.
	 */
	def sessions = {
		def sessions = ContextListener.instance()?.sessions?.collect {
			[session: it,
			 age: DurationFormatUtils.formatDurationWords(it.lastAccessedTime - it.creationTime, true, true),
			 maxInactive: DurationFormatUtils.formatDurationWords(it.maxInactiveInterval * 1000, true, true)]
		}

		render view: '/appinfo/sessions', model: [sessions: sessions]
	}

	/**
	 * Manually invalidate a session. This will unauthenticate the user.
	 */
	def invalidateSession = {
		ContextListener.instance().getSession(params.sessionId)?.invalidate()
		redirect action: 'sessions', controller: params.controller
	}
}
