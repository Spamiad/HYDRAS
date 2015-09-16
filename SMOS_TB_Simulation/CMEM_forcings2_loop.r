


# extract data from CLM input / forcings and write CMEM 5.1 inputs
# Murray-Darling Basin
# dynamic variables (meteorological forcing / (LAI) / Soil Moisture and Temperature)

library(ncdf)
library(raster)

# read lat/lon and define dimensions
#nc = open.ncdf("D:/Users/lrains/Desktop/stuff/t2.clm2.h1.2000-01-01-00000.nc")


# folder with history files 
files = list.files("F:/CESM_Output/16_09_2015/h1", pattern=".nc", all.files=T, full.names=T)

i = 0

for(file in files) {
  
  i = i+1
  
  nc = open.ncdf(file)

  lon = get.var.ncdf(nc,"lon")
  lat = get.var.ncdf(nc,"lat")
  time = get.var.ncdf(nc,"time")
  time = time+1
  lev  = 1


# Define some straightforward dimensions
x <- dim.def.ncdf( "LONGITUDE", "LONGITUDE", lon)
y <- dim.def.ncdf( "LATITUDE", "LATITUDE", lat)
t <- dim.def.ncdf( "TIME", "TIME", time)
l <- dim.def.ncdf( "LEV", "LEV", 1)


# Moisture
data = get.var.ncdf(nc,"H2OSOI")
data1 <- array(0,dim=c(160,160,1,24))
data1[,,1,] <- data[,,1,]

data2 <- array(0,dim=c(160,160,1,24))
data2[,,1,] <- data[,,2,]

data3 <- array(0,dim=c(160,160,1,24))
data3[,,1,] <- data[,,3,]


sm1 = var.def.ncdf("SWVL1","SWVL1", list(x,y,l,t), 1.e30)
sm2 = var.def.ncdf("SWVL2","SWVL2", list(x,y,l,t), 1.e30)
sm3 = var.def.ncdf("SWVL3","SWVL3", list(x,y,l,t), 1.e30)

ncout1 <- create.ncdf(paste ("SWVL1_",i,".nc", sep = "", collapse = NULL), sm1)
ncout2 <- create.ncdf(paste ("SWVL2_",i,".nc", sep = "", collapse = NULL), sm2)
ncout3 <- create.ncdf(paste ("SWVL3_",i,".nc", sep = "", collapse = NULL), sm3)

put.var.ncdf(ncout1, sm1, data1)
put.var.ncdf(ncout2, sm2, data2)
put.var.ncdf(ncout3, sm3, data3)

close.ncdf(ncout1)
close.ncdf(ncout2)
close.ncdf(ncout3)

# Soil Temperature
data = get.var.ncdf(nc,"TSOI")

data1 <- array(0,dim=c(160,160,1,24))
data1[,,1,] <- data[,,1,]

data2 <- array(0,dim=c(160,160,1,24))
data2[,,1,] <- data[,,2,]

data3 <- array(0,dim=c(160,160,1,24))
data3[,,1,] <- data[,,3,]

sm1 = var.def.ncdf("STL1","STL1", list(x,y,l,t), 1.e30)
sm2 = var.def.ncdf("STL2","STL2", list(x,y,l,t), 1.e30)
sm3 = var.def.ncdf("STL3","STL3", list(x,y,l,t), 1.e30)

ncout1 <- create.ncdf(paste ("STL1_",i,".nc", sep = "", collapse = NULL), sm1)
ncout2 <- create.ncdf(paste ("STL2_",i,".nc", sep = "", collapse = NULL), sm2)
ncout3 <- create.ncdf(paste ("STL3_",i,".nc", sep = "", collapse = NULL), sm3)

put.var.ncdf(ncout1, sm1, data1)
put.var.ncdf(ncout2, sm2, data2)
put.var.ncdf(ncout3, sm3, data3)

close.ncdf(ncout1)
close.ncdf(ncout2)
close.ncdf(ncout3)

# Air Temperature
data = get.var.ncdf(nc,"TBOT")

r = brick(file,varname="TBOT")
r2 = flip(r,2)

data1 <- array(0,dim=c(160,160,1,24))
data1[,,1,] <- data[,,]


sm1 = var.def.ncdf("TAIR","TAIR", list(x,y,l,t), 1.e30)
ncout1 <- create.ncdf("2T.nc", sm1)
put.var.ncdf(ncout1, sm1, data1)
close.ncdf(ncout1)

# LAI of low vegetation
#data = get.var.ncdf(nc,"TLAI")

#nc2   = open.ncdf("D:/Users/lrains/Documents/CMEM_preprocessing/_ncdf/ECOCVL.nc")
#data2 = get.var.ncdf(nc2,"CVL")

#data1 <- array(0,dim=c(160,160,1,24))
#data1[,,1,] <- data[,,]

#sm1 = var.def.ncdf("LAI","LAI", list(x,y,l,t), 1.e30)
#ncout1 <- create.ncdf("ECOLAIstatic.nc", sm1)
#put.var.ncdf(ncout1, sm1, data1)
#close.ncdf(ncout1)


# Snow Density
#data = get.var.ncdf(nc,"TBOT")
#data[] = 0

#data1 <- array(0,dim=c(160,160,1,24))
#data1[,,1,] <- data[,,]

#sm1 = var.def.ncdf("SD","Snow Density", list(x,y,l,t), 1.e30)
#ncout1 <- create.ncdf(paste ("SD_",i,".nc", sep = "", collapse = NULL), sm1)
#put.var.ncdf(ncout1, sm1, data1)
#close.ncdf(ncout1)

# Snow Depth
data = get.var.ncdf(nc,"TBOT")
data[] = 0

data1 <- array(0,dim=c(160,160,1,24))
data1[,,1,] <- data[,,]

sm1 = var.def.ncdf("SD","Snow Depth", list(x,y,l,t), 1.e30)
ncout1 <- create.ncdf(paste ("SD_",i,".nc", sep = "", collapse = NULL), sm1)
put.var.ncdf(ncout1, sm1, data1)
close.ncdf(ncout1)

# Snow Density
data = get.var.ncdf(nc,"TBOT")
data[] = 0

data1 <- array(0,dim=c(160,160,1,24))
data1[,,1,] <- data[,,]

sm1 = var.def.ncdf("RSN","Snow Density", list(x,y,l,t), 1.e30)
ncout1 <- create.ncdf(paste ("RSN_",i,".nc", sep = "", collapse = NULL), sm1)
put.var.ncdf(ncout1, sm1, data1)
close.ncdf(ncout1)


# Skin Temperature
data = get.var.ncdf(nc,"TG")

data1 <- array(0,dim=c(160,160,1,24))
data1[,,1,] <- data[,,]

sm1 = var.def.ncdf("TSKIN","TSKIN", list(x,y,l,t), 1.e30)
ncout1 <- create.ncdf(paste ("TSKIN_",i,".nc", sep = "", collapse = NULL), sm1)
put.var.ncdf(ncout1, sm1, data1)
close.ncdf(ncout1)


}

