<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Package List</title>
</head>

<body>

<table border="0" width="100%">
	<tr>
		<td nowrap='nowrap'>
			<font class="ListTitleFont">${title}</font>
			<br/>
		</td>
	</tr>
	<tr>
		<td>
			<a href="${docFileManager.getRef(docFile, docFileManager.getAllEntitiesDocFile())}" target="entitiesFrame">all entities</a>
			<br/>
<#foreach package in packageList>
				<a href="${docFileManager.getRef(docFile, docFileManager.getPackageEntityListDocFile(package))}" target="entitiesFrame">${package}</a>
			<br/>
</#foreach>
		</td>
	</tr>
</table>

</body>

</html>