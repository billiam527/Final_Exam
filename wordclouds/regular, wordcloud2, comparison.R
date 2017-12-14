library(gutenbergr)
library(tidytext)
library(dplyr)
library(tm)
library(wordcloud)
library(wordcloud2)
library(reshape2)

dracula<-gutenberg_download(345)

dracula_words<-dracula%>%
  unnest_tokens(word, text)

bing<-get_sentiments('bing')

dracula_words<-inner_join(dracula_words,bing)
dracula_words$gutenberg_id<-NULL

dracula_words<-dracula_words%>%
  group_by(word)%>%
  summarize(freq=n(),sentiment=first(sentiment))

wordcloud(dracula_words$word,dracula_words$freq,min.freq = 10)

#or use wordlcoud2
wordcloud2(dracula_words, backgroundColor = 'black', fig = 'bat.jpg', size = 0.25)

#word is rows, sentiment is columns
#fill = 0 tells it to replace NAs with 0s
#reshape takes dataframe and puts things into long or short form
dracula_matrix<-acast(dracula_words,word~sentiment, value.var = 'freq', fill = 0)

comparison.cloud(dracula_matrix,colors = c('black', 'orange'))
