<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Caching</title>
</head>

<body>

<g:render template='/appinfo/hibernateCombos'/>

<table width='500px'>
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
	<g:each var='cacheName' in='${statistics.secondLevelCacheRegionNames}'>
		<g:set var='cacheStatistics' value='${statistics.getSecondLevelCacheStatistics(cacheName)}'/>
		<tr><td colspan='2'>
			<table width='500px'>
				<tr><th colspan='2'>${cacheName}</th></tr>
				<tr><td>ElementCountInMemory</td><td width='100px'>${cacheStatistics.elementCountInMemory}</td></tr>
				<tr><td>ElementCountOnDisk</td><td>${cacheStatistics.elementCountOnDisk}</td></tr>
				<tr><td>HitCount</td><td>${cacheStatistics.hitCount}</td></tr>
				<tr><td>MissCount</td><td>${cacheStatistics.missCount}</td></tr>
				<tr><td>PutCount</td><td>${cacheStatistics.putCount}</td></tr>
				<tr><td>SizeInMemory</td><td>${cacheStatistics.sizeInMemory}</td></tr>
				<tr><td colspan='2'>
					<div class='nav'>
						<span class='menuButton'><g:link action='hibernateClearCache' params='[cacheName: cacheName]'>Clear</g:link></span>
						<span class='menuButton'><g:link action='hibernateCacheGraphs' params='[cacheName: cacheName]'>Graphs</g:link></span>
					</div>
				</td></tr>
			</table>
		</td></tr>
	</g:each>
	</tbody>
</table>
</body>
