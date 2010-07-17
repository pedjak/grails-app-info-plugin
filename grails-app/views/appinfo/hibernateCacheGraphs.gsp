<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Cache Graphs</title>
</head>

<body>

<g:render template='/appinfo/hibernateCombos'/>

<script type='text/javascript' src='http://www.google.com/jsapi'></script>
<script>
google.load('visualization', '1', {'packages':['columnchart']});
</script>

<table>
	<tr>
		<td>
			<appinfo:chart name='cacheGraph' height='400' width='600'
				stacked='${false}' title='Hibernate 2nd-level Cache'
				barNames='${[shortName]}' sectionNames='${cacheTypeNames}' data='${cacheData}' />
		</td>
		<td>
			<appinfo:chart name='cacheMemoryGraph' height='400' width='400'
				title = 'Hibernate 2nd-level Cache Memory Usage'
				barNames='${[shortName]}' sectionNames='${cacheMemoryTypeNames}' data='${cacheMemoryData}' />
		</td>
	</tr>
</table>

</body>
