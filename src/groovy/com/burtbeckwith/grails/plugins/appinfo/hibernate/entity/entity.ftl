<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/tr/html4/loose.dtd">

<html>

<head>
<title>Hibernate Mappings - Entity Info</title>
</head>

<body>

<h4>${class.packageName}</h4>
<h3>Entity : ${class.getShortName()} </h3>

<#if class.isInterface()>Interface Name :
<#else>Class Name :
</#if>
${class.qualifiedDeclarationName}
<br/>
<#if class.getMetaAsString("class-description")?has_content><HR>
<br/>
 ${class.getMetaAsString("class-description")}
<br/>
</#if><hr/>

<#if class.hasIdentifierProperty()><#assign propertyIdentifier = class.getIdentifierProperty()><p>
<a name="identifier_summary"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="9" class="MainTableHeading">Identifier Summary</th></tr>
		<tr>
			<th width="14%">Name</th>
			<th width="14%">Column</th>
			<th width="14%">Type</th>
			<th width="58%">Description</th>
		</tr>
	</thead>

<#if dochelper.getComponentPOJO(propertyIdentifier)?exists>
 <#assign compoclass = dochelper.getComponentPOJO(propertyIdentifier)>
 <#foreach prop in compoclass.allPropertiesIterator>
   <#assign columnIterator = prop.getValue().columnIterator>
   <#assign rowspan = prop.getValue().getColumnSpan()>
		<tr>
			<td width="14%" rowspan="${rowspan}"><a href='#field_summary'>${prop.name}</a></td>

   <#if (rowspan>0)>
     <#assign column = columnIterator.next()>
     <#if column.isFormula()>
			<td width="14%">&nbsp;</td>
     <#else>
			<td width="14%"><a href='#property_summary'>${column.getName()}</a>
   </#if>
			</td>

   <#else>
			<td width="14%">&nbsp;</td>
   </#if>
			<td width="14%" rowspan="${rowspan}">

   <#if dochelper.getComponentPOJO(prop)?exists>
				&nbsp;
				<a href='${docFileManager.getRef(docFile, docFileManager.getEntityDocFileByDeclarationName(dochelper.getComponentPOJO(prop)))}' target="generalFrame">
					${compoclass.getJavaTypeName(prop, jdk5)}
				</a>
   <#else>
				&nbsp; ${compoclass.getJavaTypeName(prop, jdk5)}
   </#if>
			</td>

			<td width="44%" rowspan="${rowspan}">&nbsp;
   <#if compoclass.hasFieldJavaDoc(prop)?exists>
                ${compoclass.getFieldDescription(prop)}
   </#if>
  			</td>
		</tr>
   <#if (rowspan>1)>
    <#foreach column in columnIterator>
 		<tr><td><a href='#property_summary'>${column.name}</a></td></tr>
    </#foreach>
  </#if>
 </#foreach>
<#else>
		<tr>
			<td width="14%"><a href='#field_summary'>${propertyIdentifier.name}</a></td>
			<td width="14%">Column</td>
			<td width="14%">&nbsp; ${class.getJavaTypeName(propertyIdentifier, jdk5)}</td>
			<td width="58%">&nbsp;
				<#if class.hasFieldJavaDoc(propertyIdentifier)>
						${class.getFieldDescription(propertyIdentifier)}
				</#if>
			</td>
		</tr>
</#if>
</table>
</#if>
<p>
<a name="property_summary"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="9" class="MainTableHeading">Property Summary</th></tr>
		<tr>
			<th width="14%">Name</th>
			<th width="14%">Column</th>
			<th width="14%">Access</th>
			<th width="14%">Type</th>
			<th width="44%">Description</th>
		</tr>
	</thead>
	<tbody>

<#foreach prop in class.allPropertiesIterator>
<#assign columnIterator = prop.getValue().columnIterator>
<#assign rowspan = prop.getValue().getColumnSpan()>
<#assign getterName = propertyHelper.getPropertyAccessorName(prop)>
		<tr>
			<td width="14%" rowspan="${rowspan}"><a href='#field_summary'>${prop.name}</a></td>

<#if (rowspan>0)>
<#assign column = columnIterator.next()>
	<#if column.isFormula()>
			<td width="14%">&nbsp;</td>
	<#else>
			<td width="14%"><a href='#property_summary'>${column.getName()}</a>
	</#if>
			</td>

<#else>
			<td width="14%">&nbsp;</td>

</#if>
			<td width="14%" rowspan="${rowspan}">
				${getterName} (<a href='#property_summary'>get</a> / <a href='#property_summary'>set</a>)
			</td>

			<td width="14%" rowspan="${rowspan}">

<#if dochelper.getComponentPOJO(prop)?exists>
				&nbsp;
				<a href='${docFileManager.getRef(docFile, docFileManager.getEntityDocFileByDeclarationName(dochelper.getComponentPOJO(prop)))}' target="generalFrame">
					${class.getJavaTypeName(prop, jdk5)}
				</a>
<#else>
				&nbsp; ${class.getJavaTypeName(prop, jdk5)}
</#if>
			</td>

			<td width="44%" rowspan="${rowspan}">&nbsp;
<#if class.hasFieldJavaDoc(prop)>${class.getFieldDescription(prop)}
</#if>
			</td>
		</tr>
<#if (rowspan>1)><#foreach column in columnIterator>
		<tr><td><a href='#property_summary'>${column.name}</a></td></tr>
</#foreach></#if></#foreach>
	</tbody>
</table>
<p>

</body>

</html>
