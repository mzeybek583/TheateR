


# Load Library ------------------------------------------------------------

library(lidR)



# Load Data ---------------------------------------------------------------

las <- readLAS(files = "Result/O1200_clean_clipped.las")

chm <- grid_canopy(las, res = 0.1, pitfree(c(0,1,2,5,10,15), c(0, 1),subcircle = 0))
col <- height.colors(50)

plot(chm, col=col)

library(zoo)
chm2 <- chm
chm2@data@values <- na.approx(chm@data@values)

plot(chm2)

writeRaster(chm2,"Result/O1200_raster_filled.asc", overwrite=TRUE)

# Parameters --------------------------------------------------------------

myenv <- rsaga.env(path="C:/Program Files/QGIS 3.10/apps/saga-ltr", 
                   workspace = "E:/DR_Sonrasi_Projeler/MAA_LidarBergamaTiyatro/R")
CDEDsgrd<-"Result/O1200.sgrd"


#f1 <- focal(chm, w=matrix(1/9,nrow=3,ncol=3),fun=mean, na.rm=TRUE)
r_focal = focal(chm, w = matrix(1, nrow = 3, ncol = 3), fun = max)


plot(r_focal)
plot(chm)
plot(f1)

plot(chm)

writeRaster(chm,"Result/O1200_raster.asc", overwrite=TRUE)

library(RSAGA)

#read in ASCII DEM and then write to SAGA grid format
asc<-read.ascii.grid("Result/O1200_raster.asc", return.header = TRUE, print = 0, 
                     nodata.values = c(), at.once = TRUE, na.strings = "NA")

write.sgrd(asc, CDEDsgrd, env=myenv)


xx <- read.sgrd("Result/O1200.sgrd", return.header = TRUE, print = 0,
          nodata.values = c(0), at.once = TRUE, env=myenv)

rsaga.slope(in.dem = xx, out.slope = "Result/slope", method = "poly2zevenbergen", env= myenv)


library(raster)
x <- terrain(chm, opt=c('slope', 'aspect'), unit='degrees')

plot(x)
is.na(O1200_raster)
rsaga.geoprocessor("ta_lighting",0,list(ELEVATION=O1200_raster,SHADE="hillshade",EXAGGERATION=2),env = myenv)


rsaga.slope(in.dem = O1200_raster, "slope", method = "poly2zevenbergen", env = myenv)

