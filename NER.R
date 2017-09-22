library(rJava)
install.packages(c("NLP", "openNLP", "RWeka", "qdap"))
install.packages("openNLPmodels.en",repos = "http://datacube.wu.ac.at/",type = "source")


library(NLP)
library(openNLP)
library(RWeka)
library(magrittr)

#Induvidual lines in multiple vectors
gandhi <- readLines("C:\\idio\\gandhi.txt")
print(gandhi)

# All to a single vector
gandhi <- paste(gandhi, collapse = " ")
print(gandhi)

#Covert to a Sting(class)
gandhi <- as.String(gandhi)

#Mark whare words & setences start & end.
word_ann <- Maxent_Word_Token_Annotator()
sent_ann <- Maxent_Sent_Token_Annotator()

# DEtermine where sentences are and then where words are using annotate()
gandhi_annotations <- annotate(gandhi, list(sent_ann, word_ann))

class(gandhi_annotations)
head(gandhi_annotations)

#Create an annotated plain text document
gandhi_doc <- AnnotatedPlainTextDocument(gandhi, gandhi_annotations)

#Get words or senetnces using 
sents(gandhi_doc)
words(gandhi_doc)

# or as plain text
as.character(gandhi_doc)

# named entity recognition (NER) ("date", "location", "money", "organization", "percentage", "person", "misc")
person_ann <- Maxent_Entity_Annotator(kind = "person")
location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")

# Use annotate to extract all the following
pipeline <- list(sent_ann,
                 word_ann,
                 person_ann,
                 location_ann,
                 organization_ann)
gandhi_annotations <- annotate(gandhi, pipeline)
gandhi_doc <- AnnotatedPlainTextDocument(gandhi, gandhi_annotations)

# function to Extract entities from an AnnotatedPlainTextDocument
entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}

entities(gandhi_doc, kind = "person")
entities(gandhi_doc, kind = "location")
entities(gandhi_doc, kind = "organization")

#NERD API
