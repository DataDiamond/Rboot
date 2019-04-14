##### A24 - Topic Modeling
### US & Australian Constitutions


########## Libraries
library(koRpus)      # for readability analysis
#install.packages("koRpus.lang.en")
library(koRpus.lang.en)
#install.packages("readtext")
library(readtext)   # for reading in document
library(tidyverse)
library(stringr)
#install.packages("tm")
library(tm) #for text mining
#install.packages("SnowballC") #-- needed for stemming
library(SnowballC)

###################### Data Reading and Cleaning ###################
USurl<-"http://www.richardtwatson.com/data/USConstitution.txt"
USConst<-readtext(USurl)[,-1]

AUSurl<-"http://www.richardtwatson.com/data/AustralianConstitution.txt"
AUSConst<-readtext(AUSurl)[,-1]

##### Unites States Cleaning
USConst_split<-str_split(USConst, "\n")[[1]]
USConst_split<-USConst_split[USConst_split != USConst_split[2]]

USC_corpus<-Corpus(VectorSource(USConst_split))

##### Australia Cleaning
AUSC_split<-str_split(AUSConst, "\n")[[1]]

AUSC_corpus<-Corpus(VectorSource(AUSC_split))

######################## Pre-Processing #############################

##### United States
# convert to lower
clean.USC <-  tm_map(USC_corpus, content_transformer(tolower))
# remove punctuation
clean.USC <- tm_map(clean.USC,content_transformer(removePunctuation))
# remove numbers
clean.USC <-  tm_map(clean.USC,content_transformer(removeNumbers))
# remove stop words 
clean.USC <-  tm_map(clean.USC,removeWords,stopwords('SMART'))
# strip extra white space
clean.USC <-  tm_map(clean.USC,content_transformer(stripWhitespace))


clean.USC[["46"]][["content"]]

##### Australia
clean.AUSC <- tm_map(AUSC_corpus, content_transformer(tolower))
clean.AUSC <- tm_map(clean.AUSC,content_transformer(removePunctuation))
clean.AUSC <- tm_map(clean.AUSC,content_transformer(removeNumbers))
clean.AUSC <- tm_map(clean.AUSC,removeWords,stopwords('SMART'))
clean.AUSC <- tm_map(clean.AUSC,content_transformer(stripWhitespace))

clean.AUSC[["23"]][["content"]]

################## Stemming & Stem Completion ######################

##### United States
### Stemming and producing Term Document Matrix
stem.USC<-tm_map(clean.USC,stemDocument,
                     language = "english")

USC_frequencies<-TermDocumentMatrix(stem.USC,
                                    control=list(minWordLength=3))
### Stem Completing
USC_frequencies.stem<-stemCompletion(rownames(USC_frequencies),
                                     dictionary=clean.USC,
                                     type=c("prevalent"))
rownames(USC_frequencies) <- as.vector(USC_frequencies.stem) # change to stem completed row names


##### Australia
stem.AUSC<-tm_map(clean.AUSC,stemDocument,
                 language = "english")
AUSC_frequencies<-TermDocumentMatrix(stem.AUSC,
                                    control=list(minWordLength=3))
AUSC_frequencies.stem<-stemCompletion(rownames(AUSC_frequencies),
                                     dictionary=clean.AUSC,
                                     type=c("prevalent"))
rownames(AUSC_frequencies) <- as.vector(AUSC_frequencies.stem)


###################### Frequency Calculation ########################
i = 40
k=10
while (i>10) {
  USMostFrequentWords<-findFreqTerms(USC_frequencies, lowfreq = k, highfreq = Inf)
  k=k+1
  print(length(USMostFrequentWords))
  i = length(USMostFrequentWords)
}

i = 40
k=10
while (i>10) {
  AUSMostFrequentWords<-findFreqTerms(AUSC_frequencies, lowfreq = k, highfreq = Inf)
  k=k+1
  print(length(AUSMostFrequentWords))
  i = length(AUSMostFrequentWords)
}


####################### Printing Solution ##########################

paste(c("The 10 most frequent words in the US Constitution are:",
        USMostFrequentWords), collapse=" ")

paste(c("The 10 most frequent words in the Australian Constitution are:",
        AUSMostFrequentWords), collapse=" ")
