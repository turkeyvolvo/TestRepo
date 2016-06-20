# LVitovsky_MSDS6306_402_CaseStudy1
Lindsay Vitovsky  
June 19, 2016  




## Introduction

Headquartered in Washington, D.C., the World Bank Group is "a vital source of financial and technical assistance to developing countries around the world" since 1944 (source: worldbank.org).  In addition to offering low-cost and low-interest financial products and services, the World Bank also works to provide assistance to governments and organizations in the areas of research and policy analysis, all with the end goals of reducing poverty and promoting prosperity around the world.

The World Bank collects vast amounts of data and data types, however, for this paper, the focus will be on certain data collected in the following data sets:

  * "GDP" - http://data.worldbank.org/data-catalog/GDP-ranking-table
  
  * "Education Statistics" - http://data.worldbank.org/data-catalog/ed-stats
  
Several particular questions will be addressed, and an overall look at the relationship between income level and GDP will be examined.

##Data

  The data for the analysis was obtained from the following data sets:

  * The "GDP" data set includes GDP rankings for 190 countries with populations greater than 30,000 (as well as rankings for a few regions, which have been ignored for purposes of this paper).  

  * The "Education Statistics" data set, which includes a variable that divides countries and regions into five income groups:
  
      * "Low income" - $1,045
    
      * "Lower middle income"" - $1,046 - $4,125
  
      * "Upper middle income" - $4,126 - $12,735
    
      * "High income: nonOECD" - $12,736 or more (nonOECD denotes a country that is not a member of the Organization for Economic Co-operation and Development)
    
      * "High income: OECD" - $12,736 or more (OECD denotes a country that is a member of the Organization for Economic Co-operation and Development)
      
      *Incomes listed are annual, per capita*
    

###Data Cleanup Code

Below is the code used to cleanup and explore the data.  To skip ahead to the Data Analysis, go to the next section, "Analysis."

1. Packages needed to reproduce code:

  

```r
## loadpackages
library(downloader)
library(plyr)
library(questionr)
library(ggplot2)
```

2. Note: Set desired working directory.

3. Load Data Sets.



```r
## loaddata
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", destfile="GDP.csv")
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile = "educationbycountry.csv")
```

4. Prepare first data set, which houses country code, GDP rank, country name, and latest updated GDP numbers (last updated April 2016)



```r
#data starts at row 6 with blank row between header and data
gdpdata <- read.csv("GDP.csv", skip = 5, header = FALSE, na.strings = c("", "NA"))
#keep raw data file for backup
gdpraw <- gdpdata
#only keep needed columns "countrycode", "rank", economy", and "millions of US dollars"
gdpdata <- gdpdata[c(1,2,4,5)]
gdpdata <- gdpdata[1:190,]
#assign names
names(gdpdata) <- c("countrycode","rank","country", "gdp")
str(gdpdata)
```

```
## 'data.frame':	190 obs. of  4 variables:
##  $ countrycode: Factor w/ 228 levels "ABW","ADO","AFG",..: 214 37 101 50 67 71 27 173 98 92 ...
##  $ rank       : Factor w/ 193 levels ".. Not available.  ",..: 2 103 114 125 136 147 158 169 180 3 ...
##  $ country    : Factor w/ 228 levels "  East Asia & Pacific",..: 217 50 106 81 76 216 36 171 104 97 ...
##  $ gdp        : Factor w/ 204 levels " 1,008 "," 1,129 ",..: 39 177 142 99 65 62 60 57 56 15 ...
```

```r
#only keep needed rows.  Reviewed the data to see 190 countries listed.
gdpdata <- na.omit(gdpdata)
str(gdpdata)
```

```
## 'data.frame':	190 obs. of  4 variables:
##  $ countrycode: Factor w/ 228 levels "ABW","ADO","AFG",..: 214 37 101 50 67 71 27 173 98 92 ...
##  $ rank       : Factor w/ 193 levels ".. Not available.  ",..: 2 103 114 125 136 147 158 169 180 3 ...
##  $ country    : Factor w/ 228 levels "  East Asia & Pacific",..: 217 50 106 81 76 216 36 171 104 97 ...
##  $ gdp        : Factor w/ 204 levels " 1,008 "," 1,129 ",..: 39 177 142 99 65 62 60 57 56 15 ...
```

```r
#need to change gdp and rank to numeric for future calculations
gdpdata$gdp <- as.numeric(gsub(",", "", gdpdata$gdp))
gdpdata$rank <- as.numeric(paste(gdpdata$rank))
str(gdpdata)
```

```
## 'data.frame':	190 obs. of  4 variables:
##  $ countrycode: Factor w/ 228 levels "ABW","ADO","AFG",..: 214 37 101 50 67 71 27 173 98 92 ...
##  $ rank       : num  1 2 3 4 5 6 7 8 9 10 ...
##  $ country    : Factor w/ 228 levels "  East Asia & Pacific",..: 217 50 106 81 76 216 36 171 104 97 ...
##  $ gdp        : num  16244600 8227103 5959718 3428131 2612878 ...
```


