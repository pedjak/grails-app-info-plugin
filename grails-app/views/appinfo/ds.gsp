<head>
<meta name='layout' content='appinfo' />
<title>Data Source</title>

<g:javascript>
$(document).ready(function() {
	$('#dataSource').dataTable({
		"bStateSave": true
	});
});
</g:javascript>

</head>

<body>

<br/>
<span class='appinfo_warning'>Note: Only visible form element values will be submitted</span><br/><br/>

<g:form action='updateDataSource'>

<div id="dataSourceHolder">
<h2>Data Source (${dataSourceClassName})</h2>
<table id="dataSource" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead><tr><th>Key</th><th>Value</th></thead>
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
</div>

<input type='submit' value='Update' />

</g:form>

</body>

