library('ProjectTemplate')
load.project()


# ----- Car Park Data 1 ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#car-parks-6mo

# Load the data from cache folder
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carpark.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carparkLONG.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carparkSummary.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carparkSummaryShort.RData")


# WHAT DOES THIS DATA SHOW?
# The below charts are expressed in vehicle-hours, meaning each vehicle being parked 
# is multiplied by the duration of its stay.


load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carpark.RData")

# Check for NAs
sapply(carpark, function(x) sum(is.na(x)))
# We can see that there are no recorded observations for car parks Claremont.Road, Grainger.Town, and Quarryfield.Road 
# so these observations should be removed from the dataframe 
# Everyone of the remaining values contain some NAs. The most is Eldon Square and Eldon Garden with 6417 NAs each and Manors with 6416. As each car park has 22015 observations
# this equates to around 30% of the data. Let's investigate further.

# Filter car parks with high NAs

carparkmini = select(carpark, time, BALTIC, Dean.Street, Eldon.Garden, Eldon.Square, Gateshead.College, Manors, Swinburne.Street)


# The NAs occur during the night period everyday. For Gateshead College this includes the weekend too, which seems to indicate when the car park closes.
# Eldon.Garden, Eldon.Square, Gateshead.College, Manors stop monitoring between 01:00 and 07:00 
# Dean.Street stops monitoring from 03:00 and 07:00
# Swinburne.Street stops monitoring from 03:30 and 08:30 

#As this is a consistent occurrence and we are not 
# trying to directly compare car park numbers we can ignore the NAs.

# Dean Street is more tricky, as it NA pattern changes. 





###### WHAT TO DO WITH MISSING VALUES?????
# Daily total vehicle-hours during the last six months
# Eldon.Square (NE1 497 spaces)
carparkSummary %>%
  filter(Car.Park == "Eldon Square") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_col()

# Manors (NE1 484 spaces)
carparkSummary %>%
  filter(Car.Park == "Manors") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Four.Lane.Ends.Interchange (NE12 475 spaces)
carparkSummary %>%
  filter(Car.Park == "Four Lane Ends Interchange") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Gateshead.Civic.Centre (NE8 450 spaces)
carparkSummary %>%
  filter(Car.Park == "Gateshead Civic Centre") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Eldon.Garden (NE1 449 spaces)
carparkSummary %>%
  filter(Car.Park == "Eldon Garden") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Heworth Interchange (Long Stay) (NE10 413 spaces)
carparkSummary %>%
  filter(Car.Park == "Heworth Interchange (Long Stay)") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Heworth.Interchange.(Short.Stay) (NE10 64 spaces)
carparkSummary %>%
  filter(Car.Park == "Heworth Interchange (Short Stay)") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Northumberland.Park.Metro (NE27 405 spaces)
carparkSummary %>%
  filter(Car.Park == "Northumberland Park Metro") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Sage.Gateshead (NE8 285 spaces)
carparkSummary %>%
  filter(Car.Park == "Sage Gateshead") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Mill.Road (NE8 283 spaces)
carparkSummary %>%
  filter(Car.Park == "Mill Road") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Dean.Street (NE1 257 spaces)
carparkSummary %>%
  filter(Car.Park == "Dean Street") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Gateshead.College (NE8 226 spaces)
carparkSummary %>%
  filter(Car.Park == "Gateshead College") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")


# Callerton.Parkway.Metro (NE13 192 spaces)
carparkSummary %>%
  filter(Car.Park == "Callerton Parkway Metro") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Regent.Centre.Interchange (NE3 183 spaces)
carparkSummary %>%
  filter(Car.Park == "Regent Centre Interchange") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Stadium.of.Light.Metro (SR5 182 spaces)
carparkSummary %>%
  filter(Car.Park == "Stadium of Light Metro") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Ellison.Place (NE1 126 spaces)
carparkSummary %>%
  filter(Car.Park == "Ellison Place") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Kingston.Park.Metro (NE3 95 spaces)
carparkSummary %>%
  filter(Car.Park == "Kingston Park Metro") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# East.Boldon.Metro (NE36 75 spaces)
carparkSummary %>%
  filter(Car.Park == "East Boldon Metro") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# BALTIC (NE8 71 spaces)
carparkSummary %>%
  filter(Car.Park == "BALTIC") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Bank.Foot.Metro (NE13 62 spaces)
carparkSummary %>%
  filter(Car.Park == "Bank Foot Metro") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Swinburne.Street (NE8 57 spaces)
carparkSummary %>%
  filter(Car.Park == "Swinburne Street") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Fellgate.Metro (NE32 54 spaces)
carparkSummary %>%
  filter(Car.Park == "Fellgate Metro") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Old.Town.Hall (NE8 53 spaces)
carparkSummary %>%
  filter(Car.Park == "Old Town Hall") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Church.Street (NE8 43 spaces)
carparkSummary %>%
  filter(Car.Park == "Church Street") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")

# Charles.Street (NE8 27 spaces)
carparkSummary %>%
  filter(Car.Park == "Charles Street") %>%
  ggplot(aes(x=date, y=daily.hours, fill = weekend)) +
  geom_bar(stat = "identity")


# THINGS TO NOTE
# You said their are a couple of exceptions to the car park data, which only
# count vehicles out, such as Mill Road car park. Please can you provide a list of
# all the exceptions?



############## ----------- Prepare plots for Shiny App

### East.Boldon.Metro example
ggplot(data = filter(carparkSummaryShort, Car.Park == "East.Boldon.Metro"), aes(x=date, y=daily.hours, fill = wkend)) +
  geom_bar(stat = "identity")

### insert input$ value
ggplot(data = filter(carparkSummaryShort, Car.Park == input$CarParkName)) +
  geom_bar(stat = "identity", mapping = aes(x=date, y=daily.hours, fill = wkend))




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
