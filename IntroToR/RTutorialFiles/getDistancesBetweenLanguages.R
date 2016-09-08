library(fields)
setwd("~/Documents/Teaching/JenaSpringSchool/org/qmss-2016/IntroToR/")

# this file is from http://glottolog.org/static/download/glottolog-languoid.csv.zip
d = read.csv("data/languoid.csv", stringsAsFactors = F)

# get rid of languaages without lat/long
d = d[!is.na(d$latitude),]
# get rid of families
d = d[d$level=="language",]

d = d[,c("id",'longitude','latitude')]

d = rbind(d,
        data.frame(id='wels1726',longitude=0.05, latitude=38)
  )


# rdist.earth help file says we need a matrix of two columns - the first is longitude and the second is latitude
latLong = d[,c("longitude","latitude")]

glotto.dist = rdist.earth(latLong, miles=F)
rownames(glotto.dist) = d$id
colnames(glotto.dist) = d$id


# number of languages within 50km
withinkm = 50
numWithin = apply(glotto.dist, 1, function(X){sum(X < withinkm)-1})

res = data.frame(glotto=colnames(glotto.dist), numWithin = numWithin)


myLangs = c("wels1247",'corn1251','iris1253', 'scot1245','manx1243', 'hibe1235')

res = res[res$glotto %in% myLangs,]

celt = glotto.dist[myLangs,myLangs]

library(mcclust)
hc = hclust(as.dist(celt))
plot(hc)
