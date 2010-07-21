package com.burtbeckwith.grails.plugins.appinfo

class ChartTagLib {

	static namespace = 'appinfo'

	def chart = { attrs ->
		String name = attrs.remove('name') // e.g. 'heapPoolGraph'
		int height = attrs.remove('height').toInteger()
		int width = attrs.remove('width').toInteger()
		def barNames = attrs.remove('barNames') // e.g. ['PS Eden Space', 'PS Survivor Space', 'PS Old Gen']
		def sectionNames = attrs.remove('sectionNames') // e.g. ['Init', 'Used', 'Committed', 'Max']
		def data = attrs.remove('data')
		def stacked = attrs.remove('stacked')
		boolean isStacked = (stacked instanceof Boolean) ? stacked : true
		String title = attrs.remove('title') ?: ''

		def dataLines = []
		data.each { key, values ->
			def line = new StringBuilder("['")
			line.append key
			line.append "'"
			for (datum in values) {
				line.append ', '
				line.append datum
			}
			line.append ']'
			dataLines << line.toString()
		}
		out << """
<div id='$name'></div>
<script>

var ${name}_dataTable = new google.visualization.DataTable();
var ${name}_data = [
	${dataLines.join(",\n\t")}
];
var ${name}_barNames = ['${barNames.join("', '")}'];

${name}_dataTable.addColumn('string', 'Type');
for (var i = 0; i  < ${name}_data.length; ++i) {
	${name}_dataTable.addColumn('number', ${name}_data[i][0]);
}

${name}_dataTable.addRows(${name}_barNames.length);

for (var j = 0; j < ${name}_barNames.length; ++j) {
	${name}_dataTable.setValue(j, 0, ${name}_barNames[j]);
}
for (var i = 0; i  < ${name}_data.length; ++i) {
	for (var j = 1; j  < ${name}_data[i].length; ++j) {
		${name}_dataTable.setValue(j - 1, i + 1, ${name}_data[i][j]);
	}
}

new google.visualization.ColumnChart(document.getElementById('$name')).draw(
	${name}_dataTable, {isStacked: $isStacked, width: $width, height: $height,
	                    min: 0, title: "$title"});

</script>
"""
	}
}
