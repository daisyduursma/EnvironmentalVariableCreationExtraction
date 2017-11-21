#download AWAP data

library(RCurl)

y1<-as.Date("12/09/1911","%d/%m/%Y")
y2<-as.Date("12/09/1911","%d/%m/%Y")
dates<-seq(y1,y2, by= 1)

19110912

for(i in 1:length(dates)){
  D<-strftime(dates[i],format = "%d")
  M<-strftime(dates[i],format = "%m")
  Y<-strftime(dates[i],format = "%Y")

download.file(paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/maxave/daily/grid/0.05/history/nat/",Y,M,D,Y,M,D,".grid.Z"),
                     paste0("/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/AWAP/DailyTmax/",Y,M,D,Y,M,D,".grid.Z"),
                            mode="w",method="curl")
download.file(paste0("http://www.bom.gov.au/web03/ncc/www/awap/temperature/minave/daily/grid/0.05/history/nat/",Y,M,D,Y,M,D,".grid.Z"),
              paste0("/Users/daisy/Google Drive/PhD/Data/Spatial/Climate/AWAP/DailyTmin/",Y,M,D,Y,M,D,".grid.Z"),
              mode="w",method="curl")

message(paste0(i," out of ",length(dates)))
}

