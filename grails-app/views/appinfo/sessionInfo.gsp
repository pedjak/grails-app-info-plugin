<head>
<meta name='layout' content='appinfo' />
<title>Session Scope</title>
</head>

<body>

<table style='width: 100%' border='1'>
	<caption>Session Variables (Session ID ${session.id}, Start: <g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(session.creationTime)}'/>)</caption>
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
