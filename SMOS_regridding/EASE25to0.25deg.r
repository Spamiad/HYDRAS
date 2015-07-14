
# from http://gis.stackexchange.com/questions/47991/how-to-re-project-the-ease-equal-area-scalable-earth-grid-with-a-25-km-cylind

library(ncdf)

# simple plot
#f = open.ncdf("F:/Users/lrains/SMOS/MIR_CLF3MD/2013/12/SM_RE02_MIR_CLF3MD_20131201T000000_20131231T235959_272_001_7.nc")
#sm=list(x=get.var.ncdf(f,"lon"),y=get.var.ncdf(f,"lat"),z=get.var.ncdf(f,"Soil_Moisture"))
#image(sm)

files <- list.files(path="C:/Users/Dommi/Desktop/copula_codes/SMOSL3/MIR_CLF31A", pattern=".nc", all.files=T, full.names=T)
for (file in files) {
  ## do stuff
  f = open.ncdf(file)
  sm=list(x=get.var.ncdf(f,"lon"),y=get.var.ncdf(f,"lat"),z=get.var.ncdf(f,"Soil_Moisture"))

smr = convertGrid(file,"Soil_Moisture")
plot(smr)


## anything below zero is NA (-1 is missing data, soil moisture is +ve)
smr[smr < -0.0] <- NA
smrp = transformTo(smr) # takes a short while

#x <- as.data.frame(as(smrp, "SpatialGridDataFrame")) 

fileout = paste (file,"_0.25deg.nc", sep = "", collapse = NULL)
#write.csv(x, file = fileout)
writeRaster(smrp, filename=fileout, format="CDF", overwrite=TRUE) 
}


# function
convertGrid <- function(gridfile, name, inCRS="+init=epsg:4053"){
  library(ncdf)
  library(raster)
  library(sp)
  library(rgdal)
  
  d = open.ncdf(gridfile)
  
  sm = list(
    x=get.var.ncdf(d,"lon"),
    y=get.var.ncdf(d,"lat"),
    z=get.var.ncdf(d,name)
  )
  
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