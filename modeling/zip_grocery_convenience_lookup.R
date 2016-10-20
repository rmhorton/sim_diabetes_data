# Look up convenience store/grocery store ratio by zipcode
dataset1 <- maml.mapInputPort(1) # class: data.frame

# Contents of Zip port are in ./src/
cg <- read.csv("src/zip_grocery_convenience.csv")
rownames(cg) <- sprintf("%05d", cg$zip)

dataset1$cg_ratio <- cg[sprintf("%05d", dataset1$zipcode), "ratio"]

maml.mapOutputPort("dataset1");