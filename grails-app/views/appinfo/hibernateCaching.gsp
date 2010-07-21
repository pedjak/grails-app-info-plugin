<%@page import="grails.util.GrailsNameUtils" %>

<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Caching</title>

<g:javascript>
$(document).ready(function() {
	<g:each var='cacheName' in='${statistics.keySet()}'>
	$('#${GrailsNameUtils.getShortName(cacheName)}Table').dataTable( { 'bAutoWidth': false } );
	</g:each>
	$('ul.tabs').tabs('div.panes > div')
});
</g:javascript>

</head>

<body>

<g:render template='/appinfo/hibernateCombos'/>

<h2>Hibernate 2<sup>nd</sup>-level Caches</h2>
<br/>

<ul class="tabs">
	<g:each var='entry' in='${statistics}'>
	<li><a href="#">${GrailsNameUtils.getShortName(entry.key)}</a></li>
	</g:each>
</ul>

<div class='panes'>

<g:each var='entry' in='${statistics}'>

<div id="${GrailsNameUtils.getShortName(entry.key)}TableHolder" class="tabPane">
<table id="${GrailsNameUtils.getShortName(entry.key)}Table" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
		<tr><td>ElementCountInMemory</td><td width='100px'>${entry.value.elementCountInMemory}</td></tr>
		<tr><td>ElementCountOnDisk</td><td>${entry.value.elementCountOnDisk}</td></tr>
		<tr><td>HitCount</td><td>${entry.value.hitCount}</td></tr>
		<tr><td>MissCount</td><td>${entry.value.missCount}</td></tr>
		<tr><td>PutCount</td><td>${entry.value.putCount}</td></tr>
		<tr><td>SizeInMemory</td><td>${entry.value.sizeInMemory}</td></tr>
	</tbody>
</table>

<br/>
<div class='nav'>
<span class='menuButton'><g:link action='hibernateClearCache' params='[cacheName: entry.key]'>Clear</g:link></span>
<span class='menuButton'><g:link action='hibernateCacheGraphs' params='[cacheName: entry.key]'>Graphs</g:link></span>
</div>
<br/>

</div>

</g:each>

</div>

</body>
