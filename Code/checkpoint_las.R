## Check point in las file or not.

library(progress)
library(lidR)
library(concaveman)
library(pracma)

# search point 
df <- read.csv("picking_list3.txt", sep = ",", header = FALSE)
#picking list. txt
# 684798.260002136230,5017983.670000076294,26.909999847412
# 684853.130001068115,5017974.649999618530,21.329999923706
# 684845.200000762939,5017932.169998168945,24.979999542236
# 684784.440002441406,5017931.800003051758,18.549999237061
# 684865.560001373291,5017803.369995117188,23.379999160767

x <- df$V1; y <- df$V2
#temp = list.files(path="E:/Lidar_Test_Verisi/optech/1200/",pattern="\\.las$", 
#                  full.names = TRUE, recursive = TRUE, include.dirs = TRUE)
#temp = list.files(path="E:/Lidar_Test_Verisi/optech/2600/",pattern="\\.las$", 
#                  full.names = TRUE, recursive = TRUE, include.dirs = TRUE)
 temp = list.files(path="E:/Lidar_Test_Verisi/optech/1200/Tiled/",pattern="\\.las$", 
                  full.names = TRUE, recursive = TRUE, include.dirs = TRUE)

pb <- progress_bar$new(total = length(temp))
ls <- data.frame()

#for (i in ind<- 1:21) {
for (i in ind<- 1:length(temp)) {
    
  pb$tick()
  #Sys.sleep(1 / 100)
  #i<- 64
  las <- readLAS(temp[i])
  #las <- decimate_points(las, algorithm = homogenize(1,5))
  #Polygon
  #df_poly <- matrix(las@data[,1:2])
  #plyg <-concaveman(df_poly)
  # polygon(pg[,1], pg[,2])
  # P <- matrix(runif(20000), 10000, 2)
  # R <- inpolygon(P[, 1], P[, 2], pg[, 1], pg[,2])
  # clrs <- ifelse(R, "red", "blue")
  # points(P[, 1], P[, 2], pch = ".", col = clrs)## End(Not run)
  
  minx <- las@bbox[1,1]
  miny <- las@bbox[2,1]
  maxx <- las@bbox[1,2]
  maxy <- las@bbox[2,2]
  for (j in ind <- 1:length(x)) {
    if (x[j] > minx && x[j] < maxx && y[j] > miny && y[j] < maxy) {
    cat(sprintf("Point LAS file: %s\n",temp[i]))
      out <- temp[i]
      ls <- append(ls, out)
    } 
    #else 
  #{cat(sprintf("Point is not in %s file\n", k))}
  #plot(las)
  }
}

ls2 <- data.frame(unlist(ls))
write.table(ls2, "lasFileList_O1200.txt")

