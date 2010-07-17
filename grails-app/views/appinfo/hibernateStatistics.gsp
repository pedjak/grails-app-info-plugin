<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Statistics</title>
</head>

<body>

<g:render template='/appinfo/hibernateStatisticsHeader'/>

<table>
	<caption>Hibernate Statistics (<g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(statistics.startTime)}'/>)</caption>
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
		<g:each var='entry' in='${data}'>
		<tr><td>${entry.key}</td><td>${entry.value}</td></tr>
		</g:each>
	</tbody>
</table>

<table>
	<caption>Hibernate Entity Statistics</caption>
	<thead>
		<tr><th>Name</th></tr>
	</thead>
	<tbody>
		<g:each var='name' in='${statistics.entityNames}'>
		<tr><td><g:link action='hibernateEntityStatistics' params='[entity: name]'>${name}</g:link></td></tr>
		</g:each>
	</tbody>
</table>

<table>
	<caption>Hibernate Collection Statistics</caption>
	<thead>
		<tr><th>Name</th></tr>
	</thead>
	<tbody>
		<g:each var='name' in='${statistics.collectionRoleNames}'>
		<tr><td><g:link action='hibernateCollectionStatistics' params='[collection: name]'>${name}</g:link></td></tr>
		</g:each>
	</tbody>
</table>

<table>
	<caption>Hibernate Query Cache Statistics</caption>
	<thead>
		<tr><th>Name</th></tr>
	</thead>
	<tbody>
		<g:each var='name' in='${statistics.queries}'>
		<tr><td><g:link action='hibernateQueryStatistics' params='[query: name]'>${name}</g:link></td></tr>
		</g:each>
	</tbody>
</table>

</body>
