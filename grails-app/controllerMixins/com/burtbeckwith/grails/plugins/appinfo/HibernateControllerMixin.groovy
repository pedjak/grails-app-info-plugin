package com.burtbeckwith.grails.plugins.appinfo

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class HibernateControllerMixin {

	def hibernateProperties
	def hibernateInfoService

	/**
	 * The Hibernate overview page.
	 */
	def hibernate = {
		def configuration = hibernateInfoService.configuration
		render view: '/appinfo/hibernate',
		       model: [configuration: configuration, // TODO needed?
		               mappings: configuration.createMappings(),
		               dialect: hibernateInfoService.dialectClass.newInstance(),
		               hibernateProperties: hibernateProperties] +
		               hibernateInfoService.tablesAndEntities
	}

	/**
	 * Shows the Hibernate 2nd-level cache page.
	 */
	def hibernateCaching = {
		render view: '/appinfo/hibernateCaching',
		       model: [statistics: hibernateInfoService.secondLevelCacheStatistics] +
		               hibernateInfoService.tablesAndEntities
	}

	def hibernateCacheGraphs = {

		String cacheName = params.cacheName
		String shortName = cacheName
		int index = shortName.lastIndexOf('.')
		if (index > -1) {
			shortName = shortName.substring(index + 1)
		}

		def cacheData = hibernateInfoService.getCacheData(cacheName)
		def cacheMemoryData = hibernateInfoService.getCacheMemoryData(cacheName)

		render view: '/appinfo/hibernateCacheGraphs',
		       model: [name: fixCacheName(cacheName),
		               shortName: shortName,
		               cacheTypeNames: cacheData.keySet(), cacheData: cacheData,
		               cacheMemoryTypeNames: cacheMemoryData.keySet(), cacheMemoryData: cacheMemoryData] +
		               hibernateInfoService.tablesAndEntities
	}

	/**
	 * Clears the specified cache.
	 */
	def hibernateClearCache = {
		hibernateInfoService.clearCache(params.cacheName)
		redirect action: 'hibernateCaching', controller: params.controller
	}

	def hibernateTableInfo = {
		Map<String, Object> info = hibernateInfoService.lookupTableInfo(params.table)
		if (!info) {
			render "Table $params.table not found"
			return
		}

		render view: '/appinfo/hibernateTableInfo', model: info + hibernateInfoService.tablesAndEntities
	}

	def hibernateEntityInfo = {
		Map<String, Object> info = hibernateInfoService.lookupEntityInfo(params.entity)
		if (!info) {
			render "Entity $params.entity not found"
			return
		}

		render view: '/appinfo/hibernateEntityInfo',
		       model: info + hibernateInfoService.tablesAndEntities
	}

	/**
	 * Generate the hbm.xml for the specified entity.
	 */
	def hibernateHbm = {
		render view: '/appinfo/hibernateHbm',
		       model: [hbm: hibernateInfoService.generateHbmXml(params.entity),
		               entity: params.entity] + hibernateInfoService.tablesAndEntities
	}

	/**
	 * Render the entity graph.
	 */
	def hibernateEntityImage = {
		response.contentType = 'image/png'
		response.outputStream << hibernateInfoService.generateEntityImage()
		response.outputStream.flush()
	}

	def hibernateEntityGraph = {
		String cmap = hibernateInfoService.generateEntityGraphCmap(
			g.createLink(action: 'hibernateEntityInfo').toString())
		render view: '/appinfo/hibernateEntityGraph',
				 model: [entitygrapharea: cmap] + hibernateInfoService.tablesAndEntities
	}

	def hibernateTableImage = {
		response.contentType = 'image/png'
		response.outputStream << hibernateInfoService.generateTableImage()
		response.outputStream.flush()
	}

	def hibernateTableGraph = {
		String cmap	= hibernateInfoService.generateTableGraphCmap(
			g.createLink(action: 'hibernateEntityGraph').toString())
		render view: '/appinfo/hibernateTableGraph',
		       model: [tablegrapharea: cmap] + hibernateInfoService.tablesAndEntities
	}

	def hibernateStatistics = {
		render view: '/appinfo/hibernateStatistics',
		       model: [stats: hibernateInfoService.lookupStatisticsValues(),
		               extra: hibernateInfoService.lookupSecondaryStatisticsValues(),
							statisticsEnabled: hibernateInfoService.statisticsEnabled] +
		               hibernateInfoService.tablesAndEntities
	}

	def hibernateStatisticsReset = {
		hibernateInfoService.resetStatistics()
		redirect action: 'hibernateStatistics', controller: params.controller
	}

	def hibernateStatisticsEnable = {
		hibernateInfoService.statisticsEnabled = params.enable?.toBoolean()
		redirect action: 'hibernateStatistics', controller: params.controller
	}

	def hibernateEntityStatistics = {
		render view: '/appinfo/hibernateEntityStatistics',
		       model: [entity: params.entity,
		               stats: hibernateInfoService.lookupEntityStatistics(params.entity),
		               statisticsEnabled: hibernateInfoService.statisticsEnabled] +
		               hibernateInfoService.tablesAndEntities
	}

	def hibernateCollectionStatistics = {
		render view: '/appinfo/hibernateCollectionStatistics',
		       model: [collection: params.collection,
		               stats: hibernateInfoService.lookupCollectionStatistics(params.collection),
		               statisticsEnabled: hibernateInfoService.statisticsEnabled] +
		               hibernateInfoService.tablesAndEntities
	}

	def hibernateQueryStatistics = {
		render view: '/appinfo/hibernateQueryStatistics',
		       model: [query: params.query,
		               stats: hibernateInfoService.lookupQueryStatistics(params.query),
		               statisticsEnabled: hibernateInfoService.statisticsEnabled] +
		               hibernateInfoService.tablesAndEntities
	}

	protected String fixCacheName(String cacheName) {
		String fixed = cacheName
		fixed -= 'org.hibernate.cache.'
		fixed
	}
}
