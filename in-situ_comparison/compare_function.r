

# read clm netcdf output streams
read_clm = function(ncdf_dir) {
  
  files = list.files(ncdf_dir,"t2.clm2.h1.*", full.names = TRUE)
  r = stack(files)
}

read_clmpix = function(r,latlon) {
  result = extract(r, latlon)
  result = result[1,]
  from   = as.Date("2000-01-01")
  to     = as.Date("2007-04-23")
  days   = seq.Date(from=from,to=to,by="day")
  days   = as.character(days)
  ts     = as.data.frame(cbind(days,result))
  
  z2 <- read.zoo(ts, header = F, FUN = as.Date)
}


# read in-situ .stm file 
ismn_ts = function(stmfile) {
  
  header = read.csv(stmfile, nrow=1, header=F, sep="")
  lat = header$V4
  lon = header$V5
  
  sm = read.csv(stmfile, sep="", header=F, skip=1)
  sm = sm[,1:3]
  
  zsm = read.zoo(sm, index = 1:2, FUN = f, na.strings = "NaN")
  zsm = aggregate(zsm, as.Date, mean)
  
  return(zsm)
}

# read in-situ .stm file 
ismn_latlon = function(stmfile) {
  
  header = read.csv(stmfile, nrow=1, header=F, sep="")
  lat = header$V4
  lon = header$V5
  
  latlon = cbind(lon, lat)
  return(latlon)
}


# function for reading zoo object
f <- function(d, t) as.chron(paste(as.Date(d,"%Y/%m/%d"),t))





