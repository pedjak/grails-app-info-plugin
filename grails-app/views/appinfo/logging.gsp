<head>
<meta name='layout' content='appinfo' />
<title>Loggers</title>

<g:javascript library="jquery" plugin="jquery" />
<g:javascript>
$(document).ready(function() {
	$('#spring').dataTable( { 'bAutoWidth': false } );
	$('#hibernate').dataTable( { 'bAutoWidth': false } );
	$('#codec').dataTable( { 'bAutoWidth': false } );
	$('#controller').dataTable( { 'bAutoWidth': false } );
	$('#controllerMixin').dataTable( { 'bAutoWidth': false } );
	$('#domain').dataTable( { 'bAutoWidth': false } );
	$('#filters').dataTable( { 'bAutoWidth': false } );
	$('#service').dataTable( { 'bAutoWidth': false } );
	$('#taglib').dataTable( { 'bAutoWidth': false } );
	$('#grails').dataTable( { 'bAutoWidth': false } );
	$('#groovy').dataTable( { 'bAutoWidth': false } );
	$('#misc').dataTable( { 'bAutoWidth': false } );

   $("#accordion").tabs("#accordion div.pane", {tabs: 'h2', effect: 'default', initialIndex: null});
});
</g:javascript>

</head>

<body>

<table style='width: 100%' border='1'>
	<caption>Estimated log4j.xml</caption>
	<tbody>
	<tr><td><textarea id='appinfo_log4j'>
<%=log4jXml%></textarea></td></tr>
</table>

<br/><br/>

<g:form action='setLogLevel'>
New Logger: <g:textField name='logger' size='75' />
<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, true)')}" name='level' id='level'>
<g:each var='level' in='${allLevels}'>
	<option>${level}</option>
</g:each>
</select>
</g:form>

<br/>

<div id="accordion" style='width:100%;'>

<h2 class="current">Codecs</h2>
<div id="codecHolder" class="pane" style="display:block">
<table id="codec" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${codec}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Controllers</h2>
<div id="controllerHolder" class="pane">
<table id="controller" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${controller}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Controller Mixins</h2>
<div id="controllerMixinHolder" class="pane">
<table id="controllerMixin" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${controllerMixin}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Domain Classes</h2>
<div id="domainHolder" class="pane">
<table id="domain" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${domain}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Filters</h2>
<div id="filtersHolder" class="pane">
<table id="filters" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${filters}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Services</h2>
<div id="serviceHolder" class="pane">
<table id="service" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${service}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>TagLibs</h2>
<div id="taglibHolder" class="pane">
<table id="taglib" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${taglib}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Grails</h2>
<div id="grailsHolder" class="pane">
<table id="grails" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${grails}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Groovy</h2>
<div id="groovyHolder" class="pane">
<table id="groovy" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${groovy}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Spring</h2>
<div id="springHolder" class="pane">
<table id="spring" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${spring}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Hibernate</h2>
<div id="hibernateHolder" class="pane">
<table id="hibernate" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${hibernate}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

<h2>Misc</h2>
<div id="miscHolder" class="pane">
<table id="misc" cellpadding="0" cellspacing="0" border="0" class="display">
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<g:each var='loggerNameAndLevel' in='${misc}'>
	<tr>
		<td>${loggerNameAndLevel.name}</td>
		<td>
			<select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, false)')}"
				name='level_${loggerNameAndLevel.name}' id='level_${loggerNameAndLevel.name}'>
			<g:each var='level' in='${allLevels}'>
				<option <g:if test='${level == loggerNameAndLevel.level}'> selected='selected'</g:if>>${level}</option>
			</g:each>
			</select>
		</td>
	</tr>
	</g:each>
	</tbody>
</table>
</div>

</div>

<script>
function generateParameters(theSelect, manual) {
	var logger
	if (manual) {
		logger = $('#logger').val();
	}
	else {
		logger = theSelect.id.substring('level_'.length);
	}

	return "logger=" + escape(logger) +
	       "&level=" + theSelect.options[theSelect.selectedIndex].value;
}
</script>
</body>
