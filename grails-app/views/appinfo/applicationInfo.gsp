<head>
<meta name='layout' content='appinfo' />
<title>Application Scope</title>

<g:javascript>
	$(document).ready( function () {
		$('#contextAttributes').dataTable();
		$('#initParams').dataTable();	
	});
</g:javascript>

</head>

<body>
	
<h1>Application-Scope Variables</h1>

<h2>Context Attributes</h2>
<table id="contextAttributes" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Name</th>
		<th>Value</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='entry' in='${attrNamesAndValues}'>
	<tr>
		<td>${entry.key}&nbsp;</td>
		<td>${entry.value}&nbsp;</td>
	</tr>
	</g:each>
	</tbody>
</table>

<h2>Init Params</h2>
<table id="initParams" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Name</th>
		<th>Value</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='entry' in='${initParamNamesAndValues}'>
	<tr>
		<td>${entry.key}&nbsp;</td>
		<td>${entry.value}&nbsp;</td>
	</tr>
	</g:each>
	</tbody>
</table>

</body>
