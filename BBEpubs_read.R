## Caltech BBE faculty publication data scraping
## Kristin A. Briney, 2020-05-06

## This code scrapes faculty article lists in the JSON file format via Caltech Library Feeds
## (It only captures article, not other content types from CODA)
## It requires a csv list of all faculty CaltechAUTHOR IDs in the BBEfac.csv file to identify which authors to scrape
## The scraped article lists are saved as .json files in the /PubsList folder named with the relevant author IDs
## The individual publication lists are then combined into one large tibble, facPubs
## The data isn't 100% perfect in the facPubs tibble, mostly due to having different number of authors on each article



library(tidyverse)
library(stringr)
library(lubridate)
library(RefManageR)
library(jsonlite)



# Relevant file paths, change as necessary
fpath <- getwd()
fname <- "BBEfac.csv"
pubsFolder="/PubsList/"



# Read faculty CaltechAUTHORS handles
finput <- paste(fpath, fname, sep="/")
BBEfac <- read_csv(finput)



# Scrape Authors feeds for JSON and save locally
for (i in 1:dim(BBEfac)[1]) {
  fac <- as.character(slice(BBEfac,i))
  jsoninput <- paste("https://feeds.library.caltech.edu/people/", fac, "/article.json", sep="")
  bibinput <- paste(fpath, pubsFolder, fac, ".json", sep="")
  download.file(jsoninput,bibinput)
}



# Read in scrapped JSON files
fac <- as.character(slice(BBEfac,1))
bibinput <- paste(fpath, pubsFolder, fac, ".json", sep="")
facBib <- as_tibble(fromJSON(bibinput, flatten=TRUE))
facBib <- add_column(facBib, faculty=fac)
facPubs <- facBib

for (i in 2:dim(BBEfac)[1]) {
  fac <- as.character(slice(BBEfac,i))
  bibinput <- paste(fpath, pubsFolder, fac, ".json", sep="")
  facBib <- as_tibble(fromJSON(bibinput, flatten=TRUE))
  facBib <- add_column(facBib, faculty=fac)
  facPubs <- bind_rows(facPubs, facBib)
}



# Fix year formatting
facPubs <- mutate(facPubs, pubDate=year(as_date(date)))
