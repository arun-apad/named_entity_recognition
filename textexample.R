install.packages("tm")
library("tm")


my.corpus <- Corpus(DirSource("C:\\idio\\speech\\"))


#Transformations
my.corpus <- tm_map(my.corpus, removePunctuation)

#Removing stopwords
my.corpus <- tm_map(my.corpus, removeWords, stopwords("english"))


#Removing stopwords of your choice
# my.stops <- c("history","clio", "programming")
# my.corpus <- tm_map(my.corpus, removeWords, my.stops)
# my.list <- unlist(read.table("PATH TO STOPWORD FILE", stringsAsFactors=FALSE)
#                   my.stops <- c(my.list)
#                   my.corpus <- tm_map(my.corpus, removeWords, my.stops)



# lemmatizing/ group together variant forms of same word
install.packages("Snowball")
require("Snowball")
my.corpus <- tm_map(my.corpus, stemDocument)

# Create a term document matrix
my.tdm <- TermDocumentMatrix(my.corpus)
inspect(my.tdm)

# Create Document term Matrix
my.dtm <- DocumentTermMatrix(my.corpus, control = list(weighting = weightTfIdf, stopwords = TRUE))
inspect(my.dtm)


#Finding frequent terms
findFreqTerms(my.tdm, 2)

#inspect word associations, in this case with a minimum threshold of .20:
findAssocs(my.tdm, 'war', 0.20)

#Visual relationships
my.df <- as.data.frame(inspect(my.tdm))
my.df.scale <- scale(my.df)
d <- dist(my.df.scale,method="euclidean")
fit <- hclust(d, method="ward.D")
plot(fit)


my.df <- as.data.frame(inspect(my.dtm))
my.df.scale <- scale(my.df)
d <- dist(my.df.scale,method="euclidean")
fit <- hclust(d, method="ward.D")
plot(fit)

