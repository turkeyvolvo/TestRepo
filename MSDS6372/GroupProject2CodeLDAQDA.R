library(MASS)
cancerdata.raw <- read.csv("cancerdata.csv", header = TRUE)
##or you can use ...
##cancerdata.raw <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data", header = FALSE, sep=",")
##check out the data
summary(cancerdata.raw)
str(cancerdata.raw)

# Split data into testing and training
train <- cancerdata.raw[2:285,]
test <- cancerdata.raw[286:569,]

##run LDA
lda.fit <- lda(diagnosis~ ., data=train)
lda.fit
lda.predict <- predict(lda.fit, data=test)

##see what's available from the predict call
names(lda.predict)

##table the results of the predictions compared to the real diagnoses
table(lda.predict$class, test$diagnosis)
mean(lda.predict$class==test$diagnosis)

#use a different threshold of 90%
sum(lda.predict$posterior[,1]>0.9)
