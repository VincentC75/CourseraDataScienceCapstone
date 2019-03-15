# This files produces the datasets used by the Shiny application for prediction.

# Download base dataset
DataURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
DataFile <- "Coursera-SwiftKey.zip"
if (!file.exists(DataFile)) {
  download.file(DataURL, destfile = DataFile)
  unzip(DataFile)
}

# Load english data
en_blog <- readLines("final/en_US/en_US.blogs.txt", encoding="UTF-8")
en_news <- readLines("final/en_US/en_US.news.txt", encoding="UTF-8")
en_twitter <- readLines("final/en_US/en_US.twitter.txt", encoding="UTF-8", skipNul = TRUE)
en_text <- c(en_blog, en_twitter, en_news)
rm(en_blog, en_twitter, en_news)

# Build corpus
library(quanteda)
library(dplyr)
en_corpus <- corpus(en_text)


# Unigrams
unigrams <- dfm(en_corpus, ngrams = 1, concatenator = " ",remove_punct=TRUE, tolower=TRUE, remove_twitter=TRUE)
unigrams <- as.data.frame(as.matrix(docfreq(unigrams)))
names(unigrams) <- c("Freq")
unigrams$word <- rownames(unigrams)
unigrams <- unigrams %>% arrange(-Freq) %>% filter(Freq > 50)
saveRDS(unigrams,"unigrams.RData")
rm(unigrams)

# Bigrams
bigrams <- dfm(en_corpus, ngrams = 2, concatenator = " ",remove_punct=TRUE, tolower=TRUE, remove_twitter=TRUE)
bigrams <- as.data.frame(as.matrix(docfreq(bigrams)))
names(bigrams) <- c("Freq")
bigrams$word <- rownames(bigrams)
bigrams <- bigrams %>% arrange(-Freq) %>% filter(Freq > 50)
saveRDS(bigrams,"bigrams.RData")
rm(bigrams)

# Trigrams
trigrams <- dfm(en_corpus, ngrams = 3, concatenator = " ",remove_punct=TRUE, tolower=TRUE, remove_twitter=TRUE)
trigrams <- as.data.frame(as.matrix(docfreq(trigrams)))
names(trigrams) <- c("Freq")
trigrams$word <- rownames(trigrams)
trigrams <- trigrams %>% arrange(-Freq) %>% filter(Freq > 50)
saveRDS(trigrams,"trigrams.RData")
rm(trigrams)
