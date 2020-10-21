library('ProjectTemplate')
load.project()

load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/deaths.RData")


# The 'publish' data is only available for the nations NOT regions

# View the structure of the data
str(deaths)

table(deaths$area.type)
# For the death data there are 2210 observations. 1533 are regional observations 677 are national observations.

# Check for missing values in the death data by publish date metrics
sum(is.na(deaths$deaths.dailypublish)) # 1548 NAs
sum(is.na(deaths$deaths.cumulativepublish)) # 1554 NAs
sum(is.na(deaths$deaths.ratepublish)) # 1554 NAs
# It looks like the publish data is missing for all the regional observations plus some of the national observations.

# filter by regions
test = filter(deaths, area.type == "region")
sum(is.na(test$deaths.dailypublish)) # 1524 NAs
sum(is.na(test$deaths.cumulativepublish)) # 1533 NAs
sum(is.na(test$deaths.ratepublish)) # 1533 NAs
# Almost all of the publish values are missing and so they cannot be used for the regions. 
table(test$name)

# filter by nations
test = filter(deaths, area.type == "nation")
sum(is.na(test$deaths.dailypublish)) # 24 NAs
sum(is.na(test$deaths.cumulativepublish)) # 21 NAs
sum(is.na(test$deaths.ratepublish)) # 21 NAs
# The missing values are located at the start of the Covid-19 period when there were no deaths to report.

# Check for missing values in the death data by date of death metrics
sum(is.na(deaths$deaths.daily)) # 67 NAs
sum(is.na(deaths$deaths.cumulative)) # 12 NAs
sum(is.na(deaths$deaths.rate)) # 12 NAs

# The 12 NAs for cumulative and rate are from the 24 August 2020. As there is a delay with with date of death 
# data it may make sense to only report up to the week prior to the data being pulled. This would mean the data 
# will need to be filtered to remove any observations from before 24/08 minus 1 week (17/08).


###### ADDITIONAL DATA PREPARATION
# 1. Remove the publish columns 
# 2. Remove observations after the 17 August 2020


# Check for missing values in the death data by date of death metrics
sum(is.na(deaths$deaths.daily)) # 49 NAs
sum(is.na(deaths$deaths.cumulative)) # 0 NAs
sum(is.na(deaths$deaths.rate)) # 0 NAs

# Need to understand the NAs for deaths.daily
#filter by area.type and name to inspect the individual areas

# NATIONS
# Scotland
test = filter(deaths, area.type == "nation" & name == "Scotland")
sum(is.na(test$deaths.daily)) # 1 NAs
# Starting date: 	2020-02-28 
# First death: 2020-03-12
# This NA should be a 0

# England
test = filter(deaths, area.type == "nation" & name == "England")
sum(is.na(test$deaths.daily)) # 3 NAs
# Starting date: 	2020-03-02
# First death: 2020-03-02
# These 3 NAs appear like they could be updated to 0. The related cumulative values also need fixing, as they are 0. 

# Wales
test = filter(deaths, area.type == "nation" & name == "Wales")
sum(is.na(test$deaths.daily)) # 0 NAs
# Starting date: 	2020-03-16
# First death: 2020-03-16

# Northern Ireland
test = filter(deaths, area.type == "nation" & name == "Northern Ireland")
sum(is.na(test$deaths.daily)) # 0 NAs
# Starting date: 	2020-03-18
# First death: 2020-03-18





# REGIONS
# East Midlands
test = filter(deaths, area.type == "region" & name == "East Midlands")
sum(is.na(test$deaths.daily)) # 11 NAs
# Starting date: 	2020-03-03
# First death: 2020-03-03


# East of England
test = filter(deaths, area.type == "region" & name == "East of England")
sum(is.na(test$deaths.daily)) # 10 NAs
# Starting date: 	2020-03-02
# First death: 2020-03-02
# These 10 NAs appear like they could be updated to 0. The related cumulative values also need fixing, as they are 0. 


# London
test = filter(deaths, area.type == "region" & name == "London")
sum(is.na(test$deaths.daily)) # 0 NAs
# Starting date: 	2020-03-09
# First death: 2020-03-09


# North East
test = filter(deaths, area.type == "region" & name == "North East")
sum(is.na(test$deaths.daily)) # 5 NAs
# Starting date: 	2020-03-15
# First death: 2020-03-15
# These 5 NAs appear like they could be updated to 0. The related cumulative values also need fixing, as they are 0. 

# North West
test = filter(deaths, area.type == "region" & name == "North West")
sum(is.na(test$deaths.daily)) # 3 NAs
# Starting date: 	2020-03-08
# First death: 2020-03-08
# These 3 NAs appear like they could be updated to 0. The related cumulative values also need fixing, as they are 0. 

