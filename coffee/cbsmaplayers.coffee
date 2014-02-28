request = require "request"
fs = require "fs"
Q = require "q"
e = require "./esri.coffee"

URL = "http://geoservices.cbs.nl/arcgis/rest/services/CBSgebiedsindelingen/CBSgebiedsindelingen/MapServer"
# get all regions, all fields, in WGS84
QUERY = "text=%&outFields=*&outSR=4326&f=json"

qrequest = (url) ->
	d = Q.defer()
	request url, (err, response, body) ->
		d.resolve JSON.parse(body)
	d.promise

###request "#{URL}/1/query?text=%&f=json", (err, response, body) ->
	fs.writeFileSync "esri.json", body
###

get_esri = (id, name, esri, objectid = 0) ->
	req = qrequest("#{URL}/#{id}/query?#{QUERY}&where=objectid > #{objectid}}")
	req.then (data) ->
		if esri? 
			esri.features = esri.features.concat data.features
		else esri = data 
		console.log "getting '#{name}' (#{objectid})..."
#		console.log esri.features[0]
		if data.exceededTransferLimit
        	return get_esri id, name, esri, objectid + 1000
        console.log "Saving '#{name}'..."
        return esri
	req.then (esri) ->
	    fs.writeFileSync "../layers/#{name}.esrijson", JSON.stringify esri
	    return esri
    req.then (esri) ->
	    geo = e.to_geojson esri
	    fs.writeFileSync "../layers/#{name}.geojson", JSON.stringify geo
	    return esri
    
qrequest("#{URL}?f=json")
.then (maps) ->
	layers = (l for l in maps.layers when l.subLayerIds is null)
	#console.log layers
	for l in layers#[4..4]
		get_esri(l.id, l.name).all()
