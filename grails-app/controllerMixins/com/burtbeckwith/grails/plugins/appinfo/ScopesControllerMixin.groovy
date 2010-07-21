package com.burtbeckwith.grails.plugins.appinfo

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class ScopesControllerMixin {

	def scopesInfoService

	/**
	 * Controller list page.
	 */
	def controllers = {
		render view: '/appinfo/controllers', model: [data: scopesInfoService.controllerInfo]
	}

	/**
	 * Application-scope attribute page.
	 */
	def applicationInfo = {
		def attrNamesAndValues = [:]
		scopesInfoService.servletContextValues.each { key, value ->
			if (value?.getClass()?.isArray()) {
				attrNamesAndValues[key] = Arrays.toString(value)
			}
			else {
				attrNamesAndValues[key] = value
			}
		}

		def initParamNamesAndValues = [:]
		scopesInfoService.servletContextInitParams.each { key, value ->
			if (value?.getClass()?.isArray()) {
				initParamNamesAndValues[key] = Arrays.toString(value)
			}
			else {
				initParamNamesAndValues[key] = value
			}
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
		render view: '/appinfo/requestInfo', model: [props: scopesInfoService.getRequestInfo(request)]
	}

	/**
	 * Shows the sessions page.
	 */
	def sessions = {
		render view: '/appinfo/sessions', model: [sessions: scopesInfoService.sessionsInfo]
	}

	/**
	 * Manually invalidate a session. This will unauthenticate the user.
	 */
	def invalidateSession = {
		scopesInfoService.invalidateSession params.sessionId
		redirect action: 'sessions', controller: params.controller
	}
}
