##source: http://www.stat.berkeley.edu/classes/s133/Nclass2.html
##source: https://rpubs.com/ryankelly/LDA-QDA
library(MASS)
library(caret)
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

##QDA
qda.fit <- qda(diagnosis~ ., data=train)
qda.fit

##predict class
qda.class <- predict(qda.fit, test)$class
table(qda.class, test$diagnosis)

##test for accuracy
mean(qda.class == test$diagnosis)

modelFitQDA <- train(diagnosis~ ., method='qda', c('scale', 'center'), data=train)
modelFitQDA

modelFitLDA <- train(diagnosis~ ., method='lda', c('scale', 'center'), data=train)
modelFitLDA

confusionMatrix(test$diagnosis, predict(modelFitQDA, test))
confusionMatrix(test$diagnosis, predict(modelFitLDA, test))

##visualize the lda and qda data
plot(lda.class)
plot(qda.class) ##qda graph - what does it mean




##plot lda and qda - incomplete - work in progress!!
require(ggplot2)
require(scales)
require(gridExtra)

lda <- lda(diagnosis~ ., train)
prop.lda = lda$svd^2 / sum(lda$svd^2)
plda <- predict(object = lda, newdata = test)

qda <- qda(diagnosis~ ., train)
prop.qda = qda$svd^2 / sum(qda$svd^2)
pqda <- predict (object = qda, newdata = test)
