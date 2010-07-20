package com.burtbeckwith.grails.plugins.appinfo

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import org.springframework.beans.BeanWrapper
import org.springframework.beans.PropertyAccessorFactory
import org.springframework.beans.SimpleTypeConverter
import org.springframework.beans.TypeMismatchException

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class PropertiesControllerMixin {

	private static final SimpleTypeConverter TYPE_CONVERTER = new SimpleTypeConverter()

	def dataSource
	def dataSourceUnproxied

	/**
	 * Shows the grails properties.
	 */
	def grailsProperties = {
		render view: '/appinfo/grailsProperties', model: [grailsProperties: new TreeMap(CH.config.flatten())]
	}

	/**
	 * Shows the system property management page.
	 */
	def sysProperties = {
		render view: '/appinfo/sysProperties', model: [sysprops: new TreeMap(System.properties)]
	}

	/**
	 * Updates and/or adds system properties.
	 */
	def updateProperties = {
		for (String paramName : params.keySet()) {
			if (paramName.startsWith('PROPERTY_')) {
				String value = params[paramName]
				if (value == null) {
					continue
				}
				paramName -= 'PROPERTY_'
				paramName = paramName.replaceAll('__DOT__', '.')
				System.setProperty paramName, value
			}
		}

		String name = params.newProperty
		String value = params.newPropertyValue
		if (name && name.length() > 0 && value) {
			System.setProperty(name, value)
		}

		redirect action: 'sysProperties', controller: params.controller
	}

	/**
	 * Shows the data source management page.
	 */
	def ds = {

		def realDataSource = dataSourceUnproxied ?: dataSource

		def propertyInfo = []

		def allowedTypes = [int, boolean, String]

		BeanWrapper beanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(realDataSource)
		for (pd in beanWrapper.propertyDescriptors.sort { it.name }) {
			if (!pd.readMethod || !pd.writeMethod) {
				continue
			}

			Class<?> returnType = pd.readMethod.returnType
			if (!returnType.primitive && !Number.isAssignableFrom(returnType) && returnType != String) {
				continue
			}

			try {
				propertyInfo << [name: pd.name,
				                 value: pd.readMethod.invoke(realDataSource),
				                 set: pd.writeMethod.name,
				                 type: returnType.name]
			}
			catch (ignored) {}
		}

		render view: '/appinfo/ds', model: [dataSource: realDataSource, propertyInfo: propertyInfo]
	}

	/**
	 * Updates data source attributes.
	 */
	def updateDataSource = {

		def realDataSource = dataSourceUnproxied ?: dataSource

		def pds = [:]
		BeanWrapper beanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(realDataSource)
		for (pd in beanWrapper.propertyDescriptors) {
			if (pd.writeMethod) {
				pds[pd.writeMethod.name] = pd
			}
		}

		for (String paramName : params.keySet().sort()) { // sort to force a copy
			if (paramName.startsWith('_SETTER_set')) {
				fixBoolean params, paramName
			}
		}

		for (String paramName : params.keySet()) {
			if (!paramName.startsWith('SETTER_set')) {
				continue
			}

			def value = params[paramName]
			if (value == null) {
				continue
			}

			paramName -= 'SETTER_'
			def pd = pds[paramName]
			if (pd.writeMethod.parameterTypes.length == 1) {
				String oldValue = pd.readMethod.invoke(realDataSource)?.toString()
				if (value == oldValue) {
					continue
				}

				try {
					value = TYPE_CONVERTER.convertIfNecessary(value, pd.writeMethod.parameterTypes[0])
					pd.writeMethod.invoke realDataSource, value
				}
				catch (TypeMismatchException e) {
					// ignore
				}
			}
		}

		redirect action: 'ds', controller: params.controller
	}

	private void fixBoolean(params, String name) {
		String realParamName = name[1..-1]
		params[realParamName] = 'on' == params[realParamName]
	}
}
