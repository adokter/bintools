#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)<2) {
  stop(paste(sub(".*=", "", commandArgs()[4]),"<input directory> [.. <input directory n>] <output directory>, missing input arguments ..."),call.=FALSE) 
}

library(bioRad)

fs=list.files(path=args[-length(args)],pattern="*.txt",full.names=T)
radars=unique(substr(basename(fs),0,4))

for(radar in radars){
  fsradar=fs[grepl(radar,fs)]
  f=tempfile()
  writeLines(unlist(sapply(fsradar,readLines)),f)
  if(file.size(f)==0){
     #do.call(rm,list(substr(f,1,8)))
     file.remove(f)
     next
  }
  fbase=basename(fsradar[1])
  # read vp.table
  assign(substr(fbase,1,4),readvp.table(f,substr(fbase,1,4),'S'))
  # save vpts object
  exportf=paste(args[length(args)],"/",substr(fbase,1,4),".RData",sep="")
  cat(exportf,'\n')
  do.call(save,list(substr(fbase,1,4),file=exportf))
  # clean up
  file.remove(f)
  do.call(rm,list(substr(fbase,1,4)))
}
