## this script is analysis eye performance for the monocular suppression project
## with the new study version (temporal delay). It will also analyze result from
## the truck task 
## By: Karen T. Navarro
## Date: 02/28/2020

#load necessary libraries
library(rmatio)
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)
library(gridExtra)
library(readr)
library(directlabels)
library(psycho)
library(reshape2)

#clear out current environment
rm(list = ls(all.names = TRUE))

####Analyze adaptation data####
#read in files
temp <- list.files(pattern="*SupDat_")
temp <-ldply(temp, read_csv)
temp$X1 <- NULL
#temp<- dplyr::filter(temp, rt > 0) #filter out rt less than start time
temp<- dplyr::filter(temp, subject != "Sub001_day2noBlur" & 
                       subject !="Sub002_day1" & 
                       subject !="Sub002_day2noBlur" &
                       subject !="Sub003_day1" & 
                       subject !="Sub003_day2noBlur" & 
                       subject !="Sub001_day2" & 
                       subject !="Sub001_day3" &
                       subject !="Sub001_day4" & 
                       subject !="Sub006_day1")
temp<- dplyr::filter(temp, rt > 0)
#divide into separate dataframes

len<- dplyr::filter(temp, subject == "Sub002_day2" | 
                      subject =="Sub002_day3" | 
                      subject =="Sub002_day4" | 
                      subject =="Sub002_day5")
subNo <- as.vector(matrix("Sub002", nrow = length(len$subject)))

len2<- dplyr::filter(temp, subject == "Sub003_day2" | 
                       subject =="Sub003_day3" | 
                       subject =="Sub003_day4")
subNo2 <- as.vector(matrix("Sub003", nrow = length(len2$subject)))
temp$subNo<- c(subNo,subNo2)

blurryEye<-subset(temp, decEye == deprivedEye) 
nonBlurryEye<-subset(temp, decEye != deprivedEye)

gg<- ggplot(data=nonBlurryEye, aes(x=rt,y=depths)) +
  geom_point(aes(color = subject)) + geom_line(aes(color = subject))+ ylim(0,1)
gg<- gg+ labs(x = "time (s)",y = "decrement depth(contrast) 0=full contrast", title =
                "Non-Blurry Eye Performance")
gg<- gg+facet_grid(day~subNo)

gg1<- ggplot(data=blurryEye, aes(x=rt,y=depths)) +
  geom_point(aes(color = subject)) + geom_line(aes(color = subject))+ ylim(0,1)
gg1<- gg1+ labs(x = "time (s)",y = "decrement depth(contrast) 0=full contrast", title =
                  "Blurry Eye Performance")
gg1<- gg1+facet_grid(day~subNo)

grid.arrange(gg, gg1, nrow=2)

####Analyze truck task data####
## Start processing rivalry data 
#read in all .csv files and combine into one 
setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia/Pilot_Data/")

temp1 <- list.files(pattern="*preXpostAdapt")
preXpostResults <- ldply(temp1, read_csv)
preXpostResults$X1 <- NULL
temp2<-list.files(pattern="*preXpostTimePoints")
preXpostTimePoints <- ldply(temp2, read_csv)
preXpostTimePoints$X1 <- NULL
preXpostTimePoints<- subset(preXpostTimePoints,subject !="KTN_day1")

preAdapt<-subset(preXpostTimePoints,phase=="preAdapt")
postAdapt<- subset(preXpostTimePoints,phase=="postAdapt")


#plot rivalry percent  
gg2 <- ggplot() + 
  geom_line(data = preAdapt, 
            aes(x = timePoints, y = pct_be, color = "pct_be")) + 
  geom_point(data = preAdapt, 
             aes(x = timePoints, y = pct_be, color = "pct_be")) +
  geom_line(data = preAdapt, 
            aes(x = timePoints, y = pct_nbe, color = "pct_nbe")) + 
  geom_point(data = preAdapt, 
             aes(x = timePoints, y = pct_nbe, color = "pct_nbe")) + 
  geom_line(data = preAdapt, 
            aes(x = timePoints, y = pct_mix, color = "pct_mix")) + 
  geom_point(data = preAdapt, 
             aes(x = timePoints, y = pct_mix, color = "pct_mix"))  
#gg2<- gg2 + xlim(0,600) 
gg2<- gg2 + labs(x = "time (s)",y = "% time seeing each eye", title = 
                   "Pre Adaptation") 
gg2<- gg2+ facet_grid(days~subNo)

gg3<-ggplot() + 
  geom_line(data = postAdapt, 
            aes(x = timePoints, y = pct_be, color = "pct_be")) + 
  geom_point(data = postAdapt, 
             aes(x = timePoints, y = pct_be, color = "pct_be")) +
  geom_line(data = postAdapt, 
            aes(x = timePoints, y = pct_nbe, color = "pct_nbe")) + 
  geom_point(data = postAdapt, 
             aes(x = timePoints, y = pct_nbe, color = "pct_nbe")) + 
  geom_line(data = postAdapt, 
            aes(x = timePoints, y = pct_mix, color = "pct_mix")) + 
  geom_point(data = postAdapt, 
             aes(x = timePoints, y = pct_mix, color = "pct_mix"))  
gg3<- gg3 + labs(x = "time (s)",y = "% time seeing each eye", title = 
                   "Post Adaptation") 
gg3<- gg3+ facet_grid(.~subject)
grid.arrange(gg2, gg3, nrow=2)



