<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Entity Statistics</title>

<g:javascript>
$(document).ready(function() {
	$('#statistics').dataTable();
});
</g:javascript>

</head>

<body>

<g:render plugin='appInfo' template='/appinfo/hibernateStatisticsHeader'/>

<div id="statisticsHolder">
<h2>Hibernate Entity Statistics: ${entity}</h2>
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

</body>

