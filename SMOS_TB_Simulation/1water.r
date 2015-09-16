


nc = open.ncdf("D:/Users/lrains/Downloads/cmem_v5.1/io_sample_v5.1/forcing/netcdf/ECOWAT.nc")

lon = get.var.ncdf(nc,"LONGITUDE")
lat = get.var.ncdf(nc,"LATITUDE")


# Define some straightforward dimensions
x <- dim.def.ncdf( "Longitude", "Longitude", lon)
y <- dim.def.ncdf( "Latitude", "Latitude", lat)


# Water fraction
data = get.var.ncdf(nc,"WATER")
data = 1 - data

water_out <- var.def.ncdf("WATER","WATER FRACTION", list(x,y), 1.e30)

# Create a netCDF file with this variable
ncnew <- create.ncdf("LSM.nc", water_out)
put.var.ncdf(ncnew, water_out, data)
close.ncdf(ncnew)