5. Prepare second data set, which houses country code, income group, and country name.


```r
#read in second data set, sub "Na" for blank cells to be read properly by R
educdata <- read.csv("educationbycountry.csv", skip=1, header = FALSE, na.strings = c("", "NA"))
#keep raw data file for backup
educraw <- educdata
#only keep needed columns "CountryCode", "Long Name", "Income Group"
educdata <- educdata[c(1,2,3)]
#update names to match gdp data set
names(educdata) <- c("countrycode", "longname", "incomegroup")
#get rid of NAs
educdata <- na.omit(educdata)
str(educdata)
```

```
## 'data.frame':	210 obs. of  3 variables:
##  $ countrycode: Factor w/ 234 levels "ABW","ADO","AFG",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ longname   : Factor w/ 234 levels "American Samoa",..: 5 104 57 99 108 226 4 109 1 2 ...
##  $ incomegroup: Factor w/ 5 levels "High income: nonOECD",..: 1 1 3 4 5 1 5 4 5 5 ...
##  - attr(*, "na.action")=Class 'omit'  Named int [1:24] 55 56 57 58 61 85 88 113 119 120 ...
##   .. ..- attr(*, "names")= chr [1:24] "55" "56" "57" "58" ...
```


6. Check for missing/bad data.



```r
#find nas
freq.na(gdpdata)
```

```
## Warning in freq.na(gdpdata): No variables specified; showing top five
## results.
```

```
##             missing %
## countrycode       0 0
## rank              0 0
## country           0 0
## gdp               0 0
```

```r
freq.na(educdata)
```

```
## Warning in freq.na(educdata): No variables specified; showing top five
## results.
```

```
##             missing %
## countrycode       0 0
## longname          0 0
## incomegroup       0 0
```

```r
#We should be good to go! No NAs found.  If data changes, included rows will need to change as well and NAs will need to be removed.
```


7. Merge data sets (raw copies of original data sets were generated above).


```r
#create new data set "gdp.by.income"
gdp.by.income <- merge(gdpdata, educdata, by="countrycode")
str(gdp.by.income)#check data set
```

```
## 'data.frame':	189 obs. of  6 variables:
##  $ countrycode: Factor w/ 228 levels "ABW","ADO","AFG",..: 1 3 4 5 6 7 8 10 11 12 ...
##  $ rank       : num  161 105 60 125 32 26 133 172 12 27 ...
##  $ country    : Factor w/ 228 levels "  East Asia & Pacific",..: 19 10 15 11 215 17 18 16 20 21 ...
##  $ gdp        : num  2584 20497 114147 12648 348595 ...
##  $ longname   : Factor w/ 234 levels "American Samoa",..: 5 57 99 108 226 4 109 2 15 110 ...
##  $ incomegroup: Factor w/ 5 levels "High income: nonOECD",..: 1 3 4 5 1 5 4 5 2 2 ...
```


##Analysis
After cross-referencing the two data sets, there were 189 countries with complete data to work with. Visualizing the data helped to generally understand the data. When analyzing GDP, due to the vast differences amongst the countries, the log of this variable was taken for visualization purposes.

Firstly, it was apparent that the High Income categories, both OECD member countries as well as non-OECD, had the highest concentrations amongst the higher GDPs.



```r
#density plot
qplot(log(gdp.by.income$gdp), data=gdp.by.income, geom="density", fill=gdp.by.income$incomegroup, alpha=I(.5),main = "Distribution of GDP by Income Group", xlab = "GDP", ylab = "Density") + guides(fill=guide_legend((title="Income Groups")))
```

<img src="LVitovsky_MSDS6306_402_CaseStudy1_files/figure-html/GDPbyIncome-1.png" style="display: block; margin: auto;" />


Also apparent from this graph is perhaps a rebuttal against OECD-naysayers who claim that OECD countries are less prosperous than non-OECD countries (due to their more restrictive use of oil-based energy).  This would lead one to suspect that the GDP of OECD countries surpasses that of non-OECD countries.  But more research on that topic is reserved for a later time!

Secondly, one can see from the box plot below, that:

  * The "Low income" group (group "3") has the most condensed results. This might indicate that there is not as much potential to move out of a certain income class.
  
  * The group with the most variability seems to be the "Lower middle income" group (group "4").  
  
  * The two income groups that produced the most GDP per capita were the "High inocme: nonOECD" (group "1") and the "High income: OECD" (group "2").  These groups, generally, produce more GDP per capita, and do not include the lower GDP numers of the other groups, even as outliers.  This indicates that while other income groups might experience high GDPs, it is not necessarily typical.  These "High income" countries seem to indicate that higher incomes per capita do not "guarantee" the highest GDPs, but they seem to be related to NOT having a low GDP.
  
      * Legend:
      
        "High income: nonOECD" = 1 
        
        "High income: OECD" = 2
        
        "Low income" = 3
        
        "Lower middle income" = 4
        
        "Upper middle income" = 5




