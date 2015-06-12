# 21 January 2015
# Function purpose: read soil moisture data from International Soil Moisture Network
# Header+Data format files


# include plotting timeline, coordinates etc... ??
# include option to plot data with specific quality flag (row 3)

read_bom_sm <- function(file, directory){
  
  fpath = paste(directory,file, sep="")
  sm = read.csv(fpath, header=FALSE, sep="", skip=1, col.names=c("Date","Time","sm","F1","F2"))
  
  return(sm)
}