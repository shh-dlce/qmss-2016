# Description of file:
# Load data on grammatical properties of langauges, then test whether languages which are closer together geographically are also more similar in their grammar.

# Set working directory
setwd("~/Documents/Teaching/JenaSpringSchool/org/spring-school/IntroToR")

# Load libraries that we'll need
library(maps)
library(ecodist)
library(fields)

## PARAMETERS
# Should I use log distance?

useLogGeoDist <- TRUE


#########
# DATA
# load a data frame
d <- read.csv("data/WALS_WordOrder.csv", stringsAsFactors = F)

# What's in the data frame?
str(d)
table(d$BasicWordOrder)

####
# Make a matrix where each cell compares two languages.  Give a value of 0 if they're identical and a value of 1 otherwise.
basicWordOrderSimilarity <- outer(d$BasicWordOrder, d$BasicWordOrder, "!=")

# (convert the boolean values to a numeric matrix)
basicWordOrderSimilarity <- matrix(as.numeric(basicWordOrderSimilarity), nrow=nrow(basicWordOrderSimilarity))

# Create a distance object
basicWordOrderDist <- as.dist(basicWordOrderSimilarity)

####
# Calculate geographic distance between each language

geoDist <- as.dist(rdist.earth(cbind(d$longitude, d$latitude)))

# make it log distance (smoothed)
if(useLogGeoDist){
  geoDist <- log10(geoDist+1)
}

###
# TEST: are geo dist and syntactic dist correlated?
#   Using mantel test
ecodist::mantel(geoDist~basicWordOrderDist)


# r is positive and signficant: greater the distance, greater the difference in grammar.  However, the effect size is small.