#this code loops through daily data and writes a .rds file for the extracted date
#downloads and opens AWAP data in temporary files
#saves values for the locations of interest but not the raster file
#thanks to Daisy Englert Duursma

library(stringr)
library(RCurl)
library(raster)
library(readr)

out.dir<-'data' #location to write daily data to

#locations
dat<-  read.csv('data/native_leaf_proteomics_sites.csv')
locs<-dat[,c('Longitude','Latitude')]

#dates
dates<-seq(as.Date('1950/01/01'), as.Date('2016/01/01'), 'day')

z7path = shQuote('C:\\Program Files\\7-Zip\\7z') # set 7zip path for extracting compressed files


for(i in 736:length(dates)){
  D<-strftime(dates[i],format = '%d')
  D<-str_pad(D,2, pad='0')
  M<-strftime(dates[i],format = '%m')
  M<-str_pad(M,2, pad='0')
  Y<-strftime(dates[i],format = '%Y')
  
  temp <- tempfile()#prep temperture data
  t <- paste0('http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/daily/grid/0.05/history/nat/',Y,M,D,Y,M,D,'.grid.Z')
  download.file(t ,temp, mode='wb')
  file.copy(temp, 'tmp.Z',overwrite=TRUE)
  file = paste(getwd(), '/tmp.z', sep = '')
  cmd = paste(z7path, ' e ', file, ' -y -o', getwd(), '/', sep='')
  shell(cmd)
  tmax <- raster('tmp')
  
  temp2 <- tempfile()#prep vapour pressure data
  vp <- paste0('http://www.bom.gov.au/web03/ncc/www/awap/vprp/vprph15/daily/grid/0.05/history/nat/',Y,M,D,Y,M,D,'.grid.Z')
  download.file(vp ,temp2, mode='wb')
  file.copy(temp2, 'tmp2.Z',overwrite=TRUE)
  file = paste(getwd(), '/tmp2.z', sep = '')
  cmd = paste(z7path, ' e ', file, ' -y -o', getwd(), '/', sep='')
  shell(cmd)
  vp <- raster('tmp2')
  
  temp3 <- tempfile()#prep rain data
  rain <- paste0('http://www.bom.gov.au/web03/ncc/www/awap/rainfall/totals/daily/grid/0.05/history/nat/',Y,M,D,Y,M,D,'.grid.Z')
  download.file(rain ,temp3, mode='wb')
  file.copy(temp3, 'tmp3.Z',overwrite=TRUE)
  file = paste(getwd(), '/tmp3.z', sep = '')
  cmd = paste(z7path, ' e ', file, ' -y -o', getwd(), '/', sep='')
  shell(cmd)
  rain <- raster('tmp3')
  
  temp4 <- tempfile()#prep TMIN data
  Tmin <- paste0('http://www.bom.gov.au/web03/ncc/www/awap/temperature/minave/daily/grid/0.05/history/nat/',Y,M,D,Y,M,D,'.grid.Z')
  download.file(Tmin ,temp4, mode='wb')
  file.copy(temp4, 'tmp4.Z',overwrite=TRUE)
  file = paste(getwd(), '/tmp4.z', sep = '')
  cmd = paste(z7path, ' e ', file, ' -y -o', getwd(), '/', sep='')
  shell(cmd)
  Tmin <- raster('tmp4')
  
  outdat<-locs
  outdat$TMAX<-raster::extract(tmax,locs)
  outdat$TMIN<-raster::extract(Tmin,locs)
  outdat$RAIN<-raster::extract(rain,locs)
  outdat$VP<-raster::extract(vp,locs)
  outdat$date<-as.Date(paste(Y,M,D),'%Y %m %d')
  outdat$ID<-dat$ID
  
  ############
  saveRDS(outdat, file = paste0(out.dir,'/climate',paste0(Y,M,D),'.rds'))
  
  
  unlink(c('tmp','tmp2','tmp3','tmp4'))
  message(paste0(i,' out of ',length(dates)))
}


