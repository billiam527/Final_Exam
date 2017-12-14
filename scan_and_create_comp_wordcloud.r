library(dplyr)
library(reshape2)
library(wordcloud)
library(tidytext)

mercyhurst_scan<-scan('mercyhurst.txt',what=character(),sep='\n')
mercyhurst_lines<-data_frame(lines=1:24066,text=mercyhurst_scan)
mercyhurst_words<-unnest_tokens(mercyhurst_lines,word,text)

bing<-get_sentiments('bing')

mercyhurst_words<-inner_join(mercyhurst_words,bing)

mercyhurst_words<-mercyhurst_words%>%
  group_by(word)%>%
  summarize(freq=n(),sentiment=first(sentiment))

mercyhurst_matrix<-acast(mercyhurst_words,word~sentiment,value.var='freq',fill=0)

comparison.cloud(mercyhurst_matrix)