
# Code: Dr. Mustafa ZEYBEK

# EllipseDirectFit  
# Date: 18.04.2021

# Load Library ------------------------------------------------------------

library(conicfit)
library(fields)
library(lidR)
library(ggplot2)

# Load Data ---------------------------------------------------------------

data <- readLAS(files = "circ_fit_test.las")

# Start Timer
time <- proc.time()

data.df <- data@data[,1:2]

# Circle Fit --------------------------------------------------------------

xy <- as.matrix(data.df)


xy.min1 <- round(min(xy[,1]))[1]
xy.min2 <- round(min(xy[,2]))[1]
xy[,1] <-xy[,1]-xy.min1 
xy[,2] <-xy[,2]-xy.min2 

ellipDirect <- fitbookstein(xy)
#ellipDirectG <- AtoG(ellipDirect)$ParG
n.xy <- length(xy)
xyDirect<-calculateEllipse(ellipDirect$z[1], ellipDirect$z[2], ellipDirect$a,
                           ellipDirect$b, 180/pi*ellipDirect$alpha,steps = n.xy)

library(RANN)

dist <- nn2(xyDirect, query = xy, k = 1, treetype = c("kd"), searchtype = c("radius"), radius = 6)
dist.th <- dist$nn.dists[dist$nn.dists <= 2]
hist(dist.th)
max(dist.th)
min(dist.th)



xyDirect[,1] <- xyDirect[,1]+xy.min1
xyDirect[,2] <- xyDirect[,2]+xy.min2
xyDirect.df <- data.frame(xyDirect)
colnames(xyDirect.df) <- c("x", "y")

xy.end <- xyDirect[dist$nn.idx,]
colnames(xy.end) <- c("Xend", "Yend")
seg.df <- data.frame(data.df, xy.end)

# PLOTS -------------------------------------------------------------------

# Plot
ggplot(data = data.df, mapping = aes(x=X, y=Y))+
  geom_point()+coord_fixed(ratio = 1)+
  theme_bw(base_size = 20)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.6, hjust=0.8))+
  xlab("Easting [m]") + ylab("Northing [m]")

ggplot(xyDirect.df,aes(x,y)) + 
  geom_path(col="green")+
  geom_point(data = data.df, mapping = aes(x=X, y=Y), size=0.2)+coord_fixed(ratio = 1)+
  theme_bw(base_size = 20)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.6, hjust=0.8))+
  xlab("Easting [m]") + ylab("Northing [m]")+
  geom_segment(data=seg.df, aes(X, Y, xend=Xend, yend=Yend, col="red"))


# Basic histogram
#ggplot(dists, aes(x=c.dists.)) + 
#  geom_histogram(binwidth=0.1,color="black", fill="grey")+
#  theme_bw(base_size = 20) + ylab("Count") + xlab("Distance [m]")

# Basic histogram
res <- data.frame(dist.th)
n=length(res)
binwidth = 0.1 # passed to geom_histogram and stat_function
ggplot(res, aes(x=dist.th)) + 
  geom_histogram(aes(y=..density..), colour="black", fill="white",binwidth=0.1)+
  # geom_histogram(binwidth=0.1,color="black", fill="grey")+ ylab("Count") + xlab("Residuals [m]")+
  theme_bw(base_size = 20) + 
  ylab("Density") + xlab("Residuals [m]")+
  geom_density(alpha=.2, fill="#FF6666") +
  geom_vline(aes(xintercept=mean(dist.th)),
             color="blue", linetype="dashed", size=1.5)


# Statistical Analysis ----------------------------------------------------
# Relative Error
# Residual/mean(expected)
RE <- sum(dist.th)/mean(dist.th)
RE
STD <- sqrt(sum(dist.th^2)/(length(dist.th)-1))
STD

# STANDARD DEVIATION OF THE MEAN (STANDARD ERROR)
# When we report the average value of N measurements, 
# the uncertainty we should associate with this average value 
# is the standard deviation of the mean, often called the standard error (SE).
sigma <- STD/sqrt(length(dist.th))
sigma


#FRACTIONAL UNCERTAINTY REVISITED
sigma/mean(dist.th)

# End of Programme --------------------------------------------------------

sprintf("Processing time is :%3.3f s.", round((proc.time()- time)[3], digits = 2))

