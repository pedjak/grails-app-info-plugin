<head>
<meta name='layout' content='appinfo' />
<title>Hibernate Mappings - Entity Info</title>
</head>

<body>

<g:render template='/appinfo/hibernateCombos'/>

<h4>${clazz.packageName}</h4>
<h3>Entity : ${clazz.shortName} </h3>

<g:if test='${clazz.isInterface()}'>
Interface Name :
</g:if>
<g:else>
Class Name :
</g:else>
${clazz.qualifiedDeclarationName}
<br/>
<g:if test='${clazz.getMetaAsString("clazz-description")}'>
<hr/>
<br/>
 ${clazz.getMetaAsString("clazz-description")}
<br/>
</g:if>
<hr/>

<g:if test='${clazz.hasIdentifierProperty()}'>
<p>
<a name="identifier_summary"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="9">Identifier Summary</th></tr>
		<tr>
			<th width="14%">Name</th>
			<th width="14%">Column</th>
			<th width="14%">Type</th>
			<th width="58%">Description</th>
		</tr>
	</thead>

<g:if test='${dochelper.getComponentPOJO(clazz.identifierProperty)}'>
<g:set var='compoclass' value='${dochelper.getComponentPOJO(clazz.identifierProperty)}'/>
<g:each var'prop' in='${compoclass.allPropertiesIterator}'>
	<g:set var='columnIterator' value='${prop.value.columnIterator}'/>
	<g:set var='rowspan' value='${prop.value.columnSpan}'/>
		<tr>
			<td width="14%" rowspan="${rowspan}"><a href='#field_summary'>${prop.name}</a></td>

	<g:if test='${rowspan > 0}'>
		<g:set var='column' value='${columnIterator.next()}'/>
		<g:if test='${column.isFormula()}'>
			<td width="14%">&nbsp;</td>
		</g:if>
		<g:else>
			<td width="14%"><a href='#property_summary'>${column.name}</a>
		</g:else>
			</td>
	</g:if>
	<g:else>
			<td width="14%">&nbsp;</td>
	</g:else>
			<td width="14%" rowspan="${rowspan}">

	<g:if test='${dochelper.getComponentPOJO(prop)}'>
				&nbsp;
				<a href='${docFileManager.getRef(docFile, docFileManager.getEntityDocFileByDeclarationName(dochelper.getComponentPOJO(prop)))}'>
					${compoclass.getJavaTypeName(prop, false)}
				</a>
	</g:if>
	<g:else>
				&nbsp; ${compoclass.getJavaTypeName(prop, false)}
	</g:else>
			</td>

			<td width="44%" rowspan="${rowspan}">&nbsp;
	<g:if test='${compoclass.hasFieldJavaDoc(prop)}'>
				${compoclass.getFieldDescription(prop)}
	</g:if>
			</td>
		</tr>
	<g:if test='${rowspan > 1}'>
		<g:each var='column' in='${columnIterator}'>
 		<tr><td><a href='#property_summary'>${column.name}</a></td></tr>
		</g:each>
	</g:if>
</g:each>
</g:if>
<g:else>
		<tr>
			<td width="14%"><a href='#field_summary'>${clazz.identifierProperty.name}</a></td>
			<td width="14%">Column</td>
			<td width="14%">&nbsp; ${clazz.getJavaTypeName(clazz.identifierProperty, false)}</td>
			<td width="58%">&nbsp;
				<g:if test='${clazz.hasFieldJavaDoc(clazz.identifierProperty)}'>
				${clazz.getFieldDescription(clazz.identifierProperty)}
				</g:if>
			</td>
		</tr>
</g:else>
</table>
</g:if>
<p>
<a name="property_summary"></a>
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<thead>
		<tr><th colspan="9">Property Summary</th></tr>
		<tr>
			<th width="14%">Name</th>
			<th width="14%">Column</th>
			<th width="14%">Access</th>
			<th width="14%">Type</th>
			<th width="44%">Description</th>
		</tr>
	</thead>
	<tbody>

<g:each var='prop' in='${clazz.allPropertiesIterator}'>
<g:set var='columnIterator' value='${prop.value.columnIterator}'/>
<g:set var='rowspan' value='${prop.value.columnSpan}'/>
<g:set var='getterName' value='${propertyHelper.getPropertyAccessorName(prop)}'/>
		<tr>
			<td width="14%" rowspan="${rowspan}"><a href='#field_summary'>${prop.name}</a></td>

