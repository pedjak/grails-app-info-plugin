<g:set var='defaultSchema' value="${hibernateProperties.'hibernate.default_schema'}" />
<g:set var='defaultCatalog' value="${hibernateProperties.'hibernate.default_catalog'}" />

<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Configuration</title>

<g:javascript>
$(document).ready(function() {
	$('#propertiesTable').dataTable( { 'bAutoWidth': false } );
	$('#mappingsTable').dataTable( { 'bAutoWidth': false } );
	$('#importsTable').dataTable( { 'bAutoWidth': false } );
	$('#auxTable').dataTable( { 'bAutoWidth': false } );
	$('#namedQueriesTable').dataTable( { 'bAutoWidth': false } );
	$('#namedSqlQueriesTable').dataTable( { 'bAutoWidth': false } );
	$('#typeDefsTable').dataTable( { 'bAutoWidth': false } );
	$('#filtersTable').dataTable( { 'bAutoWidth': false } );
	$('ul.tabs').tabs('div.panes > div')
});
</g:javascript>

</head>

<body>

<g:render template='/appinfo/hibernateCombos'/>

<ul class="tabs">
	<li><a href="#">Properties</a></li>
	<li><a href="#">Mappings</a></li>
	<li><a href="#">Imports</a></li>
	<li><a href="#">Aux. DB Objects</a></li>
	<li><a href="#">Named Queries</a></li>
	<li><a href="#">Named SQL Queries</a></li>
	<li><a href="#">TypeDefs</a></li>
</ul>

<div class='panes'>

<div id="propertiesTableHolder" class="tabPane">
<table id="propertiesTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Dialect</td>
			<td>${configuration.properties.'hibernate.dialect'}</td>
		</tr>
		<tr>
			<td>Cache Provider Class</td>
			<td>${hibernateProperties.'hibernate.cache.provider_class'}</td>
		</tr>
		<tr>
			<td>Use 2nd Level Cache</td>
			<td>${hibernateProperties.'hibernate.cache.use_second_level_cache'}</td>
		</tr>
		<tr>
			<td>Use Query Cache</td>
			<td>${hibernateProperties.'hibernate.cache.use_query_cache'}</td>
		</tr>
		<tr>
			<td>HBM2DDL Auto</td>
			<td>${hibernateProperties.'hibernate.hbm2ddl.auto' ?: 'None'}</td>
		</tr>

	</tbody>
</table>
</div>

<div id="mappingsTableHolder" class="tabPane">
<table id="mappingsTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Schema Name</td>
			<td>${mappings.schemaName}&nbsp;</td>
		</tr>
		<tr>
			<td>Catalog Name</td>
			<td>${mappings.catalogName}&nbsp;</td>
		</tr>
		<tr>
			<td>Default Cascade</td>
			<td>${mappings.defaultCascade}&nbsp;</td>
		</tr>
		<tr>
			<td>Default Access</td>
			<td>${mappings.defaultAccess}&nbsp;</td>
		</tr>
		<tr>
			<td>Default Auto Import</td>
			<td>${mappings.autoImport}</td>
		</tr>
		<tr>
			<td>Default Package</td>
			<td>${mappings.defaultPackage}&nbsp;</td>
		</tr>
		<tr>
			<td>Naming Strategy</td>
			<td>${mappings.namingStrategy.class.name}</td>
		</tr>
		<tr>
			<td>Default Lazy</td>
			<td>${mappings.defaultLazy}</td>
		</tr>
	</tbody>
</table>
</div>

<div id="importsTableHolder" class="tabPane">
<table id="importsTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<g:each var='entry' in='${mappings.@imports}'>
		<tr>
			<td>${entry.key}</td>
			<td>${entry.value}</td>
		</tr>
		</g:each>
	</tbody>
</table>
</div>

<div id="auxTableHolder" class="tabPane">
<table id="auxTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Create String</th>
			<th>Drop String</th>
			<th>Dialect Scopes</th>
		</tr>
	</thead>
	<tbody>
		<g:each var='o' in='${mappings.@auxiliaryDatabaseObjects}'>
		<tr>
			<td>${o.sqlCreateString(dialect, null, defaultCatalog, defaultSchema)}</td>
			<td>${o.sqlDropString(dialect, defaultCatalog, defaultSchema)}</td>
			<td>${o.dialectScopes}&nbsp;</td>
		</tr>
		</g:each>
	</tbody>
