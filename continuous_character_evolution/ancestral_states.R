################### ancestral state estimatuion with ape ##################
#################3############# QMSS ######################################
########## Max Planck Institute for the Science of Human History ##########
########################### 13-18 05 2016 #################################
######################### Annemarie Verkerk ###############################

# In this tutorial we will estimate ancestral states for a tiny subset of the languages
# included in PHOIBLE: the Indo-European languages. We'll look at consonants, but could
# also look at the number of vowels.

# First, set your working directory to point to the folder where this script resides. 

# Next, let's load some packages we will need.

library(ape) # ace
library(phytools) # read.newick

# Next, let's read in the PHOIBLE data.

phoible_IE <- read.csv(file = "PHOIBLE_IE.txt", sep = "\t")

# Next, let's read in the IE tree.

IE_tree <- read.newick(file = "glottolog_IE.tree")

# What does R have to say about it?

IE_tree

# Let's do an ancestral state estimation!

ASE <- ace(x = phoible_IE$Consonants, phy = IE_tree, method = "ML")

# what is the output?

ASE

# a simple plot of the results

plot.phylo(IE_tree, label.offset = 2)
tiplabels(phoible_IE$Consonants, width = 0.5)
nodelabels(round(ASE$ace, 0), width = 0.5)

#   BONUS TIME   #
# What are the ASEs for the other two variables, no. of Vowels & no. of tones?
# Look at other models covered by ace(), do the ASEs differ very much from those estimated
# using Schluter et al.'s (1997) ML?