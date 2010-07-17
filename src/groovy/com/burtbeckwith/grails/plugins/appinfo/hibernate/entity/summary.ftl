<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>Hibernate Mappings - Entity Summary</title>
</head>

<body>

<h1>Hibernate Mapping Documentation</h1>

<#if graphsGenerated>
<p>
	<img src="entitygraph.png" usemap="#entitygraph"/>
	<map name="entitygraph">${entitygrapharea}</map>
</p>
</#if>

<h2>List of Packages</h2>

<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr>
			<th colspan="2" class="MainTableHeading">Packages</th>
		</tr>
	</thead>
	<tbody>
<#foreach package in packageList>
		<tr>
			<td>
				<a href='${docFileManager.getRef(docFile, docFileManager.getPackageSummaryDocFile(package))}' target="generalFrame"><b>${package}</b></a>
			</td>
		</tr>
</#foreach>
	</tbody>
</table>

</body>
