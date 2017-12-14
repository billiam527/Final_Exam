library(dplyr)
library(tidytext)
library(tm)
library(wordcloud)
library(janeaustenr)
library(stringr)
library(knitr)

#Store the Jane Austen Books into a DF
sns<-austen_books()

#Print the df
sns

#Remove all the other books besides Sense and Sensibility
sns<-sns%>%
  filter(book=='Sense & Sensibility')

#We make the book column all characters now as opposed to factors
sns$book<-as.character(sns$book)

#If you want to see more than 10 lines
#n=the number of lines you can see
###print(sns,n=100)

#Want to get rid of the "Chapter" at the beginning of each chapter of the book
#str_detect looks for the word
#^ means begins with
###str_detect(sns$text,'^CHAPTER')

#Want to look at one of the TRUEs
###sns$text[725]
###sns$text[827]

#Use dplyr to remove the TRUEs aka the word Chapter
###temp<-sns%>%
###  filter(!str_detect(sns$text,'^CHAPTER'))
#We use temp so that we can check the TRUEs to make sure they are the chapters we want

#check the temp
###print(temp,n=50)

#Will make above dplyr statement permenant in sns
sns<-sns%>%
  filter(!str_detect(sns$text,'^CHAPTER'))

#Still have weird beginning part. If we print we see the novel starts on line 12
###print(sns,n=50)

#shows rows 1-11
#need to show columns as well but if you put nothing, like below, you get all of the columns
###sns[1:11,]

#Shows total rows
###dim(sns)

#Makes it so we are only using rows 12 - 12574
sns<-sns[12:12574,]

#We have the end at the end of the df which we might want to get rid of, can take out the last
#line by using
sns<-sns[1:12562,]

#Split the words apart into their own rows
words_df<-sns%>%
  unnest_tokens(word,text)

#Use stop words to get rid of unwanted easy words
#Can be confusing because we are using with two columns named word from 2 different dfs
words_df<-words_df%>%
  filter(!(word %in% stop_words$word))

#Count by the frequency each word shows up
word_freq<-words_df%>%
  group_by(word)%>%
  summarize(count=n())

#Plug the two columns into the word cloud function
#min.freq=100, words will not show up unless they show
#up 100 times
wordcloud(word_freq$word,word_freq$count,min.freq=25)