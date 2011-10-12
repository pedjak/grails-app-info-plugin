package grails.plugins.appinfo

import java.lang.management.ThreadMXBean
import java.lang.management.ManagementFactory
import java.lang.management.ThreadInfo

/**
 * @author Vasily Bogdan
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class ThreadsInfoService {

	static transactional = false

	private static final ThreadMXBean threadManagementBean = ManagementFactory.getThreadMXBean()

	private static double nanosToMilis(long ns) {
		ns / ((double) 1000000)
	}

	def getThreadDumpData() {
		Map threadDump = [threadCount: threadManagementBean.threadCount,
		                  peakThreadCount: threadManagementBean.peakThreadCount,
		                  daemonThreadCount: threadManagementBean.daemonThreadCount]

		ThreadInfo[] threadInfos = getAllThreadInfos()

		for (ThreadInfo threadInfo in threadInfos) {
			if (threadManagementBean.threadCpuTimeSupported) {
				def cpuTime = nanosToMilis(threadManagementBean.getThreadCpuTime(threadInfo.threadId))
				threadInfo.metaClass.getCpuTime = { -> cpuTime }
				def userTime = nanosToMilis(threadManagementBean.getThreadUserTime(threadInfo.threadId))
				threadInfo.metaClass.getUserTime = { ->  userTime }
			}

			def stackTrace 
			if (threadInfo.lockOwnerId != -1) {
				ThreadInfo lockerThreadInfo = threadInfos.find { ti -> ti.threadId == threadInfo.lockOwnerId }
				stackTrace = lockerThreadInfo.stackTrace as List
			} 
			threadInfo.metaClass.getLockStackTrace = { -> stackTrace }
			
		}

		threadDump.allThreads = threadInfos

		threadDump
	}

	ThreadInfo[] getAllThreadInfos() {
		// check if we are running under Java 1.5 
		if (threadManagementBean.metaClass.methods.find { it.name == "dumpAllThreads" }) {
			threadManagementBean.dumpAllThreads(threadManagementBean.isObjectMonitorUsageSupported(),
				threadManagementBean.isSynchronizerUsageSupported())
		} else {
			def infos = threadManagementBean.getThreadInfo(threadManagementBean.getAllThreadIds())
			infos.each {
				// add this methods because _threadInfo wants to access them
				it.metaClass.getLockedMonitors = { -> null  }
				it.metaClass.getLockedSynchronizers = { -> null }
			}
		}
	}
}
