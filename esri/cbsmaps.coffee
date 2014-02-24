request = require "request"
fs = require "fs"

URL = "http://geoservices.cbs.nl/arcgis/rest/services/CBSgebiedsindelingen/CBSgebiedsindelingen/MapServer"

request "#{URL}/1/query?text=%&f=json", (err, response, body) ->
	fs.writeFileSync "esri.json", body