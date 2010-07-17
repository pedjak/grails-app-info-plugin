<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Table Info</title>
</head>

<body>

<h3>Table: ${table.name}</h3>
<h4>Schema: ${dochelper.getQualifiedSchemaName(table)}</h4>

<p>${table.comment?if_exists}</p>

<a name="column_summary"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr>
			<th colspan="9" class="MainTableHeading">Column Summary</th>
		</tr>
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
<#foreach column in table.columnIterator>
		<tr>
			<td><a href='#column_detail_${column.name}'>${column.name}</a></td>
			<td>${dochelper.getSQLTypeName(column)}
			</td>
			<td align="right">${column.length}</td>
			<td align="right">${column.precision}</td>
			<td align="right">${column.scale}</td>
			<td align="center">${column.nullable?string}</td>
			<td align="center">${column.unique?string}</td>
		</tr>
</#foreach>
	</tbody>
</table>

<p>

<a name="primary_key"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr>
			<th colspan="2" class="MainTableHeading">Primary Key</th>
		</tr>
	</thead>
	<tbody>
<#if table.hasPrimaryKey()>
		<tr>
			<td width="50%">
<#if table.primaryKey.name?has_content>
				${table.primaryKey.name}
<#else>
				Name not specified
</#if>
			</td>
			<td width="50%">
<#list table.primaryKey.columnIterator() as column>
				<a href='#column_detail_${column.name}'>${column.name}<br/></a>
</#list>
			</td>
		</tr>
<#else>
		<tr><td>No Primary Key</td></tr>
</#if>
	</tbody>
</table>

<#if table.foreignKeyIterator.hasNext()><P>

<a name="foreign_keys"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="3" class="MainTableHeading">Foreign Keys</th></tr>
		<tr><th width="33%">Name</th>
			<th width="33%">Referenced Table</th>
			<th width="33%">Columns</th>
		</tr>
	</thead>
	<tbody>
<#foreach foreignKey in table.foreignKeyIterator>
		<tr>
			<td>${foreignKey.name?default("Name not specified")}</td>
			<td>
				<a href='${docFileManager.getRef(docFile, docFileManager.getTableDocFile(foreignKey.referencedTable))}' target="generalFrame">
					${foreignKey.referencedTable.name}
				</a>
			</td>
			<td>
<#foreach column in foreignKey.getColumnIterator()>
				<a href='#column_detail_${column.name}'>${column.name}<br/></a>
</#foreach>
			</td>
		</tr>
</#foreach>
	</tbody>
</table>
</#if>

<#if table.uniqueKeyIterator.hasNext()>
<p>

<a name="unique_keys"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="2" class="MainTableHeading">Unique Keys</th></tr>
		<tr>
			<th width="50%">Name</th>
			<th width="50%">Columns</th>
		</tr>
	</thead>
	<tbody>
<#foreach uniqueKey in table.getUniqueKeyIterator()>
		<tr>
			<td>${uniqueKey.name?default("Name not specified")}</td>
			<td>
<#foreach column in uniqueKey.getColumnIterator()>
				<a href='#column_detail_${column.name}'>${column.name}<br/></a>
</#foreach>
			</td>
		</tr>
</#foreach>
	</tbody>
</table>
</#if>

<#if table.indexIterator.hasNext()><P>

<a name="indexes"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="2" class="MainTableHeading">Indexes</th></tr>
		<tr>
			<th width="50%">Name</th>
			<th width="50%">Columns</th>
		</tr>
	</thead>
	<tbody>
<#foreach index in table.indexIterator>
		<tr>
			<td>${index.name?default("Name not specificed")}</td>
			<td>
<#foreach column in index.columnIterator>
				<a href='#column_detail_${column.name}'>${column.name}<br/></a>
</#foreach>
			</td>
		</tr>
</#foreach>
	</tbody>
</table>
</#if>
<#if table.columnIterator.hasNext()>
<P>

<a name="column_detail"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th class="MainTableHeading">Column Detail</th></tr>
	</thead>
</table>

<#foreach column in table.columnIterator>
<a name='column_detail_${column.name}'></a>
<h3>${column.name}</h3>

<ul>
	<li><b>Type: </b>${dochelper.getSQLTypeName(column)}</li>
	<li><b>Length: </b>${column.length}</li>
	<li><b>Precision: </b>${column.precision}</li>
	<li><b>Scale: </b>${column.scale}</li>
	<li><b>Nullable: </b>${column.nullable?string}</li>
	<li><b>Unique: </b>${column.unique?string}</li>
	<li><b>Comment: </b>${column.comment?if_exists}</li>
</ul>

<p>

<hr/>
</#foreach>
</#if>
</body>

</html>
