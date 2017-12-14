dracula<-gutenberg_download(345)

dracula_words<-dracula%>%
  unnest_tokens(word,text)

bing<-get_sentiments('bing')

dracula_words<-inner_join(dracula_words, bing)

dracula_words$gutenberg_id<-NULL

dracula_pos<-dracula_words%>%
  filter(sentiment=='positive')%>%
  group_by(word)%>%
  summarize(count=n())%>%
  arrange(count)%>%
  filter(count>=66)


dracula_pos$word<-factor(dracula_pos$word, levels=dracula_pos$word)

ggplot()+
  geom_bar(data=dracula_pos,aes(x=word,y=count),stat='identity')+
  coord_flip()

dracula_neg<-dracula_words%>%
  filter(sentiment=='negative')%>%
  group_by(word)%>%
  summarize(count=n())%>%
  arrange(count)%>%
  filter(count>=49)%>%
  filter(word != 'miss')

dracula_neg$word<-factor(dracula_neg$word, levels=dracula_neg$word)

ggplot()+
  geom_bar(data=dracula_neg,aes(x=word,y=count),stat='identity')+
  coord_flip()

dracula_comp<-rbind(dracula_pos,dracula_neg)

ggplot()+
  geom_bar(data=dracula_comp,aes(x=word,y=count),stat='identity')+
  coord_flip()+
  facet_wrap()