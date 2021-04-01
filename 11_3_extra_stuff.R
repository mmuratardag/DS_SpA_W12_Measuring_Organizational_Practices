
library(readxl)
dic <- read_excel("000_data/expanded_dict_cleaned_all_unique_LIWC_format_extra.xlsx")

library(quanteda)
quanteda_options(threads = 7)
dic$n_token <- ntoken(dic$n_grams)
library(tidyverse)
dic_uni_grams <- dic %>% filter(n_token == 1)
dic_bi_grams <- dic %>% filter(n_token == 2)
dic_tri_grams <- dic %>% filter(n_token == 3)
dic_four_grams <- dic %>% filter(n_token == 4)

load("000_data/Corpus.RData")

ug_pro_kwic <- kwic(GlassdoorCorpus, pattern = "profitability", window = 8, valuetype = "fixed")
ug_ma_kwic <- kwic(GlassdoorCorpus, pattern = "microaggression", window = 8, valuetype = "fixed")
bg_mo_kwic <- kwic(GlassdoorCorpus, pattern = phrase("matrix organization"), window = 8, valuetype = "fixed")
bg_co_kwic <- kwic(GlassdoorCorpus, pattern = phrase("continuous improvement"), window = 8, valuetype = "fixed")
tg_mrt_kwic <- kwic(GlassdoorCorpus, pattern = phrase("much red tape"), window = 8, valuetype = "fixed")
tg_hwl_kwic <- kwic(GlassdoorCorpus, pattern = phrase("heavy work load"), window = 8, valuetype = "fixed")
fg_espp_kwic <- kwic(GlassdoorCorpus, pattern = phrase("employee stock purchase program"), window = 8, valuetype = "fixed")
fg_mpl_kwic <- kwic(GlassdoorCorpus, pattern = phrase("maternity / paternity leave"), window = 8, valuetype = "fixed")

names_text_vector <- c("Alphan", "Alexandra", "Krystana", "Pietro", "Pooja", "Pavel", "Lena", "Svenja", "Nader", "Bala", "Müfit", "Mahmood", "Anastasia", "Galiya")
dfm_names <- dfm(names_text_vector)
set.seed(14)
textplot_wordcloud(dfm_names, min_count = 1)








