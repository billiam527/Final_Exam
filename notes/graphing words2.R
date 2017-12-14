dracula<-gutenberg_download(345)

dracula$line<-1:15568

dracula$gutenberg_id<-NULL

dracula_words<-dracula%>%
  unnest_tokens(word,text)

dracula_words$group<-dracula_words$line %/% 80

afinn<-get_sentiments("afinn")

dracula_words<-inner_join(dracula_words,afinn)

dracula_sent<-dracula_words%>%
  group_by(group)%>%
  summarize(group_sentiment=sum(score))

ggplot()+
  geom_col(data=dracula_sent,aes(x=group, y=group_sentiment),fill='#ef6e15', color='black')
