package com.burtbeckwith.grails.plugins.appinfo

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class PropertiesControllerMixin {

	def dataSource
	def dataSourceUnproxied
	def propertiesInfoService

	/**
	 * Shows the grails properties.
	 */
	def grailsProperties = {
		render view: '/appinfo/grailsProperties',
		       model: [grailsProperties: new TreeMap(CH.config.flatten())]
	}

	/**
	 * Shows the system property management page.
	 */
	def sysProperties = {
		render view: '/appinfo/sysProperties',
		       model: [sysprops: new TreeMap(System.properties)]
	}

	/**
	 * Updates and/or adds system properties.
	 */
	def updateProperties = {
		for (String paramName : params.keySet()) {
			if (paramName.startsWith('PROPERTY_')) {
				String value = params[paramName]
				if (value != null) {
					paramName -= 'PROPERTY_'
					paramName = paramName.replaceAll('__DOT__', '.')
					System.setProperty paramName, value
				}
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
		render view: '/appinfo/ds',
		       model: [dataSourceClassName: propertiesInfoService.realDataSource.getClass().name,
		               propertyInfo: propertiesInfoService.datasourceInfo]
	}

	/**
	 * Updates data source attributes.
	 */
	def updateDataSource = {

		for (String paramName : params.keySet().sort()) { // sort to force a copy
			if (paramName.startsWith('_SETTER_set')) {
				fixBoolean params, paramName
			}
		}

		def values = [:]
		for (String paramName : params.keySet()) {
			if (paramName.startsWith('SETTER_set')) {
				def value = params[paramName]
				if (value != null) {
					paramName -= 'SETTER_'
					values[paramName] = value
				}
			}
		}

		propertiesInfoService.updateDataSource values

		redirect action: 'ds', controller: params.controller
	}

	protected void fixBoolean(params, String name) {
		String realParamName = name[1..-1]
		params[realParamName] = 'on' == params[realParamName]
	}
}
