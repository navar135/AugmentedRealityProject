##By: Karen Navarro 
## 03/04/2019
## 
## This code creates a table for the location (in pixels for a screen 1280x1024) 
## where the gabor will be drawn in each truck image and exports it as a csv file
##
##
# set working directory 
setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia")
#Create variables
ImageNames <- c("Truck1","Truck2","Truck3","Truck4","Truck5",
                         "Truck6","Truck7","Truck8","Truck9","Truck10",
                         "Truck11","Truck12","Truck13","Truck14","Truck15",
                         "Truck16","Truck17","Truck18","Truck19","Truck20")
xLocation <- c(490,420,820,440,550,560,560,450,545,575,
               405,560,615,690,640,430,720,580,460,660)
yLocation <- c(470,555,595,545,500,660,490,570,530,330,
               430,525,575,440,810,640,700,650,650,575)
#create table
locations <- matrix(c(ImageNames,xLocation,yLocation),ncol=3,byrow=FALSE)
colnames(locations) <- c("Image","x","y")
locations <- as.table(locations)
locations

#export as csv file 
write.csv(locations, file = "TruckGaborLocation.csv")
