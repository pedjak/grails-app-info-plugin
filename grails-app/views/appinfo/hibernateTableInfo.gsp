<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Mappings - Table Info</title>

<g:javascript>
$(document).ready(function() {
	$('#tableInfo').dataTable( { 'bAutoWidth': false } );
	$('#columnSummaryTable').dataTable( { 'bAutoWidth': false } );
	$('#primaryKeyTable').dataTable( { 'bAutoWidth': false } );
	$('#foreignKeysTable').dataTable( { 'bAutoWidth': false } );
	$('#uniqueKeysTable').dataTable( { 'bAutoWidth': false } );
	$('#indexesTable').dataTable( { 'bAutoWidth': false } );
	$('ul.tabs').tabs('div.panes > div')
});
</g:javascript>

</head>

<body>

<g:render plugin='appInfo' template='/appinfo/hibernateCombos'/>

<h2>Table '${table.name}'</h2>
<g:if test='${table.comment}'><h2>${table.comment}</h2></g:if>

<br/>

<ul class="tabs">
	<li><a href="#">Table</a></li>
	<li><a href="#">Columns</a></li>
	<li><a href="#">Primary Key</a></li>
	<g:if test='${table.foreignKeyIterator.hasNext()}'>
	<li><a href="#">Foreign Keys</a></li>
	</g:if>
	<g:if test='${table.uniqueKeyIterator.hasNext()}'>
	<li><a href="#">Unique Keys</a></li>
	</g:if>
	<g:if test='${table.indexIterator.hasNext()}'>
	<li><a href="#">Indexes</a></li>
	</g:if>
</ul>

<div class='panes'>

<div id="tableInfoHolder" class="tabPane">
<table id="tableInfo" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead><tr><th>Name</th><th>Value</th></tr></thead>
	<tbody>
		<tr><td>Schema</td><td>${dochelper.getQualifiedSchemaName(table)}&nbsp;</td></tr>
		<tr><td>Catalog</td><td>${table.catalog}&nbsp;</td></tr>
		<tr><td>RowId</td><td>${table.rowId}&nbsp;</td></tr>
		<tr><td>Subselect</td><td>${table.subselect}</td></tr>
		<tr><td>Is Abstract Union Table</td><td>${table.abstractUnionTable}</td></tr>
		<tr><td>Has Denormalized Tables</td><td>${table.hasDenormalizedTables()}</td></tr>
		<tr><td>Abstract</td><td>${table.isAbstract()}</td></tr>
		<tr><td>Is Physical Table</td><td>${table.physicalTable}</td></tr>
		<tr><td>Comment</td><td>${table.comment}&nbsp;</td></tr>
		<tr><td>Create SQL</td><td>${table.sqlCreateString(dialect, sessionFactory, defaultCatalog, defaultSchema)}</td></tr>
		<tr><td>Drop SQL</td><td>${table.sqlDropString(dialect, defaultCatalog, defaultSchema)}</td></tr>
	</tbody>
</table>
</div>

<a name="column_summary"></a>
<div id="columnSummaryTableHolder" class="tabPane">
<table id="columnSummaryTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th width="14%">Name</th>
			<th width="14%">SqlType</th>
			<th width="14%">Length</th>
			<th width="14%">Precision</th>
			<th width="14%">Scale</th>
			<th width="14%">Nullable</th>
			<th width="14%">Unique</th>
		</tr>
	</thead>
	<tbody>
<g:each var='column' in='${table.columnIterator}'>
		<tr>
			<td><a href='#column_detail_${column.name}'>${column.name}</a></td>
			<td>${dochelper.getSQLTypeName(column)}
			</td>
			<td align="right">${column.length}</td>
			<td align="right">${column.precision}</td>
			<td align="right">${column.scale}</td>
			<td align="center">${column.nullable}</td>
			<td align="center">${column.unique}</td>
		</tr>
</g:each>
	</tbody>
</table>
</div>

<a name="primary_key"></a>
<div id="primaryKeyTableHolder" class="tabPane">
<table id="primaryKeyTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Columns</th>
		</tr>
	</thead>
	<tbody>
<g:if test='${table.hasPrimaryKey()}'>
		<tr>
			<td width="50%">
<g:if test='${table.primaryKey.name}'>
				${table.primaryKey.name}
</g:if>
<g:else>
				Name not specified
</g:else>
			</td>
			<td width="50%">
			<ul>
