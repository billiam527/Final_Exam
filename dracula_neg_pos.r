#with TidyText's get_sentiments('bing') we get positives and negatives attached to words
bing<-get_sentiments('bing')

#we download dracula into a df called dracula from the gutenberg library
dracula<-gutenberg_download(345)

#We seperate the words in df dracula and store it into dracula_words
dracula_words<-dracula%>%
  unnest_tokens(word,text)

#Here we join the dfs dracula_words and bing
#They will be joined by "word" since that is the column they have in common
dracula_sent<-inner_join(dracula_words,bing)
draculua_sent$gutenberg_id<-NULL

#Add a column
dracula_sent$score<-1

#Tells us all the row numbers that are negative
rows<-which(dracula_sent$sentiment=='negative')

#Look at what the column is for these particular rows (should be all negatives)
dracula_sent$sentiment[rows]

#This will take the row "score" that are in the rows df, aka negative words, a value of -1
dracula_sent$score[rows]<--1