<head>
<meta name='layout' content='appinfo' />
<title>System Properties</title>
</head>

<body>

<g:form action='updateProperties'>

<table>

	<thead><tr><th colspan='2'>System Properties</th></tr></thead>
	<tbody>
	<g:each var='prop' in='${sysprops}'>
		<tr>
			<td>${prop.key}</td>
			<td><input size='70' type='text' class='text' name='PROPERTY_${prop.key.replaceAll('\\.', '__DOT__')}' value='${prop.value}'/></td>
		</tr>
	</g:each>

	<tr>
		<td>New System Property:&nbsp;&nbsp;<input size='10' type='text' class='text' name='newProperty'/></td>
		<td><input size='50' type='text' class='text' name='newPropertyValue'/></td>
	</tr>
	</tbody>
</table>

<br />

<input type='submit' value='Update Property Values' />

</g:form>

</body>
