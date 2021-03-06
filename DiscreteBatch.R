#You can use code you wrote for the correlation exercise here.
source("~/phyloMeth.packages/DiscreteTraits/DiscreteFunctions.R")
tree <- read.tree("~/R/Vascular_Plants_rooted.dated.tre")
#discrete.data <- read.csv(file="~/Documents/Data/sample.binary.data", stringsAsFactors=FALSE, row.names=1) #death to factors.

ploidy.data <- read.csv(file="~/Documents/Data/ploidy.data.txt", stringsAsFactors=FALSE, row.names=1)
cleaned.discrete <- CleanData(tree, ploidy.data, sort=TRUE)


VisualizeData(rand.tree, cleaned.discrete)

#First, let's use parsimony to look at ancestral states

cleaned.discrete.phyDat <- phyDat(cleaned.discrete$data, type="USER", levels=c("2","4","6","8","12")) #phyDat is a data format used by phangorn
anc.p <- ancestral.pars(tree, cleaned.discrete.phyDat)
plotAnc(tree, anc.p, 1)
#save the data file as an R data object
#Do you see any uncertainty? What does that mean for parsimony?

#now plot the likelihood reconstruction
anc.ml <- ancestral.pml(pml(tree, cleaned.discrete.phyDat), type="ml")
plotAnc(tree, anc.ml, 1)

#How does this differ from parsimony? 
#Why does it differ from parsimony?
#What does uncertainty mean?

#How many changes are there in your trait under parsimony? 
parsimony.score <- ____some_function_____(tree, cleanded.discrete.phyDat)
print(parsimony.score)

#Can you estimate the number of changes under a likelihood-based model? 

#Well, we could look at branches where the reconstructed state changed from one end to the other. But that's not really a great approach: at best, it will underestimate the number of changes (we could have a change on a branch, then a change back, for example). A better approach is to use stochastic character mapping.

estimated.histories <- make.simmap(tree, cleaned.discrete, model="ARD", nsim=5)

#always look to see if it seems reasonable
plotSimmap(estimated.histories)

counts <- countSimmap(estimated.histories)
print(counts)

#Depending on your biological question, investigate additional approaches:
#  As in the correlation week, where hypotheses were examined by constraining rate matrices, one can constrain rates to examine hypotheses. corHMM, ape, and other packages have ways to address this.
#  Rates change over time, and this could be relevant to a biological question: have rates sped up post KT, for example. Look at the models in geiger for ways to do this.
#  You might observe rates for one trait but it could be affected by some other trait: you only evolve wings once on land, for example. corHMM can help investigate this.