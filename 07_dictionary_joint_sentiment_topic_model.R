
load("000_data/Corpus.RData")

library(quanteda)
quanteda_options(threads = 7)

train <- corpus_subset(GlassdoorCorpus, tss %in% "train")
test <- corpus_subset(GlassdoorCorpus, tss %in% "test")

ICdic <- dictionary(file = "dic.dic", format = "LIWC")

train_dfm_dic <- train %>% tokens(remove_punct = T,
                                  remove_symbols = F,
                                  remove_numbers = T,
                                  remove_url = T,
                                  remove_separators = T,
                                  split_hyphens = F) %>% 
  #tokens_select(pattern = stopwords('en'), selection = 'remove') %>%
  tokens_ngrams(n = c(1,2,3,4)) %>% dfm() %>% dfm_select(ICdic)

test_dfm_dic <- test %>% tokens(remove_punct = T,
                                remove_symbols = F,
                                remove_numbers = T,
                                remove_url = T,
                                remove_separators = T,
                                split_hyphens = F)  %>%
  #tokens_select(pattern = stopwords('en'), selection = 'remove') %>%
  tokens_ngrams(n = c(1,2,3,4)) %>% dfm() %>% dfm_select(ICdic)

#train_dfm_dic_df <- train_dfm_dic %>% convert(to = "data.frame")

library(rJST)
train_jst_op <- jst(train_dfm_dic, sentiLexInput = ICdic, numTopics = 3, numSentiLabs = 3, numIters = 600, excludeNeutral = T)
train_pi <- get_parameter(train_jst_op, 'pi')
library(tidyverse)
train_pi <- train_pi %>% rename(topic1_sentiment = sent1, topic2_sentiment = sent2, topic3_sentiment = sent3) %>% select(ID,topic1_sentiment:topic3_sentiment)

test_jst_op <- jst(test_dfm_dic, sentiLexInput = ICdic, numTopics = 3, numSentiLabs = 3, numIters = 600, excludeNeutral = T)
test_pi <- get_parameter(test_jst_op, 'pi')
test_pi <- test_pi %>% rename(topic1_sentiment = sent1, topic2_sentiment = sent2, topic3_sentiment = sent3) %>% select(ID,topic1_sentiment:topic3_sentiment)

jst_scores_df <- bind_rows(train_pi, test_pi)

gdata::keep(list = c("jst_scores_df", "ICdic"), sure=T)
load("000_data/Corpus_DF.RData")

d <- d %>% inner_join(jst_scores_df, by = "ID")
rm(jst_scores_df)

library(quanteda.dictionaries)
LIWC_op <- liwcalike(d$text, dictionary = ICdic, verbose = T) %>% select(employee_orientation,
                                                                         formalization_practices,
                                                                         innovation_practices)
d <- bind_cols(d, LIWC_op)

library(easystats)
d %>% filter(tts%in%"train") %>% 
  select(employee_orientation:innovation_practices, topic1_sentiment:topic3_sentiment) %>% correlation() %>% summary() %>%
  plot(show_values = T, show_p = T, digits = 2)  +
  labs(title = "Train set",
       subtitle = "Correlations across the topic sentiments and dictionary scores",
       caption = "N = 96469") +
  theme(axis.text.x = element_text(angle = 45))

d %>% filter(tts%in%"test") %>% 
  select(employee_orientation:innovation_practices, topic1_sentiment:topic3_sentiment) %>% correlation() %>% summary() %>%
  plot(show_values = T, show_p = T, digits = 2)  +
  labs(title = "Test set",
       subtitle = "Correlations across the topic sentiments and dictionary scores",
       caption = "N = 4328") +
  theme(axis.text.x = element_text(angle = 45))


library(vader)
set.seed(666)
train_rs <- d %>% filter(tts%in%"train") %>% group_by(Company, Industry) %>% sample_frac(.0125) %>% ungroup()
train_rs_sentiment <- vader_df(train_rs$text)
train_rs_sentiment <- train_rs_sentiment %>% select(compound:neg)
train_rs <- bind_cols(train_rs, train_rs_sentiment)
train_rs %>% select(employee_orientation:innovation_practices,topic1_sentiment:topic3_sentiment, compound:neg) %>% correlation() %>% summary() %>%
  plot(show_values = T, show_p = T, digits = 2)  +
  labs(title = "Train set",
       subtitle = "Correlations across the dimensions of corporate culture, employee ratings, sentiment scores",
       caption = "N = 1183 (1,25 % of train data)
                  \n Getting sentiment scores for all observations with vader or sentimentr takes ridiculously long time") +
  theme(axis.text.x = element_text(angle = 45))
set.seed(666)
test_rs <- d %>% filter(tts%in%"test") %>% group_by(Company, Industry) %>% sample_frac(.25) %>% ungroup()
test_rs_sentiment <- vader_df(test_rs$text) 
test_rs_sentiment <- test_rs_sentiment %>% select(compound:neg)
test_rs <- bind_cols(test_rs, test_rs_sentiment)
test_rs %>% select(employee_orientation:innovation_practices,topic1_sentiment:topic3_sentiment, compound:neg) %>% correlation() %>% summary() %>%
  plot(show_values = T, show_p = T, digits = 2)  +
  labs(title = "Test set",
       subtitle = "Correlations across the dimensions of corporate culture, employee ratings, sentiment scores",
       caption = "N = 1086 (25 % of test set)
                  \n Getting sentiment scores for all observations with vader or sentimentr takes ridiculously long time") +
  theme(axis.text.x = element_text(angle = 45))
