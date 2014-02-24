library(rgdal)

toWGS84 <- function(shp){
  require(rgdal)
  RD <- CRS("+init=epsg:28992 +towgs84=565.237,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812")
  WGS84 <- CRS("+proj=longlat +datum=WGS84")  
  proj4string(shp) <- RD
  
  wgs <- spTransform(shp, WGS84)
  wgs
}

to_geojson <- function(shp, name){
  if (is.character(shp)){
    shp <- readShapeSpatial(shp)
  }
  fn <- paste0(name, ".json")
  unlink(fn)
  writeOGR(shp, dsn=fn, layer=name, driver="GeoJSON", overwrite_layer=T)  
}

#http://www.cbs.nl/nl-NL/menu/themas/dossiers/nederland-regionaal/links/2013-wijk-en-buurtkaart-2012-versie-1.htm