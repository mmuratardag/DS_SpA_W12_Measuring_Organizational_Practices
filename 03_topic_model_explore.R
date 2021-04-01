
load("000_data/Corpus.RData")


library(quanteda)
quanteda_options(threads = 7)
library(ldatuning)

dfm <- tokens(GlassdoorCorpus, remove_punct = T) %>%
  tokens_select(pattern = stopwords('en'), selection = 'remove') %>%
  dfm(remove_symbols = T)
dfm_topmod <- convert(dfm, to = "topicmodels")

result20 <- FindTopicsNumber(dfm_topmod, topics = seq(from = 2, to = 20, by = 2),
                             metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010", "Deveaud2014"),
                             method = "Gibbs",
                             control = list(seed = 666),
                             mc.cores = 7L, verbose = T)
FindTopicsNumber_plot(result20)

rm(list = ls())

load("000_data/Corpus_DF.RData")

library(stm)
corpus_processed <- textProcessor(documents = d$text,
                                  metadata = d,
                                  language = "en",
                                  onlycharacter = T,
                                  stem = F,
                                  removestopwords=T,
                                  removenumbers = T,
                                  removepunctuation = T)
corpus_prep_docs_output <- prepDocuments(corpus_processed$documents,
                                         corpus_processed$vocab,
                                         corpus_processed$meta,
                                         lower.thresh = 1000)
corpus_docs <- corpus_prep_docs_output$documents
corpus_vocab <- corpus_prep_docs_output$vocab
corpus_meta <- corpus_prep_docs_output$meta

K<-c(5, 8, 14, 16, 18, 20)
kresults <- searchK(corpus_docs, corpus_vocab, K, prevalence =~ Company + Industry, data = corpus_meta, seed = 666)

kresults_df <- data.frame(matrix(unlist(kresults$results), nrow=6, byrow=F))
colnames(kresults_df) <- c("K","exclus","semcoh","heldout","residual","bound","lbound","em.its" )

library(tidyverse)
sc_lp <- ggplot(data=kresults_df, aes(x=K, y=semcoh)) + geom_line() + geom_point() +
  labs(x = "Number of Topics", y = "Semantic Coherence",
       subtitle = "Semantic Coherence") + theme_bw()
re_lp <- ggplot(data=kresults_df, aes(x=K, y=residual)) + geom_line() + geom_point() +
  labs(x = "Number of Topics", y = "Residuals",
       subtitle = "Residuals") + theme_bw()

library(gridExtra)
grid.arrange(sc_lp,re_lp, ncol=2, top = "Diagnostic Values by Number of Topics")

stm_results_20_topics <- stm(corpus_docs,
                             corpus_vocab,
                             K = 20,
                             prevalence =~ Company + Industry,
                             data = corpus_meta, init.type = "LDA", seed = 666)

library(tidytext)
td_beta20 <- tidy(stm_results_20_topics)
td_beta20 %>%
  group_by(topic) %>%
  top_n(20, beta) %>%
  ungroup() %>%
  mutate(topic = paste0("Topic ", topic),
         term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = as.factor(topic))) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y") +
  coord_flip() +
  scale_x_reordered() +
  labs(x = NULL, y = expression(beta),
       title = "20 topics solution",
       subtitle = "Highest word probabilities for each topic") + theme_bw()

stm_20_res_topwords <- labelTopics(stm_results_20_topics, n = 20)

stm_20_res_topwords_prob <- as.data.frame(stm_20_res_topwords[["prob"]])
stm_20_res_topwords_frex <- as.data.frame(stm_20_res_topwords[["frex"]])
stm_20_res_topwords_lift <- as.data.frame(stm_20_res_topwords[["lift"]])
stm_20_res_topwords_score <- as.data.frame(stm_20_res_topwords[["score"]])

stm_20_res_topwords_df <- bind_rows(stm_20_res_topwords_prob, stm_20_res_topwords_frex, stm_20_res_topwords_lift, stm_20_res_topwords_score)

df_unq <- unique(stm_20_res_topwords_df[ , c(colnames(stm_20_res_topwords_df))])
df_unq$ID <- 1:80    
df_unq$Cons <- "Cons"
library(reshape2)
long_unq <- melt(df_unq, id.vars=21:22)
unq_words <- unique(long_unq$value)
unq_words_df <- tibble(unq_words) # 398
unq_words_df <- unq_words_df %>% rename(seedCandW = unq_words)

library(readxl)
CandidateSeedWords_old <- read_excel("000_data/0000_candW_all_merged_final_with_human_touch.xlsx") %>% 
  filter(tokenC == 1 & source == "employee") %>% rename(seedCandW = candW) %>% select(seedCandW)

seedCandW_df <- bind_rows(unq_words_df, CandidateSeedWords_old) %>% distinct()
rio::export(seedCandW_df, file = "000_data/03_topic_model_explore.R_01_candidate_seed_words_raw.xlsx")
