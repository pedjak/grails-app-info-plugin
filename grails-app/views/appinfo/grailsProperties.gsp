<head>
<meta name='layout' content='appinfo' />
<title>Grails Properties</title>

<g:javascript>
$(document).ready(function() {
	$('#grailsProperties').dataTable();
});
</g:javascript>

</head>

<body>

<br/>

<div id="grailsPropertiesHolder">
<h2>Grails Properties</h2>

<br/>

<table id="grailsProperties" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead><tr><th>Key</th><th>Value</th></thead>
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
</div>

</body>