</table>
</div>

<div id="namedQueriesTableHolder" class="tabPane">
<table id="namedQueriesTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Query String</th>
			<th>Cacheable</th>
			<th>Cache Region</th>
			<th>Fetch Size</th>
			<th>Timeout</th>
			<th>Flush Mode</th>
			<th>Parameter Types</th>
			<th>Query</th>
			<th>Cache Mode</th>
			<th>Read Only</th>
			<th>Comment</th>
		</tr>
	</thead>
	<tbody>
		<g:each var='entry' in='${mappings.@queries}'>
		<tr>
			<td>${entry.key}</td>
			<td>${entry.value.queryString}&nbsp;</td>
			<td>${entry.value.cacheable}</td>
			<td>${entry.value.cacheRegion}&nbsp;</td>
			<td>${entry.value.fetchSize}&nbsp;</td>
			<td>${entry.value.timeout}&nbsp;</td>
			<td>${entry.value.flushMode}&nbsp;</td>
			<td>${entry.value.parameterTypes}&nbsp;</td>
			<td>${entry.value.query}&nbsp;</td>
			<td>${entry.value.cacheMode}&nbsp;</td>
			<td>${entry.value.readOnly}</td>
			<td>${entry.value.comment}&nbsp;</td>
		</tr>
		</g:each>
	</tbody>
</table>
</div>

<div id="namedSqlQueriesTableHolder" class="tabPane">
<table id="namedSqlQueriesTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Query String</th>
			<th>Cacheable</th>
			<th>Cache Region</th>
			<th>Fetch Size</th>
			<th>Timeout</th>
			<th>Flush Mode</th>
			<th>Parameter Types</th>
			<th>Query</th>
			<th>Cache Mode</th>
			<th>Read Only</th>
			<th>Comment</th>
			<th>Query Returns</th>
			<th>Query Spaces</th>
			<th>Callable</th>
			<th>ResultSet Ref</th>
		</tr>
	</thead>
	<tbody>
		<g:each var='entry' in='${mappings.@sqlqueries}'>
		<tr>
			<td>${entry.key}</td>
			<td>${entry.value.queryString}&nbsp;</td>
			<td>${entry.value.cacheable}</td>
			<td>${entry.value.cacheRegion}&nbsp;</td>
			<td>${entry.value.fetchSize}&nbsp;</td>
			<td>${entry.value.timeout}&nbsp;</td>
			<td>${entry.value.flushMode}&nbsp;</td>
			<td>${entry.value.parameterTypes}&nbsp;</td>
			<td>${entry.value.query}&nbsp;</td>
			<td>${entry.value.cacheMode}&nbsp;</td>
			<td>${entry.value.readOnly}</td>
			<td>${entry.value.comment}&nbsp;</td>
			<td>${entry.value.queryReturns as List}</td>
			<td>${entry.value.querySpaces}&nbsp;</td>
			<td>${entry.value.callable}</td>
			<td>${entry.value.resultSetRef}&nbsp;</td>
		</tr>
		</g:each>
	</tbody>
</table>
</div>

<div id="typeDefsTableHolder" class="tabPane">
<table id="typeDefsTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Type Class</th>
			<th>Parameters</th>
		</tr>
	</thead>
	<tbody>
		<g:each var='entry' in='${mappings.@typeDefs}'>
		<tr>
			<td>${entry.key}</td>
			<td>${entry.value.typeClass}</td>
			<td>${entry.value.parameters}&nbsp;</td>
		</tr>
		</g:each>
	</tbody>
</table>
</div>

<div id="filtersTableHolder" class="tabPane">
<h2>Filter Definitions</h2>
<table id="filtersTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Default Filter Condition</th>
			<th>Parameter Names</th>
			<th>Parameter Types</th>
		</tr>
	</thead>
	<tbody>
		<g:each var='o' in='${mappings.@filterDefinitions.values()}'>
		<tr>
			<td>${o.filterName}&nbsp;</td>
			<td>${o.defaultFilterCondition}&nbsp;</td>
			<td>${o.parameterNames}&nbsp;</td>
			<td>${o.parameterTypes}&nbsp;</td>
		</tr>
		</g:each>
	</tbody>
</table>
</div>

</div>

</body>
