class SimpleTest extends AbstractAppInfoWebTest {

	protected void setUp() {
		super.setUp()
		javaScriptEnabled = false
	}

	void testIndex() {
		get '/admin/manage'
		assertContentContains 'Attributes'
		assertContentContains 'Properties'
		assertContentContains 'Info'
		assertContentContains 'Hibernate'
	}

	void testApplicationInfo() {
		get '/admin/manage/applicationInfo'
		assertContentContains 'Context Attributes'
		assertContentContains 'Init Params'
		assertContentContains 'grails.plugins.appinfo.start_time '
	}

	void testRequestInfo() {
		get '/admin/manage/requestInfo'
		assertContentContains 'Request Scope'
		assertContentContains 'Request Info'
		assertContentContains 'Cookies'
		assertContentContains 'Headers'
		assertContentContains 'Attributes'
		assertContentContains 'getAuthType()'
	}

	void testSessionInfo() {
		get '/admin/manage/sessionInfo'
		assertContentContains 'Session Scope'
		assertContentContains 'Session Variables'
		assertContentContains 'Session Id'
	}

	void testDs() {
		get '/admin/manage/ds'
		assertContentContains 'Data Source (org.apache.commons.dbcp.BasicDataSource)'
	}

	void testGrailsProperties() {
		get '/admin/manage/grailsProperties'
		assertContentContains 'Grails Properties'
		assertContentContains 'dataSource.dbCreate'
	}

	void testSysProperties() {
		get '/admin/manage/sysProperties'
		assertContentContains 'System Properties'
		assertContentContains 'base.dir'
	}

	void testControllers() {
		get '/admin/manage/controllers'
		assertContentContains 'ErrorsController'
		assertContentContains 'com.burtbeckwith.appinfo_test.AdminManageController'
	}

	void testLogging() {
		get '/admin/manage/logging'
		assertContentContains 'Estimated log4j.xml'
		assertContentContains 'grails.app.codec.org.codehaus.groovy.grails.plugins.codecs.Base64Codec'
	}

	void testMemory() {
		get '/admin/manage/memory'
		assertContentContains 'Garbage Collect'
	}

	void testSessions() {
		get '/admin/manage/sessions'
		assertContentContains 'Invalidate'
	}

	void testSpring() {
		get '/admin/manage/spring'
		assertContentContains 'GrailsWebApplicationContext'
		assertContentContains 'com.burtbeckwith.appinfo_test.AdminManageController'
	}

	void testHibernate() {
		get '/admin/manage/hibernate'
		assertContentContains 'net.sf.ehcache.hibernate.EhCacheProvider'
		assertContentContains 'org.hibernate.dialect.HSQLDialect'
		assertContentContains 'com.burtbeckwith.appinfo_test.UserRole'
		assertContentContains 'DROP TABLE IF EXISTS database_update'
		assertContentContains 'gonzoBooks'
		assertContentContains 'maxBookTitleLength'
		assertContentContains 'com.burtbeckwith.appinfo_test.MyUserType'
	}

	void testHibernateEntityGraph() {
		get '/admin/manage/hibernateEntityGraph'
		assertStatus 200
		get '/admin/manage/hibernateEntityImage'
		assertStatus 200
	}

	void testHibernateTableImage() {
		get '/admin/manage/hibernateTableImage'
		assertStatus 200
		get '/admin/manage/hibernateTableGraph'
		assertStatus 200
	}

	void testHibernateCaching() {
		get '/admin/manage/hibernateCaching'
		assertContentContains 'ElementCountInMemory'
		assertContentContains 'StandardQueryCache'
		assertContentContains 'UpdateTimestampsCache'
		assertContentContains 'Role'
		assertContentContains 'Customer'
	}

	void testHibernateCacheGraphs() {
		get '/admin/manage/hibernateCacheGraphs?cacheName=com.burtbeckwith.appinfo_test.Role'
		assertStatus 200
	}

	void testHibernateStatistics() {
		get '/admin/manage/hibernateStatistics'
		assertContentContains 'Hibernate Statistics'
		assertContentContains 'Entity Statistics'
		assertContentContains 'Collection Statistics'
		assertContentContains 'Query Cache Statistics'
		assertContentContains 'closeStatementCount'
	}

	void testHibernateCollectionStatistics() {
		get '/admin/manage/hibernateCollectionStatistics?collection=com.burtbeckwith.appinfo_test.Author.books'
		assertContentContains 'Hibernate Collection Cache Statistics: com.burtbeckwith.appinfo_test.Author.books'
		assertContentContains 'fetchCount'
	}

	void testHibernateEntityStatistics() {
		get '/admin/manage/hibernateEntityStatistics?entity=com.burtbeckwith.appinfo_test.Role'
		assertContentContains 'Hibernate Entity Statistics: com.burtbeckwith.appinfo_test.Role'
		assertContentContains 'fetchCount'
	}

	void testHibernateEntityInfo() {
		get '/admin/manage/hibernateEntityInfo?entity=com.burtbeckwith.appinfo_test.User'
		assertContentContains 'com.burtbeckwith.appinfo_test'
		assertContentContains 'Entity : User'
		assertContentContains 'Class Name : com.burtbeckwith.appinfo_test.User'
		assertContentContains 'accountExpired'
		assertContentContains 'account_expired'
	}

	void testHibernateTableInfo() {
		get '/admin/manage/hibernateTableInfo?table=customer'
		assertContentContains 'create table customer '
		assertContentContains "Table 'customer'"
	}

	void testHibernateHbm() {
		get '/admin/manage/hibernateHbm?entity=com.burtbeckwith.appinfo_test.Role'
		assertContentContains '<class name="com.burtbeckwith.appinfo_test.Role" table="role" persister="org.codehaus.groovy.grails.orm.hibernate.persister.entity.GroovyAwareSingleTableEntityPersister">'
	}
}

