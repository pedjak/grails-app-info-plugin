package com.burtbeckwith.grails.plugins.appinfo.hibernate

import org.hibernate.cfg.Configuration
import org.hibernate.tool.hbm2x.GenericExporter
import org.hibernate.tool.hbm2x.TemplateHelper

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class DotExporter extends GenericExporter {

	DotExporter(Configuration cfg) {
		super(cfg, new File(''))
	}

	String export() {
		setTemplateHelper(new TemplateHelper())
		setupTemplates()
		setupContext()
		def producer = new GrailsTemplateProducer(templateHelper, artifactCollector, false)
		producer.produce(Collections.emptyMap(), templateName,
				new File(outputDirectory, filePattern), templateName)
		producer.results.values().iterator().next()
	}
}
