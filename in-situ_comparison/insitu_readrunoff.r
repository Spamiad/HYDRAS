# 21 January 2015
# Function purpose: read daily runoff data from Australian Bureau of Meteorology


# include plotting timeline, coordinates etc... ??
# include option to plot data with specific quality flag (row 3)

read_bom_dd_runoff <- function(file, directory){
  
  fpath = paste(directory,file, sep="")
  dd_runoff = read.csv(fpath, header=TRUE, sep=",", skip=18)
  
  return(dd_runoff)
}