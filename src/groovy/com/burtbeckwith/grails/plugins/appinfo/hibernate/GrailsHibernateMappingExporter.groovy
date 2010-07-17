package com.burtbeckwith.grails.plugins.appinfo.hibernate

import org.hibernate.cfg.Configuration
import org.hibernate.tool.hbm2x.HibernateMappingExporter
import org.hibernate.tool.hbm2x.TemplateHelper
import org.hibernate.tool.hbm2x.pojo.POJOClass

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class GrailsHibernateMappingExporter extends HibernateMappingExporter {

	private GrailsTemplateProducer _producer

	GrailsHibernateMappingExporter(Configuration cfg) {
		super(cfg, new File(''))
	}

	@Override
	void start() {
		setTemplateHelper(new TemplateHelper())
		setupTemplates()
		setupContext()
		_producer = new GrailsTemplateProducer(templateHelper, artifactCollector, true)
		doStart()
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
}
