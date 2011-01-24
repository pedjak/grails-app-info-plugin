digraph EntityGraph {
	compound=true;
	bgcolor="white";
	fontcolor="black";
	fontname="Helvetica";
	fontsize="10.0";
	ranksep="equally";
	label="Entity Graph";
	URL="http://grails.org";
	edge [
		color="lightgrey",
		fontcolor="black",
		fontname="Helvetica",
		fontsize="8.0",
		labelangle=-25.0,
		labeldistance=1.5
	];
	node [
		fontcolor="black",
		fontname="Helvetica",
		fontsize="10.0",
		shape=record,
		fillcolor="#D4E5FE",
		style="solid,filled"
	];

<#foreach entity in cfg.classMappings>
	/* Node ${entity.entityName} */
	<@nodeName entity.entityName/> [label="<@propertyLabels name=entity.entityName root=entity/>", URL="URL_ROOT${entity.entityName}"]
	/* Subclass edges for ${entity.entityName} */
	<#foreach subclass in entity.directSubclasses>
		<@nodeName subclass.entityName/> -> <@nodeName entity.entityName/>  [weight="10", arrowhead="onormal"]
	</#foreach>
	<@propertyEdges rootName=entity.entityName?replace(".","_dot_") root=entity/>
</#foreach>
}

<#macro nodeName name>${name?replace(".","_dot_")}</#macro>

<#macro propertyLabels name root>
<@compress single_line=true>
	{
		${name?replace(".","\\.")}|

<#if root.identifier.getClass().name != 'org.hibernate.mapping.Component'>
	${root.identifierProperty.name}\l
</#if>
<#if root.identifier.getClass().name == 'org.hibernate.mapping.Component'>
	compound_id(<#foreach idp in root.identifier.propertyIterator>${idp.name} </#foreach>)\l
</#if>

<#foreach p in root.propertyIterator>
<#if p.value.isSimpleValue()>
<#if p.getClass().name != 'org.hibernate.mapping.Backref'>
<#if p.getClass().name != 'org.hibernate.mapping.IndexBackref'>
	${p.name}\l
</#if>
</#if>
</#if>
</#foreach>
	}
</@compress>
</#macro>

<#macro dumpComponent compProperty>
<#assign component=compProperty.value>
/* Node component ${component} */
${c2h.getHibernateTypeName(compProperty)?replace(".","_dot_")} [
	label="<@propertyLabels name=component.componentClassName root=component/>"
]
<@propertyEdges rootName=component.componentClassName?replace(".","_dot_") root=component/>
</#macro>

<#macro propertyEdges rootName root>

/* Property edges/nodes for ${rootName} */
<#foreach property in root.propertyIterator>

<#if property.getClass().name != 'org.hibernate.mapping.Backref'>

<#if c2h.getHibernateTypeName(property)?exists>
	${rootName} -> ${c2h.getHibernateTypeName(property)?replace(".","_dot_")} [
		label="${property.name}"
<#if c2j.isComponent(property)>
		arrowtail="diamond"
</#if>
	]
</#if>
<#if c2j.isComponent(property)>
<@dumpComponent property/>
</#if>

</#if>  

</#foreach>
</#macro>
