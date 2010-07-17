<#foreach queryKey in cfg.namedSQLQueries.keySet()>
<#assign queryDef = cfg.namedSQLQueries.get(queryKey)>
    <sql-query 
        name="${queryKey}"
<#if queryDef.flushMode?exists>
        flush-mode="${queryDef.flushMode.toString().toLowerCase()}"
</#if>
<#if queryDef.isCacheable()>
	    cacheable="${queryDef.isCacheable()?string}"
</#if>
<#if queryDef.cacheRegion?exists>
	    cache-region="${queryDef.cacheRegion}"
</#if>
<#if queryDef.fetchSize?exists>
        fetch-size="${queryDef.fetchSize}"
</#if>
<#if queryDef.timeout?exists>
        timeout="${queryDef.timeout?c}"
</#if>    
>
<#foreach tableName in queryDef.querySpaces>
	    <synchronize table="${tableName}" />
</#foreach>
      <![CDATA[${queryDef.queryString.trim()}]]>
    </sql-query>
    
</#foreach>