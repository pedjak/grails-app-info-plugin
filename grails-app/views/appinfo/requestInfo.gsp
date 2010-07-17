<head>
<meta name='layout' content='appinfo' />
<title>Request Scope</title>
</head>

<body>

<table style='width: 100%' border='1'>
	<caption>Request Info</caption>
	<tbody>
	<g:each var='entry' in='${props}'>
	<tr><td>${entry.key}()</td><td>${entry.value}&nbsp;</td></tr>
	</g:each>
	<tr>
		<td>Cookies</td>
		<td>
			<table style='width: 100%' border='1'>
				<thead>
				<tr>
					<th>Name</th>
					<th>Value</th>
					<th>Comment</th>
					<th>Domain</th>
					<th>MaxAge</th>
					<th>Path</th>
					<th>Secure</th>
					<th>Version</th>
				</tr>
				</thead>
				<g:each var='cookie' in='${request.cookies}'>
				<tr>
					<td>${cookie.name}&nbsp;</td>
					<td>${cookie.value}&nbsp;</td>
					<td>${cookie.comment}&nbsp;</td>
					<td>${cookie.domain}&nbsp;</td>
					<td>${cookie.maxAge}&nbsp;</td>
					<td>${cookie.path}&nbsp;</td>
					<td>${cookie.secure}&nbsp;</td>
					<td>${cookie.version}&nbsp;</td>
				</tr>
				</g:each>
			</table>
		</td>
	</tr>
	<tr>
		<td>Headers</td>
		<td>
			<table style='width: 100%' border='1'>
				<thead>
				<tr><th>Name</th><th>Value</th></tr>
				</thead>
				<tbody>
				<g:each var='headerName' in='${request.headerNames}'>
				<tr>
					<td>${headerName}&nbsp;</td>
					<td>${request.getHeader(headerName)}&nbsp;</td>
				</tr>
				</g:each>
				</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td>Attributes</td>
		<td>
			<table style='width: 100%' border='1'>
				<thead>
					<tr><th>Name</th><th>Value</th></tr>
				</thead>
				<g:each var='attributeName' in='${request.attributeNames}'>
				<tr>
					<td>${attributeName}&nbsp;</td>
					<td>${request.getAttribute(attributeName)}&nbsp;</td>
				</tr>
				</g:each>
			</table>
		</td>
	</tr>
	</tbody>
</table>

</body>
