<head>
<meta name='layout' content='appinfo' />
<title>Data Source</title>
</head>

<body>
<g:form action='updateDataSource'>

<table>
	<caption>Data Source (${dataSource.class.name})</caption>
	<thead><tr><th>Name</th><th>Value</th></tr></thead>
	<tbody>
		<g:each var='property' in='${propertyInfo}'>
		<tr>
			<td>${property.name}&nbsp;</td>
			<td>
			<g:if test='${property.type == "boolean"}'>
			<g:checkBox name='SETTER_${property.set}' value='${property.value}'/>
			</g:if>
			<g:else>
			<g:textField size='70' class='text' name='SETTER_${property.set}' value='${property.value}'/>
			</g:else>
			</td>
		</tr>
		</g:each>
	</tbody>
</table>

<input type='submit' value='Update' />

</g:form>
</body>
