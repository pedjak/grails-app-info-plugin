<head>
<meta name='layout' content='appinfo' />
<title>Memory</title>
</head>

<body>

<script type='text/javascript' src='http://www.google.com/jsapi'></script>
<script>
google.load('visualization', '1', {'packages':['columnchart']});
</script>

<table>
	<caption>Memory</caption>
	<tr>
		<td>
			<appinfo:chart name='heapPoolGraph' height='300' width='350'
				stacked='${false}' title='Heap memory'
				barNames='${heapPoolNames}' sectionNames='${heapSectionNames}' data='${heapNumbers}' />
		</td>
		<td>
			<appinfo:chart name='nonheapPoolGraph' height='300' width='350'
				stacked='${false}' title='Non-heap memory'
				barNames='${nonheapPoolNames}' sectionNames='${nonheapSectionNames}' data='${nonheapNumbers}' />
		</td>
		<td>
			<appinfo:chart name='memoryGraph' height='300' width='300' title='Heap Usage'
				barNames='${memoryNames}' sectionNames='${memorySectionNames}' data='${memoryNumbers}' />
		</td>
	</tr>
</table>

<br/>
<g:link action='gc'>Garbage Collect</g:link>

</body>
