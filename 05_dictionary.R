
library(readr)
expanded_dict <- read_csv("000_data/expanded_dict.csv")
rio::export(expanded_dict, file = "000_data/expanded_dict.xlsx")
rm(list = ls())

library(readxl)
expanded_dict_cleaned <- read_excel("000_data/expanded_dict_cleaned.xlsx")
library(tidyverse)
n_distinct(expanded_dict_cleaned$employee_orientation) # 414 ## all good
employee_orientation <- expanded_dict_cleaned %>% select(employee_orientation) %>% drop_na()
n_distinct(expanded_dict_cleaned$formalization_practices) # 419 out of 421 ## remove 2
formalization_practices <- expanded_dict_cleaned %>% select(formalization_practices) %>% distinct()
n_distinct(expanded_dict_cleaned$innovation_practices) # 443 ## all good
innovation_practices <- expanded_dict_cleaned %>% select(innovation_practices)

rio::export(list(employee_orientation = employee_orientation,
                 formalization_practices = formalization_practices,
                 innovation_practices = innovation_practices), file = "000_data/expanded_dict_cleaned_all_unique.xlsx")
