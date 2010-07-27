package grails.plugins.appinfo

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import org.hibernate.cfg.Configuration
import org.hibernate.dialect.Dialect
import org.hibernate.dialect.HSQLDialect
import org.hibernate.mapping.PersistentClass
import org.hibernate.mapping.Table
import org.hibernate.stat.SecondLevelCacheStatistics
import org.hibernate.stat.Statistics
import org.hibernate.tool.hbm2x.pojo.POJOClass

import org.springframework.beans.PropertyAccessorFactory
import org.springframework.orm.hibernate3.LocalSessionFactoryBean

import com.burtbeckwith.grails.plugins.appinfo.hibernate.GrailsDocExporter
import com.burtbeckwith.grails.plugins.appinfo.hibernate.GrailsHibernateMappingExporter

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class HibernateInfoService {

	boolean transactional = false

	def dataSource
	def grailsApplication
	def hibernateProperties
	def sessionFactory

	/**
	 * Generate the entity graph.
	 * @return a png as a byte array
	 */
	byte[] generateEntityImage() {
		def exporter = new GrailsDocExporter(configuration, lookupDotPath())
		doWithExporter(exporter) {
			exporter.results['/entities/entitygraph.png']
		}
	}

	String generateEntityGraphCmap(String hibernateEntityInfoLink) {
		def exporter = new GrailsDocExporter(configuration, lookupDotPath())
		doWithExporter(exporter) {
			def files = exporter.results
			def cmap = files['/entities/entitygraph.cmap']
			cmap = cmap.replaceAll('URL_ROOT', hibernateEntityInfoLink + '?entity=')
			cmap
		}
	}

	/**
	 * Generate the table graph.
	 * @return a png as a byte array
	 */
	byte[] generateTableImage() {
		def exporter = new GrailsDocExporter(configuration, lookupDotPath())
		doWithExporter(exporter) {
			exporter.results['/tables/tablegraph.png']
		}
	}

	String generateTableGraphCmap(String entityGraphLink) {
		def exporter = new GrailsDocExporter(configuration, lookupDotPath())
		doWithExporter(exporter) {
			def files = exporter.results
			String cmap = files['/tables/tablegraph.cmap']
			cmap = cmap.replaceAll('URL_ROOT', entityGraphLink)
			cmap
		}
	}

	/**
	 * Generate the hbm.xml for the specified entity.
	 * @param entity the entity name
	 * @return the XML
	 */
	String generateHbmXml(String entity) {
		String key = entity.replaceAll('\\.', '/') + '.hbm.xml'
		new GrailsHibernateMappingExporter(configuration).export()[key]
	}

	Map<String, Integer> getCacheData(String cacheName) {
		def cacheStatistics = sessionFactory.statistics.getSecondLevelCacheStatistics(cacheName)
		['Element Count In Memory': [cacheStatistics.elementCountInMemory],
		 'Element Count On Disk': [cacheStatistics.elementCountOnDisk],
		 'Hit Count': [cacheStatistics.hitCount],
		 'Miss Count': [cacheStatistics.missCount],
		 'Put Count': [cacheStatistics.putCount]]
	}

	Map<String, Integer> getCacheMemoryData(String cacheName) {
		def cacheStatistics = sessionFactory.statistics.getSecondLevelCacheStatistics(cacheName)
		['Size in Memory': [cacheStatistics.sizeInMemory]]
	}

	Map<String, Object> lookupTableInfo(String tableName) {
		def exporter = new GrailsDocExporter(configuration, lookupDotPath())
		def model
		doWithExporter exporter, {
			for (Table table in configuration.tableMappings) {
				if (table.name == tableName) {
					def docFile = exporter.docFileManager.getTableDocFile(table)
					if (docFile) {
						model = [docFile: docFile, table: table]
						break
					}
				}
			}
		}

		if (!model) {
			return null
		}

		model.dochelper = exporter.docHelper
		model.docFileManager = exporter.docFileManager
		model.dialect = dialectClass.newInstance()
		model.sessionFactory = sessionFactory
		model.defaultSchema = hibernateProperties.'hibernate.default_schema'
		model.defaultCatalog = hibernateProperties.'hibernate.default_catalog'

		model
	}

	Map<String, Object> lookupEntityInfo(String name) {
		def exporter = new GrailsDocExporter(configuration, lookupDotPath())
		def model
		doWithExporter exporter, {
			for (POJOClass pojoClass in exporter.docHelper.classes) {
				pojoClass.getPropertiesForMinimalConstructor()
				if (pojoClass.qualifiedDeclarationName == name) {
					def docFile = exporter.docFileManager.getEntityDocFile(pojoClass)
					if (docFile) {
						model = [docFile: docFile, 'clazz': pojoClass,
									entity: configuration.createMappings().@classes[pojoClass.qualifiedDeclarationName]]
						break
					}
				}
			}
		}

		if (!model) {
			return null
		}

		model.propertyHelper = exporter
		model.dochelper = exporter.docHelper

		model
	}

	/**
	 * Get 'core' getter values from the Statistics instance.
	 * @return the data; keys are property names and values are getter values
	 */
	Map<String, Object> lookupStatisticsValues() {

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

		data
	}

	/**
	 * Get 'secondary' getter values from the Statistics instance.
	 * @return the data; keys are property names and values are getter values
	 */
	Map<String, Object> lookupSecondaryStatisticsValues() {

		def wrapper = PropertyAccessorFactory.forBeanPropertyAccess(sessionFactory.statistics)
		def names = wrapper.propertyDescriptors.collect { it.name }.sort()
		def data = [:]
		for (name in names) {
			if (name.endsWith('Names') || name in ['queries', 'startTime']) {
				data[name] = wrapper.getPropertyValue(name)
			}
		}

		data
	}

	boolean isStatisticsEnabled() {
		sessionFactory.statistics.statisticsEnabled
	}

	Map<String, Object> lookupEntityStatistics(String entityName) {
		lookupStatistics sessionFactory.statistics.getEntityStatistics(entityName)
	}

	Map<String, Object> lookupCollectionStatistics(String collectionName) {
		lookupStatistics sessionFactory.statistics.getCollectionStatistics(collectionName)
	}

	Map<String, Object> lookupQueryStatistics(String query) {
		lookupStatistics sessionFactory.statistics.getQueryStatistics(query)
	}

	protected Map<String, Object> lookupStatistics(statistics) {

		def wrapper = PropertyAccessorFactory.forBeanPropertyAccess(statistics)
		def names = wrapper.propertyDescriptors.collect { it.name }.sort()
		names -= 'class'
		names -= 'categoryName'

		def data = [:]
		for (name in names) {
			data[name] = wrapper.getPropertyValue(name)
		}

		data
	}

	Map getTablesAndEntities() {

		def tables = []
		for (Table table in configuration.tableMappings) {
			if (table.isPhysicalTable()) {
				tables << table
			}
		}

		def entities = []
		for (PersistentClass clazz in configuration.classMappings) {
			entities << clazz
		}

		[allTables: tables, allEntities: entities]
	}

	/**
	 * Get the configuration from the SessionFactory.
	 * @return  the configuration
	 */
	Configuration getConfiguration() {
		grailsApplication.mainContext.getBean('&sessionFactory').configuration
	}

	def doWithExporter(GrailsDocExporter exporter, Closure c) {
		LocalSessionFactoryBean.configTimeDataSourceHolder.set dataSource
		try {
			exporter.start()
			return c()
		}
		finally {
			LocalSessionFactoryBean.configTimeDataSourceHolder.set null
		}
	}

	/**
	 * Find the path to the GraphViz dot executable.
	 * @return  the path
	 */
	String lookupDotPath() {
		CH.config.grails.plugins.appinfo.dotPath ?: '/usr/bin/dot'
	}

	/**
	 * Clears the specified cache.
	 * @param cacheName the name
	 */
	void clearCache(String cacheName) {
		sessionFactory.getSecondLevelCacheRegion(cacheName)?.clear()
	}

	/**
	 * Resolve the Dialect.
	 * @return  the class
	 */
	Class<Dialect> getDialectClass() {
		Dialect.getDialect(configuration.getProperties()).getClass()
	}

	/**
	 * Reset all statistics.
	 */
	void resetStatistics() {
		sessionFactory.statistics.clear()
	}

	/**
	 * Set whether statistics collection is enabled.
	 * @param enabled if true collect statistics
	 */
	void setStatisticsEnabled(boolean enabled) {
		sessionFactory.statistics.statisticsEnabled = enabled
	}

	Map<String, SecondLevelCacheStatistics> getSecondLevelCacheStatistics() {
		Map<String, SecondLevelCacheStatistics> map = [:]
		for (String name in sessionFactory.statistics.secondLevelCacheRegionNames) {
			map[name] = sessionFactory.statistics.getSecondLevelCacheStatistics(name)
		}
		map
	}
}
