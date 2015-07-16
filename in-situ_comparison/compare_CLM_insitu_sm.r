

# script for comparing clm model output with in-situ soil moisture data from oznet


setwd("D:/Users/lrains/Documents/Data/MurrayDarlingBasin/Insitu/Soil_Moisture/OZNET/Uri-Park")


library(zoo)
library(chron)


header = read.csv("OZNET_OZNET_Uri-Park_sm_0.000000_0.300000_CS616_19500101_20150121.stm", nrow=1, header=F, sep="")

f <- function(d, t) as.chron(paste(as.Date(d,"%Y/%m/%d"),t))
z1 <- read.zoo("OZNET_OZNET_Uri-Park_sm_0.000000_0.300000_CS616_19500101_20150121.stm", header = F, skip = 1, index = 1:2, FUN = f)
z2 <- read.zoo("OZNET_OZNET_Uri-Park_sm_0.300000_0.600000_CS616_19500101_20150121.stm", header = F, skip = 1, index = 1:2, FUN = f)
z3 <- read.zoo("OZNET_OZNET_Uri-Park_sm_0.600000_0.900000_CS616_19500101_20150121.stm", header = F, skip = 1, index = 1:2, FUN = f)

z = merge(z1[,1],z2[,1],z3[,1], all=F)
plot(z, plot.type="single",ylim=c(0,0.5))



# select pixel from model output
header$V4
header$V5

smfile = "D:/Users/lrains/Documents/Data/MurrayDarlingBasin/Insitu/Soil_Moisture/t2.clm2.h1.2001-02-24-00000.nc"

library(raster)

setwd("D:/Users/lrains/Documents/Data/MurrayDarlingBasin/Insitu/Soil_Moisture")
x = brick("sresa1b_ncar_ccsm3-example.nc")

nc = open.ncdf("t2clm2h12001022400000.nc")
data <- get.var.ncdf(nc,"H2OSOI")


r85NOXene <- brick("t2clm2h12001022400000.nc", lvar = 4, varname = "H2OSOI")
