##source: http://www.stat.berkeley.edu/classes/s133/Nclass2.html
##source: https://rpubs.com/ryankelly/LDA-QDA
library(MASS)
library(klaR)
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

# run wilkes lambda stepwise variable selection
VariableSelect <- greedy.wilks(diagnosis ~  radius_mean  + 
                                 texture_mean            + 
                                 perimeter_mean          + 
                                 area_mean               + 
                                 smoothness_mean         + 
                                 compactness_mean        +
                                 concavity_mean          +
                                 concave.points_mean     +
                                 symmetry_mean           +
                                 fractal_dimension_mean  +
                                 radius_se               +
                                 texture_se              +
                                 perimeter_se            +
                                 area_se                 +
                                 smoothness_se           +
                                 compactness_se          +
                                 concavity_se            +
                                 concave.points_se       +
                                 symmetry_se             +
                                 fractal_dimension_se    +
                                 radius_worst            +
                                 texture_worst           +
                                 perimeter_worst         +
                                 area_worst              +
                                 smoothness_worst        +
                                 compactness_worst       +
                                 concavity_worst         +
                                 concave.points_worst    +
                                 symmetry_worst          +
                                 fractal_dimension_worst
                               ,data = cancerdata.raw
                               ,niveau = 0.05)

##run LDA
lda.fit <- lda(VariableSelect$formula, data=train)
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
qda.fit <- qda(VariableSelect$formula, data=train)
qda.fit

##predict class
qda.class <- predict(qda.fit, test)$class
table(qda.class, test$diagnosis)

##test for accuracy
mean(qda.class == test$diagnosis)

modelFitQDA <- train(VariableSelect$formula, method='qda', c('scale', 'center'), data=train)
modelFitQDA

modelFitLDA <- train(VariableSelect$formula, method='lda', c('scale', 'center'), data=train)
modelFitLDA

confusionMatrix(test$diagnosis, predict(modelFitQDA, test))
confusionMatrix(test$diagnosis, predict(modelFitLDA, test))


##visualize the Raw Diagnosis
plot(test$diagnosis)
##visualize the lda and qda predicted data
plot(lda.predict$class)
plot(qda.class) ##qda graph - what does it mean




##plot lda and qda - incomplete - work in progress!!
require(ggplot2)
require(scales)
require(gridExtra)

lda <- lda(VariableSelect$formula, train)
prop.lda = lda$svd^2 / sum(lda$svd^2)
plda <- predict(object = lda, newdata = test)

qda <- qda(VariableSelect$formula, train)
prop.qda = qda$svd^2 / sum(qda$svd^2)
pqda <- predict (object = qda, newdata = test)
