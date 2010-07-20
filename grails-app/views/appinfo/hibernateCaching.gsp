<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Caching</title>

<g:javascript>
$(document).ready(function() {
	<g:each var='cacheName' in='${statistics.secondLevelCacheRegionNames}'>
	$('#${cacheName.replaceAll('\\.','_')}Table').dataTable();
	</g:each>
});
</g:javascript>

</head>

<body>

<g:render template='/appinfo/hibernateCombos'/>

<g:each var='cacheName' in='${statistics.secondLevelCacheRegionNames}'>
<g:set var='cacheStatistics' value='${statistics.getSecondLevelCacheStatistics(cacheName)}'/>

<div id="${cacheName.replaceAll('\\.','_')}TableHolder">
<h2>${cacheName}</h2>
<table id="${cacheName.replaceAll('\\.','_')}Table" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
		<tr><td>ElementCountInMemory</td><td width='100px'>${cacheStatistics.elementCountInMemory}</td></tr>
		<tr><td>ElementCountOnDisk</td><td>${cacheStatistics.elementCountOnDisk}</td></tr>
		<tr><td>HitCount</td><td>${cacheStatistics.hitCount}</td></tr>
		<tr><td>MissCount</td><td>${cacheStatistics.missCount}</td></tr>
		<tr><td>PutCount</td><td>${cacheStatistics.putCount}</td></tr>
		<tr><td>SizeInMemory</td><td>${cacheStatistics.sizeInMemory}</td></tr>
	</tbody>
</table>
</div>

<br/>
<div class='nav'>
<span class='menuButton'><g:link action='hibernateClearCache' params='[cacheName: cacheName]'>Clear</g:link></span>
<span class='menuButton'><g:link action='hibernateCacheGraphs' params='[cacheName: cacheName]'>Graphs</g:link></span>
</div>
<br/>
</g:each>

</body>

