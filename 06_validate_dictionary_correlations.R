
load("000_data/Corpus_DF.RData")

library(tidyverse)

train <- d %>% filter(tts%in%"train")
test  <- d %>% filter(tts%in%"test")

library(quanteda)
ICdic <- dictionary(file = "dic.dic", format = "LIWC")
library(quanteda.dictionaries)
train_LIWC_op <- liwcalike(train$text, dictionary = ICdic, verbose = T) %>% select(employee_orientation,
                                                                                   formalization_practices,
                                                                                   innovation_practices)

test_LIWC_op <- liwcalike(test$text, dictionary = ICdic, verbose = T) %>% select(employee_orientation,
                                                                                 formalization_practices,
                                                                                 innovation_practices)
train <- bind_cols(train, train_LIWC_op)
test <- bind_cols(test, test_LIWC_op)

library(easystats)
train %>% select(employee_orientation:innovation_practices, rating_overall:rating_mgmt) %>% correlation() %>% summary() %>%
  plot(show_values = T, show_p = T, digits = 2)  +
  labs(title = "Train set",
       subtitle = "Correlations across the dimensions of corporate culture and employee ratings",
       caption = "N = 96469") +
  theme(axis.text.x = element_text(angle = 45))

test %>% select(employee_orientation:innovation_practices, rating_overall:rating_mgmt) %>% correlation() %>% summary() %>%
  plot(show_values = T, show_p = T, digits = 2)  +
  labs(title = "Test set",
       subtitle = "Correlations across the dimensions of corporate culture and employee ratings",
       caption = "N = 4338") +
  theme(axis.text.x = element_text(angle = 45))

#library(sentimentr)
# library(vader)
# set.seed(666)
# train_rs <- train %>% group_by(Company, Industry, date, employee_title, employee_status) %>% sample_frac(.4) %>% ungroup()
# train_rs_sentiment <- vader_df(train_rs$text)
# train_rs_sentiment <- train_rs_sentiment %>% select(compound:neg)
# train_rs <- bind_cols(train_rs, train_rs_sentiment)
# train_rs %>% select(rating_overall:rating_mgmt, employee_orientation:innovation_practices, compound:neg) %>% correlation() %>% summary() %>%
#   plot(show_values = T, show_p = T, digits = 2)  +
#   labs(title = "Train set",
#        subtitle = "Correlations across the dimensions of corporate culture, employee ratings, sentiment scores",
#        caption = "N = 1030
#                   \n Getting sentiment scores for all observations with vader or sentimentr takes ridiculously long time") +
#   theme(axis.text.x = element_text(angle = 45))
# set.seed(666)
# test_rs <- test %>% group_by(Company, Industry, date, employee_title, employee_status) %>% sample_frac(.5) %>% ungroup()
# test_rs_sentiment <- vader_df(test_rs$text) 
# test_rs_sentiment <- test_rs_sentiment %>% select(compound:neg)
# test_rs <- bind_cols(test_rs, test_rs_sentiment)
# test_rs %>% select(rating_overall:rating_mgmt, employee_orientation:innovation_practices, compound:neg) %>% correlation() %>% summary() %>%
#   plot(show_values = T, show_p = T, digits = 2)  +
#   labs(title = "Test set",
#        subtitle = "Correlations across the dimensions of corporate culture, employee ratings, sentiment scores",
#        caption = "N = 257
#                   \n Getting sentiment scores for all observations with vader or sentimentr takes ridiculously long time") +
#   theme(axis.text.x = element_text(angle = 45))
