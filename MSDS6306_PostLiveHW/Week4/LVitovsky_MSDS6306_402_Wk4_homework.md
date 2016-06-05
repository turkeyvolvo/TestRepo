# LVitovsky_Week4_BootstrapHW
Vitovsky  
June 4, 2016  



##Introduction
***The assignment instructed to create a total of four samples, two of different sizes from a normal distribution, and two of difference sizes from an exponential distribution.***

Groundwork used for this report:

  * a random normal distribution (x) of size 100, mean = 40, and standard deviation = 3
  
  * an exponential distribution (x2) of size 100 
  * sample sizes of 5 and 50 for each distribution
  
  * a Bias Corrected and accelerated bootstrap confidence interval to compare the confidence intervals calculated from the bootstrap techinque.
  
##Summary

Upon building and running the code, here were my observations:

**Sampling 50 and 5 from the normal distribution**

  * The bootstrap of the large and small samples generated a bootstrap mean of 40.51026 and 41.00502 respectively.  Both fell within their 95% confidence intervals (39.77734 - 40.85411 and 39.61505 - 40.95951, respectively), so if this were a test of actual data, I would not have rejected the null hypothesis.  There does not seem to be a statistical difference between the means of either sample and the population mean.
  
  * There was no change when finding the the Bias Corrected and accelerated Confidence Interval, which was found to be 39.81 - 40.81.  This indicates that there is no bias in our bootstrap confidence level.  Also, this is very close to the CIs of the two samples.  This is not surprising, as we took our samples from a randomized normal distribution.
  
  * The larger sample's standard deviation (3.0757) was larger than the smaller sample's standard deviation (2.408).  The standard deviation of the 100 random normal variables was 2.695.  
  
**Sampling 50 and 5 from the exponential distribution**

When running the same commands on an exponential distribution, here is what I found:

  * the bootstrapped means in these cases fell outside of the 95% confidence intervals.  The larger sample bootstrap mean of 0.83848 is below the confiendence interval of 0.84449 - 1.25168, and the smaller bootstrap mean of 2.35078 was above the 95% confidence interval of 0.854478 - 1.47757.  If I had collected these samples in an actual experiment, I would have rejected the null hypothesis.
  
  * after finding the Bias Corrected and accelerated bootstrap confidence interval, I found that there was a small difference between the 95% confidence interval and the BCa interval of the population.  It doesn't appear to be a large difference, though, and would have moved the confidence intervals positively.  This would not have helped the larger sample, which fell barely below the lower confidence interval, and the smaller sample, which was noticeably higher than the upper confidence interval.  The BCa does not change my interpretation that we would reject the null hypothese in this case.
  
  * after reviewing a stem and leaf chart of the exponential distribution, one can see why a random sample of 50 would be much more likely to include lower values than the smaller sample of size 5.  This shows how important it is to have as large of a sample as possible.
  
  * after running histograms of the large and small samples of the exponential distribution, one can see that the larger sample is approaching a normal distribution more closely than the small sample. Indeed, when I re-ran the exponential distribution samples, they approached a more normal distribution.
  
##Conclusion

Through bootstrapping, one can see that the Central Limit Theorem holds true.

  * As the sample size increased, the distribution of means converge upon being normal.
  
  * As the number of bootstraps increaes, the distribution of means converge upon being normal, regardless of the original distribution.  This supports the statement that one does not need to know that the original population is normally distributed.  This is why you collect a sufficient number of bootstrapped means.

  
### Coding / Supporting Documentation

Use a normal distribution with two different sample sizes and an exponential distribution with two different sample sizes




```r
#created a normal distribution to choose samples from, placed inside "x"
#set.seed to reproduce results
set.seed(1)
x <- rnorm(100, 40, 3)

#create the bootstrap framework
xbar <- mean(x)
sem <- sd(x)/sqrt(100)
reps <- 1000
bootnorm <- numeric(reps)


#run a bootstrap sampling with a larger sample size
for(i in 1:reps) {
  bootsample <- sample(x, size = 50, replace = TRUE)
  samplemean <- mean(bootsample)
  samplesd <- sd(bootsample)
  tpivot <- (samplemean - xbar)/(samplesd/sqrt(50))
  bootnorm[i] <- tpivot
}

#find the quantiles to compute Confidence Intervals

quant <- quantile(bootnorm, c(0.025, 0.975))
quantlowend <- xbar - quant[2]*sem
quantupend <- xbar - quant[1]*sem
data.frame("SampleMean" = samplemean, "SampleSdDev" = samplesd, "XBar" = xbar, "LowerCI"=quantlowend, "UpperCI"=quantupend)
```

```
##       SampleMean SampleSdDev     XBar  LowerCI  UpperCI
## 97.5%   40.51026    3.075744 40.32666 39.77734 40.85411
```

After running a sample size of 50, I then ran a sample size of 5.


```r
#run a bootstrap sampling with a small sample size
for(i in 1:reps) {
  bootsample <- sample(x, size = 5, replace = TRUE)
  samplemean <- mean(bootsample)
  samplesd <- sd(bootsample)
  tpivot <- (samplemean - xbar)/(samplesd/sqrt(5))
  bootnorm[i] <- tpivot
}

#find the quantiles to compute Confidence Intervals

quant <- quantile(bootnorm, c(0.025, 0.975))
quantlowend <- xbar - quant[2]*sem
quantupend <- xbar - quant[1]*sem
data.frame("SampleMean" = samplemean,"SampleSdDev" = samplesd, "XBar" = xbar, "LowerCI"=quantlowend, "UpperCI"=quantupend)
```

