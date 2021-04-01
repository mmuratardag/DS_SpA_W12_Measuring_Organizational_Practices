
load("000_data/Corpus.RData")

library(quanteda)
quanteda_options(threads = 7)

### raw freq
dfm <- tokens(GlassdoorCorpus, remove_punct = T) %>%
  tokens_select(pattern = stopwords('en'), selection = 'remove') %>%
  dfm(remove_symbols = T)
topfeatures(dfm, 1000)

library(tidyverse)
dfm_raw_freq <- read_table2("000_data/02_dfm_raw_freq.txt", col_names = F)  %>% select(X1:X9)
ssi <- seq(1, 224, by=2)
dfm_raw_freq <- dfm_raw_freq[ssi,]
dfm_raw_freq <- stack(dfm_raw_freq) %>% select(values) %>% drop_na()
dfm_raw_freq <- dfm_raw_freq[order(dfm_raw_freq$values),]
dfm_raw_freq <- tibble(dfm_raw_freq)

### weighted
dfm_weight <- dfm_weight(dfm, scheme  = "prop")
topfeatures(dfm_weight, 1000)

dfm_weighted <- read_table2("000_data/02_dfm_weighted.txt", col_names = F) %>% select(X1:X9)
dfm_weighted <- dfm_weighted[ssi,]
dfm_weighted <- stack(dfm_weighted) %>% select(values) %>% drop_na()
dfm_weighted <- dfm_weighted[order(dfm_weighted$values),]
dfm_weighted <- tibble(dfm_weighted)

### tf-idf
tfidf <- dfm_tfidf(dfm)
topfeatures(tfidf, 1000)

tfidf <- read_table2("000_data/02_dfm_tfidf.txt", col_names = FALSE) %>% select(X1:X9)
ssi <- seq(1, 223, by=2)
tfidf <- tfidf[ssi,]
tfidf <- stack(tfidf) %>% select(values) %>% drop_na()
tfidf <- tfidf[order(tfidf$values),]
tfidf <- tibble(tfidf)

rio::export(list(dfm_raw_freq = dfm_raw_freq,
                 dfm_weighted = dfm_weighted,
                 tfidf = tfidf), file = "000_data/02_freq_words.xlsx")
