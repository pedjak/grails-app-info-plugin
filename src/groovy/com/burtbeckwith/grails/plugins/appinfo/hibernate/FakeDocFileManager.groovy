package com.burtbeckwith.grails.plugins.appinfo.hibernate

import org.hibernate.mapping.Table
import org.hibernate.tool.hbm2x.doc.DocHelper
import org.hibernate.tool.hbm2x.pojo.POJOClass
import org.springframework.util.Assert

/**
 * Class used to manage the files created during the documentation generation
 * process. This manager is needed to manage references between files.
 *
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class FakeDocFileManager {

	/**
	 * Root Documentation Folder.
	 */
	private FakeDocFolder rootDocFolder

	/**
	 * The main index file for the documentation.
	 */
	private FakeDocFile mainIndexDocFile

	/**
	 * The header of the documentation.
	 */
	private FakeDocFile headerDocFile

	/**
	 * Folder for the utility files.
	 */
	private FakeDocFolder assetsDocFolder

	/**
	 * The Hibernate image.
	 */
	private FakeDocFile hibernateImageDocFile

	/**
	 * The CSS stylesheet file.
	 */
	private FakeDocFile cssStylesDocFile

	/**
	 * Root Folder for the Table documentation.
	 */
	private FakeDocFolder rootTablesDocFolder

	/**
	 * Root Folder for Class doccumentation
	 */
	private FakeDocFolder rootEntitiesDocFolder

	/**
	 * Class index FakeDocFile
	 */
	private FakeDocFile classIndexDocFile

	/**
	 * Class Summary FakeDocFile
	 */
	private FakeDocFile entitySummaryDocFile

	/**
	 * All packages FakeDocFile allpackages.html
	 */
	private FakeDocFile allPackagesDocFile

	/**
	 * All classes FakeDocFile allclases.html
	 */
	private FakeDocFile allEntitiesDocFile

	/**
	 * Table index FakeDocFile.
	 */
	private FakeDocFile tableIndexDocFile

	/**
	 * Table summary FakeDocFile.
	 */
	private FakeDocFile tableSummaryDocFile

	/**
	 * All Schemas FakeDocFile.
	 */
	private FakeDocFile allSchemasDocFile

	/**
	 * All Tables FakeDocFile.
	 */
	private FakeDocFile allTablesDocFile

	/**
	 * Map with the doc files for the tables. The keys are the Table objects and
	 * the values are the FakeDocFile instances.
	 */
	private Map<Table, FakeDocFile> tableDocFiles = [:]

	/**
	 * Map with the FakeDocFile for classes. The keys are the POJOClass objects and
	 * the values are the FakeDocFile instances.
	 */
	private Map<POJOClass, FakeDocFile> entityDocFiles = [:]

	/**
	 * Map with the schema summary DocFiles keyed by Schema FQN.
	 */
	private Map<String, FakeDocFile> schemaSummaryDocFiles = [:]

	/**
	 * Map with the package summary DocFiles keyed by package name
	 */
	private Map<String, FakeDocFile> packageSummaryDocFiles = [:]

	/**
	 * Map with the schema table lists DocFiles keyed by Schema FQN.
	 */
	private Map<String, FakeDocFile> schemaTableListDocFiles = [:]

	/**
	 * Map with package class lists DocFiles keyed by package name
	 */
	private Map<String, FakeDocFile> packageEntityListDocFile = [:]

	FakeDocFolder getRootDocFolder() { rootDocFolder }

	/**
	 * Constructor.
	 *
	 * @param docHelper  the doc helper.
	 * @param rootFolder  the root folder for the documentation.
	 */
	FakeDocFileManager(DocHelper docHelper, File rootFolder) {
		rootDocFolder = new FakeDocFolder(rootFolder)
		mainIndexDocFile = new FakeDocFile('index.html', rootDocFolder)
		headerDocFile = new FakeDocFile('header.html', rootDocFolder)
		assetsDocFolder = new FakeDocFolder('assets', rootDocFolder)
		hibernateImageDocFile = new FakeDocFile('hibernate_logo.gif', assetsDocFolder)
		cssStylesDocFile = new FakeDocFile('doc-style.css', assetsDocFolder)
		rootEntitiesDocFolder = new FakeDocFolder('entities', rootDocFolder)
		classIndexDocFile = new FakeDocFile('index.html', rootEntitiesDocFolder)
		entitySummaryDocFile = new FakeDocFile('summary.html', rootEntitiesDocFolder)
		allPackagesDocFile = new FakeDocFile('allpackages.html', rootEntitiesDocFolder)
		allEntitiesDocFile = new FakeDocFile('allentities.html', rootEntitiesDocFolder)
		rootTablesDocFolder = new FakeDocFolder('tables', rootDocFolder)
		tableIndexDocFile = new FakeDocFile('index.html', rootTablesDocFolder)
		tableSummaryDocFile = new FakeDocFile('summary.html', rootTablesDocFolder)
		allSchemasDocFile = new FakeDocFile('allschemas.html', rootTablesDocFolder)
		allTablesDocFile = new FakeDocFile('alltables.html', rootTablesDocFolder)

		Map<String, FakeDocFolder> schemaFolders = [:]

		for (String packageName in docHelper.packages) {
			FakeDocFolder packageFolder = null
			FakeDocFolder theRoot = rootEntitiesDocFolder
			if (!packageName.equals(DocHelper.DEFAULT_NO_PACKAGE)) {
				String[] packagesArr = packageName.split('\\.')

				for (int count = 0; count < packagesArr.length; count++) {
					packageFolder = new FakeDocFolder(packagesArr[count], theRoot)
					theRoot = packageFolder
				}

				FakeDocFile packageSummaryDocFile = new FakeDocFile('summary.html', packageFolder)
				packageSummaryDocFiles.put(packageName, packageSummaryDocFile)
				packageEntityListDocFile.put(packageName, new FakeDocFile('entities.html', packageFolder))
			}
			else {
				packageFolder = rootEntitiesDocFolder
			}

			for (POJOClass pc in docHelper.getClasses(packageName)) {
				String classFileName = pc.declarationName + '.html'
				FakeDocFile classDocFile = new FakeDocFile(classFileName, packageFolder)
				entityDocFiles.put(pc, classDocFile)
			}
		}

		for (String schemaName in docHelper.schemas) {
			FakeDocFolder schemaFolder = new FakeDocFolder(schemaName, rootTablesDocFolder)
			schemaFolders.put(schemaName, schemaFolder)
			FakeDocFile schemaSummaryDocFile = new FakeDocFile('summary.html', schemaFolder)
			schemaSummaryDocFiles.put(schemaName, schemaSummaryDocFile)
			FakeDocFile tableListDocFile = new FakeDocFile('tables.html', schemaFolder)
			schemaTableListDocFiles.put(schemaName, tableListDocFile)

			for (Table table in docHelper.getTables(schemaName)) {
				if (table.isPhysicalTable()) {
					tableDocFiles[table] = new FakeDocFile(table.name + '.html', schemaFolder)
				}
			}
		}
	}

	/**
	 * @return the FakeDocFolder for the helper files
	 */
	FakeDocFolder getAssetsDocFolder() { assetsDocFolder }

	/**
	 * @return the FakeDocFile for the CSS definitions.
	 */
	FakeDocFile getCssStylesDocFile() { cssStylesDocFile }

	/**
	 * @return the FakeDocFile for the header.
	 */
	FakeDocFile getHeaderDocFile() { headerDocFile }

	/**
	 * @return the FakeDocFile for the Hibernate Image
	 */
	FakeDocFile getHibernateImageDocFile() { hibernateImageDocFile }

	/**
	 * @return the FakeDocFile for the main index.
	 */
	FakeDocFile getMainIndexDocFile() { mainIndexDocFile }

	/**
	 * @return the table index FakeDocFile.
	 */
	FakeDocFile getTableIndexDocFile() { tableIndexDocFile }

	/**
	 * @return class index FakeDocFile
	 */
	FakeDocFile getClassIndexDocFile() { classIndexDocFile }

	/**
	 * @return summary index FakeDocFile
	 */
	FakeDocFile getClassSummaryFile() { entitySummaryDocFile }

	/**
	 * @return the FakeDocFile responsible for generating allpackages.html
	 */
	FakeDocFile getAllPackagesDocFile() { allPackagesDocFile }

	/**
	 * @return  the FakeDocFile responsible for generating allclasses.html
	 */
	FakeDocFile getAllEntitiesDocFile() { allEntitiesDocFile }

	/**
	 * Returns the FakeDocFile responsible to generate classes.html corresponding to
	 * packageName passed.
	 *
	 * @param packageName
	 *           Package name which acts as key to get FakeDocFile value object from
	 *           packageEntityListDocFile
	 * @return FakeDocFile for classes.html
	 */
	FakeDocFile getPackageEntityListDocFile(String packageName) {
		packageEntityListDocFile.get(packageName)
	}

	/**
	 * @return the table summary FakeDocFile.
	 */
	FakeDocFile getTableSummaryDocFile() { tableSummaryDocFile }

	/**
	 * @return the all schemas FakeDocFile.
	 */
	FakeDocFile getAllSchemasDocFile() { allSchemasDocFile }

	/**
	 * @return the all tables FakeDocFile.
	 */
	FakeDocFile getAllTablesDocFile() { allTablesDocFile }

	/**
	 * @param table the Table.
	 * @return the FakeDocFile for the specified Table.
	 */
	FakeDocFile getTableDocFile(Table table) { tableDocFiles.get(table) }

	/**
	 * Get the FakeDocFile corresponding to POJOClass. But if the POJOClass is
	 * ComponentPOJO, it is created on fly and we are not implementing .equals
	 * method hence get by getQualifiedDeclarationName.
	 *
	 * @param pc
	 *           FakeDocFile corresponding to this POJOClass
	 * @return FakeDocFile
	 */
	FakeDocFile getEntityDocFileByDeclarationName(POJOClass pc) {
		FakeDocFile df = getEntityDocFile(pc)
		String pcQualifiedDeclarationName = pc.qualifiedDeclarationName
		String pojoClassQualifiedDeclarationName
		if (!df) {
			for (POJOClass pojoClass in entityDocFiles.keySet()) {
				pojoClassQualifiedDeclarationName = pojoClass.qualifiedDeclarationName
				if (pcQualifiedDeclarationName.equals(pojoClassQualifiedDeclarationName)) {
					df = entityDocFiles.get(pojoClass)
					break
				}
			}
		}

		return df
	}

	/**
	 * Returns the FakeDocFile responsible to generate the .html for each classes.
	 *
	 * @param pc
	 *           The FakeDocFile corresponding to this pc is retrieved from
	 *           entityDocFiles
	 * @return FakeDocFile
	 */
	FakeDocFile getEntityDocFile(POJOClass pc) { entityDocFiles.get(pc) }

	/**
	 * Return the summary FakeDocFile for the specified schema FQN.
	 *
	 * @param schemaName  the name of the schema.
	 * @return the FakeDocFile.
	 */
	FakeDocFile getSchemaSummaryDocFile(String schemaName) { schemaSummaryDocFiles.get(schemaName) }

	/**
	 * get FakeDocFile responsible to generate summary.html for corresponding
	 * packageName passed
	 *
	 * @param packageName
	 *           FakeDocFile corresponding to this packagename is retrieved from
	 *           packageSummaryDocFiles
	 * @return FakeDocFile
	 */
	FakeDocFile getPackageSummaryDocFile(String packageName) {
		packageSummaryDocFiles.get(packageName)
	}

	/**
	 * Return the Table List FakeDocFile for the specified schema FQN.
	 *
	 * @param schemaName  the name of the schema.
	 * @return the FakeDocFile.
	 */
	FakeDocFile getSchemaTableListDocFile(String schemaName) {
		schemaTableListDocFiles.get(schemaName)
	}

	/**
	 * Return the relative reference between the specified files.
	 *
	 * @param from  the origin.
	 * @param to  the target.
	 * @throws IllegalArgumentException  if any parameter is null.
	 */
	String getRef(FakeDocFile from, FakeDocFile to) {
		Assert.notNull(from, 'From cannot be null.')
		Assert.notNull(to, 'To cannot be null.')
		from.buildRefTo(to)
	}
}
