## Caltech BBE faculty publication analysis
## Kristin A. Briney, 2020-05-06

## This code should be run after the BBEpubs_read.R script, as it doesn't reload the facPubs tibble
## It does some basic bibliographic analysis of journal titles by year and by faculty
## These summary tables currently only exist in the R environment and are not saved as .csv files
## This code can be expanded to do different and further analyses as needed



library(tidyverse)
library(stringr)
library(lubridate)
library(RefManageR)
library(jsonlite)




## Top titles of BBE faculty (2015-2020, with >= 10 publications per title)
topTitles <- group_by(facPubs, publication) %>% filter(date_type=="published", pubDate>=2015, pubDate<=2020) %>%
  mutate(total=n()) %>% select(publication, total) %>%
  unique() %>% filter(total>=10) %>% arrange(desc(total))

#ggplot(data=topTitles, mapping=aes(x=publication, y=total, label=publication)) +
#  theme_light() + 
#  coord_flip() +
#  theme(legend.position="none") +
#  geom_col(fill="#999999") + 
#  geom_text() +
#  labs(x="Publication", y="Number of Articles")




## Top titles by year (with >= 5 publications per title))
titlesByYear <- group_by(facPubs, publication, pubDate) %>% 
  filter(date_type=="published", pubDate>0) %>% mutate(total=n()) %>%
  select(publication, pubDate, total) %>%
  unique() %>% filter(total>=5) %>% arrange(desc(pubDate), desc(total))




## Top titles by faculty (2015-2020, with >= 2 publications per title)
topTitlesByFac <- group_by(facPubs, faculty, publication) %>% 
  filter(date_type=="published", pubDate>=2015, pubDate<=2020) %>%
  mutate(total=n()) %>% select(faculty, publication, total) %>%
  unique() %>% filter(total>=2) %>% arrange(faculty, desc(total), publication)




## Publication venues in rows by year in columns with article counts as data (2000-2019)
titleShift <- group_by(facPubs, publication, pubDate) %>% 
  filter(date_type=="published", pubDate>=2000, pubDate<2020) %>% mutate(total=n()) %>%
  select(publication, pubDate, total) %>%
  unique() %>% spread(pubDate, total)
