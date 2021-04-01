
load("000_data/Corpus_DF.RData")
library(tidyverse)
library(quanteda)
ICdic <- dictionary(file = "dic.dic", format = "LIWC")
library(quanteda.dictionaries)
LIWC_op <- liwcalike(d$text, dictionary = ICdic, verbose = T) %>% select(employee_orientation,
                                                                         formalization_practices,
                                                                         innovation_practices)
d <- bind_cols(d, LIWC_op)

gdata::keep(list = c("d", "ICdic"), sure = T)

library(quanteda)
quanteda_options(threads = 7)

# dfm_whole_corpus <- tokens(d$text,
#                            remove_punct = T,
#                            remove_symbols = F,
#                            remove_numbers = T,
#                            remove_url = T,
#                            remove_separators = T,
#                            split_hyphens = F) %>% 
#   tokens_select(pattern = stopwords('en'), selection = 'remove') %>% 
#   tokens_ngrams(n = c(1,2,3,4)) %>%
#   dfm() %>% dfm_tfidf() %>% convert(to = "data.frame")

dfm_dic <- tokens(d$text,
                  remove_punct = T,
                  remove_symbols = F,
                  remove_numbers = T,
                  remove_url = T,
                  remove_separators = T,
                  split_hyphens = F) %>% 
  tokens_select(pattern = stopwords('en'), selection = 'remove') %>%
  tokens_ngrams(n = c(1,2,3,4)) %>%
  dfm() %>% dfm_tfidf() %>% dfm_select(ICdic) %>% convert(to = "data.frame")

save(dfm_dic, file = "11_1_extra_stuff.R_for_autoencoder.RData")
