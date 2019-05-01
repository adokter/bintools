#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("txt2vptslist.R <input_dir> [<output_dir>]", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "."
}

inputdir=args[1]
outputdir=args[2]

stopifnot(file.exists(inputdir) && file.exists(outputdir))

library(bioRad)

load("~/Dropbox/radar/NEXRAD/occultation/NEXRAD_ground_antenna_height.RData")

fnames=list.files(inputdir,full.names=T,recursive=T,include.dirs=T,pattern="*.txt")

load_radar_csv = function(filename){
  radar=substr(basename(filename),1,4)
  record=radarInfo[radarInfo$radar==radar,]
  data=readvp.table(filename,radar,wavelength='S')
  data$attributes$where$lat=record$lat
  data$attributes$where$lon=record$lon
  data$attributes$where$height=record$antenna
  data
}

data=lapply(fnames,load_radar_csv)
names(data)=substr(basename(fnames),1,4)

save(data,file=paste(outputdir,"/nexrad",basename(inputdir),".RData",sep=""))
