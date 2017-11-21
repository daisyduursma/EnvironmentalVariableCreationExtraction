# The followng code is used to run the biovars function in the dismo Package. 
rm(list = ls())

library(raster)
library(dismo)
library(rgdal)

#variables to be used 
sVar=c("tmin", "tmax", "prec")

#location of three folders
sBaseDir<-paste0("/Users/daisy/Documents/data/climate_mmn/", sVar[])

#create location to write out files
dir.out = "/Users/daisy/Documents/data/climate_mmn/biovars"

#check dir.out exhist
if (file.exists(dir.out) != TRUE) stop(paste0("Output file does not exhist, please check path."))

#for each of the variables read in the 12 months of data for sVar and create dataframes

for (j in 1:length(sBaseDir)){
  #print(paste(Sys.time(),":: STARTED ::",sVar[j],sep=" "))
  #Make a list of all the files with pattern
  lFiles<-list.files(path = sBaseDir[j],
                   pattern = ".nc",  
                   all.files = T, 
                   full.names = T, 
                   recursive = F) 
  #check that 12 months of data are found
  if (length(lFiles) != 12) stop(paste0("The number of files found in ", sBaseDir[j], " is not equal to 12 months of data."))
  
  r_stack <- stack(raster(lFiles[1], band=1),
                      raster(lFiles[2], band=1),
                      raster(lFiles[3], band=1),
                      raster(lFiles[4], band=1),
                      raster(lFiles[5], band=1),
                      raster(lFiles[6], band=1),
                      raster(lFiles[7], band=1),
                      raster(lFiles[8], band=1),
                      raster(lFiles[9], band=1),
                      raster(lFiles[10], band=1),
                      raster(lFiles[11], band=1),
                      raster(lFiles[12], band=1))
  
  #reasign name to the dataframe and remove generic one
  if (j==1){assign(paste0(sVar[1]),r_stack)}
  if (j==2){assign(paste0(sVar[2]),r_stack)}
  if (j==3){assign(paste0(sVar[3]),r_stack)}
  remove(r_stack)
  
}

# run biovars
biovar <- biovars(prec, tmin, tmax)
rm (tmin,tmax,prec)

#write out the biovars to ascii
brasters <- unstack(biovar)
outputnames <- paste("bio_",seq_along(brasters), ".asc",sep="")
for(ii in seq_along(brasters)){writeRaster(brasters[[i]], filename=paste0(dir.out,"/",outputnames[ii]))}


for (z in 1:length(seq_along(brasters))){
  print(paste0("bio_", z))
  print(paste0("mean = ",cellStats(brasters[[z]],stat=mean)))
  print(paste0("min = ",cellStats(brasters[[z]],stat=min)))
  print(paste0("max= ",cellStats(brasters[[z]],stat=max)))
}

