# PredictNextWord

library(dplyr)

# Load saved data
unigrams <- readRDS("unigrams.RData")
bigrams <- readRDS("bigrams.RData")
trigrams <- readRDS("trigrams.RData")
quadrigrams <- readRDS("quadrigrams.RData")
pentagrams <- readRDS("pentagrams.RData")
hexagrams <- readRDS("hexagrams.RData")

CleanInput <- function(inputwords) {
  inputwords <- tolower(inputwords)
  inputwords <- gsub("#|\\?|;|!|:|\\)|\\(|\\.|&|,", "", inputwords)
  inputwords <- trimws(inputwords)
  inputwords
}

PredictNextWord <- function(prevwords) {
  prevwords <- CleanInput(prevwords)
  startwords <- unlist(strsplit(prevwords, split = ' '))
  
  # last resort if no match found: predict the 5 most common unigrams
  prediction <- head(unigrams,5)
  prediction$Matched <- 0
    
  l <- length(startwords)
  if (l >= 5) {
      candidate <- hexagrams[hexagrams$Word5 == startwords[l] &
                             hexagrams$Word4 == startwords[l-1] & 
                             hexagrams$Word3 == startwords[l-2] & 
                             hexagrams$Word2 == startwords[l-3] & 
                             hexagrams$Word1 == startwords[l-4]
                               , c('Word6', 'Freq')]
      if (nrow(candidate) > 0) {
        candidate$Word <- candidate$Word6
        candidate$Word6 <- NULL
        candidate$Matched <- 5
        candidate <- head(candidate, 5)
        prediction <- rbind(prediction, candidate)
      }
  }
  if (l >= 4) {
    candidate <- pentagrams[pentagrams$Word4 == startwords[l] & 
                             pentagrams$Word3 == startwords[l-1] & 
                             pentagrams$Word2 == startwords[l-2] & 
                             pentagrams$Word1 == startwords[l-3]
                           , c('Word5', 'Freq')]
    if (nrow(candidate) > 0) {
      candidate$Word <- candidate$Word5
      candidate$Word5 <- NULL
      candidate$Matched <- 4
      candidate <- head(candidate, 5)
      prediction <- rbind(prediction, candidate)
    }
  }
  if (l >= 3) {
    candidate <- quadrigrams[quadrigrams$Word3 == startwords[l] & 
                             quadrigrams$Word2 == startwords[l-1] & 
                             quadrigrams$Word1 == startwords[l-2]
                           , c('Word4', 'Freq')]
    if (nrow(candidate) > 0) {
      candidate$Word <- candidate$Word4
      candidate$Word4 <- NULL
      candidate$Matched <- 3
      candidate <- head(candidate, 5)
      prediction <- rbind(prediction, candidate)
    }
  }
  if (l >= 2) {
    candidate <- trigrams[trigrams$Word2 == startwords[l] & 
                               trigrams$Word1 == startwords[l-1]
                             , c('Word3', 'Freq')]
    if (nrow(candidate) > 0) {
      candidate$Word <- candidate$Word3
      candidate$Word3 <- NULL
      candidate$Matched <- 2
      candidate <- head(candidate, 5)
      prediction <- rbind(prediction, candidate)
    }
  }
  if (l >= 1) {
    candidate <- bigrams[bigrams$Word1 == startwords[l]
                          , c('Word2', 'Freq')]
    if (nrow(candidate) > 0) {
      candidate$Word <- candidate$Word2
      candidate$Word2 <- NULL
      candidate$Matched <- 1
      candidate <- head(candidate, 5)
      prediction <- rbind(prediction, candidate)
    }
  }
  prediction %>% arrange(-Matched, -Freq) %>% group_by(Word) %>% summarise(Matched = max(Matched), Freq = first(Freq)) %>% arrange(-Matched, -Freq) %>% select(Word) %>% head(5) %>% unlist()
}

