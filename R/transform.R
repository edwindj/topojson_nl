library(rgdal)

toWGS84 <- function(shp){
  require(rgdal)
  RD <- CRS("+init=epsg:28992 +towgs84=565.237,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812")
  WGS84 <- CRS("+proj=longlat +datum=WGS84")  
  proj4string(shp) <- RD
  
  spTransform(shp, WGS84)
}

#http://www.cbs.nl/nl-NL/menu/themas/dossiers/nederland-regionaal/links/2013-wijk-en-buurtkaart-2012-versie-1.htm