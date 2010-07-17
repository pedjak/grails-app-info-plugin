<head>
<meta name='layout' content='appinfo' />
<title>Spring Beans</title>
</head>

<body>

<table border='1'>
	<caption>Spring Beans</caption>
	<thead>
	<tr><th colspan='7'>
	${ctx.displayName} (${ctx.beanDefinitionCount} beans, started at
		<g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(ctx.startupDate)}'/>)
	</th></tr>
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
<g:each var='entry' in='${beanInfo}'>
	<tr><th colspan='7'>${entry.key}</th></tr>
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
	</tbody>
	</g:each>
	</g:each>
	<tr><th colspan='7'>
	Parent Context - ${ctx.parent.displayName} (${ctx.parent.beanDefinitionCount} beans, started at
		<g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(ctx.parent.startupDate)}'/>)
	</th></tr>
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
	</tbody>
	</g:each>
</table>
