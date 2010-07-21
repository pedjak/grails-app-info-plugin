package com.burtbeckwith.grails.plugins.appinfo

import grails.plugins.appinfo.Log4jInfoService

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class Log4jControllerMixin {

	def log4jInfoService

	/**
	 * Logging management page.
	 */
	def logging = {
		render view: '/appinfo/logging',
		       model: log4jInfoService.loggers +
				        [allLevels: Log4jInfoService.LOG_LEVELS.keySet(),
		               log4jXml: log4jInfoService.estimateLog4j()]
	}

	/**
	 * Ajax call to update the log level of the specified logger.
	 */
	def setLogLevel = {
		log4jInfoService.setLogLevel params.logger, params.level

		if (request.xhr) {
			render 'ok'
		}
		else {
			redirect action: 'logging', controller: params.controller
		}
	}
}
