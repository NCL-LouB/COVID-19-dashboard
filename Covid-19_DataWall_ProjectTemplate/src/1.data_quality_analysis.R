library('ProjectTemplate')
load.project()


# Data quality of the original 8 data sources

# Load the files
# GOV.UK
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/cases.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/deaths.RData")

# Urban Observatory
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/mediantraffic.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/anpr.volumes.point.meta.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/anpr.volumes.16min.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carpark.meta.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carpark.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/pedestrian.flow.RData")


# How many upper-tier local authorities and lower-tier local authorities are there?
test = filter(cases, area.type == "utla")
length(unique(test$name))
test = filter(cases, area.type == "ltla")
length(unique(test$name))
# utla = 149, ltla = 315

# Step 1a: Check for Missing Data: Cases
sum(is.na(cases))
# There are 164862 values missing from the cases data set
# View which values are missing
apply(is.na(cases), 2, which)
# A. The same values are missing for variables cases.daily, cases.cumulative and cases.rate
# B. There are a large amount of na for cases.dailyPublish and cases.cumulativePublish. 
# This is because the values are only provided for the UK and nation areaTypes. 
# C. There is missing population data. This no longer matters, as the rate data is now provided via the api 
# and so it does not need to be calculated separately 

# A. which variables are missing from cases.daily, cases.cumulative and cases.rate  
sum(is.na(cases$cases.daily)) 
sum(is.na(cases$cases.cumulative))
sum(is.na(cases$cases.rate))
# 375 values are missing from each column 
# Pull out the values and confirm that they are the same values for each column
missingcol5 = which(is.na(cases[ , 5]))
missingcol6 = which(is.na(cases[ , 6]))
missingcol7 = which(is.na(cases[ , 7]))
missingcol5 == missingcol6
missingcol6 == missingcol7
# They are the same

# Create a date frame of the observations with the missing values
missingcol567 = cases[missingcol5,]
# The missing values are only for areaTypes UK and nation 
# There is no data for UK. This missing values for the nations appear to be before they receive there first case so it is ok that they are NAs
# This is ok, as the dashboard will not use the UK overview data and the nation data can use the cases.dailyPublish and cases.cumulativePublish variables

# B. which variables are missing from cases.dailyPublish and cases.cumulativePublish  
sum(is.na(cases$cases.dailyPublish)) 
sum(is.na(cases$cases.cumulativePublish))
# 81392 is missing from cases.dailyPublish and 81624 from cases.cumulativePublish
# This data will only be used for the nations so filter by area.type == "nation" and review NAs again
PublishCases = filter(cases, area.type == "nation")
sum(is.na(PublishCases$cases.dailyPublish)) 
sum(is.na(PublishCases$cases.cumulativePublish))
# 0 is missing from cases.dailyPublish and 206 from cases.cumulativePublish
# the 206 missing values are equivalent to 0 becauase there were no reported cases 

# C. which variables are missing from population
sum(is.na(cases$population)) 
# 721 values are missing from the population data
missingpop = which(is.na(cases[ , 11]))
# Create a date frame of the observations with the missing values
missingpopdata = cases[missingpop,]
# This data is not going to be used so no furthe work is needed.




# Step 1b: Check for Missing Data: Deaths
sum(is.na(deaths))
# There are 0 values missing from the deaths data set. This is because the missing variables 
# were addressed at the munge stage and missing values were manually inputted




# Step 1c: Check for Missing Data: mediantraffic
sum(is.na(mediantraffic))
# There are 24 values missing from the mediantraffic data set
# View which values are missing
apply(is.na(mediantraffic), 2, which)
# The same values are missing for Sunderland, South.Tyneside, North.Tyneside, Newcastle.upon.Tyne, 
# Gateshead and Northumberland observations 17,18,72 and 141. As this data has been previously processed by the
# Urban Observatory, we have to assumed that this is due to data quality issues that they dealt with by not 
# using data on these days: 2020-03-17, 2020-03-18, 2020-05-10 and 2020-07-18
mediantraffic[c(17, 18,72, 141),]



# Step 1d: Check for Missing Data: anpr.volumes.point.meta 
sum(is.na(anpr.volumes.point.meta))
# There are 0 values missing from the anpr.volumes.point.meta data set




# Step 1e: Check for Missing Data: anpr.volumes.16min 
sum(is.na(anpr.volumes.16min))
# There are 0 values missing from the anpr.volumes.16min data set




# Step 1f: Check for Missing Data: carpark.meta 
sum(is.na(carpark.meta))
# There are 3 values missing from the carpark.meta data set
# View which values are missing
apply(is.na(carpark.meta), 2, which)
# These refer to missing id numbers. We do not use this data so we can ignore these NAs




# Step 1g: Check for Missing Data: carpark
sum(is.na(carpark))
# There are 41703 values missing from the carpark data set
# View which values are missing
apply(is.na(carpark), 2, which)


# Step 1h: Check for Missing Data: pedestrian.flow
sum(is.na(pedestrian.flow))
# There are 21835 values missing from the pedestrian.flow data set

