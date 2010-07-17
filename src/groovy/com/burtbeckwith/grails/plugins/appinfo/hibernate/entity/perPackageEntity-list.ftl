<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Entity List</title>
</head>

<body>

<table border="0" width="100%">
	<tr>
		<td nowrap='nowrap'>
			<font class="ListTitleFont">
				<a href='${docFileManager.getRef(docFile, docFileManager.getPackageSummaryDocFile(title))}' target="generalFrame">${title}</a>
			</font>
			<br/>
		</td>
	</tr>
<#if (classList.size()>0)>
	<tr>
		<td>Entities<br/>
<#foreach class in classList>
			<a href='${docFileManager.getRef(docFile, docFileManager.getEntityDocFile(class))}' target="generalFrame">${class.declarationName}</a>
			<br/>
</#foreach>
		</td>
	</tr>
</#if>

</table>
</body>
</html>
