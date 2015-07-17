

# test for reading ncdf file and extracting data at specific coordinates

library(raster)


setwd("C:/Users/Dommi/Desktop/clm_2000_2012")

files <- list.files("C:/Users/Dommi/Desktop/clm_2000_2012","t2.clm2.h1.*", full.names = TRUE)
r = stack(files)

r = brick("t2.clm2.h1.2000-01-01-00000.nc")

point <- cbind(145.849, -34.62888 )
result <- extract(r, point)
result = result[1,]


library(zoo)
read.zoo(result)

z <- read.zoo(result, header = TRUE, tz = "GMT")
y = aggregate(z1, as.Date, mean)

from <- as.Date("2000-01-01")
to   <- as.Date("2007-04-23")
days <- seq.Date(from=from,to=to,by="day")
days = as.character(days)
ts   = as.data.frame(cbind(days,result))

z2 <- read.zoo(ts, header = F, FUN = as.Date)

xx = aggregate(z1, as.Date, mean)


all = merge(xx, z2)

x = as.numeric(all[,1])
y = as.numeric(all[,2])
cor(x,y,use = "complete.obs")