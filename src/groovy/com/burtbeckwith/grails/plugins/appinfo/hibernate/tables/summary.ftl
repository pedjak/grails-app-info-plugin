<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Table Summary</title>
</head>

<body>

<H1>Hibernate Mapping Documentation</H1>

<#if graphsGenerated>
<p>
	<img src="tablegraph.png" usemap="#tablegraph"/>
	<map name="tablegraph">${tablegrapharea}</map>
</p>
</#if>

<h2>List of Tables by Schema</h2>

<#foreach schema in dochelper.tablesBySchema.keySet()>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="2" class="MainTableHeading">${schema}</th></tr>
	</thead>
	<tbody>
<#foreach table in dochelper.getTables(schema)>
		<tr>
			<td>
				<a href='${docFileManager.getRef(docFile, docFileManager.getTableDocFile(table))}' target="generalFrame">
					${table.name}
				</a>
			</td>
			<td>
				<table border="1" cellpadding="3" cellspacing="0">
					<thead>
						<tr>
							<th width="50%">Name</th>
							<th width="30%">SQL Type</th>
							<th width="15%">Nullable</th>
							<th width="15%">Unique</th>
						</tr>
					</thead>
					<tbody>
<#foreach column in table.columnIterator>
						<tr>
							<td>
								<a href='${docFileManager.getRef(docFile, docFileManager.getTableDocFile(table))}#column_detail_${column.name}' TARGET="generalFrame">
									${column.name}
								</a>
							</td>
							<td>${dochelper.getSQLTypeName(column)}</td>
							<td align="center">${column.nullable?string}</td>
							<td align="center">${column.unique?string}</td>
						</tr>
</#foreach>
					</tbody>
				</table>
			</td>
		</tr>
</#foreach>
	</tbody>
</table>
</#foreach>
</body>
