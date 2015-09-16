

# process SMOS for CMEM Input

library(ncdf)
library(raster)

library(compositions) # use binary conversion

setwd("D:/Users/lrains/Desktop/tmp/SMOS_CMEM")

# loop over files
#files1 <- list.files(path="F:/Users/lrains/SMOS/L3TB/RE02/2010", pattern="SM_RE02", all.files=T, full.names=T)
#files2 <- list.files(path="F:/Users/lrains/SMOS/L3SM/MIR_CLF31A/2010", pattern="SM_RE02", all.files=T, full.names=T)

files1 <- list.files(path="F:/Users/lrains/SMOS/L3TB/RE02/2011", pattern="SM_RE02", all.files=T, full.names=T)
files2 <- list.files(path="F:/Users/lrains/SMOS/L3SM/MIR_CLF31A/2011", pattern="SM_RE02", all.files=T, full.names=T)

i = 0

for (file in files1) {
  ## do stuff
  
  f = open.ncdf(file)
  
  #z=get.var.ncdf(f,"BT_H")
  z=get.var.ncdf(f,"BT_V")
  z = z[,,9] # 42.5 degrees
  
  
  i = i+1
  f = open.ncdf(files2[i])
  
  # mask brightness temperatures according to science flags
  rfix=get.var.ncdf(f,"N_Rfi_X")
  rfiy=get.var.ncdf(f,"N_Rfi_Y")
  ava0=get.var.ncdf(f,"M_Ava0")
  
  rfiprob = rfix + rfiy
  rfiprob = rfiprob / ava0
  
  rfiprob[rfiprob >  0.2] = NaN
  rfiprob[rfiprob <= 0.2] = 1
  
  
  sciflags=get.var.ncdf(f,"Science_Flags")
  
  NonNAindex <- which(!is.na(sciflags))
  sciflags2 = binary(sciflags[NonNAindex])
  
  y = strsplit(sciflags2,"")
  f1 = as.numeric(do.call( rbind, y)[,7])
  f2 = as.numeric(do.call( rbind, y)[,8])
  f3 = as.numeric(do.call( rbind, y)[,9])
  f4 = as.numeric(do.call( rbind, y)[,13])
  f5 = as.numeric(do.call( rbind, y)[,14])
  fsum = f1 + f2 + f3 + f4 + f5
  
  #sciflags2 = as.numeric(sciflags2)
  
  #digitsum <- function(x) sum(floor(x / 10^(0:(nchar(x) - 1))) %% 10)
  #digitsum = function(x) sum( as.numeric(unlist(strsplit(as.character(x), split="")))) 
  

  sciflags[NonNAindex] = fsum
  sciflags[is.na(sciflags)] = 9
  sciflags[sciflags > 0.5] = NaN
  sciflags[sciflags < 0.5] = 1

  z2 = z * sciflags
 
  
  #rfi_mask = list(x=get.var.ncdf(f,"lon"),y=get.var.ncdf(f,"lat"),z=rfiprob)
  
  z2 = z2 * rfiprob
  sm=list(x=get.var.ncdf(f,"lon"),y=get.var.ncdf(f,"lat"),z=z2)
  
  smr = convertGrid(sm)
  #plot(smr)
  
  
  ## anything below zero is NA (-1 is missing data, soil moisture is +ve)
  #smr[smr < -0.0] <- NA
  smrp = transformTo(smr) # takes a short while
  
  #x <- as.data.frame(as(smrp, "SpatialGridDataFrame")) 
  
  fileout = strsplit(file, "\\.")
  fileout = paste (fileout[[1]],"2011_42_5i_V_0_25deg.nc", sep = "", collapse = NULL)
  #write.csv(x, file = fileout)
  writeRaster(smrp, filename=fileout[1], format="CDF", overwrite=TRUE)
}


# function
convertGrid <- function(sm, name, inCRS="+init=epsg:4053"){
  library(ncdf)
  library(raster)
  library(sp)
  library(rgdal)
  
  
  xp = data.frame(x=sm$x,y=0)
  coordinates(xp)=~x+y
  proj4string(xp)=CRS(inCRS)
  xp=spTransform(xp,CRS("+init=epsg:3410"))
  
  yp = data.frame(x=0,y=sm$y)
  coordinates(yp)=~x+y
  proj4string(yp)=CRS(inCRS)
  yp=spTransform(yp,CRS("+init=epsg:3410"))
  
  sm$xp = coordinates(xp)[,1]
  sm$yp = coordinates(yp)[,2]
  
  smr = raster(list(x=sm$xp,y=sm$yp,z=sm$z),crs="+init=epsg:3410")
  return(smr)
}

transformTo <- function(r1){
  ### 0.25*0.25 degree resolution and extent -180, 180, -90, 90
  r=raster(xmn=-180, xmx=180, ymn=-90, ymx=90,
           nrows=180*4,ncols=360*4,crs="+init=epsg:4326")
  projectRaster(r1,r)
}




