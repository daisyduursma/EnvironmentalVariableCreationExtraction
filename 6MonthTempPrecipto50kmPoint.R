#convert monthly rain and prec to Cyclindrical Equal Area 100km resolution

rm(list = ls())
library(raster)
library(rgdal)
library(plantecophys)
library(stringr)
library(RCurl)
library(maptools)

#Albers equal area projection
Albers<-"+proj=aea +lat_1=-18 +lat_2=-36 +lat_0=0 +lon_0=134 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

#make 50km equal area raster Albers equal area:
km50 <- raster(nrows=98, ncols=112, 
                xmn=-2904860, xmx=2695140,ymn=-5334205, ymx=-434205,
                crs =paste(Albers))
km5<-raster(nrows=980, ncols=1120, 
            xmn=-2904860, xmx=2695140,ymn=-5334205, ymx=-434205,
            crs =paste(Albers))

land<-raster('/Users/daisy/Google Drive/PhD/Data/Spatial/AustraliaMask/AustraliaMask.asc',
             crs= "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# #########################
# #rain and temperture - average from 1950-2016
# ########################
# calcrain<-FALSE
# 
# if(calcrain==TRUE){

#dates
Junedates<-seq(as.Date("1900/06/01"), as.Date("1910/06/01"), "year")
Julydates<-seq(as.Date("1900/07/01"), as.Date("1910/07/01"), "year")
Adates<-seq(as.Date("1900/08/01"), as.Date("1910/08/01"), "year")
Sdates<-seq(as.Date("1900/09/01"), as.Date("1910/09/01"), "year")
Odates<-seq(as.Date("1900/10/01"), as.Date("1910/10/01"), "year")
Ndates<-seq(as.Date("1900/11/01"), as.Date("1910/11/01"), "year")
Ddates<-seq(as.Date("1900/12/01"), as.Date("1910/12/01"), "year")

for(i in 1:length(Junedates)){
#download monthly data 
#June
  June1<-strftime(Junedates[i],format = "%Y%m%d")
  June2<-strftime(Julydates[i]-1,format = "%Y%m%d")
  # temp <- tempfile()#prep temperture data
  # t1 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/month/grid/0.05/history/nat/",June1,June2,".grid.Z")
  # download.file(t1 ,temp, mode="wb")
  # file.copy(temp, "tmp.Z",overwrite=TRUE)
  # system("uncompress tmp.Z")
  # tmax1 <- raster("tmp")
  # 
  temp7 <- tempfile()#rain
  rain1 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/month/grid/0.05/history/nat/",June1,June2,".grid.Z")
  download.file(rain1 ,temp7, mode="wb")
  file.copy(temp7, "tmp7.Z",overwrite=TRUE)
  system("uncompress tmp7.Z")
  rain1<- raster("tmp7")

#July
  July1<-strftime(Julydates[i],format = "%Y%m%d")
  July2<-strftime(Adates[i]-1,format = "%Y%m%d")
  # temp2 <- tempfile()#prep temperture data
  # t1 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/month/grid/0.05/history/nat/",July1,July2,".grid.Z")
  # download.file(t1 ,temp2, mode="wb")
  # file.copy(temp2, "tmp2.Z",overwrite=TRUE)
  # system("uncompress tmp2.Z")
  # tmax2 <- raster("tmp2")
  
  temp8 <- tempfile()#rain
  rain2 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/month/grid/0.05/history/nat/",July1,July2,".grid.Z")
  download.file(rain2 ,temp8, mode="wb")
  file.copy(temp8, "tmp8.Z",overwrite=TRUE)
  system("uncompress tmp8.Z")
  rain2<- raster("tmp8")
 
  
  #August
  A1<-strftime(Adates[i],format = "%Y%m%d")
  A2<-strftime(Sdates[i]-1,format = "%Y%m%d")
  # temp3 <- tempfile()#prep temperture data
  # t3 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/month/grid/0.05/history/nat/",A1,A2,".grid.Z")
  # download.file(t3 ,temp3, mode="wb")
  # file.copy(temp3, "tmp3.Z",overwrite=TRUE)
  # system("uncompress tmp3.Z")
  # tmax3 <- raster("tmp3")
  
  temp9 <- tempfile()#rain
  rain3 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/month/grid/0.05/history/nat/",A1,A2,".grid.Z")
  download.file(rain3 ,temp9, mode="wb")
  file.copy(temp9, "tmp9.Z",overwrite=TRUE)
  system("uncompress tmp9.Z")
  rain3<- raster("tmp9")
  
  
  #Sept
  S1<-strftime(Sdates[i],format = "%Y%m%d")
  S2<-strftime(Odates[i]-1,format = "%Y%m%d")
  # temp4 <- tempfile()#prep temperture data
  # t4 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/month/grid/0.05/history/nat/",S1,S2,".grid.Z")
  # download.file(t4 ,temp4, mode="wb")
  # file.copy(temp4, "tmp4.Z",overwrite=TRUE)
  # system("uncompress tmp4.Z")
  # tmax4 <- raster("tmp4")
  
  temp10 <- tempfile()#rain
  rain4 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/month/grid/0.05/history/nat/",S1,S2,".grid.Z")
  download.file(rain4 ,temp10, mode="wb")
  file.copy(temp10, "tmp10.Z",overwrite=TRUE)
  system("uncompress tmp10.Z")
  rain4<- raster("tmp10")

  #Oct
  O1<-strftime(Odates[i],format = "%Y%m%d")
  O2<-strftime(Ndates[i]-1,format = "%Y%m%d")
  # temp5 <- tempfile()#prep temperture data
  # t5 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/month/grid/0.05/history/nat/",O1,O2,".grid.Z")
  # download.file(t5 ,temp5, mode="wb")
  # file.copy(temp5, "tmp5.Z",overwrite=TRUE)
  # system("uncompress tmp5.Z")
  # tmax5 <- raster("tmp5")
  
  temp11 <- tempfile()#rain
  rain5 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/month/grid/0.05/history/nat/",O1,O2,".grid.Z")
  download.file(rain5 ,temp11, mode="wb")
  file.copy(temp11, "tmp11.Z",overwrite=TRUE)
  system("uncompress tmp11.Z")
  rain5<- raster("tmp11") 
  
  #NOV
  N1<-strftime(Ndates[i],format = "%Y%m%d")
  N2<-strftime(Ddates[i]-1,format = "%Y%m%d")
  # temp6 <- tempfile()#prep temperture data
  # t6 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/month/grid/0.05/history/nat/",N1,N2,".grid.Z")
  # download.file(t6 ,temp6, mode="wb")
  # file.copy(temp6, "tmp6.Z",overwrite=TRUE)
  # system("uncompress tmp6.Z")
  # tmax6 <- raster("tmp6")
  
  temp12 <- tempfile()#rain
  rain6 <- paste0("http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/month/grid/0.05/history/nat/",N1,N2,".grid.Z")
  download.file(rain6 ,temp12, mode="wb")
  file.copy(temp12, "tmp12.Z",overwrite=TRUE)
  system("uncompress tmp12.Z")
  rain6<- raster("tmp12") 
  
  
  

  # cellStats(tmax1, max)
  # cellStats(tmax2, max)
  # cellStats(tmax3, max)
  # cellStats(tmax4, max)
  # cellStats(tmax5, max)
  # cellStats(tmax6, max)
  # # 
  
  #make winter avwerage
  WRain<-(rain1+rain2+rain3+rain4+rain5+rain6)/6
  # Wtmax<-(tmax1+tmax2+tmax3+tmax4+tmax5+tmax6)/6
  #plot(WSRain)
  #unlink files not needed
  unlink(paste0("tmp",1:12))
  
  
############################################
#convert rain and temp to 50km equal area
############################################
crs(WRain)<-"+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
# crs(Wtmax)<-"+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
#just keep land area
  WRain<-intersect(WRain,land)*land
  # Wtmax<-intersect(Wtmax,land)*land
  
rainAlbers05<-projectRaster(WRain,km5,method='ngb')
rainAlbers50<-aggregate(rainAlbers05,10)
rainAlbers50<-as.data.frame(rasterToPoints(rainAlbers50,spatial=FALSE))
colnames(rainAlbers50)<-c("x","y","rainWntSpr")

# tmaxAlbers05<-projectRaster(Wtmax,km5,method='ngb')
# tmaxAlbers50<-aggregate(tmaxAlbers05,10)
# tmaxAlbers50<-as.data.frame(rasterToPoints(tmaxAlbers50,spatial=FALSE))
# colnames(tmaxAlbers50)<-c("x","y","tmaxWntSpr")

yeardat<-rainAlbers50
# yeardat$tmaxWntSpr<-tmaxAlbers50[,3]
yeardat$JuneDate<-Junedates[i]

saveRDS(yeardat,paste0("/Users/daisy/Google Drive/PhD/ENSO/Data/RainTmax",
                      as.Date(Junedates[i], "%Y %m %d"),".rds"))
message(i)

}



####################
#Bring the data back together
####################

files<-list.files("/Users/daisy/Google Drive/PhD/ENSO/Data/RainTmax",full.name=TRUE)

dat<-readRDS(files[1])


for (ii in 1:length(files)){
    df1<-readRDS(files[ii])
    dat<-smartbind(dat,df1)
  
}

write.csv(dat,"/Users/daisy/Google Drive/PhD/ENSO/Data/WntSprRainTmax.csv")

