rm(list = ls())

library(raster)
library(dismo)


clim.dir<-"/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/AWAP/"

y1<-as.Date("01/01/1911","%m/%d/%Y")
y2<-as.Date("11/11/2015","%m/%d/%Y")
days<-seq(y1,y2, by= 1)

for(i in 1:length(days)){
  dayD<-strftime(days[i],format = "%d")
  dayM<-strftime(days[i],format = "%m")
  dayY<-strftime(days[i],format = "%Y")

    # read in raster
    #TMAX
    Zfile<-paste0(clim.dir,"DailyTmax/",dayY,dayM,dayD,dayY,dayM,dayD,".grid.Z")
    file.copy(Zfile, "tmp.Z",overwrite=TRUE)
    system("uncompress tmp.Z")
    tmax <- raster("tmp")
   
  ###TMIN###
    Zfile<-paste0(clim.dir,"DailyTmin/",dayY,dayM,dayD,dayY,dayM,dayD,".grid.Z")
    file.copy(Zfile, "tmp2.Z",overwrite=TRUE)
    system("uncompress tmp2.Z")
    tmin<- raster("tmp2")
 
    avg<-tmax+tmin/2
    unlink("tmp")
    unlink("tmp2")
    
    writeRaster(avg,paste0(clim.dir,"DailyTavg/",dayY,dayM,dayD,dayY,dayM,dayD,".tif"))
  }
 