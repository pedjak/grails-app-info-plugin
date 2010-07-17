<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/tr/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Table Summary</title>
</head>

<body>

<h1>Hibernate Mapping Documentation</h1>

<h2>List of Tables for Schema: ${schema}</h2>

<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="2" class="MainTableHeading">Tables</th></tr>
	</thead>
<#foreach table in dochelper.tablesBySchema.get(schema)>
	<tbody>
		<tr>
			<td>
				<a href='${docFileManager.getRef(docFile, docFileManager.getTableDocFile(table))}' target="generalFrame">
					<b>${table.name}</b>
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
							<td>${column.name}</td>
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

</body>
