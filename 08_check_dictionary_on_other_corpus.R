
library(readxl)
ku <- read_excel("000_data/0000_kununu_final_ENG.xlsx")
ku$kununu_score <- as.numeric(ku$kununu_score)
library(tidyverse)
n_distinct(ku$company) # 224 companies
n_distinct(ku$industry) # 33 industries

library(quanteda)
ICdic <- dictionary(file = "dic.dic", format = "LIWC")
library(quanteda.dictionaries)
LIWC_op <- liwcalike(ku$merged_text, dictionary = ICdic, verbose = T) %>% select(employee_orientation,
                                                                                 formalization_practices,
                                                                                 innovation_practices)
ku <- bind_cols(ku, LIWC_op)
library(easystats)
ku %>% select(employee_orientation:innovation_practices, kununu_score:review_score) %>% correlation() %>% summary() %>%
  plot(show_values = T, show_p = T, digits = 2)  +
  labs(title = "Different Corpus
                \nKununu employee reviews",
       subtitle = "Correlations across the dimensions of corporate culture and employee ratings",
       caption = "N = 23004") +
  theme(axis.text.x = element_text(angle = 45))
