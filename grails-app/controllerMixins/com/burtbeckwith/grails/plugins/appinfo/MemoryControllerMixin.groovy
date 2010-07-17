package com.burtbeckwith.grails.plugins.appinfo

import java.lang.management.ManagementFactory
import java.lang.management.MemoryPoolMXBean
import java.lang.management.MemoryType
import java.text.DecimalFormat

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class MemoryControllerMixin {

	/**
	 * Calls garbage collection.
	 */
	def gc = {
		System.gc()
		redirect action: 'memory', controller: params.controller
	}

	/**
	 * Shows the memory usage page.
	 */
	def memory = {

		def heapPoolNames = []
		def heapNumbers = [:]
		generatePoolGraphData MemoryType.HEAP, heapPoolNames, heapNumbers

		def nonheapPoolNames = []
		def nonheapNumbers = [:]
		generatePoolGraphData MemoryType.NON_HEAP, nonheapPoolNames, nonheapNumbers

		long memoryTotal = Runtime.runtime.totalMemory()
		long memoryFree = Runtime.runtime.freeMemory()
		long memoryUsed = memoryTotal - memoryFree

		def memoryNames = ['Heap']
		def memoryNumbers = ['Free': [formatMB(memoryFree)],
		                     'Used': [formatMB(memoryUsed)]]

		render view: '/appinfo/memory',
		       model: [heapPoolNames: heapPoolNames,
		               heapSectionNames: heapNumbers.keySet(),
		               heapNumbers: heapNumbers,
		               nonheapPoolNames: nonheapPoolNames,
		               nonheapSectionNames: nonheapNumbers.keySet(),
		               nonheapNumbers: nonheapNumbers,
		               memoryNames: memoryNames,
		               memorySectionNames: memoryNumbers.keySet(),
		               memoryNumbers: memoryNumbers]
	}

	private void generatePoolGraphData(MemoryType type, poolNames, numbers) {

		numbers.Init = []
		numbers.Used = []
		numbers.Committed = []
		numbers.Max = []
						
		for (MemoryPoolMXBean bean : ManagementFactory.memoryPoolMXBeans) {
			if (bean.type == type) {
				numbers.Init << formatMB(bean.usage.init)
				numbers.Used << formatMB(bean.usage.used)
				numbers.Committed << formatMB(bean.usage.committed)
				numbers.Max << formatMB(bean.usage.max)
				poolNames << bean.name
			}
		}
	}

	private float formatMB(long value) {
		String formatted = new DecimalFormat('.000').format(value / 1024.0 / 1024.0)
		formatted.toFloat()
	}
}
