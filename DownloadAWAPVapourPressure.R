#download AWAP data

library(RCurl)

y1<-as.Date("01/11/2012","%d/%m/%Y")
y2<-as.Date("01/12/2014","%d/%m/%Y")
#dates<-seq(y1,y2, by= "1"month)



#NDVI
dates<-seq(as.Date("2012/11/1"), as.Date("2014/12/1"), "month")

for(i in 1:length(dates)){
  D<-strftime(dates[i],format = "%d")
  d2<-strftime(dates[i+1]-1,format = "%d")
  M<-strftime(dates[i],format = "%m")
  Y<-strftime(dates[i],format = "%Y")
  
download.file(paste0("http://www.bom.gov.au/web03/ncc/www/awap/ndvi/ndviave/month/grid/history/nat/",Y,M,D,Y,M,d2,".Z"),
                     paste0("/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/AWAP/MonthlyNDVI/",Y,M,D,Y,M,d2,".Z"),
                            mode="w",method="curl")


message(paste0(i," out of ",length(dates)))
}

#weekely tmax

dates<-seq(as.Date("2012/10/31"), as.Date("2014/12/2"), "week")
for(i in 1:length(dates)){
  D<-strftime(dates[i],format = "%d")
  d2<-strftime(dates[i+1]-1,format = "%d")
  M<-strftime(dates[i],format = "%m")
  m2<-strftime(dates[i+1]-1,format = "%m")
  Y<-strftime(dates[i],format = "%Y")
  y2<-strftime(dates[i+1]-1,format = "%Y")
  
  download.file(paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/week/grid/0.05/history/nat/",Y,M,D,y2,m2,d2,"grid.Z"),
                paste0("/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/AWAP/WeeklyTmax/",Y,M,D,y2,m2,d2,"grid.Z"),
                mode="w",method="curl")
  
  
  message(paste0(i," out of ",length(dates)))
}

#weekely tmin

dates<-seq(as.Date("2012/10/31"), as.Date("2014/12/2"), "week")
for(i in 1:length(dates)){
  D<-strftime(dates[i],format = "%d")
  d2<-strftime(dates[i+1]-1,format = "%d")
  M<-strftime(dates[i],format = "%m")
  m2<-strftime(dates[i+1]-1,format = "%m")
  Y<-strftime(dates[i],format = "%Y")
  y2<-strftime(dates[i+1]-1,format = "%Y")
  
  download.file(paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/minave/week/grid/0.05/history/nat/",Y,M,D,y2,m2,d2,"grid.Z"),
                paste0("/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/AWAP/WeeklyTmin/",Y,M,D,y2,m2,d2,"grid.Z"),
                mode="w",method="curl")
  
  
  message(paste0(i," out of ",length(dates)))
}

#weekely VP


dates<-seq(as.Date("2012/10/31"), as.Date("2014/12/2"), "week")
for(i in 1:length(dates)){
  D<-strftime(dates[i],format = "%d")
  d2<-strftime(dates[i+1]-1,format = "%d")
  M<-strftime(dates[i],format = "%m")
  m2<-strftime(dates[i+1]-1,format = "%m")
  Y<-strftime(dates[i],format = "%Y")
  y2<-strftime(dates[i+1]-1,format = "%Y")
  
  
  download.file(paste0("http://www.bom.gov.au/web03/ncc/www/awap/vprp/vprph15/week/grid/0.05/history/nat/",Y,M,D,y2,m2,d2,"grid.Z"),
                paste0("/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/AWAP/WeeklyVP3pm/",Y,M,D,y2,m2,d2,"grid.Z"),
                mode="w",method="curl")
  
  
  message(paste0(i," out of ",length(dates)))
}


#weekely solar radiation


dates<-seq(as.Date("2012/10/31"), as.Date("2014/12/2"), "week")
for(i in 1:length(dates)){
  D<-strftime(dates[i],format = "%d")
  d2<-strftime(dates[i+1]-1,format = "%d")
  M<-strftime(dates[i],format = "%m")
  m2<-strftime(dates[i+1]-1,format = "%m")
  Y<-strftime(dates[i],format = "%Y")
  y2<-strftime(dates[i+1]-1,format = "%Y")
  
  
  download.file(paste0("http://www.bom.gov.au/web03/ncc/www/awap/solar/solarave/daily/grid/0.05/history/nat/",Y,M,D,y2,m2,d2,"grid.Z"),
                paste0("/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/AWAP/WeeklySolar/",Y,M,D,y2,m2,d2,"grid.Z"),
                mode="w",method="curl")
  
  
  message(paste0(i," out of ",length(dates)))
}


