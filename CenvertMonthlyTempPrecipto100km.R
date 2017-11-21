#convert monthly rain and prec to Cyclindrical Equal Area 100km resolution

rm(list = ls())
library(raster)
library(rgdal)
library(plantecophys)
library(stringr)
library(RCurl)

#Albers equal area projection
Albers<-"+proj=aea +lat_1=-18 +lat_2=-36 +lat_0=0 +lon_0=134 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

#make 100km equal area raster Albers equal area:
km100 <- raster(nrows=49, ncols=56, 
                xmn=-2904860, xmx=2695140,ymn=-5334205, ymx=-434205,
                crs =paste(Albers))
km1<-raster(nrows=4900, ncols=5600, 
            xmn=-2904860, xmx=2695140,ymn=-5334205, ymx=-434205,
            crs =paste(Albers))

# #########################
# #rain and temperture - average from 1950-2016
# ########################
calcrain<-FALSE

if(calcrain==TRUE){

#dates
dates<-seq(as.Date("1950/01/01"), as.Date("2016/01/01"), "month")
#download monthly data 
  D1<-strftime(dates[1],format = "%Y%m%d")
  D2<-strftime(dates[1+1]-1,format = "%Y%m%d")
  
  temp <- tempfile()#prep temperture data
  t1 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/month/grid/0.05/history/nat/",D1,D2,".grid.Z")
  download.file(t1 ,temp, mode="wb")
  file.copy(temp, "tmp.Z",overwrite=TRUE)
  system("uncompress tmp.Z")
  tmax1 <- raster("tmp")
  temp2 <- tempfile()#prep vapour pressure data
  rain1 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/month/grid/0.05/history/nat/",D1,D2,".grid.Z")
  
  download.file(rain1 ,temp2, mode="wb")
  file.copy(temp2, "tmp2.Z",overwrite=TRUE)
  system("uncompress tmp2.Z")
  rain1<- raster("tmp2")
  
  for(i in 2:length(dates)-1){
    D1<-strftime(dates[i],format = "%Y%m%d")
    D2<-strftime(dates[i+1]-1,format = "%Y%m%d")
    
    temp3 <- tempfile()#prep temperture data
    t <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/month/grid/0.05/history/nat/",D1,D2,".grid.Z")
    download.file(t ,temp3, mode="wb")
    file.copy(temp3, "tmp3.Z",overwrite=TRUE)
    system("uncompress tmp3.Z")
    tmax1 <-tmax1+raster("tmp3")
    
    temp4 <- tempfile()#prep rain
    rain <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/month/grid/0.05/history/nat/",D1,D2,".grid.Z")
    download.file(rain ,temp4, mode="wb")
    file.copy(temp4, "tmp4.Z",overwrite=TRUE)
    system("uncompress tmp4.Z")
    rain1<- rain1+raster("tmp4")
    
  unlink(c("tmp3","tmp4"))
  message(i)
}
 
tmax1<-tmax1/792
rain1<-rain1/792

writeRaster(tmax1,"/Users/daisy/Google Drive/PhD/ThermalStress/data/spatial/tmaxAvergae19502016.asc")
writeRaster(rain1,"/Users/daisy/Google Drive/PhD/ThermalStress/data/spatial/rainAvergae19502016.asc")
unlink(c("tmp","tmp2"))

}
  
  
  
############################################
#convert rain and temp to 100km equal area
############################################
rain<-raster("/Users/daisy/Google Drive/PhD/ThermalStress/data/spatial/rainAvergae19502016.asc", 
  crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
Tmax<-raster("/Users/daisy/Google Drive/PhD/ThermalStress/data/spatial/tmaxAvergae19502016.asc", 
             crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")


rainAlbers05<-projectRaster(rain,km1,method='ngb')
rain100<-aggregate(rainAlbers05,100,'mean')

tmaxAlbers05<-projectRaster(Tmax,km1,method='ngb')
tmax100<-aggregate(tmaxAlbers05,100,'mean')


writeRaster(tmax100,"/Users/daisy/Google Drive/PhD/ThermalStress/data/spatial/tmaxAvergae19502016100km.asc"
            ,overwrite=TRUE)
writeRaster(rain100,"/Users/daisy/Google Drive/PhD/ThermalStress/data/spatial/rainAvergae19502016100km.asc"
            ,overwrite=TRUE)




