
load("000_data/Corpus_DF.RData")
# load("000_data/Corpus.RData")

library(tidyverse)
library(quanteda)
quanteda_options(threads = 7)
ICdic <- dictionary(file = "dic.dic", format = "LIWC")
library(quanteda.dictionaries)


Company_dfm <- tokens(d$text,
                      remove_punct = T,
                      remove_symbols = T,
                      remove_numbers = T,
                      remove_url = T,
                      remove_separators = T,
                      split_hyphens = F) %>%
  tokens_remove(pattern = stopwords("en")) %>% tokens_ngrams(n = c(1,2,3,4)) %>% 
  dfm(dictionary = ICdic,  groups = d$Company)

Company_dfm_df <- convert(Company_dfm, "data.frame") %>%
  rename(Company = doc_id) %>%
  select(Company, employee_orientation:innovation_practices) %>%
  gather(employee_orientation:innovation_practices, key = "dimension", value = "Share") %>%
  group_by(Company) %>%
  mutate(Share = Share / sum(Share)) %>%
  mutate(dimension = haven::as_factor(dimension))

Company_dfm_df %>%
  ggplot(aes(Company, Share, colour = dimension, fill = dimension)) +
  geom_bar(stat = "identity") +
  scale_colour_brewer(palette = "Set1") +
  scale_fill_brewer(palette = "Pastel1") +
  labs(title="Dictionary dimensions in companies",
       subtitle = "Stacked % are the saliency of n-grams associated with each dimension") +
  xlab("") +
  ylab("Dimension (%)") + theme(axis.text.x = element_text(size = 6, angle = 90),
                                axis.ticks.x = element_blank())

Industry_dfm <- tokens(d$text,
                       remove_punct = T,
                       remove_symbols = F,
                       remove_numbers = T,
                       remove_url = T,
                       remove_separators = T,
                       split_hyphens = F) %>%
  tokens_remove(pattern = stopwords("en")) %>% tokens_ngrams(n = c(1,2,3,4)) %>%
  dfm(dictionary = ICdic,  groups = d$Industry)

Industry_dfm_df <- convert(Industry_dfm, "data.frame") %>%
  rename(Industry = doc_id) %>%
  select(Industry, employee_orientation:innovation_practices) %>%
  gather(employee_orientation:innovation_practices, key = "dimension", value = "Share") %>%
  group_by(Industry) %>%
  mutate(Share = Share / sum(Share)) %>%
  mutate(dimension = haven::as_factor(dimension))

Industry_dfm_df %>%
  ggplot(aes(Industry, Share, colour = dimension, fill = dimension)) +
  geom_bar(stat = "identity") +
  scale_colour_brewer(palette = "Set1") +
  scale_fill_brewer(palette = "Pastel1") +
  labs(title="Dictionary dimensions in each industry",
       subtitle = "Stacked % are the saliency of n-grams associated with each dimension") +
  xlab("") +
  ylab("Dimension (%)") + theme(axis.text.x = element_text(angle = 90),
                                    axis.ticks.x = element_blank())
