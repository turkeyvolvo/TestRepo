#EDA code
#code from WWBBFH analysis
# Test the correlation between As Is and Plan data in order to test how exact 
# the planning is. 
# Correlation is a measure of linear relationship between two variables. 

TotalCor <- cor(TotalAsIs, TotalPlan )
WugeCor <- cor(WugeAsIs, WugePlan)



# The results show a very high planning accuracy.

#fit a linear model to Total AsIs
WugeAsIs_lm <- lm(WugeAsIs ~ WugePlan , data = WugeAsIs)
summary(WugeAsIs_lm)

#fit the linear model TotalAsIs_lm to a time series
WugeAsIs_tslm <- tslm(WugeAsIs ~ TotalPlan)
summary(WugeAsIs_lm)

#use STL to breakdown seasonality, trend, and remainder
WugeAsIs_stl <- stl(WugeAsIs, s.window=5)


#review STL results on a plot

plot(WugeAsIs_stl, col="black", main="WugeAsIs_stl")


#look at trend for Wuge
par(mfrow=c(1,1), mar=c(6,4,1,1))
plot(WugeAsIs_stl$time.series[,"trend"], col="blue", main="Wuge Trend")

#compare the seasonality.  "It only makes sense to do 
#this if the seasonality componant as the trend looks almost identical and 
#the remainder is then randomly spread."

monthplot(WugeAsIs_stl$time.series[,"seasonal"], main="Monthly Seasonality", ylab="Seasonal")


## Correlation with external indicators

#The indicators are as follows:
  
#Monthly Change in Export Price Index (CEPI)
#Monthly Satisfaction Index (SI) government based data
#Average monthly temperatures in Chulwalar
#Monthly births in Chulwalar
#Monthly Satisfaction Index (SI) external index 
#Yearly Exports from Urbano
#Yearly number of Globalisation Party members in Chulwalar
#Monthly Average Export Price Index for Chulwalar
#Monthly Producer Price Index (PPI) for Etel in Chulwalar
#National Holidays
#Chulwalar Index (Total value of all companies in Chulwalar)
#Monthly Inflation rate in Chulwalar
#Proposed spending for National Holidays
#Influence of National Holiday

#The indicators will be converted into individual  vectors and subsequently converted into time series. The correlation of the indicators will then be tested against the As Is exports for Chulwalar. 

# Monthly Change in Export Price Index (CEPI)
CEPIVector <- c(ImportedIndicators[2:13,2],ImportedIndicators[2:13,3],ImportedIndicators[2:13,4],ImportedIndicators[2:13,5],ImportedIndicators[2:13,6],ImportedIndicators[2:13,7])
CEPI <- ts(CEPIVector , start=c(2008,1), end=c(2013,12), frequency=12)
plot(CEPI, main="CEPI")

WugeCEPICor <- cor(WugeAsIs, CEPI)

# Monthly Satisfaction Index (SI) government based data
SIGovVector <- c(ImportedIndicators[16:27,2],ImportedIndicators[16:27,3],ImportedIndicators[16:27,4],ImportedIndicators[16:27,5],ImportedIndicators[16:27,6],ImportedIndicators[16:27,7])
SIGov <- ts(SIGovVector , start=c(2008,1), end=c(2013,12), frequency=12)
plot(SIGov, main="SIGov")

WugeSICor <- cor(WugeAsIs, SIGov)

