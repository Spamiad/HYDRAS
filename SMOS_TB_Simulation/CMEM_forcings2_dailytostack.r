



library(ncdf)
library(raster)


stackfunction("TSKIN")
stackfunction("SD")
stackfunction("RSN")
stackfunction("SWVL1")
stackfunction("SWVL2")
stackfunction("SWVL3")
stackfunction("STL1")
stackfunction("STL2")
stackfunction("STL3")


stackfunction = function (cmemvar) {
# folder with daily forcing files including hourly data 
files = list.files(paste("F:/CESM_Output/16_09_2015/_CMEMforcing/",cmemvar, sep = "", collapse = NULL), pattern=".nc", all.files=T, full.names=T)

nc = open.ncdf(files[1])

lon = get.var.ncdf(nc,"LONGITUDE")
lat = get.var.ncdf(nc,"LATITUDE")
#time = get.var.ncdf(nc,"TIME")



lev  = 1

# Define some straightforward dimensions
x <- dim.def.ncdf( "LONGITUDE", "LONGITUDE", lon)
y <- dim.def.ncdf( "LATITUDE", "LATITUDE", lat)

l <- dim.def.ncdf( "LEV", "LEV", 1)

r = stack(files)
r = t(r)
r = flip(r,1)

dims = dim(r)
dims = dims[3]

time = seq(1:(dims-1))
t <- dim.def.ncdf( "TIME", "TIME", time)

# first hour is 23:00 - 24:00 of last day
r = r[[2:dims]]

data1 <- array(0,dim=c(160,160,1,dims-1))
data1[,,1,] <- as.array(r)

sm1 = var.def.ncdf(cmemvar,cmemvar, list(x,y,l,t), 1.e30)
ncout1 <- create.ncdf(paste (cmemvar,".nc", sep = "", collapse = NULL), sm1)
put.var.ncdf(ncout1, sm1, data1)
close.ncdf(ncout1)
}