<g:if test='${rowspan > 0}'>
<g:set var='column' value='${columnIterator.next()}'/>
	<g:if test='${column.isFormula()}'>
			<td width="14%">&nbsp;</td>
	</g:if>
	<g:else>
			<td width="14%"><a href='#property_summary'>${column.name}</a>
	</g:else>
			</td>
</g:if>
<g:else>
			<td width="14%">&nbsp;</td>

</g:else>
			<td width="14%" rowspan="${rowspan}">
				${getterName} (<a href='#property_summary'>get</a> / <a href='#property_summary'>set</a>)
			</td>

			<td width="14%" rowspan="${rowspan}">

<g:if test='${dochelper.getComponentPOJO(prop)}'>
				&nbsp;
				<a href='${createLink(action: 'hibernateTableInfo') + '?table=' + (docFileManager.getRef(docFile, docFileManager.getEntityDocFileByDeclarationName(dochelper.getComponentPOJO(prop))) - '.html')}'>
					${clazz.getJavaTypeName(prop, false)}
				</a>
</g:if>
<g:else>
				&nbsp; ${clazz.getJavaTypeName(prop, false)}
</g:else>
			</td>

			<td width="44%" rowspan="${rowspan}">&nbsp;
<g:if test='${clazz.hasFieldJavaDoc(prop)}'>
				${clazz.getFieldDescription(prop)}
</g:if>
			</td>
		</tr>
<g:if test='${rowspan > 1}'>
<g:each var='column' in='${columnIterator}'>
		<tr><td><a href='#property_summary'>${column.name}</a></td></tr>
</g:each>
</g:if>
</g:each>
	</tbody>
</table>