# Average monthly temperatures in Chulwalar
TemperatureVector <- c(ImportedIndicators[30:41,2],ImportedIndicators[30:41,3],ImportedIndicators[30:41,4],ImportedIndicators[30:41,5],ImportedIndicators[30:41,6],ImportedIndicators[30:41,7])
Temperature <- ts(TemperatureVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(Temperature, main="Temperature")

WugeTempCor <- cor(WugeAsIs, Temperature)

# Monthly births in Chulwalar 
BirthsVector <- c(ImportedIndicators[44:55,2],ImportedIndicators[44:55,3],ImportedIndicators[44:55,4],ImportedIndicators[44:55,5],ImportedIndicators[44:55,6],ImportedIndicators[44:55,7])
Births <- ts(BirthsVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(Births, main="Births")

WugeBirthCor <- cor(WugeAsIs, Births)

# Monthly Satisfaction Index (SI) external index 
SIExternVector <- c(ImportedIndicators[58:69,2],ImportedIndicators[58:69,3],ImportedIndicators[58:69,4],ImportedIndicators[58:69,5],ImportedIndicators[58:69,6],ImportedIndicators[58:69,7])
SIExtern <- ts(SIExternVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(SIExtern, main="SIExtern")

WugeSIECor <- cor(WugeAsIs, SIExtern)

# Yearly exports from Urbano
UrbanoExportsVector <- c(ImportedIndicators[72:83,2],ImportedIndicators[72:83,3],ImportedIndicators[72:83,4],ImportedIndicators[72:83,5],ImportedIndicators[72:83,6],ImportedIndicators[72:83,7])
UrbanoExports <- ts(UrbanoExportsVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(UrbanoExports, main="UrbanoExports")

WugeExpCor <- cor(WugeAsIs, UrbanoExports)

# Yearly number of Globalisation Party members in Chulwalar
GlobalisationPartyMembersVector <- c(ImportedIndicators[86:97,2],ImportedIndicators[86:97,3],ImportedIndicators[86:97,4],ImportedIndicators[86:97,5],ImportedIndicators[86:97,6],ImportedIndicators[86:97,7])
GlobalisationPartyMembers <- ts(GlobalisationPartyMembersVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(GlobalisationPartyMembers, main="GlobalisationPartyMembers")

WugeGloCor <- cor(WugeAsIs, GlobalisationPartyMembers)

# Monthly Average Export Price Index for Chulwalar
AEPIVector <- c(ImportedIndicators[100:111,2],ImportedIndicators[100:111,3],ImportedIndicators[100:111,4],ImportedIndicators[100:111,5],ImportedIndicators[100:111,6],ImportedIndicators[100:111,7])
AEPI <- ts(AEPIVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(AEPI, main="AEPI")

WugeAEPICor <- cor(WugeAsIs, AEPI)

# Monthly Producer Price Index (PPI) for Etel in Chulwalar
PPIEtelVector <- c(ImportedIndicators[114:125,2],ImportedIndicators[114:125,3],ImportedIndicators[114:125,4],ImportedIndicators[114:125,5],ImportedIndicators[114:125,6],ImportedIndicators[114:125,7])
PPIEtel <- ts(PPIEtelVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(PPIEtel, main="PPIEtel")

WugePPICor <- cor(WugeAsIs, PPIEtel)

# National Holidays
NationalHolidaysVector <- c(ImportedIndicators[170:181,2],ImportedIndicators[170:181,3],ImportedIndicators[170:181,4],ImportedIndicators[170:181,5],ImportedIndicators[170:181,6],ImportedIndicators[170:181,7])
NationalHolidays <- ts(NationalHolidaysVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(NationalHolidays, main="NationalHolidays")

WugeNatCor <- cor(WugeAsIs, NationalHolidays)

# Chulwalar Index (Total value of all companies in Chulwalar)
ChulwalarIndexVector <- c(ImportedIndicators[128:139,2],ImportedIndicators[128:139,3],ImportedIndicators[128:139,4],ImportedIndicators[128:139,5],ImportedIndicators[128:139,6],ImportedIndicators[128:139,7])
ChulwalarIndex <- ts(ChulwalarIndexVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(ChulwalarIndex, main="ChulwalarIndex")

WugeIdxCor <- cor(WugeAsIs, ChulwalarIndex)

# Monthly Inflation rate in Chulwalar 
InflationVector <- c(ImportedIndicators[142:153,2],ImportedIndicators[142:153,3],ImportedIndicators[142:153,4],ImportedIndicators[142:153,5],ImportedIndicators[142:153,6],ImportedIndicators[142:153,7])
Inflation <- ts(InflationVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(Inflation, main="Inflation")

WugeInfCor <- cor(WugeAsIs, Inflation)


# Proposed spending for Independence day presents
IndependenceDayPresentsVector <- c(ImportedIndicators[156:167,2],ImportedIndicators[156:167,3],ImportedIndicators[156:167,4],ImportedIndicators[156:167,5],ImportedIndicators[156:167,6],ImportedIndicators[156:167,7])
IndependenceDayPresents <- ts(IndependenceDayPresentsVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(IndependenceDayPresents, main="IndependenceDayPresents")

WugeIndCor <- cor(WugeAsIs, IndependenceDayPresents)

# Influence of National Holidays :
#This indicator is an experiment where the influence of National Holidays is 
#extended into the months leading up to the holiday. However later tests show 
#that this indicator is no better for forecasting than the orignial National 
#Holidays indicator.  

InfluenceNationalHolidaysVector <- c(ImportedIndicators[184:195,2],ImportedIndicators[184:195,3],ImportedIndicators[184:195,4],ImportedIndicators[184:195,5],ImportedIndicators[184:195,6],ImportedIndicators[184:195,7])
InfluenceNationalHolidays <- ts(InfluenceNationalHolidaysVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(InfluenceNationalHolidays, main="InfluenceNationalHolidays")

WugeIndCor2 <- cor(WugeAsIs, InfluenceNationalHolidays)
par(mfrow=c(1,1), mar = c(12,6,4,2) + 0.1, mgp = c(4,2,0))
Correlations <- c(WugeCEPICor, WugeExpCor, WugeSICor, WugeSIECor, WugeBirthCor, WugeTempCor, WugeGloCor, WugeAEPICor, WugePPICor, WugeNatCor, WugeIdxCor, WugeInfCor, WugeIndCor, WugeIndCor2 )
ParamNames <- c("Mo. Change in Export Price", "Mo. Avg. Export Price", "Mo.Satisfaction Idx - Govt", "Mo. Satisfaction Idx - Ext.", "Mo. Births", "Mo. Avg. Temperature", "Yearly Exports", "Yearly No. of GP Members", "Mo. Producer Price Idx", "National Holidays", "Chulwalar Idx", "Mo. Avg. Inflation Rate", "Proposed Ind. Day Gifts", "Influence of Ind. Day Gifts")
plot(Correlations, main="Correlations for Wuge Plant", xaxt="n", pch=19,col="blue", ylim=c(-1, 1), xlab = "", ylab="Correlation")
axis(1, labels = ParamNames, at=1:14, las=2)

# Check that the data import has worked
str(CEPIVector)
str(SIGovVector)  
str(TemperatureVector) 
str(BirthsVector)
str(SIExternVector)
str(UrbanoExportsVector) 
str(GlobalisationPartyMembersVector)
str(AEPIVector) 
str(PPIEtelVector) 
str(NationalHolidaysVector) 
str(ChulwalarIndexVector)
str(InflationVector) 
str(IndependenceDayPresentsVector)

par(mfrow=c(1,1))
