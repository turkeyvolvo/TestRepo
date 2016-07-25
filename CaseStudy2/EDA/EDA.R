#EDA code
#code from WWBBFH analysis
# Test the correlation between As Is and Plan data in order to test how exact 
# the planning is. 
# Correlation is a measure of linear relationship between two variables. 

TotalCor <- cor(TotalAsIs, TotalPlan )
EfakCor <- cor(EfakAsIs , EfakPlan)
WugeCor <- cor(WugeAsIs, WugePlan)
TotalEtelCor <- cor(TotalEtelAsIs, TotalEtelPlan)
BlueEtelCor <- cor(BlueEtelAsIs , BlueEtelPlan)
RedEtelCor <- cor(RedEtelAsIs , RedEtelPlan)
YearCor <- cor(YearAsIs, YearPlan)

#Make it easy to report
Names <- c("Total", "Efak", "wuge", "Total Etel", "Red Etel", "Blue Etel", "Year")
CorNumbers <- c(TotalCor, EfakCor, WugeCor, TotalEtelCor, BlueEtelCor, RedEtelCor, YearCor)
data.frame(CorNumbers, Names)


# The results show a very high planning accuracy.

#fit a linear model to Total AsIs
TotalAsIs_lm <- lm(TotalAsIs ~ TotalPlan , data = TotalAsIs)
summary(TotalAsIs_lm)

#fit the linear model TotalAsIs_lm to a time series
TotalAsIs_tslm <- tslm(TotalAsIs ~ TotalPlan )
summary(TotalAsIs_tslm)

#use STL to breakdown seasonality, trend, and remainder
TotalAsIs_stl <- stl(TotalAsIs, s.window=5)
EfakAsIs_stl <- stl(EfakAsIs , s.window=5)
WugeAsIs_stl <- stl(WugeAsIs, s.window=5)
TotalEtelAsIs_stl <- stl(TotalEtelAsIs, s.window=5)
BlueEtelAsIs_stl <- stl(BlueEtelAsIs , s.window=5)
RedEtelAsIs_stl <- stl(RedEtelAsIs , s.window=5)

#review STL results on a plots
par(mfrow=c(3,2))
plot(TotalAsIs_stl, col="black", main="TotalAsIs_stl")
plot(EfakAsIs_stl, col="black", main="EfakAsIs_stl")
plot(WugeAsIs_stl, col="black", main="WugeAsIs_stl")
plot(TotalEtelAsIs_stl, col="black", main="TotalEtelAsIs_stl")
plot(BlueEtelAsIs_stl, col="black", main="BlueEtelAsIs_stl")
plot(RedEtelAsIs_stl, col="black", main="RedEtelAsIs_stl")


#look at trend for each flower to compare to overall
par(mfrow=c(3,2))
plot(TotalAsIs_stl$time.series[,"trend"], col="black")
plot(EfakAsIs_stl$time.series[,"trend"], col="red")
plot(WugeAsIs_stl$time.series[,"trend"], col="blue")
plot(TotalEtelAsIs_stl$time.series[,"trend"], col="green")
plot(BlueEtelAsIs_stl$time.series[,"trend"], col="orange")
plot(RedEtelAsIs_stl$time.series[,"trend"], col="purple")

#compare the seasonalities of all groups.  "It only makes sense to do 
#this if the seasonality componant as the trend looks almost identical and 
#the remainder is then randomly spread."

monthplot(TotalAsIs_stl$time.series[,"seasonal"], main="", ylab="Seasonal")
monthplot(EfakAsIs_stl$time.series[,"seasonal"], main="", ylab="Seasonal")
monthplot(WugeAsIs_stl$time.series[,"seasonal"], main="", ylab="Seasonal")
monthplot(TotalEtelAsIs_stl$time.series[,"seasonal"], main="", ylab="Seasonal")
monthplot(BlueEtelAsIs_stl$time.series[,"seasonal"], main="", ylab="Seasonal")
monthplot(RedEtelAsIs_stl$time.series[,"seasonal"], main="", ylab="Seasonal")

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

