<head>
<meta name='layout' content='appinfo' />
<title>Application Scope</title>
</head>

<body>

<div class='body'>

<table border='1'>
	<caption>Application-Scope Variables</caption>
	<tr><th colspan='2'>Context Attributes</th></tr>
	<tr>
		<th>Name</th>
		<th>Value</th>
	</tr>
	<g:each var='entry' in='${attrNamesAndValues}'>
	<tr>
		<td>${entry.key}&nbsp;</td>
		<td>${entry.value}&nbsp;</td>
	</tr>
	</g:each>
</table>

<br />
<br />

<table border='1'>
	<tr><th colspan='2'>Init Params</th></tr>
	<tr>
		<th>Name</th>
		<th>Value</th>
	</tr>
	<g:each var='entry' in='${initParamNamesAndValues}'>
	<tr>
		<td>${entry.key}&nbsp;</td>
		<td>${entry.value}&nbsp;</td>
	</tr>
	</g:each>
</table>

</div>
</body>
