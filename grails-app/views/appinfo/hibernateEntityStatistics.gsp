<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Entity Statistics</title>
</head>

<body>

<g:render template='/appinfo/hibernateStatisticsHeader'/>

<table>
	<caption>Hibernate Entity Statistics: ${entity}</caption>
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
		<g:each var='entry' in='${data}'>
		<tr><td>${entry.key}</td><td>${entry.value}</td></tr>
		</g:each>
	</tbody>
</table>

</body>
