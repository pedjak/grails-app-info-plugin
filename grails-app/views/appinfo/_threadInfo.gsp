<tr>
	<td>${threadInfo.threadId}</td>
	<td>${threadInfo.threadName?.encodeAsHTML()}</td>
	<td>${threadInfo.threadState?.encodeAsHTML()}</td>
	<td>${threadInfo.lockName?.encodeAsHTML()}</td>
	<td style="text-align:center;">${threadInfo.suspended ? '*' : ''}</td>
	<td style="text-align:center;">${threadInfo.inNative ? '*' : ''}</td>
	<td style="text-align:right;">
		<g:formatNumber number="${threadInfo.cpuTime}" maxFractionDigits="4" minFractionDigits="4" type="number" groupingUsed="true" />
	</td>
	<td style="text-align:right;">
		<g:formatNumber number="${threadInfo.userTime}" maxFractionDigits="4" minFractionDigits="4" type="number" groupingUsed="true" />
	</td>
	<td><g:if test="${threadInfo.lockOwnerId != -1}">
		${threadInfo.lockOwnerName?.encodeAsHTML()}&nbsp;(${threadInfo.lockOwnerId})
		</g:if></td>
	<td>
		<g:if test="${threadInfo.stackTrace || threadInfo.lockStackTrace}">
		<a href="javascript:void(0)" onclick="toggleBlock(this, 'stackTraceContainer', ${threadInfo.threadId})"><g:message code='threadDump.link.show'/></a>
		<div id="stackTraceContainer${threadInfo.threadId}" style="display:none;">
			<g:each in="${threadInfo.stackTrace}" var="stackTraceEntry">
			${stackTraceEntry?.encodeAsHTML()}<br />
			</g:each>
			<g:if test="${threadInfo.lockStackTrace}">
			<b><g:message code='threadDump.message.thread.lockOwnerStackTrace'/></b><br />
			<g:each in="${threadInfo.lockStackTrace}" var="stackTraceEntry">
			${stackTraceEntry?.encodeAsHTML()}<br />
			</g:each>
			</g:if>
		</div>
		</g:if>
	</td>

	<td>
		<g:if test="${threadInfo.lockedMonitors || threadInfo.lockedSynchronizers}">
			<a href="javascript:void(0)" onclick="toggleBlock(this, 'lockInfoContainer', ${threadInfo.threadId})"><g:message code='threadDump.link.show'/></a>
			<div id="lockInfoContainer${threadInfo.threadId}" style="display:none;">
				<g:if test="${threadInfo.lockedMonitors}">
					<table>
						<thead>
						<tr>
							<th colspan="2"><g:message code='threadDump.thread.lockInfo.lockedMonitors'/></th>
						</tr>
						<tr>
							<th><g:message code='threadDump.thread.lockInfo.lockedMonitor.title'/></th>
							<th><g:message code='threadDump.thread.lockInfo.lockedMonitor.stackFrame'/></th>
						</tr>
						</thead>
						<tbody>
						<g:each in="${threadInfo.lockedMonitors}" var="lockedMonitor">
							<tr>
								<td>${lockedMonitor?.encodeAsHTML()}</td>
								<td>${lockedMonitor?.lockedStackFrame?.encodeAsHTML()}</td>
							</tr>
						</g:each>
						</tbody>
					</table>
				</g:if>
				<g:if test="${threadInfo.lockedSynchronizers}">
					<table>
						<thead>
						<tr>
							<th>${bundle['threadDump.thread.lockInfo.ownableSynchronizers']}</th>
						</tr>
						</thead>
						<tbody>
						<g:each in="${threadInfo.lockedSynchronizers}" var="lockedSynchronizer">
							<tr>
								<td>${lockedSynchronizer?.encodeAsHTML()}</td>
							</tr>
						</g:each>
						</tbody>
					</table>
				</g:if>
			</div>
		</g:if>
	</td>
</tr>
