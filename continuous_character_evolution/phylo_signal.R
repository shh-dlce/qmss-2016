################ phylogenetic signal estimation with lambda ###############
#################3############# QMSS ######################################
########## Max Planck Institute for the Science of Human History ##########
########################### 13-18 05 2016 #################################
######################### Annemarie Verkerk ###############################

# In this tutorial we will fit lambda to a linguistic dataset in order to test whether that dataset
# has phylogenetic signal. The dataset is data on the number of vowels, consonants, and tones taken
# from PHOIBLE (http://phoible.org/). The tree is a star tree of all the languages (not 
# dialects/varieties) included in glottolog (made with the help of Robert Forkel) (http://glottolog.org/).

# In the folder with all the materials, I have included the un-pruned star tree including 
# over 7000 languages for you to play with.

# First, set your working directory to point to the folder where this script resides. 

# Next, let's load some packages we will need.

library(phytools) # read.newick
library(geiger) # fitContinuous

# Next, let's read in the PHOIBLE data.This is a slightly cleaned dataset, I have removed
# two duplicates and some outliers, and added the language names that appear in the tree. 
# The original PHOIBLE dataset is included in the materials folder ("phoible-aggregated.txt").

phoible_all <- read.csv("PHOIBLE_cleaned_with_tree_names.txt", header = TRUE, na.strings=c("", "NA"), sep = "\t")

# Let's have a look at the number of consonants and vowels.

plot(phoible_all$Consonants,phoible_all$Vowels)

# Next, let's read in the big tree - this may take a few seconds.

glottolog_full_tree <- read.newick(file = "glottolog_full_tree_pruned.tree")

# What does R have to say about it?

glottolog_full_tree

# Should read:
# Phylogenetic tree with 382 tips and 381 internal nodes.
# Tip labels:
#  'Chimborazo_Highland_Quichua_[chim1302][qug]', 'Salasaca_Highland_Quichua_[sala1272][qxl]', 'Jauja_Wanca_Quechua_[jauj1238][qxw]', 'Huamalíes-Dos_de_Mayo_Huánuco_Quechua_[huam1248][qvh]', 'Huaylas_Ancash_Quechua_[huay1240][qwh]', 'Arhuaco_[arhu1242][arh]', ...
# Rooted; includes branch lengths.

####### and now for some analysis ########

# Make a named data vector as required by fitContinuous

consonants <- phoible_all$Consonants 
names(consonants) <- phoible_all$TreeName

# Let's compare two models: one in which the model is set to Brownian motion (default)
# and one in which we optimize lambda

mod_l_1 <- fitContinuous(phy = glottolog_full_tree, dat = consonants, model = "BM")

mod_l_est <- fitContinuous(phy = glottolog_full_tree, dat = consonants, model = "lambda")

# Let's have a look at the output of the Brownian motion model:

mod_l_1

# This should look like:
# GEIGER-fitted comparative model of continuous data
# fitted ‘BM’ model parameters:
#  sigsq = 9.725942
# z0 = 21.307663

# model summary:
#  log-likelihood = -1420.047053
# AIC = 2844.094107
# AICc = 2844.125769
# free parameters = 2

# sigsq is the sigma squared, the rate of evolution, and z0 is the inferred root state. You can see that
# proto-World is estimated to have had 21.3 consonants ;).

# and:

mod_l_est

# estimated lambda is about 0.457977

# When we compare the likelihoods:

mod_l_1$opt$lnL
# [1] -1420.047
mod_l_est$opt$lnL
# [1] -1297.024

# It is clear that optimizing lambda, and just improving the fit of the tree to the data, is a major
# improvement in likelihood terms.

# We can do a likelihood ratio test to see whether the difference is statistically significant. 

LR <- 2 * (logLik(mod_l_est) - logLik(mod_l_1))
LR 
# [1] 246.0459

P <- pchisq(LR, df = mod_l_est$opt$k - mod_l_1$opt$k, lower.tail = FALSE)
P
# [1] 1.890182e-55

# that's a pretty low p value! These results indicate that although there is phylogenetic signal 
# in the number of consonants value, it doesn't evolve strictly in a Brownian motion sense. 

# Of course, this analysis should be done properly, with a far higher number of ML iterations, preferably
# even with Bayesian methods. But you have an idea of what to do now.

#   BONUS TIME   #
# What is the lambda of the other two measures (no. of vowels, no. of tones) in PHOIBLE?