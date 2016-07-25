#load correct libraries and the data
#download data, which is in two .csv files, AsIs data and Planned data
#set working directory to proper folder to read in .csv files

#load packages and data
setwd("~/testrepo/CaseStudy2/ChulwalarCase")
library(fpp) # for time series forecasting and analysis
library(forecast) # for some other forecasting models
ImportedAsIsData <- read.csv(file="ImportedAsIsDataChulwalar.csv", 
                             header = F, sep=";", fill = T)
ImportedIndicators <- read.csv(file="ImportedIndicatorsChulwalar.csv", 
                               header = F, sep=";", fill = T)
ImportedPlanData <- read.csv(file="ImportedPlanDataChulwalar.csv", 
                             header = F, sep=";", fill = T)

#check out the data
str(ImportedAsIsData)
str(ImportedPlanData)
str(ImportedIndicators)

#convert data into vectors
TotalAsIsVector <- c(ImportedAsIsData [2:13,2],
                     ImportedAsIsData [2:13,3],
                     ImportedAsIsData [2:13,4],
                     ImportedAsIsData [2:13,5],
                     ImportedAsIsData [2:13,6],
                     ImportedAsIsData [2:13,7])
WugeAsIsVector <- c(ImportedAsIsData [30:41,2],
                    ImportedAsIsData [30:41,3],
                    ImportedAsIsData [30:41,4],
                    ImportedAsIsData [30:41,5],
                    ImportedAsIsData [30:41,6],
                    ImportedAsIsData [30:41,7])
YearAsIsVector <- c(ImportedAsIsData [86,2],
                    ImportedAsIsData [86,3],
                    ImportedAsIsData [86,4],
                    ImportedAsIsData [86,5],
                    ImportedAsIsData [86,6],
                    ImportedAsIsData [86,7])
TotalAsIsVector_2014 <- c(ImportedAsIsData[2:13,8])
PlanVector <- c(ImportedPlanData[2:13,2],
                ImportedPlanData[2:13,3],
                ImportedPlanData[2:13,4],
                ImportedPlanData[2:13,5],
                ImportedPlanData[2:13,6],
                ImportedPlanData[2:13,7])
WugePlanVector <- c(ImportedPlanData[30:41,2],
                    ImportedPlanData[30:41,3],
                    ImportedPlanData[30:41,4],
                    ImportedPlanData[30:41,5],
                    ImportedPlanData[30:41,6],
                    ImportedPlanData[30:41,7])
YearPlanVector <- c(ImportedPlanData[86,2],
                    ImportedPlanData[86,3],
                    ImportedPlanData[86,4],
                    ImportedPlanData[86,5],
                    ImportedPlanData[86,6],
                    ImportedPlanData[86,7])
PlanVector_2014 <- c(ImportedPlanData[2:13,8])

# The data is saved as a vector and needs to be converted into a time series
TotalAsIs<- ts(TotalAsIsVector , start=c(2008,1), 
               end=c(2013,12), frequency=12)
WugeAsIs <- ts(WugeAsIsVector, start=c(2008,1), 
               end=c(2013,12), frequency=12)
YearAsIs <- ts(YearAsIsVector, start=c(2008,1), 
               end=c(2013,12), frequency=12)
TotalAsIs_2014 <- ts(TotalAsIsVector_2014, start=c(2014,1), 
                     end=c(2014,12), frequency=12)
TotalPlan <- ts(PlanVector , start=c(2008,1), 
                end=c(2013,12), frequency=12)
WugePlan <- ts(WugePlanVector, start=c(2008,1), 
               end=c(2013,12), frequency=12)
YearPlan <- ts(YearPlanVector, start=c(2008,1), 
               end=c(2013,12), frequency=12)
TotalPlan_2014 <- ts(PlanVector_2014, start=c(2014,1), 
                     end=c(2014,12), frequency=12)

#check out the data to make sure it's right
str(TotalAsIs)
str(WugeAsIs)
str(YearAsIs)
str(TotalAsIs_2014)
str(TotalPlan)
str(WugePlan) 
str(YearPlan)
str(TotalPlan_2014)

