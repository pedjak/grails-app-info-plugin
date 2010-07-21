package com.burtbeckwith.grails.plugins.appinfo.hibernate

import org.hibernate.cfg.Configuration
import org.hibernate.tool.hbm2x.Cfg2HbmTool
import org.hibernate.tool.hbm2x.GenericExporter
import org.hibernate.tool.hbm2x.HibernateMappingGlobalSettings
import org.hibernate.tool.hbm2x.TemplateHelper
import org.hibernate.tool.hbm2x.pojo.POJOClass
import org.hibernate.util.StringHelper

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class GrailsHibernateMappingExporter extends GenericExporter {

	private GrailsTemplateProducer _producer

	HibernateMappingGlobalSettings globalSettings = new HibernateMappingGlobalSettings()

	GrailsHibernateMappingExporter(Configuration cfg) {
		super(cfg, new File(''))
		setTemplateName('hbm/hibernate-mapping.hbm.ftl')
		setFilePattern('{package-name}/{class-name}.hbm.xml')
	}

	@Override
	void start() {
		setTemplateHelper(new TemplateHelper())
		setupTemplates()
		super.setupContext()
		getTemplateHelper().putInContext('hmgs', globalSettings)
		_producer = new GrailsTemplateProducer(templateHelper, artifactCollector, true)
		doStart()
	}

	void doStart() {
		Cfg2HbmTool c2h = getCfg2HbmTool()
		Configuration cfg = getConfiguration()
		if (c2h.isImportData(cfg) && (c2h.isNamedQueries(cfg)) && (c2h.isNamedSQLQueries(cfg)) && (c2h.isFilterDefinitions(cfg))) {
			def producer = new GrailsTemplateProducer(getTemplateHelper(), getArtifactCollector(), false)
			producer.produce([:], 'com/burtbeckwith/grails/plugins/appinfo/hibernate/hbm/generalhbm.hbm.ftl',
				new File(getOutputDirectory(), 'GeneralHbmSettings.hbm.xml'), getTemplateName(), 'General Settings')
		}
		super.doStart()
	}

	Map<String, String> export() {
		start()
		_producer.results
	}

	@Override
	protected void exportPOJO(Map additionalContext, POJOClass element) {
		additionalContext.pojo = element
		additionalContext.clazz = element.decoratedObject
		String filename = resolveFilename(element)
		if (filename.endsWith('.java') && filename.indexOf('$') > -1) {
			log.warn("Filename for ${getClassNameForFile(element)} contains a \$. Innerclass generation is not supported.")
		}
		_producer.produce additionalContext, templateName, new File(filename), templateName
	}

	protected String getClassNameForFile(POJOClass element) {
		return StringHelper.unqualify(element.decoratedObject.entityName)
	}

	protected String getPackageNameForFile(POJOClass element) {
		return StringHelper.qualifier(element.decoratedObject.className)
	}

	protected void exportComponent(Map additionalContext, POJOClass element) {
		// we don't want components exported.
	}

	String getName() { 'hbm2hbmxml' }
}
