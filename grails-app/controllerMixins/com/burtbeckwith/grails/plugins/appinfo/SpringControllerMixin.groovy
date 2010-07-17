package com.burtbeckwith.grails.plugins.appinfo

import org.springframework.aop.support.AopUtils
import org.springframework.beans.factory.config.BeanDefinition

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class SpringControllerMixin {

	def grailsApplication

	/**
	 * Spring bean page.
	 */
	def spring = {

		def ctx = grailsApplication.mainContext
		def beanFactory = ctx.beanFactory

		def split = splitBeans(ctx, beanFactory)

		def beanInfo = [:]
		split.each { type, names ->
			beanInfo[type] = describeBeans(names, beanFactory)
		}

		def parentBeans = describeBeans(
				ctx.parent.beanDefinitionNames.toList(),
				ctx.parent.beanFactory)

		render view: '/appinfo/spring', model: [ctx: ctx, beanInfo: beanInfo, parentBeans: parentBeans]
	}

	private Map splitBeans(ctx, beanFactory) {
		def split = [Controller: [],
		             Domain: [],
		             Filter: [],
		             Service: [],
		             TagLib: []]

		def names = ctx.beanDefinitionNames as List
		for (String name : names) {
			if (name.startsWith('org.codehaus.groovy.grails')) {
				continue
			}

			BeanDefinition beanDefinition = beanFactory.getBeanDefinition(name)
			if (name.endsWith('ServiceClass')) {
				findServiceBeanName name, names, ctx, beanFactory, split.Service
			}
			else if (name.endsWith('DomainClass')) {
				findDomainClassBeanName name, names, ctx, beanFactory, split.Domain
			}
			else if (name.endsWith('TagLib')) {
				if (beanDefinition.singleton) {
					split.TagLib << name
				}
			}
			else if (name.endsWith('Controller')) {
				if (beanDefinition.prototype) {
					split.Controller << name
				}
			}
			else if (name.endsWith('Filters')) {
				if (beanDefinition.singleton) {
					split.Filter << name
				}
			}
		}

		names.removeAll split.Controller
		names.removeAll split.TagLib
		names.removeAll split.Service
		names.removeAll split.Domain
		names.removeAll split.Filter
		split.Other = names

		split
	}

	private void findServiceBeanName(String serviceClassName, names, ctx, beanFactory, typeNames) {
		String beanName = ctx.getBean(serviceClassName).propertyName
		if (names.contains(beanName)) {
			BeanDefinition beanDefinition = beanFactory.getBeanDefinition(beanName)
			if (beanDefinition.singleton) {
				typeNames << beanName
			}
		}
	}

	private void findDomainClassBeanName(String domainClassName, names, ctx, beanFactory, typeNames) {
		String beanName = domainClassName - 'DomainClass'
		if (names.contains(beanName)) {
			BeanDefinition beanDefinition = beanFactory.getBeanDefinition(beanName)
			if (beanDefinition.prototype) {
				typeNames << beanName
			}
		}
	}

	private describeBeans(names, beanFactory) {
		names.sort()

		def beanDescriptions = []

		for (String name : names) {
			BeanDefinition beanDefinition = beanFactory.getBeanDefinition(name)
			String className = buildClassName(beanFactory, name, beanDefinition)
			beanDescriptions << [name: name, className: className, scope: beanDefinition.scope ?: 'singleton',
			                     lazy: beanDefinition.lazyInit, isAbstract: beanDefinition.isAbstract(),
			                     parent: beanDefinition.parentName,
			                     beanClassName: beanDefinition.beanClassName]
		}

		beanDescriptions
	}

	private String buildClassName(beanFactory, String name, BeanDefinition beanDefinition) {

		if (beanDefinition.isAbstract()) {
			return '<i>abstract</i>'
		}

		if (beanDefinition.singleton) {
			def bean = beanFactory.getBean(name)
			if (AopUtils.isAopProxy(bean)) {
				return bean.getClass().name + " (" + AopUtils.getTargetClass(bean).name + ")"
			}
		}

		String beanClassName = beanDefinition.beanClassName
		if (!beanClassName && beanDefinition.factoryBeanName) {
			beanClassName = "Factory: $beanDefinition.factoryBeanName ($beanDefinition.factoryMethodName)"
		}
		beanClassName
	}
}
