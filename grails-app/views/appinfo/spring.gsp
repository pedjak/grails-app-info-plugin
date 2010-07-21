<head>
<meta name='layout' content='appinfo' />
<title>Spring Beans</title>

<g:javascript>
$(document).ready(function() {
	<g:each var='entry' in='${beanInfo}'>
	$('#${entry.key}Table').dataTable( { 'bAutoWidth': false } );
	</g:each>
	$('#parentTable').dataTable( { 'bAutoWidth': false } );
	$('ul.tabs').tabs('div.panes > div')
});
</g:javascript>

</head>

<body>

<h1>Main Context: ${ctx.displayName} (${ctx.beanDefinitionCount} beans, started at <g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(ctx.startupDate)}'/>)</h1>

<br/>

<ul class="tabs">
	<g:each var='entry' in='${beanInfo}'>
	<li><a href="#">${entry.key}</a></li>
	</g:each>
	<li><a href="#">Parent Context</a></li>
</ul>

<div class='panes'>

<g:each var='entry' in='${beanInfo}'>

<div id="${entry.key}TableHolder" class="tabPane">
<table id="${entry.key}Table" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Name</th>
		<th>Class</th>
		<th>Scope</th>
		<th>Lazy</th>
		<th>Abstract</th>
		<th>Parent</th>
		<th>Bean Class Name</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='desc' in='${entry.value}'>
	<tr>
		<td><%=desc.name%></td>
		<td>${desc.className}</td>
		<td>${desc.scope}</td>
		<td>${desc.lazy}</td>
		<td>${desc.isAbstract}</td>
		<td>${desc.parent ?: 'N/A'}</td>
		<td>${desc.beanClassName ?: 'N/A'}</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

</g:each>

<div id="parentTableHolder" class="tabPane">

<h2>Parent Context: ${ctx.parent.displayName} (${ctx.parent.beanDefinitionCount} beans, started at <g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(ctx.parent.startupDate)}'/>)</h2>

<table id="parentTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Name</th>
		<th>Class</th>
		<th>Scope</th>
		<th>Lazy</th>
		<th>Abstract</th>
		<th>Parent</th>
		<th>Bean Class Name</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='desc' in='${parentBeans}'>
	<tr>
		<td><%=desc.name%></td>
		<td>${desc.className}</td>
		<td>${desc.scope}</td>
		<td>${desc.lazy}</td>
		<td>${desc.isAbstract}</td>
		<td>${desc.parent ?: 'N/A'}</td>
		<td>${desc.beanClassName ?: 'N/A'}</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

</div>

</body>
