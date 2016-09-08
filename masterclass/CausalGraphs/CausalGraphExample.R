library(pcalg)

# We'll use the Iris data in R

d = iris[,!names(iris) %in% c("Species")]
d = swiss

# List of sufficient statistics
suffStat <- list(C=cor(d),n=nrow(d))

pc.fit <- pc(suffStat, indepTest = gaussCItest , labels=names(d),alpha = 0.05) 
plot(pc.fit)

# Convert everything to a factor

d2 = swiss

num.cuts = 2

for(i in 1:ncol(d2)){
  # cut factor by quantile
  if(!is.factor(d2[,i])){
    quantiles = unique(quantile(d2[,i],seq(0,1,1/num.cuts)))
    # (we take away 1 so the numbers are 0 or 1)
    d2[,i] = as.numeric(cut(d2[,i],quantiles)) -1 
  }
}

d2 = d2[complete.cases(d2),]

# get number of levels in each
nlev = apply(d2,2,function(X){length(levels(factor(X)))})
suffStat <- list(dm=d2,nlev=nlev,adaptDF=F)

# Make a causal graph
# note that we've increased alpha so that the tests are less conservative and we see some structure.  This should usually be set to 0.05
pc.fit <- pc(suffStat, indepTest = disCItest, p = ncol(d2), alpha = 0.5) 
# Plot the causal graph
plot(pc.fit,labels=names(d2))
