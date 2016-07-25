#Forecasting work
# Forecasting models with smoothing and related approaches
#Exponential Smoothing uses past values to calculate a forecast. 
#The strength with which each value influences the forecast is 
#weakened with help of a smoothing parameter. Thus we are dealing 
#with a weighted average, whose values fade out the longer ago 
#they were in the past. 

#The Akaike's Information Criterion(AIC/AICc) or the 
#Bayesian Information Criterion (BIC) should be at minimum.


## Simple expontential smoothing 
par(mfrow=c(1,1))
Model_ses <- ses(WugeAsIs, h=12)
summary(Model_ses)
plot(Model_ses, plot.conf=FALSE, ylab="Wuge Exports Chulwalar", xlab="Year", main="", fcol="white", type="o")
lines(fitted(Model_ses), col="green", type="o")
lines(Model_ses$mean, col="blue", type="o")
legend("topleft",lty=1, col=c(1,"green"), c("data", expression(alpha == 0.497)),pch=1)

## Holt's linear trend method   
# Holt added to the model in order to forecast using trends as well. 
# For this it is necessary to add a beta, which determines the trend. 
# If neither alpha nor beta is stated, both parameters will be optimised 
# using ets(). The trend is exponential if the intercepts(level) and the 
# gradient (slope) are multiplied with eachother. The values are worse. As
# the Beta was very low in the optimisation, the forecast is very similar 
# to the ses() model. 

Model_holt_1 <- holt(WugeAsIs,h=12)
summary(Model_holt_1)
plot(Model_holt_1)


# expoential trend

Model_holt_2<- holt(WugeAsIs, exponential=TRUE,h=12)
summary(Model_holt_2)
plot(Model_holt_2)


## Dampened trends
# As such simple trends tend to forecast the future too positively, we have 
# added a dampener. This also works for exponential trends. We also plot 
# the level and slope individually for each model.

Model_holt_3 <- holt(WugeAsIs, damped=TRUE,h=12)
summary(Model_holt_3)
plot(Model_holt_3)

Model_holt_4 <- holt(WugeAsIs, exponential=TRUE, damped=TRUE,h=12)
summary(Model_holt_4)
plot(Model_holt_4)

# level and slope can be plotted individually for each model. 
plot(Model_holt_1$model$state)
plot(Model_holt_2$model$state)
plot(Model_holt_3$model$state)
plot(Model_holt_4$model$state)

plot(Model_holt_1, plot.conf=FALSE, ylab=" Wuge Exports Chulwalar  )", xlab="Year", main="", fcol="white", type="o")
lines(fitted(Model_ses), col="purple", type="o")
lines(fitted(Model_holt_1), col="blue", type="o")
lines(fitted(Model_holt_2), col="red", type="o")
lines(fitted(Model_holt_3), col="green", type="o")
lines(fitted(Model_holt_4), col="orange", type="o")
lines(Model_ses$mean, col="purple", type="o")
lines(Model_holt_1$mean, col="blue", type="o")
lines(Model_holt_2$mean, col="red", type="o")
lines(Model_holt_3$mean, col="green", type="o")
lines(Model_holt_4$mean, col="orange", type="o")
legend("topleft",lty=1, col=c(1,"purple","blue","red","green","orange"), c("data", "SES","Holts auto", "Exponential", "Additive Damped", "Multiplicative Damped"),pch=1)


## Holt-Winter's seasonal method   
# Holt and Winters have expanded Holt's model further to include
# the seasonality aspect. The parameter gamma, which is for smoothing 
# the seasonality, was added to achieve this. The values are better than 
# the models without seasonality. This is logical, since the data is strongly
# influenced by seasonality.  In the following model, none of the parameters 
# are given so that they will be optimised automatically. There are two models: 
# one using an additive error model method and one using a multiplicative error model. 
# The additive model gives slightly better results than the multiplicative model.

Model_hw_1 <- hw(WugeAsIs ,seasonal="additive",h=12)
summary(Model_hw_1)
plot(Model_hw_1)

Model_hw_2 <- hw(WugeAsIs ,seasonal="multiplicative",h=12)
summary(Model_hw_2)
plot(Model_hw_2)

plot(Model_hw_1, ylab="Wuge Exports", plot.conf=FALSE, type="o", fcol="white", xlab="Year")
lines(fitted(Model_hw_1), col="red", lty=2)
lines(fitted(Model_hw_2), col="green", lty=2)
lines(Model_hw_1$mean, type="o", col="red")
lines(Model_hw_2$mean, type="o", col="green")
legend("topleft",lty=1, pch=1, col=1:3, c("data","Holt Winters' Additive","Holt Winters' Multiplicative"))

