<head>
<meta name='layout' content='appinfo' />
<title>Application Scope</title>

<g:javascript>
$(document).ready( function () {
	$('#contextAttributes').dataTable( { 'bAutoWidth': false } );
	$('#initParams').dataTable( { 'bAutoWidth': false } );
	$('ul.tabs').tabs('div.panes > div')
});
</g:javascript>

</head>

<body>

<h1>Application-Scope Variables</h1>

<ul class="tabs">
	<li><a href="#">Context Attributes</a></li>
	<li><a href="#">Init Params</a></li>
</ul>

<div class='panes'>

<div id="contextAttributesHolder" class="tabPane">
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
</div>

<div id="initParamsHolder" class="tabPane">
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
</div>

</div>
</body>
