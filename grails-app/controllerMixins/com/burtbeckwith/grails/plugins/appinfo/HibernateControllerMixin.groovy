package com.burtbeckwith.grails.plugins.appinfo

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import org.hibernate.dialect.Dialect
import org.hibernate.dialect.HSQLDialect
import org.hibernate.mapping.PersistentClass
import org.hibernate.mapping.Table
import org.hibernate.stat.Statistics
import org.hibernate.tool.hbm2x.pojo.POJOClass

import org.springframework.beans.PropertyAccessorFactory
import org.springframework.orm.hibernate3.LocalSessionFactoryBean

import com.burtbeckwith.grails.plugins.appinfo.hibernate.GrailsDocExporter
import com.burtbeckwith.grails.plugins.appinfo.hibernate.GrailsHibernateMappingExporter

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class HibernateControllerMixin {

	def dataSource
	def grailsApplication
	def hibernateProperties
	def sessionFactory

	/**
	 * The Hibernate overview page.
	 */
	def hibernate = {
		def config = getConfiguration()

		def dialectClass = CH.config.dataSource.dialect ?: HSQLDialect
		if (!(dialectClass instanceof Class)) {
			dialectClass = Class.forName(dialectClass, true, Thread.currentThread().contextClassLoader)
		}

		render view: '/appinfo/hibernate',
		       model: [configuration: config,
		               mappings: config.createMappings(),
		               dialect: dialectClass.newInstance(),
		               hibernateProperties: hibernateProperties,
		               defaultSchema: hibernateProperties.'hibernate.default_schema',
		               defaultCatalog: hibernateProperties.'hibernate.default_catalog',
		               sessionFactory: sessionFactory] + tablesAndEntities(config)
	}

	/**
	 * Shows the Hibernate 2nd-level cache page.
	 */
	def hibernateCaching = {
		render view: '/appinfo/hibernateCaching',
		       model: [statistics: sessionFactory.statistics] + tablesAndEntities(getConfiguration())
	}

	def hibernateCacheGraphs = {

		String cacheName = params.cacheName
		String shortName = cacheName
		int index = shortName.lastIndexOf('.')
		if (index > -1) {
			shortName = shortName.substring(index + 1)
		}

		def statistics = sessionFactory.statistics

		def cacheStatistics = statistics.getSecondLevelCacheStatistics(cacheName)
		cacheName = fixCacheName(cacheName)

		def cacheData = ['Element Count In Memory': [cacheStatistics.elementCountInMemory],
		                 'Element Count On Disk': [cacheStatistics.elementCountOnDisk],
		                 'Hit Count': [cacheStatistics.hitCount],
		                 'Miss Count': [cacheStatistics.missCount],
		                 'Put Count': [cacheStatistics.putCount]]

		def cacheMemoryData = ['Size in Memory': [cacheStatistics.sizeInMemory]]

		render view: '/appinfo/hibernateCacheGraphs',
		       model: [name: cacheName, shortName: shortName,
		               cacheTypeNames: cacheData.keySet(), cacheData: cacheData,
		               cacheMemoryTypeNames: cacheMemoryData.keySet(), cacheMemoryData: cacheMemoryData] +
		               tablesAndEntities(getConfiguration())
	}

	/**
	 * Clears the specified cache.
	 */
	def hibernateClearCache = {
		def cacheRegion = sessionFactory.getSecondLevelCacheRegion(params.cacheName)
		if (cacheRegion) {
			cacheRegion.clear()
		}
		redirect action: 'hibernateCaching', controller: params.controller
	}

	def hibernateTableInfo = {
		def config = getConfiguration()
		def exporter = new GrailsDocExporter(config, lookupDotPath())
		def model
		doWithExporter exporter, {
			for (Table table in config.tableMappings) {
				if (table.name == params.table) {
					def docFile = exporter.docFileManager.getTableDocFile(table)
					if (docFile) {
						model = [docFile: docFile, table: table]
						break
					}
				}
			}
		}

		if (!model) {
			render "Table $params.table not found"
			return
		}

		def dialectClass = CH.config.dataSource.dialect ?: HSQLDialect
		if (!(dialectClass instanceof Class)) {
			dialectClass = Class.forName(dialectClass, true, Thread.currentThread().contextClassLoader)
		}

		model.dochelper = exporter.docHelper
		model.docFileManager = exporter.docFileManager
		model.dialect = dialectClass.newInstance()
		model.sessionFactory = sessionFactory
		model.defaultSchema = hibernateProperties.'hibernate.default_schema'
		model.defaultCatalog = hibernateProperties.'hibernate.default_catalog'

		render view: '/appinfo/hibernateTableInfo', model: model + tablesAndEntities(config)
	}

	def hibernateEntityInfo = {
		def config = getConfiguration()
		def exporter = new GrailsDocExporter(config, lookupDotPath())
		def model
		doWithExporter exporter, {
			for (POJOClass pojoClass in exporter.docHelper.classes) {
				pojoClass.getPropertiesForMinimalConstructor()
				if (pojoClass.qualifiedDeclarationName == params.entity) {
					def docFile = exporter.docFileManager.getEntityDocFile(pojoClass)
					if (docFile) {
						model = [docFile: docFile, 'clazz': pojoClass,
						         entity: config.createMappings().@classes[pojoClass.qualifiedDeclarationName]]
						break
					}
				}
			}
		}

		if (!model) {
			render "Entity $params.entity not found"
			return
		}

		model.propertyHelper = exporter
		model.dochelper = exporter.docHelper

		render view: '/appinfo/hibernateEntityInfo', model: model + tablesAndEntities(config)
	}

	def hibernateHbm = {
		def config = getConfiguration()
		def exporter = new GrailsHibernateMappingExporter(config)
		String entity = params.entity
		String hbm
		if (entity) {
			String key = entity.replaceAll('\\.', '/') + '.hbm.xml'
			hbm = exporter.export()[key]
		}

		render view: '/appinfo/hibernateHbm',
		       model: [hbm: hbm, entity: params.entity] + tablesAndEntities(config)
	}

	def hibernateEntityGraph = {
		def config = getConfiguration()
		def exporter = new GrailsDocExporter(config, lookupDotPath())
		String cmap
		doWithExporter exporter, {
			def files = exporter.results
			cmap = files['/entities/entitygraph.cmap']
			cmap = cmap.replaceAll('URL_ROOT', g.createLink(action: 'hibernateEntityInfo') + '?entity=')
		}

		render view: '/appinfo/hibernateEntityGraph',
		       model: [entitygrapharea: cmap] + tablesAndEntities(config)
	}

	def hibernateEntityImage = {
		def config = getConfiguration()
		def exporter = new GrailsDocExporter(config, lookupDotPath())
		doWithExporter exporter, {
			def files = exporter.results
			response.contentType = 'image/png'
			response.outputStream << files['/entities/entitygraph.png']
			response.outputStream.flush()
		}
	}

	def hibernateTableGraph = {
		def config = getConfiguration()
		def exporter = new GrailsDocExporter(config, lookupDotPath())
		String cmap
		doWithExporter exporter, {
			def files = exporter.results
			cmap = files['/tables/tablegraph.cmap']
			cmap = cmap.replaceAll('URL_ROOT', g.createLink(action: 'hibernateEntityGraph').toString())
		}

		render view: '/appinfo/hibernateTableGraph',
		       model: [tablegrapharea: cmap] + tablesAndEntities(config)
	}

	def hibernateTableImage = {
		def config = getConfiguration()
		def exporter = new GrailsDocExporter(config, lookupDotPath())
		doWithExporter exporter, {
			def files = exporter.results
			response.contentType = 'image/png'
			response.outputStream << files['/tables/tablegraph.png']
			response.outputStream.flush()
		}
	}

	def hibernateStatistics = {

		def wrapper = PropertyAccessorFactory.forBeanPropertyAccess(sessionFactory.statistics)
		def names = wrapper.propertyDescriptors.collect { it.name }.sort()
		names -= 'class'
		names -= 'queries'
		names -= 'startTime'
		names -= 'statisticsEnabled'

		def data = [:]
		for (name in names) {
			if (!name.endsWith('Names')) {
				data[name] = wrapper.getPropertyValue(name)
			}
		}

		render view: '/appinfo/hibernateStatistics',
		       model: [statistics: sessionFactory.statistics, data: data] +
		               tablesAndEntities(getConfiguration())
	}

	def hibernateStatisticsReset = {
		sessionFactory.statistics.clear()
		redirect action: 'hibernateStatistics', controller: params.controller
	}

	def hibernateStatisticsEnable = {
		boolean enable = params.enable?.toBoolean()
		sessionFactory.statistics.statisticsEnabled = enable
		redirect action: 'hibernateStatistics', controller: params.controller
	}

	def hibernateEntityStatistics = {
		String entity = params.entity

		def wrapper = PropertyAccessorFactory.forBeanPropertyAccess(
				sessionFactory.statistics.getEntityStatistics(entity))
		def names = wrapper.propertyDescriptors.collect { it.name }.sort()
		names -= 'class'
		names -= 'categoryName'

		def data = [:]
		for (name in names) {
			data[name] = wrapper.getPropertyValue(name)
		}

		render view: '/appinfo/hibernateEntityStatistics',
		       model: [entity: entity, statistics: sessionFactory.statistics, data: data] +
		               tablesAndEntities(getConfiguration())
	}

	def hibernateCollectionStatistics = {
		String collection = params.collection

		def wrapper = PropertyAccessorFactory.forBeanPropertyAccess(
				sessionFactory.statistics.getCollectionStatistics(collection))
		def names = wrapper.propertyDescriptors.collect { it.name }.sort()
		names -= 'class'
		names -= 'categoryName'

		def data = [:]
		for (name in names) {
			data[name] = wrapper.getPropertyValue(name)
		}

		render view: '/appinfo/hibernateCollectionStatistics',
		       model: [collection: collection, statistics: sessionFactory.statistics, data: data] +
		               tablesAndEntities(getConfiguration())
	}

	def hibernateQueryStatistics = {
		String query = params.query

		def wrapper = PropertyAccessorFactory.forBeanPropertyAccess(
				sessionFactory.statistics.getQueryStatistics(query))
		def names = wrapper.propertyDescriptors.collect { it.name }.sort()
		names -= 'class'
		names -= 'categoryName'

		def data = [:]
		for (name in names) {
			data[name] = wrapper.getPropertyValue(name)
		}

		render view: '/appinfo/hibernateQueryStatistics',
		       model: [query: query, statistics: sessionFactory.statistics, data: data] +
		               tablesAndEntities(getConfiguration())
	}

	private Map tablesAndEntities(config) {

		def tables = []
		for (Table table in config.tableMappings) {
			if (table.isPhysicalTable()) {
				tables << table
			}
		}

		def entities = []
		for (PersistentClass clazz in config.classMappings) {
			entities << clazz
		}

		[allTables: tables, allEntities: entities]
	}

	private getConfiguration() {
		grailsApplication.mainContext.getBean('&sessionFactory').configuration
	}

	private void doWithExporter(GrailsDocExporter exporter, Closure c) {
		LocalSessionFactoryBean.configTimeDataSourceHolder.set dataSource
		try {
			exporter.start()
			c()
		}
		finally {
			LocalSessionFactoryBean.configTimeDataSourceHolder.set null
		}
	}

	private String fixCacheName(String cacheName) {
		String fixed = cacheName
		fixed -= 'org.hibernate.cache.'
		fixed
	}

	private String lookupDotPath() {
		CH.config.grails.plugins.appinfo.dotPath ?: '/usr/bin/dot'
	}
}
