<g:render template='/appinfo/hibernateCombos'/>

<g:if test='${!statistics.statisticsEnabled}'>
<div class='errors'>
<ul>
<li>Note: Hibernate Statistics are currently disabled.
</ul>
</div>
</g:if>

<div class='nav'>
	<span class='menuButton'><g:link class='delete' action='hibernateStatisticsReset'>Reset Statistics</g:link></span>
	<g:if test='${statistics.statisticsEnabled}'>
	<span class='menuButton'><g:link class='delete' action='hibernateStatisticsEnable' params='[enable: false]'>Disable Statistics</g:link></span>
	</g:if>
	<g:else>
	<span class='menuButton'><g:link class='create' action='hibernateStatisticsEnable' params='[enable: true]'>Enable Statistics</g:link></span>
	</g:else>
</div>
