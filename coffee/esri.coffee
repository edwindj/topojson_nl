###
Based on esri (https://github.com/Esri/geojson-utils) of James Cardona
###
ringIsClockwise = (ringToTest) ->
  total = 0
  pt1 = ringToTest[0]
  for pt2 in ringToTest[1..]
    total += (pt2[0] - pt1[0]) * (pt2[1] + pt1[1])
    pt1 = pt2
  total >= 0

to_geometry = (esri_geom) ->
  if esri_geom
    if esri_geom.x
      geom = {type: "Point", coordinates: [esri_geom.x, esri_geom.y]}
    else if esri_geom.points
      geom = {type: "MultiPoint", coordinates: esri_geom.points}
    else if esri_geom.paths
      geomParts = esri_geom.paths
      if geomParts.length is 1
        geom = {type: "LineString", coordinates: geomParts[0]}
      else
        geom = {type: "MultiLineString", coordinates: geomParts}
    else if esri_geom.rings
      ringArray = []
      for ring in esri_geom.rings
        if ringIsClockwise(ring)
          ringArray.push [ring]
        else
          ringArray[ringArray.length - 1].push ring
      if ringArray.length > 1
        geom = {type: "MultiPolygon", coordinates: ringArray}
      else
        geom = {type: "Polygon", coordinates: ringArray.pop()}
  geom

to_feature= (esri_feat, name_filter) ->
  feat = null
  if esri_feat
    feat = type: "Feature"
    feat.geometry = to_geometry(esri_feat.geometry)  if esri_feat.geometry
    if esri_feat.attributes
      props = {}
      for prop, value of esri_feat.attributes
        props[name_filter(prop)] = value
      feat.properties = props
  feat

to_geojson = (esri_object, name_filter = (x) -> x) ->
  if esri_object
    if esri_object.features
      geojson =
        type: "FeatureCollection"
        features: []
      for esri_feat in esri_object.features
        feat = to_feature(esri_feat, name_filter)
        geojson.features.push feat if feat
    else if esri_object.geometry
      geojson = to_feature(esri_object)
    else
      geojson = to_geometry(esri_object)
  geojson

exports.to_geojson = to_geojson

###test = true 
if test?
  fs = require "fs"
  e = require "./esri_f.json"
  g = to_geojson e, (x) -> x.toLowerCase().replace /^\w{2}_/, ""
  fs.writeFileSync("geo.json", JSON.stringify g)###