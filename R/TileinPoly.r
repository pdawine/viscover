#' @importClassesFrom sp SpatialPointsDataFrame SpatialPolygonsDataFrame SpatialPolygons
#' @importClassesFrom raster RasterLayer
NULL

#' Overlay raster tile and polygon
#'
#' Obtain the spatial intersection of a rater tile and a spatial polygon.
#'
#' @param tile a raster object
#' @param poly a spatial polygon object in WGS84
#' @return a dataframe with the counts of tile points in the polygon
#' @examples
#' library(dplyr)
#' TileinPoly(tile, poly)
#' @export
TileinPoly <- function(tile, poly){

  sp::proj4string(poly) <- sp::CRS("+init=epsg:4326")
  poly2 <- sp::spTransform(poly, sp::proj4string(tile))
  tilesub <- raster::crop(tile, sp::bbox(poly2))
  tilepoint <- raster::rasterToPoints(tilesub, spatial = T)
  joint <- tilepoint[sp::geometry(poly2),]
  count <- joint@data %>% table %>% raster::as.data.frame()

  return(count)
}