<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Statistics</title>

<g:javascript>
$(document).ready(function() {
	$('#statistics').dataTable();
	$('#entityStatistics').dataTable();
	$('#collectionStatistics').dataTable();
	$('#queryCacheStatistics').dataTable();
});
</g:javascript>

</head>

<body>

<g:render template='/appinfo/hibernateStatisticsHeader'/>

<div id="statisticsHolder">
<h2>Hibernate Statistics (<g:formatDate format='MM/dd/yyyy h:mm:ss a' date='${new Date(statistics.startTime)}'/>)</h2>
<table id="statistics" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
		<g:each var='entry' in='${data}'>
		<tr><td>${entry.key}</td><td>${entry.value}</td></tr>
		</g:each>
	</tbody>
</table>

<div id="entityStatisticsHolder">
<h2>Hibernate Entity Statistics</h2>
<table id="entityStatistics" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th></tr>
	</thead>
	<tbody>
		<g:each var='name' in='${statistics.entityNames}'>
		<tr><td><g:link action='hibernateEntityStatistics' params='[entity: name]'>${name}</g:link></td></tr>
		</g:each>
	</tbody>
</table>

<div id="collectionStatisticsHolder">
<h2>Hibernate Collection Statistics</h2>
<table id="collectionStatistics" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th></tr>
	</thead>
	<tbody>
		<g:each var='name' in='${statistics.collectionRoleNames}'>
		<tr><td><g:link action='hibernateCollectionStatistics' params='[collection: name]'>${name}</g:link></td></tr>
		</g:each>
	</tbody>
</table>

<div id="queryCacheStatisticsHolder">
<h2>Hibernate Query Cache Statistics</h2>
<table id="queryCacheStatistics" cellpadding="0" cellspacing="0" border="0" class="display">
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