```
##       SampleMean SampleSdDev     XBar  LowerCI  UpperCI
## 97.5%   41.00502    2.408293 40.32666 39.61505 40.95951
```

I then asked for the Bias Corrected Bootstrap CI's to test the validity of the bootstrap confidence intervals.


```r
mymean <-function(d,i)
  mean(d[i])

myboot <- boot(x,mymean,R=1000)
boot.ci(myboot, type = c("perc", "bca"))
```

```
## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
## Based on 1000 bootstrap replicates
## 
## CALL : 
## boot.ci(boot.out = myboot, type = c("perc", "bca"))
## 
## Intervals : 
## Level     Percentile            BCa          
## 95%   (39.81, 40.81 )   (39.80, 40.81 )  
## Calculations and Intervals on Original Scale
```

##Exponential Distribution

First, a larger sample of 50...


```r
#create exponential distribution
set.seed(2)
x2 <- rexp(100)

#create the bootstrap framework
xbar2 <- mean(x2)

#run a bootstrap sampling with a larger sample size
for(i in 1:reps) {
  bootsample <- sample(x2, size = 50, replace = TRUE)
  samplemean <- mean(bootsample)
  samplesd <- sd(bootsample)
  tpivot <- (samplemean - xbar2)/(samplesd/sqrt(50))
  bootnorm[i] <- tpivot
}

#view histogram of the results
hist(bootnorm, col = "light grey")
abline(v=mean(bootnorm), col = "blue")
```

![](LVitovsky_MSDS6306_402_Wk4_homework_files/figure-html/ExpDistLarge-1.png)<!-- -->

```r
#find the quantiles to compute Confidence Intervals

quant <- quantile(bootnorm, c(0.025, 0.975))
quantlowend <- xbar2 - quant[2]*sem
quantupend <- xbar2 - quant[1]*sem
data.frame("SampleMean" = samplemean, "SampleSdDev" = samplesd, "XBar" = xbar2, "LowerCI"=quantlowend, "UpperCI"=quantupend)
```

```
##       SampleMean SampleSdDev     XBar   LowerCI  UpperCI
## 97.5%  0.8384767    0.995481 1.006729 0.5472455 1.700434
```

...then a smaller sample of 5


```r
#run a bootstrap sampling with a smaller sample size
for(i in 1:reps) {
  bootsample <- sample(x2, size = 5, replace = TRUE)
  samplemean <- mean(bootsample)
  samplesd <- sd(bootsample)
  tpivot <- (samplemean - xbar2)/(samplesd/sqrt(5))
  bootnorm[i] <- tpivot
}

#view a histogram of the results
hist(bootnorm, col = "light grey")
abline(v=mean(bootnorm), col = "blue")
```

![](LVitovsky_MSDS6306_402_Wk4_homework_files/figure-html/ExpDistSmall-1.png)<!-- -->

```r
#find the quantiles to compute Confidence Intervals

quant <- quantile(bootnorm, c(0.025, 0.975))
quantlowend <- xbar2 - quant[2]*sem
quantupend <- xbar2 - quant[1]*sem
data.frame("SampleMean" = samplemean, "SampleSdDev" = samplesd, "XBar" = xbar2, "LowerCI"=quantlowend, "UpperCI"=quantupend)
```

```
##       SampleMean SampleSdDev     XBar   LowerCI UpperCI
## 97.5%   2.350784    1.644922 1.006729 0.5755449 2.34019
```

Ran a BCa command as before...


```r
mymean <-function(d,i)
  mean(d[i])

myboot <- boot(x2,mymean,R=1000)
boot.ci(myboot, type = c("perc", "bca"))
```

```
## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
## Based on 1000 bootstrap replicates
## 
## CALL : 
## boot.ci(boot.out = myboot, type = c("perc", "bca"))
## 
## Intervals : 
## Level     Percentile            BCa          
## 95%   ( 0.828,  1.194 )   ( 0.843,  1.215 )  
## Calculations and Intervals on Original Scale
```

Created a stem and leaf plot to visualize the exponential distribution


```r
stem(x2)
```

```
## 
##   The decimal point is at the |
## 
##   0 | 000111111111122222333333334444
##   0 | 55556666667777777888888888999999
##   1 | 00111111222333344
##   1 | 56667789999
##   2 | 002
##   2 | 6
##   3 | 01
##   3 | 
##   4 | 01
##   4 | 59
```

For the exponential distribution only, I increased the number of repetitions from 1,000 to 5,000 on the larger sample to see if the result would be closer to a normal distribution. The histogram is below.


```r
reps2 <- 5000
bootnorm <- numeric(reps2)

for(i in 1:reps2) {
  bootsample <- sample(x2, size = 50, replace = TRUE)
  samplemean <- mean(bootsample)
  samplesd <- sd(bootsample)
  tpivot <- (samplemean - xbar2)/(samplesd/sqrt(50))
  bootnorm[i] <- tpivot
}

#view histogram of the results
hist(bootnorm, col = "light grey")
abline(v=mean(bootnorm), col = "blue")
```

![](LVitovsky_MSDS6306_402_Wk4_homework_files/figure-html/LargerBoot-1.png)<!-- -->


