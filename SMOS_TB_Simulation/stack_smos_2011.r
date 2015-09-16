


setwd("D:/Users/lrains/Desktop/tmp/SMOS_CMEM/Ascending_42_5i_2010/")


library(ncdf)
library(raster)


#files <- list.files(path="D:/Users/lrains/Desktop/tmp/SMOS_CMEM/Ascending_42_5i_H_2010/", pattern=".nc", all.files=T, full.names=T)
#files <- list.files(path="D:/Users/lrains/Desktop/tmp/SMOS_CMEM/Ascending_42_5i_V_2010/", pattern=".nc", all.files=T, full.names=T)

#files = list.files("F:/Users/lrains/SMOS/_processed/SMOS_CMEM/Ascending_42_5i_H_2011/", pattern=".nc", all.files=T, full.names=T)


files = list.files("F:/Users/lrains/SMOS/_processed/SMOS_CMEM/Ascending_42_5i_V_2011", pattern=".nc", all.files=T, full.names=T)

# create empty brick

s1 <- brick(nc=1440, nr=720, nl=2)

brick = stack(files)
e = extent(brick)

setExtent(s1,e)

s2 = addLayer(s1, brick)


setwd("F:/Users/lrains")

#writeRaster(s1, filename="SMOS_TBH_Asc_2010_42_5i.nc", format="CDF", overwrite=TRUE)
#writeRaster(s1, filename="SMOS_TBV_Asc_2010_42_5i.nc", format="CDF", overwrite=TRUE)

writeRaster(s2, filename="SMOS_TBV_Asc_2011_42_5i.nc", format="CDF", overwrite=TRUE)
