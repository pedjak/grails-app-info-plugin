<head>
<meta name='layout' content='appinfo' />
<title>Session Scope</title>

<g:javascript>
	$(document).ready( function () {
		$('#session').dataTable();
	});
</g:javascript>

</head>

<body>
<h1>Session Scope</h1>

<h2>Session Variables</h2>
<strong>Session Id:</strong> ${session.id}  &nbsp;&nbsp;&nbsp;<strong>Start:</strong> <g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(session.creationTime)}'/><br/><br/>

<table id="session" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
	<g:each var='attributeName' in='${session.attributeNames}'>
		<g:set var='attribute' value='${session.getAttribute(attributeName)}'/>
		<tr>
			<td>${attributeName}&nbsp;</td>
			<td>${attribute}&nbsp;</td>
		</tr>
	</g:each>
	</tbody>
</table>

</body>
