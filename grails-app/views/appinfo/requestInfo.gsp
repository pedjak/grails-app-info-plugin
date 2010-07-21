<head>
<meta name='layout' content='appinfo' />
<title>Request Scope</title>

<g:javascript>
	$(document).ready( function () {
		$('#requestInfo').dataTable( { 'bAutoWidth': false } );
		$('#cookies').dataTable( { 'bAutoWidth': false }  );
		$('#headers').dataTable( { 'bAutoWidth': false } );
		$('#attributes').dataTable( { 'bAutoWidth': false } );
		$('ul.tabs').tabs('div.panes > div')
	} );
</g:javascript>

</head>
<body>
<h1>Request Scope</h1>

<ul class="tabs">
	<li><a href="#">Request Info</a></li>
	<li><a href="#">Cookies</a></li>
	<li><a href="#">Headers</a></li>
	<li><a href="#">Attributes</a></li>
</ul>

<div class='panes'>
<div id="requestInfoHolder" class="tabPane">
<table id="requestInfo" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead><tr><th>Key</th><th>Value</th></thead>
	<tbody>
	<g:each var='entry' in='${props}'>
	<tr>
	<td>${entry.key}()</td><td>${entry.value}&nbsp;</td>
	</tr>
	</g:each>
</table>
</div>

<div id="cookiesHolder" class="tabPane">
<table id="cookies" >
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
	<tbody>
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
	</tbody>
	</table>
</div>

<div id="headersHolder" class="tabPane">
<table id="headers">
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
</div>

<div id="attributesHolder" class="tabPane">
<table id="attributes">
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
		<g:each var='attributeName' in='${request.attributeNames}'>
		<tr>
			<td>${attributeName}&nbsp;</td>
			<td>${request.getAttribute(attributeName)}&nbsp;</td>
		</tr>
		</g:each>
	</tbody>
</table>
</div>
</div>

</body>
