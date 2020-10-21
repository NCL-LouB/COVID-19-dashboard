library('ProjectTemplate')
load.project()


# ----- Traffic data  ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#traffic-national

# WHAT DOES THIS DATA SHOW?
# The change in motor vehicle traffic, relative to a baseline.

# Sunderland
ggplot(data = traffic, aes(Date, Sunderland)) +
  geom_line() +
  geom_point()

# South Tyneside
ggplot(data = traffic, aes(Date, South.Tyneside)) +
  geom_line() +
  geom_point()

# North Tyneside
ggplot(data = traffic, aes(Date, North.Tyneside)) +
  geom_line() +
  geom_point()

# Newcastle upon Tyne
ggplot(data = traffic, aes(Date, Newcastle.upon.Tyne)) +
  geom_line() +
  geom_point()

# Gateshead
ggplot(data = traffic, aes(Date, Gateshead)) +
  geom_line() +
  geom_point()

# Northumberland
ggplot(data = traffic, aes(Date, Northumberland)) +
  geom_line() +
  geom_point()

# THINGS TO NOTE
# Missing data for days 17-18 March and 10 May. Do we know why this data is missing? Can I find it somewhere else? 
# I assume these are the median values across the region? Where can I get the data for the specific locations, 
# which is also plotted on the graphs on this page: https://covid.view.urbanobservatory.ac.uk/#traffic-national? 
# When we get the new data for the specific locations I would also like to have a geographic reference for the location.





# ----- Car Park Data 1 ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#car-parks-6mo

# WHAT DOES THIS DATA SHOW?
# The below charts are expressed in vehicle-hours, meaning each vehicle being parked 
# is multiplied by the duration of its stay.

# Create a column of cumulative occupancy for each car park so the daily occupancy hours can be
# calculated by multiplying the total number by 15 (minutes)

# pivot table
carparkLONG = pivot_longer(
  carpark, 
  cols = -c("time", "Date"),
  names_to = "Car.Park",
  values_to = "Car.Counts")

# Add additonal date options with lubridate
carparkLONG$just.hour = hour(carparkLONG$Date)
carparkLONG$just.minute = minute(carpark$Date)
carparkLONG$just.day = day(carparkLONG$Date)
carparkLONG$just.dayofweek = wday(carparkLONG$Date) # numbered 1,2,3
carparkLONG$just.dayofweek2 = wday(carparkLONG$Date, label=TRUE) #Monday, Tuesday etc
carparkLONG$just.month = month(carparkLONG$Date) # numbered 1,2,3
carparkLONG$just.month2 = month(carparkLONG$Date, label=TRUE) # January, February etc
carparkLONG$just.week = week(carparkLONG$Date)
carparkLONG$just.year = year(carparkLONG$Date)
carparkLONG$just.date = date(carparkLONG$Date)
carparkLONG$wkend = ifelse(carparkLONG$just.dayofweek %in% c(1, 7), "weekend", "weekday")
carparkLONG$wkend = as.factor(carparkSummary$wkend)

# Calculate the daily car counts, daily minutes and daily hours
carparkSummary = carparkLONG %>%
  group_by(Car.Park, just.date, Car.Counts) %>%
  summarise(
    daily.car.counts = sum(Car.Counts),
    daily.minutes = daily.car.counts*15,
    daily.hours = daily.minutes/60
  )

# add additional date columns
carparkSummary$just.day = day(carparkSummary$just.date)
carparkSummary$just.month = month(carparkSummary$just.date)
carparkSummary$just.year = year(carparkSummary$just.date)
carparkSummary$just.dayofweek = wday(carparkSummary$just.date)
carparkSummary$just.dayofweek2 = wday(carparkSummary$just.date, label=TRUE)
carparkSummary$wkend = ifelse(carparkSummary$just.dayofweek %in% c(1, 7), "weekend", "weekday")
carparkSummary$wkend = as.factor(carparkSummary$wkend)


