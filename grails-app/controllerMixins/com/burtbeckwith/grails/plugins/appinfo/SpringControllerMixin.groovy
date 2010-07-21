package com.burtbeckwith.grails.plugins.appinfo

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class SpringControllerMixin {

	def grailsApplication
	def springInfoService

	/**
	 * Spring bean page.
	 */
	def spring = {

		def ctx = grailsApplication.mainContext
		def beanFactory = ctx.beanFactory

		def split = springInfoService.splitBeans()

		def beanInfo = [:]
		split.each { type, names ->
			beanInfo[type] = springInfoService.getBeanInfo(names, beanFactory)
		}

		def parentBeans = springInfoService.getBeanInfo(
				ctx.parent.beanDefinitionNames.toList(),
				ctx.parent.beanFactory)

		render view: '/appinfo/spring',
		       model: [ctx: ctx, beanInfo: beanInfo, parentBeans: parentBeans]
	}
}
