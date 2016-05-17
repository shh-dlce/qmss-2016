#################### correlation of continuous variables ##################
#################3############# QMSS ######################################
########## Max Planck Institute for the Science of Human History ##########
########################### 13-18 05 2016 #################################
######################### Annemarie Verkerk ###############################

# First, set your working directory to point to the folder where this script resides. 

# Next, let's load some packages we will need.

library(caper) # pgls
library(phytools) # read.newick

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

res <- lm(Consonants ~ Vowels, data = phoible_all)
summary(res)

# there is a significant relation between no. of consonants and no. of vowels;
# such that if a language has more consonants it also tends to have more vowels.

# will this correlation hold if we correct for phylogeny?

compa_data <- comparative.data(glottolog_full_tree, phoible_all, names.col = TreeName)

res <- pgls(Consonants ~ Vowels, compa_data, lambda = "ML") # this may take 30 seconds or so
summary(res)

# As you can see, the correlation disappears when we correct for phylogeny. 
# lambda is definitely not 0 - it is not 1 either, looking at the tests for 
# significance.

# The correlation between no. of Consonants and no. of Vowels found earlier
# seems to have been due to related languages having similar phoneme inventories.

#   BONUS TIME   #
# Is there a correlation between no. of Vowels & no. of tones?
# Hypothesis: if you have tones, you need less vowels...
