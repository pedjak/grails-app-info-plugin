package com.burtbeckwith.grails.plugins.appinfo

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class MemoryControllerMixin {

	def memoryInfoService

	/**
	 * Calls garbage collection.
	 */
	def gc = {
		System.gc()
		redirect action: 'memory', controller: params.controller
	}

	/**
	 * Shows the memory usage page.
	 */
	def memory = {
		render view: '/appinfo/memory', model: memoryInfoService.memoryInfo
	}
}
