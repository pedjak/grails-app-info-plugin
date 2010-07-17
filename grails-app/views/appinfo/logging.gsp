<head>
<meta name='layout' content='appinfo' />
<title>Loggers</title>
<g:javascript library="jquery" plugin="jquery" />
</head>

<body>

<table style='width: 100%' border='1'>
	<caption>Estimated log4j.xml</caption>
	<tbody>
	<tr><td><textarea style='width: 100%; height: 300px;'>
<%=log4jXml%>
	</textarea></td></tr>
</table>

<table style='width: 100%' border='1'>
	<caption>Loggers</caption>
	<thead>
	<tr>
		<th>Logger</th>
		<th>Level</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<g:form action='setLogLevel'>
		<td>New: <g:textField name='logger' size='75' /></td>
		<td><select onchange="${remoteFunction(action: 'setLogLevel', params: 'generateParameters(this, true)')}"
				name='level' id='level'>
			<g:each var='level' in='${allLevels}'>
				<option>${level}</option>
			</g:each>
			</select>
		</td>
		</g:form>
	</tr>
	<g:each var='loggerNameAndLevel' in='${loggers}'>
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

<script>
function generateParameters(theSelect, manual) {
	var logger
	if (manual) {
		logger = $('logger').value;
	}
	else {
		logger = escape(theSelect.id.substring('level_'.length));
	}

	return "logger=" + logger +
	       "&level=" + theSelect.options[theSelect.selectedIndex].value;
}
</script>
</body>
