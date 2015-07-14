

# test for reading ncdf file and extracting data at specific coordinates

library(raster)


setwd("C:/Users/Dommi/Desktop/clm_out")

files <- list.files("C:/Users/Dommi/Desktop/clm_out","*.nc", full.names = TRUE)
r = stack(files)

r = brick("t2.clm2.h1.2000-01-01-00000.nc")

point <- cbind(145.0625, -37.3125)
result <- extract(r, point)


relibrary(zoo)
read.zoo(result)

z <- read.zoo(DF, header = TRUE, tz = "GMT")
aggregate(z, as.Date, mean)

from <- as.Date("2000-01-01")
to <- as.Date("2012-12-31")
days <- seq.Date(from=from,to=to,by="day")

values <- rep.int(0,length(days))