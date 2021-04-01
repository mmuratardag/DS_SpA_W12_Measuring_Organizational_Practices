
load("000_data/raw_coprus_DF.RData")

library(tidyr)
d <- d %>% unite("text", review_title, pros, cons, advice_to_mgmt, na.rm = T, remove = F, sep = " ")
d <- d %>% unite("ID", EmCoID, rowID, strID, na.rm = T, remove = F, sep = "")

library(tidyverse)
d <- d %>% select(ID,Company:Industry,date:text,helpful,rating_overall:approves_of_CEO)

library(quanteda)
quanteda_options(threads = 7)
d$n_token <- ntoken(d$text)
sum(d$n_token) # 6.840.084

n_distinct(d$Company) # 207 companies
n_distinct(d$Industry) # 57 industries
nrow(d) # 100.807 employee reviews

colnames(d)

d$text_new <- str_replace_all(d$text, "[\r\n]" , " ")
d[1,8]
d[1,20]
d$text <- d$text_new
d[1,8]
colnames(d)
d <- d %>% select(ID:n_token)

set.seed(666)
train <- d %>% group_by(Company, Industry, date, employee_title, employee_status) %>% sample_frac(.70) # 96469
test  <- anti_join(d, train, by = 'ID') # 4338

train$tts <- "train"
test$tts <- "test"

train %>% ungroup() %>% select(text) %>% vroom::vroom_write("000_data/documents.txt", delim = "\n", col_names =  F)
train %>% ungroup() %>% select(ID) %>% vroom::vroom_write("000_data/document_ids.txt", delim = "\n", col_names =  F)

train <- train %>% ungroup()
test <- test %>% ungroup()

d <- bind_rows(train,test)

rm(list=setdiff(ls(), "d"))

save(d, file = "000_data/Corpus_DF.RData")

colnames(d)
GlassdoorCorpus <- corpus(d$text,
                          docvars = data.frame(ID = d$ID,
                                               Company = d$Company,
                                               Industry = d$Industry,
                                               date = d$date,
                                               employee_title = d$employee_title,
                                               location = d$location,
                                               employee_status = d$employee_status,
                                               helpful = d$helpful,
                                               rating_overall = d$rating_overall,
                                               rating_balance = d$rating_balance,
                                               rating_culture = d$rating_culture,
                                               rating_career = d$rating_career,
                                               rating_comp = d$rating_comp,
                                               rating_mgmt = d$rating_mgmt,
                                               recommends = d$recommends,
                                               positive_outlook = d$positive_outlook,
                                               approves_of_CEO = d$approves_of_CEO,
                                               n_token = d$n_token,
                                               tss = d$tts))

save(GlassdoorCorpus, file = "000_data/Corpus.RData")
