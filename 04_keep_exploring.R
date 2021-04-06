
load("000_data/Corpus.RData")

library(readxl)
pd <- read_excel("000_data/03_topic_model_explore.R_02_candidate_seed_words_human.xlsx")

library(quanteda)
quanteda_options(threads = 7)

df_efa <- GlassdoorCorpus %>% tokens(remove_punct = T,
                                     remove_symbols = T,
                                     remove_numbers = T,
                                     remove_url = T,
                                     remove_separators = T,
                                     split_hyphens = F) %>%
  dfm() %>% #dfm_tfidf() %>%
  dfm_select(pd$seedCandW) %>% convert(to = "data.frame")

library(tidyverse)
df_efa <- df_efa %>% select (2:407)
# df_efa_desc <- psych::describe(df_efa)
# mean(df_efa_desc$max) # 7 ## 58

# do the silly thing
library(easystats)
efa_load <- psych::fa(df_efa, nfactors = 3, rotate = "geominQ", fm = "ml") %>% model_parameters(sort = T, threshold = "max")

# library(regsem)
# library(semTools)
# unrotated <- efaUnrotate(df_efa, nf = 3, varList = colnames(df_reg_sem), estimator = "mlr")
# 
# efa_lavaan_model = efaModel(3, colnames(df_efa))
# 
# semFit <- sem(efa_lavaan_model, data = df_reg_sem, std.lv = T, std.ov = T,
#               int.ov.free = F, int.lv.free = F,
#               auto.fix.single = F, se = "none", parallel = "multicore", ncpus = 7, verbose = T)
# 
# regsemFit <- cv_regsem(model = semFit, pars_pen = "loadings",
#                        mult.start = T, multi.iter = 10,
#                        n.lambda = 100, type = "lasso", jump = 10^-5, lambda.start = 0.001,
#                        ncore = 7, n.boot = 1000)

# do the real thing
df_efa_bin <- bootnet::binarize(df_efa, split = 1)

library(mirtjml)
setMIRTthreads(7)
getMIRTthreads()
jmlfa_res <- mirtjml_expr(response = as.matrix(df_efa_bin), K = 3)

# `%not_in%` <- Negate(`%in%`)

vroom::vroom_write(df_efa_bin, "000_data/df_efa_for_torch_nn_efa.csv", delim = ",")
# TO DO:
# apply the deep artificial neural network model: importance-weighted autoencoder (IWAE) for exploratory IFA