#Damp the Holt-Winter models
Model_hw_3 <- hw(WugeAsIs ,seasonal="additive", damped = TRUE,h=12)
Model_hw_4 <- hw(WugeAsIs ,seasonal="multiplicative", damped = TRUE,h=12)

#create plot to show all HW lines

HW1 <- hw(WugeAsIs, seasonal = "additive")
HW2 <- hw(WugeAsIs, seasonal = "multiplicative")
HW3 <- hw(WugeAsIs, seasonal = "additive", damped = TRUE)
HW4 <- hw(WugeAsIs, seasonal = "multiplicative", damped = TRUE)



# In order to use the results later, they need to be converted into point forecasts.
Model_hw_1_df <-as.data.frame(Model_hw_1) 
Model_hw_1_PointForecast <- ts(Model_hw_1_df$"Point Forecast", start=c(2014,1), end=c(2014,12), frequency=12)
Model_hw_1_PointForecast
Model_hw_2_df <-as.data.frame(Model_hw_2) 
Model_hw_2_PointForecast <- ts(Model_hw_2_df$"Point Forecast", start=c(2014,1), end=c(2014,12), frequency=12)
Model_hw_2_PointForecast

#measures of quality
QualityNames <- c("AIC", "AICc", "BIC")
SESMeasures <- c(1981.370, 1981.544, 1985.923)
HoltAdditive <- c(1984.278, 1984.875, 1993.385)
HoltExponential <- c(1992.221, 1992.818, 2001.327)
HoltAddDamp <- c(1986.510, 1987.419, 1997.893)
HoltExpDamp <- c(1995.499, 1996.408, 2006.883)
HWAdditive <- c(1910.881, 1920.771, 1947.307)
HWExponential <- c(1910.516, 1920.407, 1946.942)
HWAdditiveDamp <- c(1919.078, 1930.411, 1957.781)
HWExponentialDamp <- c(1919.692, 1931.025, 1958.395)

#info for error information / presentation
ErrorNames <- c("ME", "RMSE", "MAE", "MPE", "MAPE", "MASE", "ACF1")
Methods <- c("SES", "Holt Add.", "Holt Mult.", "Holt Add. w/ Damp", "Holt Mult. w/ Damp", "HW's Add.", "HW's Mult.", "HW's Add. w/ Damp", "HW's Mult. w/ Damp")
ME <- c(14472.94, -7995.956, 2854.209, 3587.916, 6750.188, -63.33698, -4709.478, 7939.675, 8344.003)
RMSE <- c(108380.5, 107561.6, 107620.5, 107735, 108003.1, 54690.67, 54484.25, 57095.66,58602.93)
MAE <- c(79591.45, 83814.52, 83306.45, 82222.7, 81857.82, 43861.37, 44908.38, 46556.41,47747.06)
MPE <- c(-0.2985412, -4.528997, -2.476202, -2.590547, -1.869407, -1.398017, -2.31886, 0.4534177,0.2032803 )
MAPE <- c(13.80368, 15.17678, 14.72429, 14.64643,14.43078, 7.97784, 8.351825, 8.459067,8.478591)
MASE <- c(0.9695715, 1.021016, 1.014827, 1.01625, 0.9971801, 0.5343129, 0.5470674, 0.5671435,0.5816478)
ACF1 <- c(0.02262988, 0.05692744, 0.1136907, 0.06340987, 0.065998, -0.1775947, -0.309649, -0.1828394,-0.27984804)

#info for Holt Winters' errors
Methods2<- c("HW's Add.", "HW's Mult.", "HW's Add. w/ Damp", "HW's Mult. w/ Damp")
HWMAE<- c(43861.37, 44908.38, 46556.41,47747.06)
HWMAPE <- c(7.97784, 8.351825, 8.459067,8.478591)
HWErrors <- data.frame(Methods2, HWMAE, HWMAPE)
names(HWErrors) <- c("Method", "MAE", "MAPE")


#Residuals
#create new set of holt winters models levels, slopes, and seasonals

states <- cbind(Model_hw_1$model$states[,1:3], Model_hw_2$model$states[,1:3])
colnames(states) <- c("Level" , "Slope", "Seasonal", "Level" , "Slope", "Seasonal")

