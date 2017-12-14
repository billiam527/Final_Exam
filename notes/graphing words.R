library(dplyr)
library(ggplot2)
library(gutenbergr)
library(tidytext)

dracula <- gutenberg_download(345)
#adds a column "line" and numbers it 1 through ...
dracula$line<-1:15568

#gets rid of gutenberg_id column
dracula$gutenberg_id<-NULL

#seperates words to their own rows
dracula_words<-dracula%>%
  unnest_tokens(word,text)

#adds column group on the end and uses line number/80 to determine its value
dracula_words$group<-dracula_words$line %/% 80

#bing words are saved to bing
bing<-get_sentiments('bing')

#innerjoins columns that are the same
dracula_words<-inner_join(dracula_words,bing)

#Add a column where 1s correlate with positive and -1s correlate with negatives
dracula_words$score<-1
rows<-which(dracula_words$sentiment == "negative")
dracula_words$score[rows]<--1

#use dplyr to group by the group number and give the section a score. This score is the sum
#of all the words in the section and tells us if it is overwhelmingly positive or negative
dracula_sent<-dracula_words%>%
  group_by(group)%>%
  summarize(group_sentiment=sum(score))

#graphing the score
ggplot()+
  geom_point(data=dracula_sent,aes(x=group, y=group_sentiment))

ggplot()+
  geom_col(data=dracula_sent,aes(x=group, y=group_sentiment),fill='#ef6e15', color='black')
