<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Entity Summary</title>
</head>

<body>

<h1>Hibernate Mapping Documentation</h1>

<h2>Package ${package}</h2>

<p>
<#if (classList.size()>0)>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr>
			<th colspan="2" class="MainTableHeading">Entities Summary</th>
		</tr>
	</thead>
	<tbody>
<#foreach class in classList>
		<tr>
			<td width="30%">
				<a href='${docFileManager.getRef(docFile, docFileManager.getEntityDocFile(class))}' target="generalFrame">
					<b>${class.declarationName}</b>
				</a>
			</td>
			<td width="70%">
&nbsp;${class.getMetaAsString("class-description")}
			</td>
		</tr>
</#foreach>
	</tbody>
</table>
</#if>
</body>
