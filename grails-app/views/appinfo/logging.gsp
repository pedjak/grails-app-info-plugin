<head>
<meta name='layout' content='appinfo' />
<title>Loggers</title>

<g:javascript library="jquery" plugin="jquery" />
<g:javascript>
$(document).ready(function() {
	$('#spring').dataTable();
	$('#hibernate').dataTable();
	$('#codec').dataTable();
	$('#controller').dataTable();
	$('#controllerMixin').dataTable();
	$('#domain').dataTable();
	$('#filters').dataTable();
	$('#service').dataTable();
	$('#taglib').dataTable();
	$('#grails').dataTable();
	$('#groovy').dataTable();
	$('#misc').dataTable();
});
</g:javascript>

</head>

<body>

<table style='width: 100%' border='1'>
	<caption>Estimated log4j.xml</caption>
	<tbody>
	<tr><td><textarea style='width: 100%; height: 300px;'>
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

<div id="codecHolder">
<h2>Codecs</h2>
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

<br/><br/>

<div id="controllerHolder">
<h2>Controllers</h2>
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

<br/><br/>

<div id="controllerMixinHolder">
<h2>Controller Mixins</h2>
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

<br/><br/>

<div id="domainHolder">
<h2>Domain Classes</h2>
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

<br/><br/>

<div id="filtersHolder">
<h2>Filters</h2>
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

<br/><br/>

<div id="serviceHolder">
<h2>Services</h2>
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

<br/><br/>

<div id="taglibHolder">
<h2>TagLibs</h2>
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

<br/><br/>

<div id="grailsHolder">
<h2>Grails</h2>
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

<br/><br/>

<div id="groovyHolder">
<h2>Groovy</h2>
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

<br/><br/>

<div id="springHolder">
<h2>Spring</h2>
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

<br/><br/>

<div id="hibernateHolder">
<h2>Hibernate</h2>
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

<br/><br/>

<div id="miscHolder">
<h2>Misc</h2>
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

<br/><br/>

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
