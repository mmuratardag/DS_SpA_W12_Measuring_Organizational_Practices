
getwd()
library(reticulate)
conda_list()
use_condaenv("r-reticulate")

load("11_1_extra_stuff.R_for_autoencoder.RData")

library(ruta)
set.seed(666)
ae_op <- autoencode(data = scale(as.matrix(dfm_dic[,2:1209])), dim  = 3, type = "basic", activation = "tanh") # should be variational
                                                                                                              # variational throws and error
                                                                                                              # possibly due due to py 
                                                                                                              # language translation
                                                                                                              # might be due to version differences
                                                                                                              # "tf.config.experimental_run_functions_eagerly(True)"
                                                                                                              # argument cannot be added from this library
# loss becomes stable after epoch 6 and starts to wiggle around 17 to 20
# the wiggling is within .0002 range so just fuck it
ae_op_df <- as.data.frame(ae_op)

load("000_data/Corpus_DF.RData")
library(tidyverse)
library(quanteda)
ICdic <- dictionary(file = "dic.dic", format = "LIWC")
library(quanteda.dictionaries)
LIWC_op <- liwcalike(d$text, dictionary = ICdic, verbose = T) %>% select(employee_orientation,
                                                                         formalization_practices,
                                                                         innovation_practices)
d <- bind_cols(d, LIWC_op, ae_op_df) %>% rename(ae_dim_red_V1 = V1, ae_dim_red_V2 = V2, ae_dim_red_V3 = V3)

library(easystats)
d %>% select(employee_orientation:innovation_practices, ae_dim_red_V1:ae_dim_red_V3) %>% correlation() %>% summary() %>%
  plot(show_values = T, show_p = T, digits = 2)  +
  labs(title = "Dictionary dimensions and autoencoder dimensions",
       subtitle = "Correlations across the dimensions of corporate culture and autoencoder dimensions") +
  theme(axis.text.x = element_text(angle = 45))