###### WHAT TO DO WITH MISSING VALUES?????
# Daily total vehicle-hours during the last six months
# Quarryfield.Road (NE8 555 spaces) **************** DID NOT WORK ****************
carparkSummary %>%
  filter(Car.Park == "Quarryfield.Road" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Eldon.Square (NE1 497 spaces)
carparkSummary %>%
  filter(Car.Park == "Eldon.Square" & just.year == 2020) %>%
ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Manors (NE1 484 spaces)
carparkSummary %>%
  filter(Car.Park == "Manors" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Four.Lane.Ends.Interchange (NE12 475 spaces)
carparkSummary %>%
  filter(Car.Park == "Four.Lane.Ends.Interchange" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Gateshead.Civic.Centre (NE8 450 spaces)
carparkSummary %>%
  filter(Car.Park == "Gateshead.Civic.Centre" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Eldon.Garden (NE1 449 spaces)
carparkSummary %>%
  filter(Car.Park == "Eldon.Garden" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Heworth.Interchange.(Long.Stay) (NE10 413 spaces)
carparkSummary %>%
  filter(Car.Park == "Eldon.Garden" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Heworth.Interchange.(Short.Stay) (NE10 64 spaces)
carparkSummary %>%
  filter(Car.Park == "Heworth.Interchange.(Short.Stay)" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Grainger.Town (NE1 410 spaces)
carparkSummary %>%
  filter(Car.Park == "Grainger.Town" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Northumberland.Park.Metro (NE27 405 spaces)
carparkSummary %>%
  filter(Car.Park == "Northumberland.Park.Metro" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Sage.Gateshead (NE8 285 spaces)
carparkSummary %>%
  filter(Car.Park == "Sage.Gateshead" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Mill.Road (NE8 283 spaces)
carparkSummary %>%
  filter(Car.Park == "Mill.Road" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Dean.Street (NE1 257 spaces)
carparkSummary %>%
  filter(Car.Park == "Dean.Street" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Gateshead.College (NE8 226 spaces)
carparkSummary %>%
  filter(Car.Park == "Gateshead.College" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Claremont.Road (NE2 225 spaces) **************** DID NOT WORK ****************
carparkSummary %>%
  filter(Car.Park == "Claremont.Road" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Callerton.Parkway.Metro (NE13 192 spaces)
carparkSummary %>%
  filter(Car.Park == "Callerton.Parkway.Metro" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Regent.Centre.Interchange (NE3 183 spaces)
carparkSummary %>%
  filter(Car.Park == "Regent.Centre.Interchange" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Stadium.of.Light.Metro (SR5 182 spaces)
carparkSummary %>%
  filter(Car.Park == "Stadium.of.Light.Metro" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Ellison.Place (NE1 126 spaces)
carparkSummary %>%
  filter(Car.Park == "Ellison.Place" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Kingston.Park.Metro (NE3 95 spaces)
carparkSummary %>%
  filter(Car.Park == "Kingston.Park.Metro" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# East.Boldon.Metro (NE36 75 spaces)
carparkSummary %>%
  filter(Car.Park == "East.Boldon.Metro" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# BALTIC (NE8 71 spaces)
carparkSummary %>%
  filter(Car.Park == "BALTIC" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Bank.Foot.Metro (NE13 62 spaces)
carparkSummary %>%
  filter(Car.Park == "Bank.Foot.Metro" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Swinburne.Street (NE8 57 spaces)
carparkSummary %>%
  filter(Car.Park == "Swinburne.Street" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Fellgate.Metro (NE32 54 spaces)
carparkSummary %>%
  filter(Car.Park == "Fellgate.Metro" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Old.Town.Hall (NE8 53 spaces)
carparkSummary %>%
  filter(Car.Park == "Old.Town.Hall" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Church.Street (NE8 43 spaces)
carparkSummary %>%
  filter(Car.Park == "Church.Street" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

# Charles.Street (NE8 27 spaces)
carparkSummary %>%
  filter(Car.Park == "Charles.Street" & just.year == 2020) %>%
  ggplot(aes(x=just.date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")



# THINGS TO NOTE
# You said their are a couple of exceptions to the car park data, which only
# count vehicles out, such as Mill Road car park. Please can you provide a list of
# all the exceptions?




# ----- Car Park Data 2 ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#car-parks-6wk

# WHAT DOES THIS DATA SHOW?
# The plots below show the profile of the car park occupancy within a 6 week period 

# Quarryfield.Road (NE8 555 spaces) **************** DID NOT WORK ****************
# Warning message:
# Removed 5429 rows containing missing values (position_stack). 
carparkLONG %>%
  filter(Car.Park == "Quarryfield.Road" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Eldon.Square (NE1 497 spaces)
carparkLONG %>%
  filter(Car.Park == "Eldon.Square" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Manors (NE1 484 spaces)
carparkLONG %>%
  filter(Car.Park == "Manors" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Four.Lane.Ends.Interchange (NE12 475 spaces)
carparkLONG %>%
  filter(Car.Park == "Four.Lane.Ends.Interchange" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Gateshead.Civic.Centre (NE8 450 spaces)
carparkLONG %>%
  filter(Car.Park == "Gateshead.Civic.Centre" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Eldon.Garden (NE1 449 spaces)
carparkLONG %>%
  filter(Car.Park == "Eldon.Garden" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Heworth.Interchange.(Long.Stay) (NE10 413 spaces)
carparkLONG %>%
  filter(Car.Park == "Heworth.Interchange.(Long.Stay)" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Heworth.Interchange.(Short.Stay) (NE10 64 spaces)
carparkLONG %>%
  filter(Car.Park == "Heworth.Interchange.(Short.Stay)" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Grainger.Town (NE1 410 spaces) **************** DID NOT WORK ****************
# Warning message:
# Removed 5429 rows containing missing values (position_stack).
carparkLONG %>%
  filter(Car.Park == "Grainger.Town" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Northumberland.Park.Metro (NE27 405 spaces)
carparkLONG %>%
  filter(Car.Park == "Northumberland.Park.Metro" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Sage.Gateshead (NE8 285 spaces)
carparkLONG %>%
  filter(Car.Park == "Sage.Gateshead" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Mill.Road (NE8 283 spaces)
carparkLONG %>%
  filter(Car.Park == "Mill.Road" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Dean.Street (NE1 257 spaces)
carparkLONG %>%
  filter(Car.Park == "Dean.Street" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Gateshead.College (NE8 226 spaces)
carparkLONG %>%
  filter(Car.Park == "Gateshead.College" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Claremont.Road (NE2 225 spaces) **************** DID NOT WORK ****************
# Warning message:
# Removed 5429 rows containing missing values (position_stack).
carparkLONG %>%
  filter(Car.Park == "Claremont.Road" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Callerton.Parkway.Metro (NE13 192 spaces)
carparkLONG %>%
  filter(Car.Park == "Callerton.Parkway.Metro" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Regent.Centre.Interchange (NE3 183 spaces)
carparkLONG %>%
  filter(Car.Park == "Regent.Centre.Interchange" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Stadium.of.Light.Metro (SR5 182 spaces)
carparkLONG %>%
  filter(Car.Park == "Stadium.of.Light.Metro" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Ellison.Place (NE1 126 spaces)
carparkLONG %>%
  filter(Car.Park == "Ellison.Place" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Kingston.Park.Metro (NE3 95 spaces)
carparkLONG %>%
  filter(Car.Park == "Kingston.Park.Metro" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# East.Boldon.Metro (NE36 75 spaces)
carparkLONG %>%
  filter(Car.Park == "East.Boldon.Metro" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# BALTIC (NE8 71 spaces)
carparkLONG %>%
  filter(Car.Park == "BALTIC" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Bank.Foot.Metro (NE13 62 spaces)
carparkLONG %>%
  filter(Car.Park == "Bank.Foot.Metro" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Swinburne.Street (NE8 57 spaces)
carparkLONG %>%
  filter(Car.Park == "Swinburne.Street" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Fellgate.Metro (NE32 54 spaces)
carparkLONG %>%
  filter(Car.Park == "Fellgate.Metro" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Old.Town.Hall (NE8 53 spaces)
carparkLONG %>%
  filter(Car.Park == "Old.Town.Hall" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Church.Street (NE8 43 spaces)
carparkLONG %>%
  filter(Car.Park == "Church.Street" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Charles.Street (NE8 27 spaces)
carparkLONG %>%
  filter(Car.Park == "Charles.Street" & just.year == 2020 & just.month %in% c(5, 6)) %>%
  ggplot(aes(x=time, y=Car.Counts, fill = wkend)) +
  geom_bar(stat = "identity")

# Three of the car parks are not working: Quarryfield.Road, Grainger.Town and Claremont.Road. 
# This is because there is no data for these car parks... they do have data on the UO dashboard
# so try to download the data again?
# All the car parks have some NAs. Need to decide how to treat them. 
<<<<<<< HEAD




# ----- Pedestrian flows: Summary (Newcastle upon Tyne) ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#pedestrian-flows-summary

# WHAT DOES THIS DATA SHOW?
# 


# pivot table
pedestrian.flow.LONG = pivot_longer(
  pedestrian.flow, 
  cols = -c("Timestamp"),
  names_to = "location",
  values_to = "pedestrian.counts")

# Add additonal date options with lubridate
pedestrian.flow.LONG$Date = ymd_hms(pedestrian.flow.LONG$Timestamp)
pedestrian.flow.LONG$just.hour = hour(pedestrian.flow.LONG$Date)
pedestrian.flow.LONG$just.minute = minute(pedestrian.flow.LONG$Date)
pedestrian.flow.LONG$just.day = day(pedestrian.flow.LONG$Date)
pedestrian.flow.LONG$just.dayofweek = wday(pedestrian.flow.LONG$Date) # numbered 1,2,3
pedestrian.flow.LONG$just.dayofweek2 = wday(pedestrian.flow.LONG$Date, label=TRUE) #Monday, Tuesday etc
pedestrian.flow.LONG$just.month = month(pedestrian.flow.LONG$Date) # numbered 1,2,3
pedestrian.flow.LONG$just.month2 = month(pedestrian.flow.LONG$Date, label=TRUE) # January, February etc
pedestrian.flow.LONG$just.week = week(pedestrian.flow.LONG$Date)
pedestrian.flow.LONG$just.year = year(pedestrian.flow.LONG$Date)
pedestrian.flow.LONG$just.date = date(pedestrian.flow.LONG$Date)
pedestrian.flow.LONG$wkend = ifelse(pedestrian.flow.LONG$just.dayofweek %in% c(1, 7), "weekend", "weekday")
pedestrian.flow.LONG$wkend = as.factor(pedestrian.flow.LONG$wkend)


# Categorise the time into morning peak (07:00-09:59), inter-peak (10:00-15:59), evening peak (16:00-18:59) and night (19:00-06:59)
# Create function to get the time category
getTimeCat <- function(x) {
  if (x %in% c(7, 8, 9)) {
    return("morning.peak")
  } else if (x %in% c(10, 11, 12, 13, 14, 15)) {
    return("inter.peak")
  } else if (x %in% c(16, 17, 18)) {
    return("evening.peak")
  } else
    return("night")
}
# Apply function and create new column of time categories
pedestrian.flow.LONG$timecat = sapply(pedestrian.flow.LONG$just.hour, getTimeCat)
pedestrian.flow.LONG$timecat = as.factor(pedestrian.flow.LONG$timecat)

# Categorise the locations into directions eg. walking north, walking south or walking east, walking west
pedestrian.flow.LONG$direction = str_sub(pedestrian.flow.LONG$location,-13,-1)
pedestrian.flow.LONG$direction = gsub("[.]","",pedestrian.flow.LONG$direction)

# Calculate the hourly average flow

ped.flow.Summary = pedestrian.flow.LONG %>%
  group_by(location, timecat, just.date) %>%
  summarise(
    timecat.counts = sum(pedestrian.counts)
  )

hourlyAV <- function(x, timecat) {
  if (timecat == "morning.peak") {
    return(x/3)
  } else if (timecat == "inter.peak") {
    return(x/6)
  } else if (timecat == "evening.peak") {
    return(x/3)
  } else
    return(x/12)
}

ped.flow.Summary$hourlyAverage = round(mapply(hourlyAV, x = ped.flow.Summary$timecat.counts, timecat = ped.flow.Summary$timecat), digits = 0)

# Calculate the percentage change from the day before and the week before
ped.flow.Summary2 = ped.flow.Summary %>%
  mutate(daylag = dplyr::lag(hourlyAverage, 1),
         weeklag = dplyr::lag(hourlyAverage, 7),
         daily.pc = round((hourlyAverage-daylag)/hourlyAverage *100, digits = 0),
         weekly.pc = round((hourlyAverage-weeklag)/hourlyAverage *100, digits = 0)
         )


# Split into location directions
# unique(ped.flow.Summary2$location)
#[Bstreet.WN] "Blackett.St.crossing.from.John.Dobson.St.to.Northumberland.St..west.side...Walking.North"  
#[Bstreet.WS] "Blackett.St.crossing.from.John.Dobson.St.to.Northumberland.St..west.side...Walking.South"  
#[JDstreet.ES.WN] "John.Dobson.St..east.side..pavement.near.The.Stack..Walking.North"                         
#[JDstreet.ES.WS] "John.Dobson.St..east.side..pavement.near.The.Stack..Walking.South"                         
#[JDstreet.WS.WN] "John.Dobson.St..west.side..pavement.near.Goldsmiths..Walking.North"                        
#[JDstreet.WS.WS] "John.Dobson.St..west.side..pavement.near.Goldsmiths..Walking.South"                        
#[JDstreet.WE] "John.Dobson.St.crossing.island.between.Blackett.St.and.New.Bridge.St.West..Walking.East"   
#[JDstreet.WW] "John.Dobson.St.crossing.island.between.Blackett.St.and.New.Bridge.St.West..Walking.West"   
#[NBstreet.WN] "New.Bridge.St.West.crossing.John.Dobson.St.to.Northumberland.St..east.side...Walking.North"
#[NBstreet.WS] "New.Bridge.St.West.crossing.John.Dobson.St.to.Northumberland.St..east.side...Walking.South"
#[Nstreet.ES.WN] "Northumberland.St.near.Fenwick..east.side...Walking.North"                                 
#[Nstreet.ES.WS] "Northumberland.St.near.Fenwick..east.side...Walking.South"                                 
#[Nstreet.WS.WN] "Northumberland.St.near.Fenwick..west.side...Walking.North"                                 
#[Nstreet.WS.WS] "Northumberland.St.near.Fenwick..west.side...Walking.South"                                 
#[Nstreet.WN] "Northumberland.St.near.TK.Maxx..Walking.North"                                             
#[Nstreet.WS] "Northumberland.St.near.TK.Maxx..Walking.South"                                             
#[P.SS.WNa] "Pavement..south.side..corner.John.Dobson.St.and.Blackett.St..Walking.North"                
#[P.SS.WSa] "Pavement..south.side..corner.John.Dobson.St.and.Blackett.St..Walking.South"                
#[P.SS.WNb] "Pavement..south.side..corner.John.Dobson.St.and.New.Bridge.St.West..Walking.North"         
#[P.SS.WSb] "Pavement..south.side..corner.John.Dobson.St.and.New.Bridge.St.West..Walking.South"         
#[SS.WE] "Science.Square.at.Newcastle.Helix..Walking.East"                                           
#[SS.WW] "Science.Square.at.Newcastle.Helix..Walking.West" 



# Calculate the percentage change from annual average
HOW HELPFUL IS THIS STATISTIC?

