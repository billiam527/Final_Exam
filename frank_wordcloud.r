library(dplyr)
library(tidytext)
library(tm)
library(wordcloud)
library(gutenbergr)
library(stringr)
library(knitr)

gutenberg_works(str_detect(title,'Frankenstein'))

frankenstein<-gutenberg_download(84)

print(frankenstein)
head(frankenstein)
tail(frankenstein)

frankenstein<-frankenstein[12:7244,]
frankenstein

frankenstein<-frankenstein%>%
  filter(!str_detect(frankenstein$text,'^CHAPTER'))
frankenstein

words_df<-frankenstein%>%
  unnest_tokens(word,text)
words_df

words_df<-words_df%>%
  filter(!(word %in% stop_words$word))
words_df

word_freq<-words_df%>%
  group_by(word)%>%
  summarize(count=n())
word_freq
print(word_freq,n=100)

wordcloud(word_freq$word,word_freq$count,min.freq=25)