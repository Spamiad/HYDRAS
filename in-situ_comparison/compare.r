library(zoo)
library(chron)
library(raster)

stmfiles = list.files("C:/PhD/ismn/OZNET/_toplayers","*.stm", full.names = TRUE)
r = read_clm("C:/Users/Dommi/Desktop/clm_2000_2012")

# create empty zoo object as basis for all time series


cors = a=data.frame(matrix(NA, nrow=length(stmfiles)))

for (i in 1:length(stmfiles))  {
  
  ts = ismn_ts(stmfiles[i])
  latlon = ismn_latlon(stmfiles[i])
  
  ts_clm = read_clmpix(r,latlon)
  ts_merge = merge(ts, ts_clm)
  cors[i,1] = cor(as.numeric(ts_merge[,1]),as.numeric(ts_merge[,2]), use = "complete.obs")
}

