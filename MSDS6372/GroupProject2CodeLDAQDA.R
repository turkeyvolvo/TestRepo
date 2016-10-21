##source: http://www.stat.berkeley.edu/classes/s133/Nclass2.html
##source: https://rpubs.com/ryankelly/LDA-QDA
library(MASS)
library(klaR)
library(caret)
library(formattable)

cancerdata.raw <- read.csv("cancerdata.csv", header = TRUE)

##or you can use ...
##cancerdata.raw <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data", header = FALSE, sep=",")
##check out the data
summary(cancerdata.raw)
str(cancerdata.raw)

# Split data into testing and training 50/50 split of original dataset
train <- cancerdata.raw[sample(nrow(cancerdata.raw), round(nrow(cancerdata.raw)/2 ,0)), ]

testRows <- !(cancerdata.raw$id %in% train$id)
test <- cancerdata.raw[testRows,]



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
                               ,data = train
                               ,niveau = 0.05)

##LDA fit
lda.fit <- lda(VariableSelect$formula, data=train)
lda.fit
lda.predict <- predict(lda.fit, data=test)

## predict class
lda.class <- predict(lda.fit, test)$class

##see what's available from the predict call
names(lda.predict)

##table the results of the predictions compared to the real diagnoses
table(lda.class, test$diagnosis)
LDA.Accuracy <- mean(lda.class==test$diagnosis)

#use a different threshold of 90%
sum(lda.predict$posterior[,1]>0.9)

##QDA
qda.fit <- qda(VariableSelect$formula, data=train)
qda.fit

##predict class
qda.class <- predict(qda.fit, test)$class
table(qda.class, test$diagnosis)

##test for accuracy
QDA.Accuracy <- mean(qda.class == test$diagnosis)

modelFitQDA <- train(VariableSelect$formula, method='qda', c('scale', 'center'), data=train)
modelFitQDA

modelFitLDA <- train(VariableSelect$formula, method='lda', c('scale', 'center'), data=train)
modelFitLDA

confusionMatrix(test$diagnosis, predict(modelFitQDA, test))
confusionMatrix(test$diagnosis, predict(modelFitLDA, test))


par(mfcol=c(1, 3))

##visualize the Raw Diagnosis
plot(test$diagnosis, main = "Original Test Data")
##visualize the lda and qda predicted data
plot(lda.class, main = "Predicted LDA Test Data")
plot(qda.class, main = "Predicted QDA Test Data") ##qda graph - what does it mean

formattable(as.data.frame(cbind(LDA.Accuracy,QDA.Accuracy)))


########## LDA/QDA on full dataset ###########
##LDA fit
ldaraw.fit <- lda(VariableSelect$formula, data=cancerdata.raw)

## predict class
ldaraw.class <- predict(ldaraw.fit, cancerdata.raw)$class

##table the results of the predictions compared to the real diagnoses
LDAraw.Accuracy <- mean(ldaraw.class==cancerdata.raw$diagnosis)

##QDA
qdaraw.fit <- qda(VariableSelect$formula, data=cancerdata.raw)

##predict class
qdaraw.class <- predict(qdaraw.fit, cancerdata.raw)$class

##test for accuracy
QDAraw.Accuracy <- mean(qdaraw.class == cancerdata.raw$diagnosis)


##visualize the Raw Diagnosis
plot(cancerdata.raw$diagnosis, main = "Original Raw Test Data")

##visualize the lda and qda predicted data
plot(ldaraw.class, main = "Predicted Raw LDA Test Data")
plot(qdaraw.class, main = "Predicted Raw QDA Test Data") ##qda graph - what does it mean

formattable(as.data.frame(cbind(LDAraw.Accuracy,QDAraw.Accuracy)))

table(cancerdata.raw$diagnosis)
table(ldaraw.class)
table(qdaraw.class)

##############################################



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
