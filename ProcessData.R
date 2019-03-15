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
library(tidyr)
en_corpus <- corpus(en_text)


# Unigrams
unigrams <- dfm(en_corpus, ngrams = 1, concatenator = " ",remove_punct=TRUE, tolower=TRUE, remove_twitter=TRUE)
unigrams <- as.data.frame(as.matrix(docfreq(unigrams)))
names(unigrams) <- c("Freq")
unigrams$word <- rownames(unigrams)
unigrams <- unigrams %>% arrange(-Freq) %>% filter(Freq > 5)
saveRDS(unigrams,"unigrams.RData")
rm(unigrams)

# Bigrams
bigrams <- dfm(en_corpus, ngrams = 2, concatenator = " ",remove_punct=TRUE, tolower=TRUE, remove_twitter=TRUE)
bigrams <- as.data.frame(as.matrix(docfreq(bigrams)))
names(bigrams) <- c("Freq")
bigrams$words <- rownames(bigrams)
bigrams <- bigrams %>% separate(words, c("Word1", "Word2"), ' ')
bigrams <- bigrams %>% arrange(-Freq) %>% filter(Freq > 5)
saveRDS(bigrams,"bigrams.RData")
rm(bigrams)

# Trigrams
# All data cannot be used for trigrams, a sample must be used instead of the entire dataset
set.seed(1971)
en_corpus_sampled <- corpus(sample(en_text, length(en_text) * 0.3))
trigrams <- dfm(en_corpus_sampled, ngrams = 3, concatenator = " ",remove_punct=TRUE, tolower=TRUE, remove_twitter=TRUE)
trigrams <- as.data.frame(as.matrix(docfreq(trigrams)))
names(trigrams) <- c("Freq")
trigrams$words <- rownames(trigrams)
trigrams <- trigrams %>% arrange(-Freq) %>% filter(Freq > 5)
trigrams <- trigrams %>% separate(words, c("Word1", "Word2", "Word3"), ' ')
saveRDS(trigrams,"trigrams.RData")
rm(trigrams)

# Quadrigrams
quadrigrams <- dfm(en_corpus_sampled, ngrams = 4, concatenator = " ",remove_punct=TRUE, tolower=TRUE, remove_twitter=TRUE)
quadrigrams <- as.data.frame(as.matrix(docfreq(quadrigrams)))
names(quadrigrams) <- c("Freq")
quadrigrams$words <- rownames(quadrigrams)
quadrigrams <- quadrigrams %>% arrange(-Freq) %>% filter(Freq > 5)
quadrigrams <- quadrigrams %>% separate(words, c("Word1", "Word2", "Word3", "Word4"), ' ')
saveRDS(quadrigrams,"quadrigrams.RData")
rm(quadrigrams)

# Pentagrams
pentagrams <- dfm(en_corpus_sampled, ngrams = 5, concatenator = " ",remove_punct=TRUE, tolower=TRUE, remove_twitter=TRUE)
pentagrams <- as.data.frame(as.matrix(docfreq(pentagrams)))
names(pentagrams) <- c("Freq")
pentagrams$words <- rownames(pentagrams)
pentagrams <- pentagrams %>% arrange(-Freq) %>% filter(Freq > 5)
pentagrams <- pentagrams %>% separate(words, c("Word1", "Word2", "Word3", "Word4", "Word5"), ' ')
saveRDS(pentagrams,"pentagrams.RData")
rm(pentagrams)


# Load saved data
rm(en_corpus)
rm(en_corpus_sampled)
unigrams <- readRDS("unigrams.RData")
bigrams <- readRDS("bigrams.RData")
trigrams <- readRDS("trigrams.RData")
quadrigrams <- readRDS("quadrigrams.RData")
pentaframs <- readRDS("pentagrams.RData")