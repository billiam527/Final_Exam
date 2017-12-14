library(gutenbergr)
library(tidytext)
library(stringr)
library(dplyr)
library(ggplot2)


frankenstein<-gutenberg_download(84)
frankenstein$gutenberg_id<-NULL
frankenstein_words<-unnest_tokens(frankenstein,word,text)
afinn<-get_sentiments('afinn')
frankenstein_words$word_number<-1:75175
frankenstein_words<-inner_join(frankenstein_words,afinn)
frankenstein_words$accumulated_sentiment<-cumsum(frankenstein_words$score)
ggplot()+
  geom_line(data=frankenstein_words,aes(x=word_number,y=accumulated_sentiment))+
  ggtitle('Accumulated Sentiment for Frankenstein')