# South East
test = filter(deaths, area.type == "region" & name == "South East")
sum(is.na(test$deaths.daily)) # 4 NAs
# Starting date: 	2020-03-03
# First death: 2020-03-03
# These 4 NAs appear like they could be updated to 0. The related cumulative values also need fixing, as they are 0. 

# South West
test = filter(deaths, area.type == "region" & name == "South West")
sum(is.na(test$deaths.daily)) # 8 NAs
# Starting date: 	2020-03-09
# First death: 2020-03-09
# These 8 NAs appear like they could be updated to 0. The related cumulative values also need fixing, as they are 0. 


# West Midlands
test = filter(deaths, area.type == "region" & name == "West Midlands")
sum(is.na(test$deaths.daily)) # 2 NAs
# Starting date: 	2020-03-08
# First death: 2020-03-08
# These 2 NAs appear like they could be updated to 0. The related cumulative values also need fixing, as they are 0. 


# Yorkshire and The Humber 
test = filter(deaths, area.type == "region" & name == "Yorkshire and The Humber")
sum(is.na(test$deaths.daily)) # 2 NAs
# Starting date: 	2020-03-12
# First death: 2020-03-12
# These 2 NAs appear like they could be updated to 0. The related cumulative values also need fixing, as they are 0. 

###### ADDITIONAL DATA PREPARATION
# Update all the NA values and their corresponding cumulative values.

# Check for missing values in the death data by date of death metrics
sum(is.na(deaths$deaths.daily)) # 0 NAs
# There are now 0 NA values


# Initial questions
# What date was the first recorded death in each nation and English region?
test = deaths %>% filter(area.type == "nation" & deaths.cumulative == 1 & deaths.daily == 1) %>%
  group_by(date) %>%
  arrange(date)

test = deaths %>% filter(area.type == "region" & deaths.cumulative == 1 & deaths.daily == 1) %>%
  group_by(date) %>%
  arrange(date)


#Nation or region | Name | Date of first recorded death | Number of deaths recorded on this day
#------------- | ------------- | ------------- | ------------- 
#Nation | England | 2020-03-02 | 1
#Region | East of England | 2020-03-02 | 1
#Region | East Midlands | 2020-03-03 | 1
#Region | South East | 2020-03-03 | 1
#Region | North West | 2020-03-08 | 1
#Region | West Midlands | 2020-03-08 | 1
#Region | London | 2020-03-09 | 2
#Region | South West | 2020-03-09 | 1
#Region | Yorkshire and The Humber | 2020-03-12 | 1
#Nation | Scotland | 2020-03-12 | 1
#Region | North East | 2020-03-15 | 1
#Nation | Wales | 2020-03-16 | 3
#Nation | Northern Ireland | 2020-03-18 | 1





# Plot the daily deaths by nation and region
ggplot(filter(deaths, area.type == "nation")) +
  geom_line(aes(x = date, y = deaths.daily, color = name))

ggplot(filter(deaths, area.type == "region")) +
  geom_line(aes(x = date, y = deaths.daily, color = name))


# Plot the cumulative deaths by nation and region
ggplot(filter(deaths, area.type == "nation")) +
  geom_line(aes(x = date, y = deaths.cumulative, color = name))

ggplot(filter(deaths, area.type == "region")) +
  geom_point(aes(x = date, y = deaths.cumulative, color = name))
# This plot is funny, check the data (there appears to be zero values where there should not be)


# Plot the rate of deaths per 100,000 people of the population by nation and region
ggplot(filter(deaths, area.type == "nation")) +
  geom_line(aes(x = date, y = deaths.ratepubl, color = name))

ggplot(filter(deaths, area.type == "region")) +
  geom_point(aes(x = date, y = deaths.rate, color = name))
# This plot is funny, check the data (there appears to be zero values where there should not be)


# Questions
# Which country had the most deaths?
# Which region had the most deaths?

deaths %>% filter(date == "2020-08-23" & area.type == "nation") %>%
  select(name, deaths.cumulative, deaths.rate) %>%
  arrange(desc(deaths.rate))


deaths %>% filter(date == "2020-08-23" & area.type == "region") %>%
  select(name, deaths.cumulative, deaths.rate) %>%
  arrange(desc(deaths.rate))

# Which region has recorded the most deaths in a single day?
deaths %>% filter(area.type == "region") %>%
  group_by(name) %>%
  summarise(worst.day = max(deaths.daily, na.rm = TRUE)) %>%
  arrange(desc(worst.day))
