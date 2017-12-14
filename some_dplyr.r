#Scatter plot-------------------------------
result<-Batting%>%
  filter(playerID=="ruthba01")%>%
  select(yearID,SO,HR)

ggplot()+
  geom_point(data=result,aes(x=SO,y=HR))+
  xlab("Strikeouts")+
  ylab("Homeruns")


#Histogram----------------------------------

ggplot()+
  geom_histogram(data=result,aes(x=HR), bins=5, color="blue", fill="white")+
  xlab("Homeruns")

#Time Series------------------------------------------------------------------

ggplot()+
  geom_point(data=result,aes(x=yearID,y=HR))+
  geom_line(data=result,aes(x=yearID,y=HR))+
  xlab("Year")+
  ylab("Homeruns")