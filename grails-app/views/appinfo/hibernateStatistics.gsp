<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Statistics</title>

<g:javascript>
$(document).ready(function() {
	$('#statistics').dataTable( { 'bAutoWidth': false } );
	$('#entityStatistics').dataTable( { 'bAutoWidth': false } );
	$('#collectionStatistics').dataTable( { 'bAutoWidth': false } );
	$('#queryCacheStatistics').dataTable( { 'bAutoWidth': false } );
	$('ul.tabs').tabs('div.panes > div')
});
</g:javascript>

</head>

<body>

<g:render plugin='appInfo' template='/appinfo/hibernateStatisticsHeader'/><br/>

<ul class="tabs">
	<li><a href="#">Hibernate Statistics</a></li>
	<li><a href="#">Entity Statistics</a></li>
	<li><a href="#">Collection Statistics</a></li>
	<li><a href="#">Query Cache Statistics</a></li>
</ul>

<div class='panes'>

<div id="statisticsHolder" class="tabPane">
<table id="statistics" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
		<g:each var='entry' in='${stats}'>
		<tr><td>${entry.key}</td><td>${entry.value}</td></tr>
		</g:each>
	</tbody>
</table>
</div>

<div id="entityStatisticsHolder" class="tabPane">
<table id="entityStatistics" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th></tr>
	</thead>
	<tbody>
		<g:each var='name' in='${extra.entityNames}'>
		<tr><td><g:link action='hibernateEntityStatistics' params='[entity: name]'>${name}</g:link></td></tr>
		</g:each>
	</tbody>
</table>
</div>

<div id="collectionStatisticsHolder" class="tabPane">
<table id="collectionStatistics" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th></tr>
	</thead>
	<tbody>
		<g:each var='name' in='${extra.collectionRoleNames}'>
		<tr><td><g:link action='hibernateCollectionStatistics' params='[collection: name]'>${name}</g:link></td></tr>
		</g:each>
	</tbody>
</table>
</div>

<div id="queryCacheStatisticsHolder" class="tabPane">
<table id="queryCacheStatistics" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th></tr>
	</thead>
	<tbody>
		<g:each var='name' in='${extra.queries}'>
		<tr><td><g:link action='hibernateQueryStatistics' params='[query: name]'>${name}</g:link></td></tr>
		</g:each>
	</tbody>
</table>
</div>

</div>

</body>
