library(dplyr)
library(ggplot2)
library(stringr)
library(lubridate)

set wd to KoreanWar.csv

open R script and save

Import the file
deaths<-read.csv('KoreanConflict.csv',header=TRUE,stringsAsFactors = FALSE)
-header is true is for if you have headers
-stringsAsFactors makes it so your strings are not factors

In console:
  colnames(deaths)

We want to looks in incident dates, we can use str_detect from stringr...
str_detect('19651213','\\d{8}')
-the first one is the data we are looking for
-second one is look for a digit (\\d) 8 times ({8})
-if we add a ^ character before it means there is nothing before the 8 digits
-if we add a $ character after it means nothing comes after it
-now looks like...
str_detect('19651213','^\\d{8}$')
-will return true
-wanna operate on our column
str_detect(deaths$INCIDENT_DATE,'^\\d{8}$')

If we run sum(str_detect(deaths$INCIDENT_DATE,'^\\d{8}$'))
-will count the Trues since they get a numerical value of 1 and false, 0
-Can then subtract the total by finding the total number of columns 
dim(deaths)
36574
and subtract the trues

When looking at data it looks like a number of our falses were just shifted

Can use a for loop to check which incident dates are messed up:
  
  for(i in 1:36574){
    incident<-str_detect(deaths$INCIDENT_DATE[i],"\\d{8}")
    print(incident)
  }

can do the same thing for FATALITY column

for(i in 1:36574){
  incident<-str_detect(deaths$INCIDENT_DATE[i],"\\d{8}")
  fatality<-str_detect(deaths$FATALITY[i],"\\d{8}")
  
  now we can write an if statement to put the column of FATALITY into the INCIDENT_DATE when the format is correct
  
  for(i in 1:36574){
    incident<-str_detect(deaths$INCIDENT_DATE[i],"\\d{8}")
    fatality<-str_detect(deaths$FATALITY[i],"\\d{8}")
    if(incident==FALSE & fatality==TRUE){
      deaths$INCIDENT_DATE[i]<-deaths$FATALITY[i]
    }
    print(i)
  }
  
  Can then take the sum of Trues and subtract it from the total and we see we only have 63 columns that arent correct
  
  head(deaths)
  
  just shows the top of the table
  
  deaths%>%
    group_by(INCIDENT_DATE)%>%
    summarize(num_deaths<-n())
  
  -grouping by day aka INCIDENT_DATE and then counting by using summarize(numdeaths<-n())
  -adding filter
  
  deaths%>%
    filter(str_detect(deaths$INCIDENT_DATE,"\\d{8}")==TRUE)%>%
    group_by(INCIDENT_DATE)%>%
    summarize(num_deaths<-n())
  
  - says keep records that hold true to str_detect(deaths$INCIDENT_DATE,"\\d{8}")
  
  df<-deaths%>%
    filter(str_detect(deaths$INCIDENT_DATE,"\\d{8}")==TRUE)%>%
    group_by(INCIDENT_DATE)%>%
    summarize(num_deaths=n())%>%
    mutate(date=ymd(INCIDENT_DATE))%>%
    select(INCIDENT_DATE,num_deaths,date)
  
  -adding in a new column date where INCIDENT date is mutated from a chr column to a date using lubridate
  -lookup strftime to look up format for dates when using scale_x_date
  
  ggplot()+
    geom_line(data=df,aes(x=date,y=num_deaths))+
    scale_x_date(date_breaks='3 months',date_labels = "%b %y")