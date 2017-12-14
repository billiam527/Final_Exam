library(flexdashboard)
library(dplyr)
library(ggplot2)
library(lubridate)
library(stringr)

production<-read.csv("candy_production.csv",header=TRUE,stringsAsFactors=FALSE)
production$observation_date<-ymd(production$observation_date)

ggplot()+
  geom_line(data=production,aes(x=observation_date,y=IPG3113N))
#-------
df<-production

df<-df%>%
  filter(observation_date<="1990-12-31" & observation_date>="1990-01-01")

ggplot()+
  geom_line(data=df,aes(x=observation_date,y=IPG3113N))+
  scale_x_date(date_breaks="1 month",date_labels="%b")

#-------
df<-production


df$observation_date<-str_sub(df$observation_date,3,3)

df<-df%>%
  filter(observation_date != 1 & observation_date != 7)%>%
  group_by(observation_date)%>%
  summarize(avg=mean(IPG3113N))

df$observation_date<-paste(df$observation_date,"0's",sep='')
df$observation_date=factor(df$observation_date,levels=c("80's","90's","00's"))

ggplot()+
  geom_bar(data=df,aes(x=observation_date,y=avg),stat='identity')