

## Google Maps Coord. to EPSG
#EPSG:3857
#WGS 84 / Pseudo-Mercator -- Spherical Mercator,

library(sp)
library(leaflet)

#lon lat
x <- c(27.182908, 27.183358, 27.183940, 27.183169)
y <- c(39.132027 , 39.132310, 39.131729, 39.131516 )

df <- data.frame(lon=x, lat=y)
coordinates(df) <- c("lon", "lat")

proj4string(df) <- CRS("+init=epsg:4326") # WGS 84
print(summary(df))
  
CRS.new <- CRS("+init=epsg:5253")
tm_coord <- spTransform(df, CRS.new)
print(summary(tm_coord))

m <- leaflet(df) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng = df@coords[,1], lat = df@coords[,2]) %>% 
  addProviderTiles(providers$OneMapSG.Grey)
m  # Print the map
