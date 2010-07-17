<head>
<meta name='layout' content='appinfo' />
<title>Sessions</title>
</head>

<body>

<table style='width: 100%' border='1'>
	<caption>Sessions</caption>
	<thead>
		<tr>
			<th>ID</th>
			<th>Invalidate</th>
			<th>Start</th>
			<th>Last Accessed</th>
			<th>Age</th>
			<th>Max Inactive</th>
			<th>Values</th>
		</tr>
	</thead>
	<tbody>
	<g:each var='s' in='${sessions}'>
		<tr>
			<td style='vertical-align: top'>${s.session.id}&nbsp;</td>
			<td style='vertical-align: top'>
				<g:link action='invalidateSession' params='[sessionId: s.session.id]'>Invalidate</g:link>
			</td>
			<td style='vertical-align: top'><g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(s.session.creationTime)}'/>&nbsp;</td>
			<td style='vertical-align: top'><g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(s.session.lastAccessedTime)}'/>&nbsp;</td>
			<td style='vertical-align: top'>${s.age}&nbsp;</td>
			<td style='vertical-align: top'>${s.maxInactive}&nbsp;</td>
			<td>
				<table style='width: 100%' border='1'>
					<thead>
						<tr><th>Name</th><th>Value</th></tr>
					</thead>
					<tbody>
					<g:each var='attributeName' in='${s.session.attributeNames}'>
						<g:set var='attribute' value='${s.session.getAttribute(attributeName)}'/>
						<tr>
							<td>${attributeName}&nbsp;</td>
							<td>${attribute}&nbsp;</td>
						</tr>
					</g:each>
					</tbody>
				</table>
			</td>
		</tr>
	</g:each>
	</tbody>
</table>
</body>
