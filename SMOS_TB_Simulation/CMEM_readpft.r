   

# read pft data from CLM restart file

library(ncdf)

nc = open.ncdf("D:/Users/lrains/Desktop/tmp/t2.clm2.r.2001-01-01-00000.nc")
elai = get.var.ncdf(nc,"elai")

pft_lat = get.var.ncdf(nc,"pfts1d_lat")
pft_lon = get.var.ncdf(nc,"pfts1d_lon")


ltype = get.var.ncdf(nc,"pfts1d_ityplun") # vegetated,urban,lake,wetland or glacier
vtype = get.var.ncdf(nc,"pfts1d_itypveg") # 0 - 16



wg = get.var.ncdf(nc,"PFT_WTGCELL") # read pft weights 
elai_w = elai * wg

df = as.data.frame(cbind(elai,pft_lon,pft_lat,ltype,vtype,elai_w))
df$ID = seq.int(nrow(df))


# create subset of low vegetation classes
df.low = subset(df , vtype >= 9 & vtype <= 15)

xx = as.data.frame(tapply(df.low$elai_w, paste(df.low$pft_lon,df.low$pft_lat), FUN=sum))
y = rownames(xx)
y = read.table(text = y, sep = " ", colClasses = "numeric")

df.low_a = cbind(y,xx)
colnames(df.low_a) = c('x','y','yield')

x = df.low_a[,1]
y = df.low_a[,2]
z = df.low_a[,3]

library(sp)
library(rgdal)
coordinates(df.low_a)=~x+y


proj4string(df.low_a)=CRS("+init=epsg:4326") # set it to lat-long
df.low_a = spTransform(df.low_a,CRS("+init=epsg:4326"))

gridded(df.low_a) = TRUE

library(raster)
r = raster(df.low_a)
projection(r) = CRS("+init=epsg:4326")


e = extent(raster("D:/Users/lrains/Documents/CMEM_preprocessing/_ncdf/ECOCVL.nc"))
r = extend(r, e)  
plot(r)


#r = flip(r,2)
data = as.matrix(r)

library(cape)
data = rotate.mat(data)

dataout = array(0,dim=c(160,160,1,30))
dataout[] = data


nc2 = open.ncdf("D:/Users/lrains/Desktop/stuff/t2.clm2.h1.2000-01-01-00000.nc")

lon = get.var.ncdf(nc2,"lon")
lat = get.var.ncdf(nc2,"lat")
time = get.var.ncdf(nc2,"time")
time = time+1
lev  = 1

# Define some straightforward dimensions
x <- dim.def.ncdf( "LONGITUDE", "LONGITUDE", lon)
y <- dim.def.ncdf( "LATITUDE", "LATITUDE", lat)
t <- dim.def.ncdf( "TIME", "TIME", time)
l <- dim.def.ncdf( "LEV", "LEV", 1)

sm1 = var.def.ncdf("LAI","LAI", list(x,y,l,t), 1.e30)
ncout1 <- create.ncdf("ECOLAI.nc", sm1)
put.var.ncdf(ncout1, sm1, dataout)
close.ncdf(ncout1)
