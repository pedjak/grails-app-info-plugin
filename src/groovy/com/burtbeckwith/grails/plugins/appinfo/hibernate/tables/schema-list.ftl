<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Schema List</title>
</head>

<body>

<table border="0" width="100%">
	<tr>
		<td nowrap="nowrap">
			<font class="ListTitleFont">${title}</font>
			<br/>
				<a href="${docFileManager.getRef(docFile, docFileManager.getAllTablesDocFile())}" target="tablesFrame">all tables</a>
			<br/>
<#foreach schema in schemaList>
				<a href="${docFileManager.getRef(docFile, docFileManager.getSchemaTableListDocFile(schema))}" target="tablesFrame">${schema}</a>
			<br/>
</#foreach>
		</td>
	</tr>
</table>

</body>

</html>