TotalCEPICor <- cor(TotalAsIs, CEPI)
EfakCEPICor <- cor(EfakAsIs , CEPI)
WugeCEPICor <- cor(WugeAsIs, CEPI)
TotalEtelCEPICor <- cor(TotalEtelAsIs, CEPI)
BlueEtelCEPICor <- cor(BlueEtelAsIs , CEPI)
RedEtelCEPICor <- cor(RedEtelAsIs , CEPI)
CEPICorNumbers <- c(TotalCEPICor, EfakCEPICor, WugeCEPICor,TotalEtelCEPICor, BlueEtelCEPICor, RedEtelCEPICor)
Names2 <- c("Total", "Efak", "Wuge", "Total Etel", "Blue Etel", "Red Etel")
CEPIDF <- data.frame(CEPICorNumbers, Names2)

# Monthly Satisfaction Index (SI) government based data
SIGovVector <- c(ImportedIndicators[16:27,2],ImportedIndicators[16:27,3],ImportedIndicators[16:27,4],ImportedIndicators[16:27,5],ImportedIndicators[16:27,6],ImportedIndicators[16:27,7])
SIGov <- ts(SIGovVector , start=c(2008,1), end=c(2013,12), frequency=12)
plot(SIGov, main="SIGov")

TotalSICor <- cor(TotalAsIs, SIGov)
EfakSICor <- cor(EfakAsIs , SIGov)
WugeSICor <- cor(WugeAsIs, SIGov)
TotalEtelSICor <- cor(TotalEtelAsIs, SIGov)
BlueEtelSICor <- cor(BlueEtelAsIs , SIGov)
RedEtelSICor <- cor(RedEtelAsIs , SIGov)
SICorNumbers <- c(TotalSICor, EfakSICor, WugeSICor, TotalEtelSICor, BlueEtelSICor, RedEtelSICor)
SIDF <- data.frame(SICorNumbers, Names2)

