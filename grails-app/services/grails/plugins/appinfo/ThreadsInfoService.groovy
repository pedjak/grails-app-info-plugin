package grails.plugins.appinfo

import java.lang.management.ThreadMXBean
import java.lang.management.ManagementFactory
import java.lang.management.ThreadInfo
import java.lang.management.MonitorInfo

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

		ThreadInfo.metaClass.cpuTime = null
		ThreadInfo.metaClass.userTime = null
		ThreadInfo.metaClass.lockStackTrace = null

		for (ThreadInfo threadInfo in threadInfos) {
			if (threadManagementBean.threadCpuTimeSupported) {
				threadInfo.cpuTime = nanosToMilis(threadManagementBean.getThreadCpuTime(threadInfo.threadId))
				threadInfo.userTime = nanosToMilis(threadManagementBean.getThreadUserTime(threadInfo.threadId))
			}

			if (threadInfo.lockOwnerId != -1) {
				ThreadInfo lockerThreadInfo = threadInfos.find { ti -> ti.threadId == threadInfo.lockOwnerId }
				MonitorInfo lockInfo = lockerThreadInfo?.lockedMonitors?.find {
					MonitorInfo mi -> mi.identityHashCode == threadInfo.lockInfo?.identityHashCode
				}

				int index = 0
				if (lockInfo) {
					index = lockerThreadInfo.stackTrace.findIndexOf { it ->
						it.equals(lockInfo.lockedStackFrame)
					}
				}
				if (index == -1) {
					index = 0
				}

				threadInfo.lockStackTrace = lockerThreadInfo.stackTrace as List
			}
		}

		threadDump.allThreads = threadInfos

		threadDump
	}

	ThreadInfo[] getAllThreadInfos() {
		threadManagementBean.dumpAllThreads(threadManagementBean.isObjectMonitorUsageSupported(),
			threadManagementBean.isSynchronizerUsageSupported())
	}
}
