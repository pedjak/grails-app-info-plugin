import com.burtbeckwith.grails.plugins.appinfo.ContextListener
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class AppInfoGrailsPlugin {

	String version = '0.3'
	String grailsVersion = '1.1 > *'
	def dependsOn = ['dynamicController': '0.2 > *',
	                 'googleVisualization': '0.2.1 > *',
	                 'jquery': '1.4.2.5 > *']

	String author = 'Burt Beckwith'
	String authorEmail = 'burt@burtbeckwith.com'
	String title = 'Application Info'
	String description = "UI for inspecting various aspects of the application's configuration"
	String documentation = 'http://grails.org/plugin/app-info'

	def doWithWebDescriptor = { xml ->
		def useContextListener = CH.config.grails.plugins.appinfo.useContextListener
		if (useContextListener == null || (useContextListener instanceof Boolean && useContextListener)) {
			def filterMapping = xml.'filter-mapping'
			filterMapping[filterMapping.size() - 1] + {
				'listener' {
					'listener-class'(ContextListener.name)
				}
			}
		}
	}
}
