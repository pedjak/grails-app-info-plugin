<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Configuration</title>
</head>

<body>

<g:render template='/appinfo/hibernateCombos'/>

<table border='1' style='width: 600px'>
	<caption>Properties</caption>
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

<br/>

<g:set var='defaultSchema' value="${hibernateProperties.'hibernate.default_schema'}" />
<g:set var='defaultCatalog' value="${hibernateProperties.'hibernate.default_catalog'}" />

<table border='1' style='width: 600px'>
	<caption>Mappings Info</caption>
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

<br/>

<table border='1' style='width: 600px'>
	<caption>Imports</caption>
	<tbody>
		<g:each var='entry' in='${mappings.@imports}'>
		<tr>
			<td>${entry.key}</td>
			<td>${entry.value}</td>
		</tr>
		</g:each>
	</tbody>
</table>

<br/>

<table border='1' style='width: 600px'>
	<caption>Auxiliary Database Objects</caption>
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

<br/>

<table border='1' style='width: 600px'>
	<caption>Named Queries</caption>
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

<br/>

<table border='1' style='width: 600px'>
	<caption>Named SQL Queries</caption>
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

<br/>

<table border='1' style='width: 600px'>
	<caption>TypeDefs</caption>
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

<br/>

<table border='1' style='width: 600px'>
	<caption>Filter Definitions</caption>
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

</body>
