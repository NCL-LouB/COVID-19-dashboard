# --- URBAN OBSERVATORY: Pedestrian Flow Data --- #

################### STEP 1: pull in the pedestrian flow data from the urban observatory
# final cached data frame: pedestrian.flow
pedestrian.flow = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/recent-pedestrian-flows-pd.csv"))




################### STEP 2: create long data frame which identifies the time category and direction
# final cached data frame: pedestrian.flow.LONG

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




################### STEP 3: create two data frames containing the hourly pedestrian counts at the Northumberland Street Fenwick location (one for the East side and the other for the West side). 
# final cached data frames: NorthumberlandSt.west and NorthumberlandSt.east


NorthumberlandSt = filter(pedestrian.flow.LONG, 
                          location %in% c("Northumberland.St.near.Fenwick..west.side...Walking.North",
                                          "Northumberland.St.near.Fenwick..west.side...Walking.South",
                                          "Northumberland.St.near.Fenwick..east.side...Walking.North",                         
                                          "Northumberland.St.near.Fenwick..east.side...Walking.South") &
                            just.date > "2019-12-31")


NorthumberlandSt = NorthumberlandSt %>%
  group_by(location, just.date, just.hour) %>%
  summarise(
    hourly.pedestrian.count = sum(pedestrian.counts)
  )

# Categorise the locations into directions eg. walking north, walking south or walking east, walking west
NorthumberlandSt$Direction = str_sub(NorthumberlandSt$location,-13,-1)
NorthumberlandSt$Direction = gsub("[.]"," ",NorthumberlandSt$Direction)

NorthumberlandSt$DateTime = with(NorthumberlandSt, paste0(just.date, sep='-', just.hour))
NorthumberlandSt$Date = ymd_h(NorthumberlandSt$DateTime)


NorthumberlandSt.west = filter(NorthumberlandSt, 
                               location %in% c("Northumberland.St.near.Fenwick..west.side...Walking.North",
                                               "Northumberland.St.near.Fenwick..west.side...Walking.South"))


NorthumberlandSt.east = filter(NorthumberlandSt, 
                               location %in% c("Northumberland.St.near.Fenwick..east.side...Walking.North",                         
                                               "Northumberland.St.near.Fenwick..east.side...Walking.South"))




################### STEP 4: create data frame of the daily pedestrian count totals at the Northumberland Street Fenwick location 
# final cached data frame: ped.daily.totals

ped.daily.totals = filter(pedestrian.flow.LONG, 
                          location %in% c("Northumberland.St.near.Fenwick..west.side...Walking.North",
                                          "Northumberland.St.near.Fenwick..west.side...Walking.South",
                                          "Northumberland.St.near.Fenwick..east.side...Walking.North",                         
                                          "Northumberland.St.near.Fenwick..east.side...Walking.South") &
                            just.date > "2019-12-31")

ped.daily.totals = ped.daily.totals %>%
  group_by(location, just.date) %>%
  summarise(
    daily.ped.count = sum(pedestrian.counts)
  )

ped.daily.totals$Location = "Northumberland Street" 
ped.daily.totals[1:460,4] = "Northumberland Street (east)"
ped.daily.totals[461:920,4] = "Northumberland Street (west)"
ped.daily.totals$direction = "Walking north"
ped.daily.totals[231:460,5] = "Walking south"
ped.daily.totals[691:920,5] = "Walking south"
ped.daily.totals$Point = "Northumberland Street (east) walking north" 
ped.daily.totals[231:460,6] = "Northumberland Street (east) walking south"
ped.daily.totals[461:690,6] = "Northumberland Street (west) walking north"
ped.daily.totals[691:920,6] = "Northumberland Street (west) walking south"

ped.daily.totals = ped.daily.totals %>%
  rename(Date = just.date,
         Daily.pedestrian.count = daily.ped.count,
         Direction = direction)

ggplot(ped.daily.totals) +
  geom_line(aes(x = Date, y = Daily.pedestrian.count, color = Point)) +
  theme(legend.position="bottom")




################### STEP 5: create a data frame of summary statistics
# For each day and each direction, the following percentages are given with respect to the average pedestrians per hour:
# Change since the day before
# Change since the same weekday last week
# Change compared to the median for the same weekday calculated over the last year
# final cached data frame: ped.summary



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

# Calculate the median for the same weekday calculated over the last year, period 15/03/19 - 14/03/20

# Calculate the number of pedestrian counts by location, time category and date
ped.flow.median = pedestrian.flow.LONG %>%
  filter(just.date > "2019-03-15" & just.date < "2020-03-16") %>%
  group_by(location, timecat, just.date) %>%
  summarise(
    timecat.counts = sum(pedestrian.counts)
  )

# Calculate the hourly average for each location, time category and date
ped.flow.median$hourlyAverage = round(mapply(hourlyAV, x = ped.flow.median$timecat.counts, timecat = ped.flow.median$timecat), digits = 0)

# Identify the days of the week
ped.flow.median$just.dayofweek = wday(ped.flow.median$just.date)
ped.flow.median$just.dayofweek1 = wday(ped.flow.median$just.date, label=TRUE)

# Calculate the median for the same weekday calculated over the last year, period 15/03/19 - 14/03/20
ped.flow.median2 = ped.flow.median %>%
  group_by(location, timecat, just.dayofweek) %>%
  summarise(
    median.counts = median(hourlyAverage)
  )


# Identify the days of the week
ped.flow.Summary2$just.dayofweek = wday(ped.flow.Summary2$just.date)
ped.flow.Summary2$just.dayofweek1 = wday(ped.flow.Summary2$just.date, label=TRUE)

#join the median data to the ped.flow.Summary2 table
ped.summary = left_join(ped.flow.Summary2, ped.flow.median2, by = c("location", "timecat", "just.dayofweek"))

# Calculate the percentage change from annual average
ped.summary = ped.summary %>%
  mutate(pc.annual.median = round((hourlyAverage-median.counts)/hourlyAverage *100, digits = 0)
  )




################### STEP 6: select only the values relating to Northumberland St near Fenwick (east side) and Northumberland St near Fenwick (west side)
# final cached data frame: ped.flow

ped.flow = ped.summary %>%
  filter(location %in% c ("Northumberland.St.near.Fenwick..east.side...Walking.North", 
                          "Northumberland.St.near.Fenwick..east.side...Walking.South",
                          "Northumberland.St.near.Fenwick..west.side...Walking.North",
                          "Northumberland.St.near.Fenwick..west.side...Walking.South"))





## Cache the data frames
# STEP 1
# cache('pedestrian.flow') 
# STEP 2
# cache('pedestrian.flow.LONG') 
# STEP 3
# cache('NorthumberlandSt.west')
# cache('NorthumberlandSt.east')
# STEP 4
# cache('ped.daily.totals')
# STEP 5
# cache('ped.summary') 
# STEP 6
# cache('ped.flow')


# remove the data frames and functions created in the munge process that we do not need
rm(ped.flow.median)
rm(ped.flow.median2)
rm(ped.flow.Summary)
rm(ped.flow.Summary2)
rm(pedestrian.flow.LONG)
rm(getTimeCat)
rm(hourlyAV)