package com.burtbeckwith.grails.plugins.appinfo

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class IndexControllerMixin {

	/**
	 * Index page.
	 */
	def index = {
		render view: '/appinfo/index'
	}
}
