
load("000_data/Corpus_DF.RData")
library(tidyverse)
library(quanteda)
ICdic <- dictionary(file = "dic.dic", format = "LIWC")
library(quanteda.dictionaries)
LIWC_op <- liwcalike(d$text, dictionary = ICdic, verbose = T) %>% select(employee_orientation,
                                                                         formalization_practices,
                                                                         innovation_practices)
d <- bind_cols(d, LIWC_op)

d_gb_company <- d %>% select(Company, employee_orientation, formalization_practices, innovation_practices) %>%
  group_by(Company) %>%
  summarise(employee_orientation = mean(employee_orientation), formalization_practices = mean(formalization_practices),
            innovation_practices = mean(innovation_practices))

library(readxl)
comp_with_ind <- read_excel("000_data/company_list_ss_with_industry.xlsx")
d_gb_company <- left_join(d_gb_company, comp_with_ind, by = "Company")

library(plotly)
fig_company <- plot_ly(d_gb_company,
                       x = ~employee_orientation,
                       y = ~formalization_practices,
                       z = ~innovation_practices,
                       color = ~Industry)
fig_company <- fig_company %>% add_markers()
fig_company <- fig_company %>% layout(scene = list(xaxis = list(title = 'Employee Orientation'),
                                                   yaxis = list(title = 'Formalization Practices'),
                                                   zaxis = list(title = 'Innovation Practices')))

fig_company

library(htmlwidgets)
saveWidget(fig_company, "fig_company.html", selfcontained = T, libdir = "lib")

d_gb_industry <- d %>% select(Industry, employee_orientation, formalization_practices, innovation_practices) %>%
  group_by(Industry) %>%
  summarise(employee_orientation = mean(employee_orientation), formalization_practices = mean(formalization_practices),
            innovation_practices = mean(innovation_practices))

fig_industry <- plot_ly(d_gb_industry,
                        x = ~employee_orientation,
                        y = ~formalization_practices,
                        z = ~innovation_practices,
                        color = ~Industry)
fig_industry <- fig_industry %>% add_markers()
fig_industry <- fig_industry %>% layout(scene = list(xaxis = list(title = 'Employee Orientation'),
                                                     yaxis = list(title = 'Formalization Practices'),
                                                     zaxis = list(title = 'Innovation Practices')))

fig_industry

saveWidget(fig_industry, "fig_industry.html", selfcontained = T, libdir = "lib")
