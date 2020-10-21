library('ProjectTemplate')
load.project()

load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/health.RData")

# View the structure of the data
str(health)

# Patients admitted to hospital
# Daily and cumulative numbers of COVID-19 patients admitted to hospital. 
# Data are not updated every day by all four nations and the figures for 
# Wales are not comparable to those for other nations as Wales include 
# suspected COVID-19 patients while the other nations include only confirmed cases.
# METRICS USED:
# newAdmissions
# cumAdmissions

# Patients in hospital
# Daily count of confirmed COVID-19 patients in hospital at midnight the preceding 
# night. Data are not updated every day.
# METRIC USED:
# hospitalCases

# Patients in mechanical ventilation beds
# Daily count of confirmed COVID-19 patients in mechanical ventilation beds. 
# Data are not updated every day.
# METRIC USED:
# covidOccupiedMVBeds


table(health$area.type)
# For the death data there are 1773 observations. 1113 are nhs regional observations 660 are national observations.

# Check for missing values 
sum(is.na(health$health.newadmissions)) # 28 NAs
sum(is.na(health$health.cumadmissions)) # 28 NAs
sum(is.na(health$health.occbeds)) # 151 NAs
sum(is.na(health$health.hospitalcases)) # 35 NAs
sum(is.na(health$health.plannedcapacity)) # 1773 NAs THERE IS NO DATA FOR THIS METRIC REMOVE FROM DATAFRAME

# Let's investigate the NAs

# As the Scotland data is only released weekly, data is only available until the 19-08-2020. So we can filter the data to 
# remove observations after 19 August.

###### ADDITIONAL DATA PREPARATION
# 1. Remove the health.plannedcapacity column 
# 2. Remove observations after the 19 August 2020


# Check for missing values again
sum(is.na(health$health.newadmissions)) # 8 NAs
sum(is.na(health$health.cumadmissions)) # 8 NAs
sum(is.na(health$health.occbeds)) # 151 NAs
sum(is.na(health$health.hospitalcases)) # 34 NAs

# Why are there 8 NAs for health.newadmissions and health.cumadmissions
# filter by area.type and name to inspect the individual areas

# NATION
# Scotland
test = filter(health, area.type == "nation" & name == "Scotland")
sum(is.na(test$health.newadmissions)) # 7 NAs
# Not sure why these values were not pulled through the api. They have been manually upated

# Northern Ireland
test = filter(health, area.type == "nation" & name == "Northern Ireland")
sum(is.na(test$health.newadmissions)) # 1 NAs
# Not sure why these values were not pulled through the api. They have been manually upated

# Why are there 34 NAs for health.hospitalcases
# There is missing data for earlier dates (March 2020). This is probably, as the reporting was just being established. 
# These values should remain as NAs

# Why are there 151 NAs for health.occbeds
# There is missing data for earlier dates (March and early April 2020). This is probably, 
# as the reporting was just being established. These values should remain as NAs.


# Plot the new admissions by nation and region
ggplot(filter(health, area.type == "nation")) +
  geom_line(aes(x = date, y = health.newadmissions, color = name))

ggplot(filter(health, area.type == "nhsregion")) +
  geom_line(aes(x = date, y = health.newadmissions, color = name))


# Plot the cumulative admissions by nation and region
ggplot(filter(health, area.type == "nation")) +
  geom_line(aes(x = date, y = health.cumadmissions, color = name))

ggplot(filter(health, area.type == "nhsregion")) +
  geom_line(aes(x = date, y = health.cumadmissions, color = name))


# Plot the occupied beds by nation and region
ggplot(filter(health, area.type == "nation")) +
  geom_line(aes(x = date, y = health.occbeds, color = name))

ggplot(filter(health, area.type == "nhsregion")) +
  geom_line(aes(x = date, y = health.occbeds, color = name))


# Plot the hospital cases by nation and region
ggplot(filter(health, area.type == "nation")) +
  geom_line(aes(x = date, y = health.hospitalcases , color = name))

ggplot(filter(health, area.type == "nhsregion")) +
  geom_line(aes(x = date, y = health.hospitalcases , color = name))
