<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Table List</title>
</head>

<body>

<table border="0" width="100%">
	<tr>
		<td nowrap>
			<font class="ListTitleFont">${title}</font>
			<br/>
<#foreach table in tableList>
			<a href='${docFileManager.getRef(docFile, docFileManager.getTableDocFile(table))}' target="generalFrame">${table.name}</a>
			<br/>
</#foreach>
		</td>
	</tr>
</table>

</body>

</html>
