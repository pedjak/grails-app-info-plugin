<head>
<meta name='layout' content='appinfo' />
<title>Grails Properties</title>
</head>

<body>

<g:form>
<table border='1'>
	<caption>Grails Properties</caption>
	<thead><tr><th>Name</th><th>Value</th></tr></thead>
	<tbody>
	<g:each var='propertyName' in='${grailsProperties.keySet() - "log4j"}'>
		<tr>
			<td>${propertyName}</td>
			<td>
				<g:if test='${grailsProperties[propertyName] instanceof Boolean}'>
				<g:checkBox name='${propertyName}' foo='bar' value='${grailsProperties[propertyName]}' DISABLED='DISABLED' />
				</g:if>
				<g:else>
				<%=grailsProperties[propertyName]%>&nbsp;
				</g:else>
			</td>
		</tr>
	</g:each>
	</tbody>
</table>
</g:form>

<br />

</body>
