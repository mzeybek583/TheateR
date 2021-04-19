
# Code: Dr. Mustafa ZEYBEK

# CircleFitByPratt 
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

c3 <- CircleFitByPratt(xy)
center <- data.frame(c3[1]+xy.min1, c3[2]+xy.min2)
R <- c3[3]
colnames(center) <- c("x", "y")
xyc3<-calculateCircle(c3[1],c3[2],c3[3])

xyc3[,1] <- xyc3[,1]+xy.min1
xyc3[,2] <- xyc3[,2]+xy.min2
#plot(xyc3[,1]+xy.min1,xyc3[,2]+xy.min2,col='green',type='l')#;par(new=TRUE)

xyc3.df <- data.frame(xyc3)
colnames(xyc3.df) <- c("x","y")

dists <- rdist(center, data.df)
dists <- data.frame(c(dists))
residuals <- data.frame(c(R - dists))

# PLOTS -------------------------------------------------------------------

# Plot
ggplot(data = data.df, mapping = aes(x=X, y=Y))+
  geom_point()+coord_fixed(ratio = 1)+
  theme_bw(base_size = 20)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.6, hjust=0.8))+
  xlab("Easting [m]") + ylab("Northing [m]")

ggplot(xyc3.df,aes(x,y)) + 
  geom_point(center,mapping=aes(x,y), shape = 3, color = "black", size = 3)+
  geom_path(col="red")+
  geom_point(data = data.df, mapping = aes(x=X, y=Y))+coord_fixed(ratio = 1)+
  theme_bw(base_size = 20)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.6, hjust=0.8))+
  xlab("Easting [m]") + ylab("Northing [m]")

# Basic histogram
ggplot(dists, aes(x=c.dists.)) + 
  geom_histogram(binwidth=0.1,color="black", fill="grey")+
  theme_bw(base_size = 20) + ylab("Count") + xlab("Distance [m]")

# Basic histogram
n=length(residuals$c.dists.)
binwidth = 0.1 # passed to geom_histogram and stat_function
ggplot(residuals, aes(x=c.dists.)) + 
  geom_histogram(aes(y=..density..), colour="black", fill="white",binwidth=0.1)+
  # geom_histogram(binwidth=0.1,color="black", fill="grey")+ ylab("Count") + xlab("Residuals [m]")+
  theme_bw(base_size = 20) + 
  ylab("Density") + xlab("Residuals [m]")+
  geom_density(alpha=.2, fill="#FF6666") +
  geom_vline(aes(xintercept=mean(c.dists.)),
             color="blue", linetype="dashed", size=1.5)


# Statistical Analysis ----------------------------------------------------
# Relative Error
# Residual/mean(expected)
RE <- sum(residuals)/R
RE
STD <- sqrt(sum(residuals$c.dists.^2)/(length(residuals$c.dists.)-1))
STD

# STANDARD DEVIATION OF THE MEAN (STANDARD ERROR)
# When we report the average value of N measurements, 
# the uncertainty we should associate with this average value 
# is the standard deviation of the mean, often called the standard error (SE).
sigma <- STD/sqrt(length(residuals$c.dists.))
sigma


#FRACTIONAL UNCERTAINTY REVISITED
sigma/mean(residuals$c.dists.)

# End of Programme --------------------------------------------------------

sprintf("Processing time is :%3.3f s.", round((proc.time()- time)[3], digits = 2))
