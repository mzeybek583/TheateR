


## Clip Las File


# Load Library ------------------------------------------------------------


library(lidR)

## Read data
mainDir <- "E:/DR_Sonrasi_Projeler/MAA_LidarBergamaTiyatro/R/"
subDir <- "Result"


# shapefile
# Extract all the polygons from a shapefile
f <- c("E:/DR_Sonrasi_Projeler/MAA_LidarBergamaTiyatro/LasData/roi.shp")
roi <- sf::st_read(f, quiet = TRUE)

# Optech 2600 -------------------------------------------------------------

#las data
las <- readLAS("E:/DR_Sonrasi_Projeler/MAA_LidarBergamaTiyatro/LasData/O2600/pt000187.las")
O2600 <- clip_roi(las, roi)
O2600_cln <- classify_noise(O2600, sor(6,3))
# Remove outliers using filter_poi()
las <- filter_poi(O2600_cln, Classification != LASNOISE)

ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)

writeLAS(las,"Result/O2600_clean_clipped.las")

# Riegl1200 ---------------------------------------------------------------

#las data
las <- readLAS("E:/DR_Sonrasi_Projeler/MAA_LidarBergamaTiyatro/LasData/R1200/riegl_1200_121-tiyatro.las")
R1200 <- clip_roi(las, roi)
R1200_cln <- classify_noise(R1200, sor(6,3))
# Remove outliers using filter_poi()
las <- filter_poi(R1200_cln, Classification != LASNOISE)

writeLAS(las,"Result/R1200_clean_clipped.las")

# Riegl2600 ---------------------------------------------------------------

#las data
las <- readLAS("E:/DR_Sonrasi_Projeler/MAA_LidarBergamaTiyatro/LasData/R2600/riegl_2600_148.las")
R2600 <- clip_roi(las, roi)
R2600_cln <- classify_noise(R2600, sor(6,3))
# Remove outliers using filter_poi()
las <- filter_poi(R2600_cln, Classification != LASNOISE)

writeLAS(las,"Result/R2600_clean_clipped.las")
