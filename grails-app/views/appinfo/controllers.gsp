<head>
<meta name='layout' content='appinfo' />
<title>Controllers</title>
</head>

<body>

<h1>Controllers</h1>
<ul>
<g:each var='item' in='${data}'>
	<br/>
	<li>
	${item.controllerName}<br/>
	<ul>
	<g:each var='action' in='${item.actions}'>
		<li><g:link controller='${item.controller}' action='${action}'>${action}</g:link></li>
	</g:each>
	</ul>
</g:each>
</ul>

</body>
