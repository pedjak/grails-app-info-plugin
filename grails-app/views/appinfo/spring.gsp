<head>
<meta name='layout' content='appinfo' />
<title>Spring Beans</title>

<g:javascript>
$(document).ready(function() {
	<g:each var='entry' in='${beanInfo}'>
	$('#${entry.key}Table').dataTable();
	</g:each>
	$('#parentTable').dataTable();
});
</g:javascript>

</head>

<body>

<h1>Main Context ${ctx.displayName} (${ctx.beanDefinitionCount} beans, started at <g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(ctx.startupDate)}'/>)</h1>

<g:each var='entry' in='${beanInfo}'>

<div id="${entry.key}TableHolder">
<h2>${entry.key}</h2>
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

	</g:each>

<div id="parentTableHolder">
<h2>Parent Context - ${ctx.parent.displayName} (${ctx.parent.beanDefinitionCount} beans, started at <g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(ctx.parent.startupDate)}'/>)</h2>
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

</body>

