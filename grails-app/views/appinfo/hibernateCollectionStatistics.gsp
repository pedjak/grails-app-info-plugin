<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Collection Cache Statistics</title>

<g:javascript>
$(document).ready(function() {
	$('#stats').dataTable();
});
</g:javascript>

</head>

<body>

<g:render template='/appinfo/hibernateStatisticsHeader'/>

<div id="statsHolder">
<h2>Hibernate Collection Cache Statistics: ${collection}</h2>
<table id="stats" cellpadding="0" cellspacing="0" border="0" class="display">
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

