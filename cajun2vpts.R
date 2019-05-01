#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("cajun2vpts.R <input_dir> [<output_dir>]", call.=FALSE)
} else if (length(args)==1) {
  # default output directory 
  args[2] = "."
}

inputdir=args[1]
outputdir=args[2]

stopifnot(file.exists(inputdir) && file.exists(outputdir))

library(bioRad)

load("~/Dropbox/radar/NEXRAD/occultation/NEXRAD_ground_antenna_height.RData")

load_radar_cajun = function(inputdir,radar){
  fnames=list.files(inputdir,full.names=T,recursive=T,pattern=radar)
  if(length(fnames)>0){
    data=bind_into_vpts(lapply(fnames,read_cajun))
    record=radarInfo[radarInfo$radar==radar,]
    data$attributes$where$lat=record$lat
    data$attributes$where$lon=record$lon
    data$attributes$where$height=record$antenna
  }
  else{
    data=NULL
  }
  return(data)
}

for(radar in radarInfo$radar){
  data=load_radar_cajun(inputdir,radar)
  if(!is.null(data)){
    save(data,file=paste(outputdir,"/nexrad_day_",radar,format(data$datetime[1],"%Y%m.RData"),sep=""))
  }
}