```r
#box plot
gdp.by.group <- gdp.by.income
gdp.by.group$incomegroup <- as.numeric(gdp.by.group$incomegroup)
boxplot(log(gdp.by.group$gdp)~gdp.by.group$incomegroup, main="Log of GDP by Income Group", xlab="Income Group", ylab="Log of GDP")
```

<img src="LVitovsky_MSDS6306_402_CaseStudy1_files/figure-html/BoxPlot-1.png" style="display: block; margin: auto;" />


##Questions
**1. Match the data based on country shortcode.  How many of the IDs match?**


```r
nrow(gdp.by.income)
```

```
## [1] 189
```
Result: 189

**2. Sort the data frame in ascending order by GDP rank.  What is the 13th country in the resulting data frame?**


```r
#sort data frame by gdp in ascending order
gdp.by.rank <- gdp.by.income #creates new df 
gdp.by.rank <- arrange(gdp.by.rank, gdp.by.rank$rank, decreasing = TRUE)
gdp.by.rank[13,]
```

```
##    countrycode rank             country gdp            longname
## 13         KNA  178 St. Kitts and Nevis 767 St. Kitts and Nevis
##            incomegroup
## 13 Upper middle income
```


Result: KNA, 178, St. Kitts and Nevis, 767, St. Kitts and Nevis, Upper middle income

**3. What are the average GDP rankings for the "High income:OECD" and "HIgh income: nonOECD" groups?**


```r
#subset HI:OECD countries and find mean
HIOECD <- gdp.by.income[which(gdp.by.income$incomegroup=="High income: OECD"),]
mean(HIOECD$rank)
```

```
## [1] 32.96667
```

```r
#subset HI:nonOECD countries and find mean
HINOECD <- gdp.by.income[which(gdp.by.income$incomegroup=="High income: nonOECD"),]
mean(HINOECD$rank)
```

```
## [1] 91.91304
```

Result: High income: nonOECD = 91.9130435, High income: OECD = 32.9666667

**4. Plot the GDP for all of the countries.  Use ggplot 2 to color your plot by Income Group.**




```r
#plot the data, add titles and geom_bin2d because of continuous v. discrete data to color properly
ggplot(gdp.by.income, aes(log(gdp.by.income$gdp), gdp.by.income$incomegroup)) + xlab("GDP") + ylab("Income Group")+ ggtitle("Heat Map of GDP by Income Group")+geom_bin2d()
```

<img src="LVitovsky_MSDS6306_402_CaseStudy1_files/figure-html/Question4-1.png" style="display: block; margin: auto;" />


**5. Cut the GDP ranking into 5 separate quantile groups.  Make a table versus Income Group.  How many countries are Lower middle income, but among the 38 nations with the highest GDP?**



```r
#add a quantiles column within the gdp.by.income, be sure to include lowest value
ApplyQuantiles <- within(gdp.by.income, quantile <- as.integer(cut(gdp.by.income$gdp, quantile(gdp.by.income$gdp, (0:5/5)), include.lowest=TRUE, labels = FALSE)))
#Make a table versus Income Group
quant.by.income <- data.frame("Quantile"=ApplyQuantiles$quantile,"Income Group"=ApplyQuantiles$incomegroup)
#see how many Lower middle Income countries are in each quantile
LowMidInc <- freq(quant.by.income$Quantile[which(quant.by.income$Income.Group=="Lower middle income")])
LowMidInc[5,1]
```

```
## [1] 5
```


Result:

Number of Lower middle income countries with GDPs in the highest quantile: 5

Graph just for fun:



```r
#visualize the income groups by quantile
#assign a ggplot to be "jittered" to variable "g" & add jitter points to the "g" ggplot
g <- ggplot(quant.by.income, aes(x=quant.by.income$Quantile, y=quant.by.income$Income.Group)) + xlab("Quantile") + ylab("Income Group") + ggtitle("Plot of Income Groups According to Quantile") + theme(legend.position="none") 
g+geom_jitter(aes(color=quant.by.income$Income.Group), position = position_jitter(width = .2))
```

<img src="LVitovsky_MSDS6306_402_CaseStudy1_files/figure-html/Question5Part2-1.png" style="display: block; margin: auto;" />


##Conclusion
While this research just scratched the surface of the relationship between Income per capita and GDP, this preliminary analysis gives an indication that the two go hand in hand.  Further research would need to be done to investigate other possible contributing factors.  For example, does geography impact the relationships as well?  Countries that have certain natural resources may find that the majority of their citizens do not benefit financially from the wealth of exports, thus creating an anomoly where a high-GDP country is in a Lower middle or Low income grouping.  The relationship is undoubtedly multi-faceted

In the absence of a randomized experiment (which would be highly unethical), one would not be able to determine causality between poverty and GDP.  What one can surmise is that the data collected by the World Bank certainly gives us some insight on the impacts/sources of poverty, so that governments and organizations can combat it.