<table border='1' width='100%' cellpadding='3' cellspacing='0'>
	<thead>
		<tr><th colspan='2'>Details</th></tr>
		<tr><th>Name</th><th>Value</th></tr>
	</thead>
	<tbody>
		<tr><td>Class Name</td><td>${entity.className}&nbsp;</td></tr>
		<tr><td>Proxy Interface Name</td><td>${entity.proxyInterfaceName}&nbsp;</td></tr>
		<tr><td>Mapped Class</td><td>${entity.mappedClass?.name}&nbsp;</td></tr>
		<tr><td>Proxy Interface</td><td>${entity.proxyInterface?.name}&nbsp;</td></tr>
		<tr><td>Dynamic Insert</td><td>${entity.useDynamicInsert()}&nbsp;</td></tr>
		<tr><td>Subclass Id</td><td>${entity.subclassId}&nbsp;</td></tr>
		<tr><td>Dynamic Update</td><td>${entity.useDynamicUpdate()}&nbsp;</td></tr>
		<tr><td>Discriminator Value</td><td>${entity.discriminatorValue}&nbsp;&nbsp;</td></tr>
		<tr><td>Has Subclasses</td><td>${entity.hasSubclasses()}&nbsp;</td></tr>
		<tr><td>Subclass Span</td><td>${entity.subclassSpan}&nbsp;</td></tr>
		<tr><td>Identity Table</td><td>${entity.identityTable?.name}&nbsp;</td></tr>
		<tr><td>Table</td><td>${entity.table?.name}&nbsp;</td></tr>
		<tr><td>Entity Name</td><td>${entity.entityName}&nbsp;</td></tr>
		<tr><td>Mutable</td><td>${entity.mutable}&nbsp;</td></tr>
		<tr><td>Identifier Property</td><td>${entity.identifierProperty}&nbsp;</td></tr>
		<tr><td>Identifier</td><td>${entity.identifier}&nbsp;</td></tr>
		<tr><td>Version</td><td>${entity.version}&nbsp;</td></tr>
		<tr><td>Discriminator</td><td>${entity.discriminator}&nbsp;&nbsp;</td></tr>
		<tr><td>Inherited</td><td>${entity.inherited}&nbsp;</td></tr>
		<tr><td>Polymorphic</td><td>${entity.polymorphic}&nbsp;</td></tr>
		<tr><td>Versioned</td><td>${entity.versioned}&nbsp;</td></tr>
		<tr><td>Cache Concurrency Strategy</td><td>${entity.cacheConcurrencyStrategy}&nbsp;</td></tr>
		<tr><td>Superclass</td><td>${entity.superclass}&nbsp;&nbsp;</td></tr>
		<tr><td>Explicit Polymorphism</td><td>${entity.explicitPolymorphism}&nbsp;</td></tr>
		<tr><td>Discriminator Insertable</td><td>${entity.discriminatorInsertable}&nbsp;</td></tr>
		<tr><td>Lazy</td><td>${entity.lazy}&nbsp;</td></tr>
		<tr><td>Embedded Identifier</td><td>${entity.hasEmbeddedIdentifier()}&nbsp;</td></tr>
		<tr><td>Entity Persister Class</td><td>${entity.entityPersisterClass?.name}&nbsp;</td></tr>
		<tr><td>Root Table</td><td>${entity.rootTable}&nbsp;</td></tr>
		<tr><td>Root Class</td><td>${entity.rootClass}&nbsp;</td></tr>
		<tr><td>Key</td><td>${entity.key}&nbsp;</td></tr>
		<tr><td>Where</td><td>${entity.where}&nbsp;&nbsp;</td></tr>
		<tr><td>Batch Size</td><td>${entity.batchSize}&nbsp;</td></tr>
		<tr><td>Select Before Update</td><td>${entity.hasSelectBeforeUpdate()}&nbsp;</td></tr>
		<tr><td>Optimistic Lock Mode</td><td>${entity.optimisticLockMode}&nbsp;</td></tr>
		<tr><td>Discriminator Value Not Null</td><td>${entity.discriminatorValueNotNull}&nbsp;</td></tr>
		<tr><td>Discriminator Value Null</td><td>${entity.discriminatorValueNull}&nbsp;</td></tr>
		<tr><td>Meta Attributes</td><td>${entity.metaAttributes}&nbsp;&nbsp;</td></tr>
		<tr><td>Join Closure Span</td><td>${entity.joinClosureSpan}&nbsp;</td></tr>
		<tr><td>Property Closure Span</td><td>${entity.propertyClosureSpan}&nbsp;</td></tr>
		<tr><td>Custom SQL Insert</td><td>${entity.customSQLInsert}&nbsp;</td></tr>
		<tr><td>Custom Insert Callable</td><td>${entity.customInsertCallable}&nbsp;</td></tr>
		<tr><td>Custom SQL Insert CheckStyle</td><td>${entity.customSQLInsertCheckStyle}&nbsp;</td></tr>
		<tr><td>Custom SQL Update</td><td>${entity.customSQLUpdate}&nbsp;</td></tr>
		<tr><td>Custom Update Callable</td><td>${entity.customUpdateCallable}&nbsp;</td></tr>
		<tr><td>Custom SQL Update CheckStyle</td><td>${entity.customSQLUpdateCheckStyle}&nbsp;</td></tr>
		<tr><td>Custom SQL Delete</td><td>${entity.customSQLDelete}&nbsp;</td></tr>
		<tr><td>Custom Delete Callable</td><td>${entity.customDeleteCallable}&nbsp;</td></tr>
		<tr><td>Custom SQL Delete CheckStyle</td><td>${entity.customSQLDeleteCheckStyle}&nbsp;</td></tr>
		<tr><td>Force Discriminator</td><td>${entity.forceDiscriminator}&nbsp;</td></tr>
		<tr><td>Joined Subclass</td><td>${entity.joinedSubclass}&nbsp;</td></tr>
		<tr><td>Loader Name</td><td>${entity.loaderName}&nbsp;</td></tr>
		<tr><td>Synchronized Tables</td><td>${entity.synchronizedTables}&nbsp;</td></tr>
		<tr><td>Abstract</td><td>${entity.isAbstract()}&nbsp;</td></tr>
		<tr><td>Node Name</td><td>${entity.nodeName}&nbsp;</td></tr>
		<tr><td>Pojo Representation</td><td>${entity.hasPojoRepresentation()}&nbsp;</td></tr>
		<tr><td>Dom4j Representation</td><td>${entity.hasDom4jRepresentation()}&nbsp;</td></tr>
		<tr><td>Subselect Loadable Collections</td><td>${entity.hasSubselectLoadableCollections()}&nbsp;</td></tr>
		<tr><td>Temporary Id Table Name</td><td>${entity.temporaryIdTableName}&nbsp;</td></tr>
		<tr><td>Temporary Id Table DDL</td><td>${entity.temporaryIdTableDDL}&nbsp;</td></tr>
		<tr><td>Identifier Mapper</td><td>${entity.identifierMapper}&nbsp;</td></tr>
		<tr><td>Natural Id</td><td>${entity.hasNaturalId()}&nbsp;</td></tr>
		<tr><td>Lazy Properties Cacheable</td><td>${entity.lazyPropertiesCacheable}&nbsp;</td></tr>
	</tbody>
</table>

</body>
