



library(ncdf)
library(raster)


stackfunction("LAI")

cmemvar = "LAI"

stackfunction = function (cmemvar) {
  # folder with daily forcing files including hourly data 
  #files = list.files(paste("F:/CESM_Output/16_09_2015/_CMEMforcing/",cmemvar, sep = "", collapse = NULL), pattern=".nc", all.files=T, full.names=T)
  
  files = list.files(paste("F:/CESM_Output/16_09_2015/___LAI", sep = "", collapse = NULL), pattern=".nc", all.files=T, full.names=T)
  
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
  

  r2 = t(r)
  r2 = flip(r2,1)
  
  dims = dim(r2)
  dims = dims[3]
  
  time = seq(1:(dims))
  t <- dim.def.ncdf( "TIME", "TIME", time)
  
  
  data1 <- array(0,dim=c(160,160,1,365))
  
  for (j in 1:365) {
    data1[,,1,j] <- as.matrix(r2[[j]])
  }
  
  
  sm1 = var.def.ncdf(cmemvar,cmemvar, list(x,y,l,t), 1.e30)
  ncout1 <- create.ncdf(paste (cmemvar,".nc", sep = "", collapse = NULL), sm1)
  put.var.ncdf(ncout1, sm1, data1)
  close.ncdf(ncout1)
}
