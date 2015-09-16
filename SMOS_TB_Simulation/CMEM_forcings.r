


# extract data from CLM input / forcings and write CMEM 5.1 inputs
# Murray-Darling Basin
# static variables
# ECOCVH, ECOCVL, ECOLAIL, ECOTVH, ECOTVL, ECOWAT


library(ncdf)
library(raster)

# read lat/lon and define dimensions
nc = open.ncdf("Z:/Model/Model_Inputdata/surfdata_0.125x0.125_MurrayDarlin_simyr2000_c150401_urb_hirespft.nc")

lon = get.var.ncdf(nc,"LONGXY")
lat = get.var.ncdf(nc,"LATIXY")
lon = lon[,1]
lat = lat[1,]

lev  = 1
time = 1

# Define some straightforward dimensions
x <- dim.def.ncdf( "LONGITUDE", "Longitude", as.single(lon))
y <- dim.def.ncdf( "LATITUDE", "Latitude", as.single(lat))
l <- dim.def.ncdf( "LEV", "Tile index", lev)
t <- dim.def.ncdf( "TIME", "Time counter", as.single(time))



# output directory for CMEM input files
setwd("D:/Users/lrains/Documents/CMEM_preprocessing/_ncdf")

# CLAY, SAND, Z <-- static inputs
# CLAY
data = get.var.ncdf(nc,"PCT_CLAY")
data = data[,,1]

#cl=list(x=lon,y=lat,z=data)
#image(cl)

clay_out <- var.def.ncdf("CLAY","CLAY*100", list(x,y), 1.e30)

# Create a netCDF file with this variable
ncnew <- create.ncdf("clay.nc", clay_out)
put.var.ncdf(ncnew, clay_out, data)
close.ncdf(ncnew)


# SAND
data = get.var.ncdf(nc,"PCT_SAND")
data = data[,,1]

#cl=list(x=lon,y=lat,z=data)
#image(cl)

sand_out <- var.def.ncdf("SAND","SAND*100", list(x,y), 1.e30)

# Create a netCDF file with this variable
ncnew <- create.ncdf("sand.nc", sand_out)
put.var.ncdf(ncnew, sand_out, data)
close.ncdf(ncnew)


# Z
data = get.var.ncdf(nc,"TOPO")
data = data/1000

#cl=list(x=lon,y=lat,z=data)
#image(cl)

z_out <- var.def.ncdf("Z","GEOPOTENTIAL", list(x,y,l,t), 1.e30)

# Create a netCDF file with this variable
ncnew <- create.ncdf("z.nc", z_out)
put.var.ncdf(ncnew, z_out, data)
close.ncdf(ncnew)


# Water fraction
data = get.var.ncdf(nc,"PCT_LAKE")
data = data / 100

# additionally read basin mask and set pixels outside basin to ocean
nc2 = open.ncdf("Z:/Model/CESM_run/Input/prestage/share/domains/domain.lnd.MurrayDarlin.150326_mask.nc")
data2 = get.var.ncdf(nc2,"mask")
data2[data2 == 1] <- 2
data2[data2 == 0] <- 1
data2[data2 == 2] <- 0

datan = data + data2
datan[datan > 1] <- 1


water_out <- var.def.ncdf("WATER","WATER FRACTION", list(x,y,l,t), 1.e30)

# Create a netCDF file with this variable
ncnew <- create.ncdf("water.nc", water_out)
put.var.ncdf(ncnew, water_out, datan)
close.ncdf(ncnew)
close.ncdf(nc2)



# low / high vegetation
r <- brick("D:/Users/lrains/Desktop/tmp/pfthires_MDarling.nc")
vegh = r[[2:9]]
vegh = sum(vegh)
vegh = vegh / 100

vegl = r[[10:16]]
vegl = sum(vegl)
vegl = vegl / 100

vegh = as.matrix(vegh)
vegl = as.matrix(vegl)

library(cape)
vegh = rotate.mat(vegh)
vegl = rotate.mat(vegl)

vegh_out <- var.def.ncdf("CVH","high vegetation", list(x,y), 1.e30)
vegl_out <- var.def.ncdf("CVL","low vegetation", list(x,y), 1.e30)

# Create a netCDF file with this variable
ncnew1 <- create.ncdf("ECOCVH.nc", vegh_out)
ncnew2 <- create.ncdf("ECOCVL.nc", vegl_out)
put.var.ncdf(ncnew1, vegh_out, vegh)
put.var.ncdf(ncnew2, vegl_out, vegl)
close.ncdf(ncnew1)
close.ncdf(ncnew2)


# vegetation classes
r <- brick("D:/Users/lrains/Desktop/tmp/pfthires_MDarling.nc")
miwhichmax <- function(x,na.rm=T) which.max(x)

veghr <- r[[1:9]]
veglr <- stack(r[[1]],r[[10:16]])
m1 <- stackApply(veghr,indices=c(1,1,1,1,1,1,1,1,1),miwhichmax)
m1 = m1 - 1

m2 <- stackApply(veglr,indices=c(1,1,1,1,1,1,1,1),miwhichmax)
m2 = m2 - 1
m2 = m2 + 8
m2[m2 == 8] <- 0

mm1 = m1
mm2 = m2


# reclassify to CMEM Ecoclimap
#No vegetation: 0
#High vegetation: 1 Decidious forests; 2 Coniferous forests; 3 Rain forests
#Low vegetation: 4 C3 Grasslands; 5 C4 Grasslands; 6 C3 Crops; 7 C4 Crops
mm1[] = 0
mm1[m1 == 6] <- 1
mm1[m1 == 7] <- 1
mm1[m1 == 8] <- 1

mm1[m1 == 1] <- 2
mm1[m1 == 2] <- 2
mm1[m1 == 3] <- 2

mm1[m1 == 4] <- 3
mm1[m1 == 5] <- 3

mm2[] = 0
mm2[m2 == 9] <- 4
mm2[m2 == 10] <- 4
mm2[m2 == 11] <- 4
mm2[m2 == 12] <- 4
mm2[m2 == 13] <- 4

mm2[m2 == 14] <- 4
mm2[m2 == 15] <- 6

library(cape)
mm1 = as.matrix(mm1)
mm1 = rotate.mat(mm1)

mm2 = as.matrix(mm2)
mm2 = rotate.mat(mm2)

veght_out <- var.def.ncdf("TVH","high vegetation type", list(x,y), 1.e30)
veglt_out <- var.def.ncdf("TVL","low vegetation type", list(x,y), 1.e30)

# Create a netCDF file with this variable
ncnew1 <- create.ncdf("ECOTVH.nc", veght_out)
ncnew2 <- create.ncdf("ECOTVL.nc", veglt_out)
put.var.ncdf(ncnew1, veght_out, mm1)
put.var.ncdf(ncnew2, veglt_out, mm2)
close.ncdf(ncnew1)
close.ncdf(ncnew2)




