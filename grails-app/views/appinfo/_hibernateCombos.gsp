Tables:
<select onchange="changePage(this, 'hibernateTableInfo', 'table')">
<option/>
<g:each var='table' in='${allTables}'>
<option>${table.name}</option>
</g:each>
</select>

Entities:
<select onchange="changePage(this, 'hibernateEntityInfo', 'entity')">
<option/>
<g:each var='entity' in='${allEntities}'>
<option>${entity.className}</option>
</g:each>
</select>

hbm.xml:
<select onchange="changePage(this, 'hibernateHbm', 'entity')">
<option/>
<g:each var='entity' in='${allEntities}'>
<option>${entity.className}</option>
</g:each>
</select>

<br/><br/><hr/><br/>

<script>
function changePage(theSelect, action, param) {
	var selectedValue = theSelect.options[theSelect.selectedIndex].value;
	if (selectedValue != '') {
		document.location = action + '?' + param + '=' + selectedValue;
	}
}
</script>