<g:each var='column' in='${table.primaryKey.columnIterator()}'>
				<li><a href='#column_detail_${column.name}'>${column.name}<br/></a></li>
</g:each>
			</ul>
			</td>
		</tr>
</g:if>
<g:else>
		<tr><td>No Primary Key</td></tr>
</g:else>
	</tbody>
</table>
</div>

<g:if test='${table.foreignKeyIterator.hasNext()}'>

<br/>

<a name="foreign_keys"></a>
<div id="foreignKeysTableHolder" class="tabPane">
<table id="foreignKeysTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Referenced Table</th>
			<th>Columns</th>
			<th>Referenced Entity Name</th>
			<th>Cascade Delete Enabled</th>
			<th>Physical Constraint</th>
			<th>Create SQL</th>
			<th>Drop SQL</th>
		</tr>
	</thead>
	<tbody>
<g:each var='foreignKey' in='${table.foreignKeyIterator}'>
		<tr>
			<td>${foreignKey.name ?: "Name not specified"}</td>
			<td>
				<a href='${createLink(action: 'hibernateTableInfo') + '?table=' + (docFileManager.getRef(docFile, docFileManager.getTableDocFile(foreignKey.referencedTable)) - '.html')}'>
					${foreignKey.referencedTable.name}
				</a>
			</td>
			<td>
<g:each var='column' in='${foreignKey.columnIterator}'>
				<a href='#column_detail_${column.name}'>${column.name}<br/></a>
</g:each>
			</td>
			<td>${foreignKey.referencedEntityName}</td>
			<td>${foreignKey.cascadeDeleteEnabled}</td>
			<td>${foreignKey.physicalConstraint}</td>
			<td><div style='overflow: auto; height: 100px; width: 200px;'>${foreignKey.sqlCreateString(dialect, sessionFactory, defaultCatalog, defaultSchema)}</div></td>
			<td>${foreignKey.sqlDropString(dialect, defaultCatalog, defaultSchema)}</td>
		</tr>
</g:each>
	</tbody>
</table>
</div>
</g:if>

<g:if test='${table.uniqueKeyIterator.hasNext()}'>
<br/>

<a name="unique_keys"></a>

<div id="uniqueKeysTableHolder" class="tabPane">
<table id="uniqueKeysTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Columns</th>
			<th>Generated</th>
			<th>Create SQL</th>
			<th>Drop SQL</th>
			<th>Constraint String</th>
		</tr>
	</thead>
	<tbody>
<g:each var='uniqueKey' in='${table.uniqueKeyIterator}'>
		<tr>
			<td>${uniqueKey.name ?: "Name not specified"}</td>
			<td>
<g:each var='column' in='${uniqueKey.columnIterator}'>
				<a href='#column_detail_${column.name}'>${column.name}<br/></a>
</g:each>
			</td>
			<td>${uniqueKey.isGenerated(dialect)}</td>
			<td><div style='overflow: auto; height: 100px; width: 200px;'>${uniqueKey.sqlCreateString(dialect, sessionFactory, defaultCatalog, defaultSchema)}</div></td>
			<td>${uniqueKey.sqlDropString(dialect, defaultCatalog, defaultSchema)}</td>
			<td>${uniqueKey.sqlConstraintString(dialect)}</td>
		</tr>
</g:each>
	</tbody>
</table>
</div>
</g:if>

<g:if test='${table.indexIterator.hasNext()}'>
<br/>

<a name="indexes"></a>
<div id="indexesTableHolder" class="tabPane">
<table id="indexesTable" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
		<tr>
			<th>Name</th>
			<th>Columns</th>
			<th>Create SQL</th>
			<th>Drop SQL</th>
			<th>Constraint String</th>
		</tr>
	</thead>
	<tbody>
<g:each var='index' in='${table.indexIterator}'>
		<tr>
			<td>${index.name ?: "Name not specificed"}</td>
			<td>
<g:each var='column' in='${index.columnIterator}'>
				<a href='#column_detail_${column.name}'>${column.name}<br/></a>
</g:each>
			</td>
			<td><div style='overflow: auto; height: 100px; width: 200px;'>${index.sqlCreateString(dialect, sessionFactory, defaultCatalog, defaultSchema)}</div></td>
			<td>${index.sqlDropString(dialect, defaultCatalog, defaultSchema)}</td>
			<td>${index.sqlConstraintString(dialect)}</td>
		</tr>
</g:each>
	</tbody>
</table>
</div>
</g:if>

</div>

</body>
