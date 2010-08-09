package com.burtbeckwith.grails.plugins.appinfo.hibernate

import org.hibernate.HibernateException
import org.hibernate.cfg.Configuration
import org.hibernate.mapping.Property
import org.hibernate.mapping.Table
import org.hibernate.tool.hbm2x.AbstractExporter
import org.hibernate.tool.hbm2x.ExporterException
import org.hibernate.tool.hbm2x.GenericExporter
import org.hibernate.tool.hbm2x.TemplateHelper
import org.hibernate.tool.hbm2x.TemplateProducer
import org.hibernate.tool.hbm2x.doc.DocHelper
import org.hibernate.tool.hbm2x.pojo.POJOClass
import org.springframework.util.FileCopyUtils

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class GrailsDocExporter extends AbstractExporter {

	private final String _dotExePath

	private DocHelper _docHelper
	private FakeDocFileManager _docFileManager
	private GrailsTemplateProducer _producer

	GrailsDocExporter(Configuration cfg, String dotExePath) {
		super(cfg, new File(''))
		_dotExePath = dotExePath
	}

	@Override
	void start() {
		setTemplateHelper(new TemplateHelper())
		setupTemplates()
		setupContext()
		_producer = new GrailsTemplateProducer(templateHelper, artifactCollector, false)

		doStart()
		cleanUpContext()
		setTemplateHelper(null)
		getArtifactCollector().formatFiles()
	}

	@Override
	void doStart() throws ExporterException {

		boolean graphsGenerated = generateDot()
		generateTablesIndex()
		generateTablesSummary(graphsGenerated)
		generateTablesDetails()
		generateTablesAllSchemasList()
		generateTablesAllTablesList()
		generateTablesSchemaTableList()
		generateTablesSchemaDetailedInfo()

		generateEntitiesIndex()
		generatePackageSummary(graphsGenerated)
		generateEntitiesDetails()
		generateEntitiesAllPackagesList()
		generateEntitiesAllEntitiesList()
		generateEntitiesPackageEntityList()
		generateEntitiesPackageDetailedInfo()
	}

	Map<String, String> export() {
		start()
		results
	}

	Map<String, String> getResults() { _producer.results }

	boolean generateDot() {
		if (!_dotExePath) {
			log.info 'Skipping entitygraph creation since dot.executable is empty or not-specified.'
			return false
		}

		try {
			def exporter = new DotExporter(getConfiguration())
			exporter.templateName = locateTemplate('entitygraph.dot', 'dot/')
			exporter.filePattern = 'entities/entitygraph.dot'
			exporter.artifactCollector = artifactCollector
			exporter.properties = getProperties()
			exporter.templatePath = templatePaths

			String entityDot = exporter.export()
			createImage entityDot, 'entities/entitygraph', 'png'
			createImage entityDot, 'entities/entitygraph', 'svg'
			createImage entityDot, 'entities/entitygraph', 'cmap'

			exporter.templateName = locateTemplate('tablegraph.dot', 'dot/')
			exporter.filePattern = 'tables/tablegraph.dot'
			exporter.properties = getProperties()

			String tableDot = exporter.export()
			createImage tableDot, 'tables/tablegraph', 'png'
			createImage tableDot, 'tables/tablegraph', 'svg'
			createImage tableDot, 'tables/tablegraph', 'cmap'

			return true
		}
		catch (IOException e) {
			throw new HibernateException('Problem while generating DOT graph for Configuration', e)
		}
	}

	static final String OS_NAME = System.getProperty('os.name')
	static final boolean IS_WINDOWS = OS_NAME.contains('Windows')

	private void createImage(String dot, String outFileName, String extension) throws IOException {
		String exeCmd = _dotExePath
		if (IS_WINDOWS) {
			// Windows needs " " around file names actually we do not
			// need it always, only when spaces are present
			// but it does not hurt to use them always
			exeCmd = '"' + exeCmd + '"'
		}
		exeCmd += ' -T' + extension

		Process p = Runtime.runtime.exec(exeCmd)
		def stdin = p.outputStream
		stdin.write dot.bytes
		stdin.flush()
		stdin.close()
		def result = FileCopyUtils.copyToByteArray(p.inputStream)
		p.waitFor()

		//		println "[STDERR] $p.err.text"
		if ('cmap' == extension) {
			result = new String(result)
		}

		_producer.results["/${outFileName}.$extension"] = result
	}

	@Override
	protected void setupContext() {
		getProperties().put('jdk5', useJdk5().toString())
		super.setupContext()
		_docHelper = new DocHelper(configuration, cfg2JavaTool)
		_docFileManager = new FakeDocFileManager(_docHelper, outputDirectory)

		templateHelper.putInContext('dochelper', _docHelper)
		templateHelper.putInContext('docFileManager', _docFileManager)
		templateHelper.putInContext('propertyHelper', this) // template will call getPropertyAccessorName()
	}

	// workaround for template bug
	String getPropertyAccessorName(Property prop) {
		String accessorName = prop.propertyAccessorName
		if (!accessorName) {
			// TODO fix
			accessorName = prop.name
			return 'get' + accessorName[0].toUpperCase() + accessorName[1..-1]
		}
		accessorName
	}

	/**
	 * Generate the index file of the table documentation.
	 */
	void generateTablesIndex() {
		def docFile = _docFileManager.tableIndexDocFile
		processTemplate([docFile: docFile], 'tables/index', docFile.file)
	}

	/**
	 * Generate the index file of the class documentation
	 */
	void generateEntitiesIndex() {
		def docFile = _docFileManager.classIndexDocFile
		processTemplate([docFile: docFile], 'entity/index', docFile.file)
	}

	/**
	 * Generate a file with an summary of all the tables.
	 *
	 * @param graphsGenerated
	 */
	void generateTablesSummary(boolean graphsGenerated) {
		def docFile = _docFileManager.tableSummaryDocFile

		def parameters = [docFile: docFile, graphsGenerated: graphsGenerated, tablegrapharea: '']
		if (graphsGenerated) {
			parameters.tablegrapharea = _producer.results['/tables/tablegraph.cmap']
		}

		processTemplate parameters, 'tables/summary', docFile.file
	}

	void generatePackageSummary(boolean graphsGenerated) {
		def docFile = _docFileManager.classSummaryFile
		List list = _docHelper.packages
		// remove 'All Classes'
		list.remove(0)
		def parameters = [docFile: docFile, packageList: list,
				graphsGenerated: graphsGenerated, entitygrapharea: '']
		if (graphsGenerated) {
			parameters.entitygrapharea = _producer.results['/entities/entitygraph.cmap']
		}

		processTemplate parameters, 'entity/summary', docFile.file
	}

	void generateTablesDetails() {
		for (Table table in configuration.tableMappings) {
			def docFile = _docFileManager.getTableDocFile(table)
			if (docFile) {
				def parameters = [docFile: docFile, table: table]
				processTemplate parameters, 'tables/table', docFile.file
			}
		}
	}

	void generateEntitiesDetails() {
		for (POJOClass pojoClass in _docHelper.classes) {
			pojoClass.getPropertiesForMinimalConstructor()
			def docFile = _docFileManager.getEntityDocFile(pojoClass)
			def parameters = [docFile: docFile, 'class': pojoClass, propertyHelper: this]
			processTemplate parameters, 'entity/entity', docFile.file
		}
	}

	/**
	 * Generates the html file containig list of packages (allpackages.html)
	 */
	void generateEntitiesAllPackagesList() {
		def docFile = _docFileManager.allPackagesDocFile
		List<?> list = _docHelper.packages
		// remove 'All Classes'
		list.remove(0)
		def parameters = [docFile: docFile, title: 'Package List', packageList: list]
		processTemplate parameters, 'entity/package-list', docFile.file
	}

	/**
	 * Generates the html file containing list of classes (allclases.html)
	 */
	void generateEntitiesAllEntitiesList() {
		def docFile = _docFileManager.allEntitiesDocFile
		def parameters = [docFile: docFile, title: 'All Entities', classList: _docHelper.classes]
		processTemplate parameters, 'entity/allEntity-list', docFile.file
	}

	/**
	 * generates the list of classes sepcific to package
	 */
	void generateEntitiesPackageEntityList() {
		for (String packageName in _docHelper.packages) {
			if (!packageName.equals(DocHelper.DEFAULT_NO_PACKAGE)) {
				def docFile = _docFileManager.getPackageEntityListDocFile(packageName)
				def parameters = [docFile: docFile, title: packageName,
						classList: _docHelper.getClasses(packageName)]
				processTemplate parameters, 'entity/perPackageEntity-list', docFile.file
			}
		}
	}

	/**
	 * Generates the html file containing list of classes and interfaces for
	 * given package
	 */
	void generateEntitiesPackageDetailedInfo() {
		List<?> packageList = _docHelper.packages
		packageList.remove(0)
		for (String packageName in packageList) {
			def summaryDocFile = _docFileManager.getPackageSummaryDocFile(packageName)
			def parameters = [docFile: summaryDocFile, 'package': packageName,
					classList: _docHelper.getClasses(packageName)]
			processTemplate parameters, 'entity/package-summary', summaryDocFile.file
		}
	}

	/**
	 * Generate a file with a list of all the schemas in the configuration.
	 */
	void generateTablesAllSchemasList() {
		def docFile = _docFileManager.allSchemasDocFile
		def parameters = [docFile: docFile, title: 'Schema List', schemaList: _docHelper.schemas]
		processTemplate parameters, 'tables/schema-list', docFile.file
	}

	/**
	 * Generate a file with a list of all the tables in the configuration.
	 */
	void generateTablesAllTablesList() {
		def docFile = _docFileManager.allTablesDocFile
		def parameters = [docFile: docFile, title: 'All Tables', tableList: _docHelper.tables]
		processTemplate parameters, 'tables/table-list', docFile.file
	}

	void generateTablesSchemaTableList() {
		for (String schemaName in _docHelper.schemas) {
			def docFile = _docFileManager.getSchemaTableListDocFile(schemaName)
			def parameters = [docFile: docFile, title: "Tables for $schemaName",
					tableList: _docHelper.getTables(schemaName)]
			processTemplate parameters, 'tables/table-list', docFile.file
		}
	}

	void generateTablesSchemaDetailedInfo() {
		for (String schemaName in _docHelper.schemas) {
			def summaryDocFile = _docFileManager.getSchemaSummaryDocFile(schemaName)

			def parameters = [docFile: summaryDocFile, schema: schemaName]
			processTemplate parameters, 'tables/schema-summary', summaryDocFile.file

			def tableListDocFile = _docFileManager.getSchemaSummaryDocFile(schemaName)

			parameters.docFile = tableListDocFile
			processTemplate parameters, 'tables/schema-summary', tableListDocFile.file
		}
	}

	private void processTemplate(Map<String, Object> parameters, String templateName, File outputFile) {
		templateName = locateTemplate(templateName, '')
		_producer.produce parameters, templateName, outputFile, templateName
	}

	private String locateTemplate(String templateName, String subfolder) {
		'/' + getClass().getPackage().name.replaceAll('\\.', '/') + '/' + subfolder + templateName + '.ftl'
	}

	@Override
	String getName() { 'hbm2doc' }

	boolean useJdk5() { false }

	DocHelper getDocHelper() { _docHelper }
	FakeDocFileManager getDocFileManager() { _docFileManager }
}
