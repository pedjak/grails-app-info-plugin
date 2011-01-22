<g:messageBundle bundle="appInfoThreadsInfo" var="bundle"/>

<head>
	<meta name='layout' content='appinfo'/>
	<title>${bundle['threadDump.title']}</title>

	<g:javascript>
	$(document).ready(function() {
		$('#threadDumpTable').dataTable();
	});
	</g:javascript>
  
	<style type="text/css">
		#threadDumpTable td { vertical-align: top; }
	</style>
</head>

<body>

<h2>${bundle['threadDump.title']}</h2>
<p><g:message code="threadDump.message.threadCount"
	           args="${[threadDump.threadCount, threadDump.peakThreadCount, threadDump.daemonThreadCount]}"/>
</p>

<div id="threadDumpTableHolder">
	<table id="threadDumpTable" class="display">
		<thead>
		<tr>
			<th>${bundle['threadDump.header.thread.id']}</th>
			<th>${bundle['threadDump.header.thread.name']}</th>
			<th>${bundle['threadDump.header.thread.state']}</th>
			<th>${bundle['threadDump.header.thread.lock']}</th>
			<th>${bundle['threadDump.header.thread.isSuspended']}</th>
			<th>${bundle['threadDump.header.thread.inNative']}</th>
			<th>${bundle['threadDump.header.thread.cpuTime']}</th>
			<th>${bundle['threadDump.header.thread.userTime']}</th>
			<th>${bundle['threadDump.header.thread.lockOwner']}</th>
			<th>${bundle['threadDump.header.thread.stackTrace']}</th>
			<th>${bundle['threadDump.header.thread.lockInfo']}</th>
		</tr>
		</thead>
		<tbody>
		<g:each in="${threadDump.allThreads}" var="threadInfo" >
		<g:render plugin="appInfo" template="/appinfo/threadInfo" model="[threadInfo: threadInfo]"/>
		</g:each>
		</tbody>
  </table>
</div>

<g:javascript>
function toggleBlock(linkRef, blockPrefix, blockId) {
	if (jQuery("#" + blockPrefix + String(blockId))[0].style.display == 'none') {
		jQuery(linkRef).text("${bundle['threadDump.link.hide']}")
		jQuery("#" + blockPrefix + String(blockId)).fadeIn();
	}
	else {
		jQuery(linkRef).text("${bundle['threadDump.link.show']}")
		jQuery("#" + blockPrefix + String(blockId)).fadeOut();
	}
}
</g:javascript>

</body>
