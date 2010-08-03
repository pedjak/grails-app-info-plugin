includeTargets << grailsScript('_GrailsBootstrap')

functionalTestPluginVersion = '1.2.7'
projectfiles = new File(basedir, 'webtest/projectFiles')
grailsHome = null
dotGrails = null
projectDir = null
appName = null
pluginVersion = null
pluginZip = null
testprojectRoot = null
deleteAll = false

target(createAppInfoTestApps: 'Creates test apps for functional tests') {

	def configFile = new File(basedir, 'testapps.config.groovy')
	if (!configFile.exists()) {
		die "$configFile.path not found"
	}

	new ConfigSlurper().parse(configFile.text).each { name, config ->
		echo "\nCreating app based on configuration $name: ${config.flatten()}\n"
		init name, config
		createApp()
		installPlugins()
		copySampleFiles()
		copyTests()
	}
}

private void init(String name, config) {

	pluginVersion = config.pluginVersion
	if (!pluginVersion) {
		die "pluginVersion wasn't specified for config '$name'"
	}

	pluginZip = new File(basedir, "grails-app-info-${pluginVersion}.zip")
	if (!pluginZip.exists()) {
		die "plugin $pluginZip.absolutePath not found"
	}

	grailsHome = config.grailsHome
	if (!new File(grailsHome).exists()) {
		die "Grails home $grailsHome not found"
	}

	projectDir = config.projectDir
	appName = 'appinfo-test-' + name
	testprojectRoot = "$projectDir/$appName"
	dotGrails = config.dotGrails
}

private void createApp() {

	ant.mkdir dir: projectDir

	deleteDir testprojectRoot
	deleteDir "$dotGrails/projects/$appName"

	callGrails(grailsHome, projectDir, 'dev', 'create-app') {
		ant.arg value: appName
	}
}

private void installPlugins() {

	// install plugins in local dir to make optional STS setup easier
	new File("$testprojectRoot/grails-app/conf/BuildConfig.groovy").withWriterAppend {
		it.writeLine 'grails.project.plugins.dir = "plugins"'
	}

	ant.mkdir dir: "${testprojectRoot}/plugins"

	callGrails(grailsHome, testprojectRoot, 'dev', 'install-plugin') {
		ant.arg value: "functional-test ${functionalTestPluginVersion}"
	}

	callGrails(grailsHome, testprojectRoot, 'dev', 'install-plugin') {
		ant.arg value: pluginZip.absolutePath
	}

	callGrails(grailsHome, testprojectRoot, 'dev', 'install-plugin') {
		ant.arg value: 'spring-security-core'
	}
	callGrails(grailsHome, testprojectRoot, 'dev', 's2-quickstart') {
		['com.burtbeckwith.appinfo_test', 'User', 'Role'].each { ant.arg value: it }
	}
}

private void copySampleFiles() {

	ant.mkdir dir: "${testprojectRoot}/src/groovy/com/burtbeckwith/appinfo_test"
	ant.copy file: "$projectfiles.path/MyUserType.groovy",
	         todir: "${testprojectRoot}/src/groovy/com/burtbeckwith/appinfo_test"

	ant.copy file: "$projectfiles.path/ErrorsController.groovy",
	         todir: "${testprojectRoot}/grails-app/controllers"

	ant.copy(todir: "${testprojectRoot}/grails-app/conf") {
		fileset(dir: "$projectfiles.path/conf")
	}

	ant.copy(todir: "${testprojectRoot}/grails-app/domain/com/burtbeckwith/appinfo_test", overwrite: true) {
		fileset(dir: "$projectfiles.path/domain")
	}

	ant.copy(todir: "${testprojectRoot}/grails-app/views") {
		fileset(dir: "$projectfiles.path/views")
	}

	new File("$testprojectRoot/grails-app/conf/Config.groovy").withWriterAppend { writer ->
		writer.write '''
//grails.plugins.springsecurity.controllerAnnotations.staticRules = [
//   '/adminmanage/**': ['ROLE_ADMIN']
//]

grails.plugins.dynamicController.mixins = [
	'com.burtbeckwith.grails.plugins.appinfo.IndexControllerMixin':       'com.burtbeckwith.appinfo_test.AdminManageController',
	'com.burtbeckwith.grails.plugins.appinfo.HibernateControllerMixin':   'com.burtbeckwith.appinfo_test.AdminManageController',
	'com.burtbeckwith.grails.plugins.appinfo.Log4jControllerMixin' :      'com.burtbeckwith.appinfo_test.AdminManageController',
	'com.burtbeckwith.grails.plugins.appinfo.SpringControllerMixin' :     'com.burtbeckwith.appinfo_test.AdminManageController',
	'com.burtbeckwith.grails.plugins.appinfo.MemoryControllerMixin' :     'com.burtbeckwith.appinfo_test.AdminManageController',
	'com.burtbeckwith.grails.plugins.appinfo.PropertiesControllerMixin' : 'com.burtbeckwith.appinfo_test.AdminManageController',
	'com.burtbeckwith.grails.plugins.appinfo.ScopesControllerMixin' :     'com.burtbeckwith.appinfo_test.AdminManageController'
]

grails.plugins.appinfo.useContextListener = true
'''
	}
}

private void copyTests() {
	ant.copy(todir: "${testprojectRoot}/test/functional") {
		fileset(dir: "$basedir/webtest/tests")
	}
}

private void deleteDir(String path) {
	if (new File(path).exists() && !deleteAll) {
		String code = "confirm.delete.$path"
		ant.input message: "$path exists, ok to delete?", addproperty: code, validargs: 'y,n,a'
		def result = ant.antProject.properties[code]
		if ('a'.equalsIgnoreCase(result)) {
			deleteAll = true
		}
		else if (!'y'.equalsIgnoreCase(result)) {
			ant.echo "\nNot deleting $path"
			exit 1
		}
	}

	ant.delete dir: path
}

private void die(String message) {
	ant.echo "\nERROR: $message"
	exit 1
}

private void callGrails(String grailsHome, String dir, String env, String action, extraArgs = null) {
	ant.exec(executable: "${grailsHome}/bin/grails", dir: dir, failonerror: 'true') {
		ant.env key: 'GRAILS_HOME', value: grailsHome
		ant.arg value: env
		ant.arg value: action
		extraArgs?.call()
	}
}

setDefaultTarget 'createAppInfoTestApps'
