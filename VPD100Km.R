#make daily VPD at 1 degree resolution

library(plantecophys)
library(stringr)
library(RCurl)
library(raster)


VPDmaker <- function(vapour, maxTemp,maskMap){
  v<-as.data.frame(rasterToPoints(vapour))
  v$tmp2<-v$tmp2*100 #cnvert to hPa
  Tx<-as.data.frame(rasterToPoints(maxTemp))
  Tx$Vsat<-esat(Tx$tmp) #calculate saturated vapour pressure
  Tx$VPD<-(Tx$Vsat-v$tmp2)/1000 #convert to kPa
  VPD<-rasterFromXYZ(cbind(Tx$x,Tx$y,Tx$VPD))
  VPD<-aggregate(VPD,fact=20,na.rm=TRUE)#convert to one degree grid cells
  VPD<-VPD*maskMap
  return(VPD)
}

ausMask<-raster::raster("/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/BOM/maxann.txt")#mask of Australia
aus_XY <- as.data.frame(rasterToPoints(ausMask))#find lat and long of 1km data
ausMask<-aggregate(ausMask,fact=40,na.rm=TRUE)#make raster 1 degree
ausMask[]<-1:1505 #Give each grid cell unique value
aus_XY$GridCellID<-raster::extract(ausMask,cbind(aus_XY$x,aus_XY$y),method='simple')#extract the 1km resolution cell value
gridCount<-as.data.frame(table(aus_XY$GridCellID))#find how many grid cells fall in the 1 degree data
gridCount<-subset(gridCount,Freq>=533)#only keep grid cells that are actually at least 33% land
gridCount$val<-1 #set the value to 1
ausMask<-subs(ausMask, data.frame(gridCount[,c("Var1","val")]))

#dates
dates<-seq(as.Date("1950/01/01"), as.Date("2016/01/01"), "day")

for(i in 1:length(dates)){
  D<-strftime(dates[i],format = "%d")
  D<-str_pad(D,2, pad="0")
  M<-strftime(dates[i],format = "%m")
  M<-str_pad(M,2, pad="0")
  Y<-strftime(dates[i],format = "%Y")

  temp <- tempfile()#prep temperture data
  t <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/daily/grid/0.05/history/nat/",Y,M,D,Y,M,D,".grid.Z")
  download.file(t ,temp, mode="wb")
  file.copy(temp, "tmp.Z",overwrite=TRUE)
  system("uncompress tmp.Z")
  tmax <- raster("tmp")

  temp2 <- tempfile()#prep vapour pressure data
  vp <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/vprp/vprph15/daily/grid/0.05/history/nat/",Y,M,D,Y,M,D,".grid.Z")
  download.file(vp ,temp2, mode="wb")
  file.copy(temp2, "tmp2.Z",overwrite=TRUE)
  system("uncompress tmp2.Z")
  VP <- raster("tmp2")

  VPD<-VPDmaker(VP, tmax,ausMask)
  writeRaster(VPD,paste0("~/Google Drive/PhD/Data/Spatial/Climate/VPD/VPD",Y,M,D,".asc"),overwrite=TRUE)

  unlink(c("tmp","tmp2"))
  message(paste0(i," out of ",length(dates)))
}