# Average monthly temperatures in Chulwalar
TemperatureVector <- c(ImportedIndicators[30:41,2],ImportedIndicators[30:41,3],ImportedIndicators[30:41,4],ImportedIndicators[30:41,5],ImportedIndicators[30:41,6],ImportedIndicators[30:41,7])
Temperature <- ts(TemperatureVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(Temperature, main="Temperature")

TotalTempCor <- cor(TotalAsIs, Temperature)
EfakTempCor <- cor(EfakAsIs , Temperature)
WugeTempCor <- cor(WugeAsIs, Temperature)
TotalEtelTempCor <- cor(TotalEtelAsIs, Temperature)
BlueEtelTempCor <- cor(BlueEtelAsIs , Temperature)
RedEtelTempCor <- cor(RedEtelAsIs , Temperature)
TempCorNumbers <- c(TotalTempCor, EfakTempCor, WugeTempCor, TotalEtelTempCor, BlueEtelTempCor, RedEtelTempCor)
TempDF <- data.frame(TempCorNumbers, Names2)

# Monthly births in Chulwalar 
BirthsVector <- c(ImportedIndicators[44:55,2],ImportedIndicators[44:55,3],ImportedIndicators[44:55,4],ImportedIndicators[44:55,5],ImportedIndicators[44:55,6],ImportedIndicators[44:55,7])
Births <- ts(BirthsVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(Births, main="Births")

TotalBirthCor <- cor(TotalAsIs, Births)
EfakBirthCor <- cor(EfakAsIs , Births)
WugeBirthCor <- cor(WugeAsIs, Births)
TotalEtelBirthCor <- cor(TotalEtelAsIs, Births)
BlueEtelBirthCor <- cor(BlueEtelAsIs , Births)
RedEtelBirthCor <- cor(RedEtelAsIs , Births)
BirthCorNumbers <- c(TotalBirthCor, EfakBirthCor, WugeBirthCor, TotalEtelBirthCor, BlueEtelBirthCor, RedEtelBirthCor)
BirthDF <- data.frame(BirthCorNumbers, Names2)

# Monthly Satisfaction Index (SI) external index 
SIExternVector <- c(ImportedIndicators[58:69,2],ImportedIndicators[58:69,3],ImportedIndicators[58:69,4],ImportedIndicators[58:69,5],ImportedIndicators[58:69,6],ImportedIndicators[58:69,7])
SIExtern <- ts(SIExternVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(SIExtern, main="SIExtern")

TotalSIECor <- cor(TotalAsIs, SIExtern)
EfakSIECor <- cor(EfakAsIs , SIExtern)
WugeSIECor <- cor(WugeAsIs, SIExtern)
TotalEtelSIECor <- cor(TotalEtelAsIs, SIExtern)
BlueEtelSIECor <- cor(BlueEtelAsIs , SIExtern)
RedEtelSIECor <- cor(RedEtelAsIs , SIExtern)
SIECorNumbers <- c(TotalSIECor, EfakSIECor, WugeSIECor, TotalEtelSIECor, BlueEtelSIECor, RedEtelSIECor)
SIEDF <- data.frame(SIECorNumbers, Names2)

# Yearly exports from Urbano
UrbanoExportsVector <- c(ImportedIndicators[72:83,2],ImportedIndicators[72:83,3],ImportedIndicators[72:83,4],ImportedIndicators[72:83,5],ImportedIndicators[72:83,6],ImportedIndicators[72:83,7])
UrbanoExports <- ts(UrbanoExportsVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(UrbanoExports, main="UrbanoExports")

TotalExpCor <- cor(TotalAsIs, UrbanoExports)
EfakExpCor <- cor(EfakAsIs , UrbanoExports)
WugeExpCor <- cor(WugeAsIs, UrbanoExports)
TotalEtelExpCor <- cor(TotalEtelAsIs, UrbanoExports)
BlueEtelExpCor <- cor(BlueEtelAsIs , UrbanoExports)
RedEtelExpCor <- cor(RedEtelAsIs , UrbanoExports)
ExpCorNumbers <- c(TotalExpCor, EfakExpCor, WugeExpCor, TotalEtelExpCor, BlueEtelExpCor, RedEtelExpCor)
ExpDF <- data.frame(ExpCorNumbers, Names2)


# Yearly number of Globalisation Party members in Chulwalar
GlobalisationPartyMembersVector <- c(ImportedIndicators[86:97,2],ImportedIndicators[86:97,3],ImportedIndicators[86:97,4],ImportedIndicators[86:97,5],ImportedIndicators[86:97,6],ImportedIndicators[86:97,7])
GlobalisationPartyMembers <- ts(GlobalisationPartyMembersVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(GlobalisationPartyMembers, main="GlobalisationPartyMembers")

TotalGloCor <- cor(TotalAsIs, GlobalisationPartyMembers)
EfakGloCor <- cor(EfakAsIs , GlobalisationPartyMembers)
WugeGloCor <- cor(WugeAsIs, GlobalisationPartyMembers)
TotalEtelGloCor <- cor(TotalEtelAsIs, GlobalisationPartyMembers)
BlueEtelGloCor <- cor(BlueEtelAsIs , GlobalisationPartyMembers)
RedEtelGloCor <- cor(RedEtelAsIs , GlobalisationPartyMembers)
GloCorNumbers <- c(TotalGloCor, EfakGloCor, WugeGloCor, TotalEtelGloCor, BlueEtelGloCor, RedEtelGloCor)
GloDF <- data.frame(GloCorNumbers, Names2)


# Monthly Average Export Price Index for Chulwalar
AEPIVector <- c(ImportedIndicators[100:111,2],ImportedIndicators[100:111,3],ImportedIndicators[100:111,4],ImportedIndicators[100:111,5],ImportedIndicators[100:111,6],ImportedIndicators[100:111,7])
AEPI <- ts(AEPIVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(AEPI, main="AEPI")

TotalAEPICor <- cor(TotalAsIs, AEPI)
EfakAEPICor <- cor(EfakAsIs , AEPI)
WugeAEPICor <- cor(WugeAsIs, AEPI)
TotalEtelAEPICor <- cor(TotalEtelAsIs, AEPI)
BlueEtelAEPICor <- cor(BlueEtelAsIs , AEPI)
RedEtelAEPICor <- cor(RedEtelAsIs , AEPI)
AEPICorNumbers <- c(TotalAEPICor, EfakAEPICor, WugeAEPICor, TotalEtelAEPICor, BlueEtelAEPICor, RedEtelAEPICor)
AEPIDF <- data.frame(AEPICorNumbers, Names2)

# Monthly Producer Price Index (PPI) for Etel in Chulwalar
PPIEtelVector <- c(ImportedIndicators[114:125,2],ImportedIndicators[114:125,3],ImportedIndicators[114:125,4],ImportedIndicators[114:125,5],ImportedIndicators[114:125,6],ImportedIndicators[114:125,7])
PPIEtel <- ts(PPIEtelVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(PPIEtel, main="PPIEtel")

TotalPPICor <- cor(TotalAsIs, PPIEtel)
EfakPPICor <- cor(EfakAsIs , PPIEtel)
WugePPICor <- cor(WugeAsIs, PPIEtel)
TotalEtelPPICor <- cor(TotalEtelAsIs, PPIEtel)
BlueEtelPPICor <- cor(BlueEtelAsIs , PPIEtel)
RedEtelPPICor <- cor(RedEtelAsIs , PPIEtel)
PPICorNumbers <- c(TotalPPICor, EfakPPICor, WugePPICor, TotalEtelPPICor, BlueEtelPPICor, RedEtelPPICor)
PPIDF <- data.frame(PPICorNumbers, Names2)

# National Holidays
NationalHolidaysVector <- c(ImportedIndicators[170:181,2],ImportedIndicators[170:181,3],ImportedIndicators[170:181,4],ImportedIndicators[170:181,5],ImportedIndicators[170:181,6],ImportedIndicators[170:181,7])
NationalHolidays <- ts(NationalHolidaysVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(NationalHolidays, main="NationalHolidays")

TotalNatCor <- cor(TotalAsIs, NationalHolidays)
EfakNatCor <- cor(EfakAsIs , NationalHolidays)
WugeNatCor <- cor(WugeAsIs, NationalHolidays)
TotalEtelNatCor <- cor(TotalEtelAsIs, NationalHolidays)
BlueEtelNatCor <- cor(BlueEtelAsIs , NationalHolidays)
RedEtelNatCor <- cor(RedEtelAsIs , NationalHolidays)
NatCorNumbers <- c(TotalNatCor, EfakNatCor, WugeNatCor, TotalEtelNatCor, BlueEtelNatCor, RedEtelNatCor)
NatDF <- data.frame(NatCorNumbers, Names2)

# Chulwalar Index (Total value of all companies in Chulwalar)
ChulwalarIndexVector <- c(ImportedIndicators[128:139,2],ImportedIndicators[128:139,3],ImportedIndicators[128:139,4],ImportedIndicators[128:139,5],ImportedIndicators[128:139,6],ImportedIndicators[128:139,7])
ChulwalarIndex <- ts(ChulwalarIndexVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(ChulwalarIndex, main="ChulwalarIndex")

TotalIdxCor <- cor(TotalAsIs, ChulwalarIndex)
EfakIdxCor <- cor(EfakAsIs , ChulwalarIndex)
WugeIdxCor <- cor(WugeAsIs, ChulwalarIndex)
TotalEtelIdxCor <- cor(TotalEtelAsIs, ChulwalarIndex)
BlueEtelIdxCor <- cor(BlueEtelAsIs , ChulwalarIndex)
RedEtelIdxCor <- cor(RedEtelAsIs , ChulwalarIndex)
IdxCorNumbers <- c(TotalIdxCor, EfakIdxCor, WugeIdxCor, TotalEtelIdxCor, BlueEtelIdxCor, RedEtelIdxCor)
IdxDF <- data.frame(IdxCorNumbers, Names2)

# Monthly Inflation rate in Chulwalar 
InflationVector <- c(ImportedIndicators[142:153,2],ImportedIndicators[142:153,3],ImportedIndicators[142:153,4],ImportedIndicators[142:153,5],ImportedIndicators[142:153,6],ImportedIndicators[142:153,7])
Inflation <- ts(InflationVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(Inflation, main="Inflation")

TotalInfCor <- cor(TotalAsIs, Inflation)
EfakInfCor <- cor(EfakAsIs , Inflation)
WugeInfCor <- cor(WugeAsIs, Inflation)
TotalEtelInfCor <- cor(TotalEtelAsIs, Inflation)
BlueEtelInfCor <- cor(BlueEtelAsIs , Inflation)
RedEtelInfCor <- cor(RedEtelAsIs , Inflation)
InfCorNumbers <- c(TotalInfCor, EfakInfCor, WugeInfCor, TotalEtelInfCor, BlueEtelInfCor, RedEtelInfCor)
InfDF <- data.frame(InfCorNumbers, Names2)


# Proposed spending for Independence day presents
IndependenceDayPresentsVector <- c(ImportedIndicators[156:167,2],ImportedIndicators[156:167,3],ImportedIndicators[156:167,4],ImportedIndicators[156:167,5],ImportedIndicators[156:167,6],ImportedIndicators[156:167,7])
IndependenceDayPresents <- ts(IndependenceDayPresentsVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(IndependenceDayPresents, main="IndependenceDayPresents")

TotalIndCor <- cor(TotalAsIs, IndependenceDayPresents)
EfakIndCor <- cor(EfakAsIs , IndependenceDayPresents)
WugeIndCor <- cor(WugeAsIs, IndependenceDayPresents)
TotalEtelIndCor <- cor(TotalEtelAsIs, IndependenceDayPresents)
BlueEtelIndCor <- cor(BlueEtelAsIs , IndependenceDayPresents)
RedEtelIndCor <- cor(RedEtelAsIs , IndependenceDayPresents)
IndCorNumbers <- c(TotalIndCor, EfakIndCor, WugeIndCor, TotalEtelIndCor, BlueEtelIndCor, RedEtelIndCor)
IndDF <- data.frame(IndCorNumbers, Names2)

# Influence of National Holidays :
#This indicator is an experiment where the influence of National Holidays is 
#extended into the months leading up to the holiday. However later tests show 
#that this indicator is no better for forecasting than the orignial National 
#Holidays indicator.  

InfluenceNationalHolidaysVector <- c(ImportedIndicators[184:195,2],ImportedIndicators[184:195,3],ImportedIndicators[184:195,4],ImportedIndicators[184:195,5],ImportedIndicators[184:195,6],ImportedIndicators[184:195,7])
InfluenceNationalHolidays <- ts(InfluenceNationalHolidaysVector, start=c(2008,1), end=c(2013,12), frequency=12)
plot(InfluenceNationalHolidays, main="InfluenceNationalHolidays")

TotalIndCor2 <- cor(TotalAsIs, InfluenceNationalHolidays)
EfakIndCor2<- cor(EfakAsIs , InfluenceNationalHolidays)
WugeIndCor2 <- cor(WugeAsIs, InfluenceNationalHolidays)
TotalEtelIndCor2 <- cor(TotalEtelAsIs, InfluenceNationalHolidays)
BlueEtelIndCor2 <- cor(BlueEtelAsIs , InfluenceNationalHolidays)
RedEtelIndCor2<- cor(RedEtelAsIs , InfluenceNationalHolidays)
IndCorNumbers2 <- c(TotalIndCor2, EfakIndCor2, WugeIndCor2, TotalEtelIndCor2, BlueEtelIndCor2, RedEtelIndCor2)
IndDF2 <- data.frame(IndCorNumbers2, Names2)

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
