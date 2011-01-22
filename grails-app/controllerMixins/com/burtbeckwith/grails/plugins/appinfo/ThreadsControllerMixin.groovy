package com.burtbeckwith.grails.plugins.appinfo

/**
 * @author Vasily Bogdan
 */
class ThreadsControllerMixin {

	def threadsInfoService

	def threadDump = {
		render view: '/appinfo/threadDump',
		       model: [threadDump: threadsInfoService.getThreadDumpData()]
	}
}
