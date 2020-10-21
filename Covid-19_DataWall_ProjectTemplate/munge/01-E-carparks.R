# --- URBAN OBSERVATORY: Car Park --- #


################### STEP 1: create a car park meta data frame that includes the lat long data
# final cached data frame: carpark.meta

# Pull in the car park meta data from the Urban Observatory
carpark.meta = read_csv(url("https://covid.view.urbanobservatory.ac.uk/output/recent-car-park-metadata-pd.csv"))
# Load in the postcode file
pc_coords = read_csv("data/ukpostcodes.csv") # source: https://www.freemaptools.com/download-uk-postcode-lat-lng.htm

# join the lat long data to the meta data file
carpark.meta = left_join(carpark.meta, pc_coords, by = 'postcode')
# remove pc_coords
rm(pc_coords)

# manually add in Charles Street, Mill Road and Old Town Hall
carpark.meta[4,8] = 54.960759 #lat
carpark.meta[4,9] = -1.601035 #long
carpark.meta[21,8] = 54.96800837 #lat
carpark.meta[21,9] = -1.597930475 #long
carpark.meta[23,8] = 54.964137 #lat
carpark.meta[23,9] = -1.604706 #long

carpark.meta = carpark.meta %>%
  rename(CarPark = X1)

carpark.meta = filter(carpark.meta, !CarPark %in% c("Claremont Road", "Grainger Town", "Quarryfield Road"))

# cache('carpark.meta')




################### STEP 2: pull in the car park data from the Urban Observatory, remove car parks with no data 
# and filter so only 2020 data is included
# final cached data frame: carpark

# Pull in the car park data from the Urban Observatory
carpark = read_csv(url("https://covid.view.urbanobservatory.ac.uk/output/recent-car-park-occupancy-pd.csv"))

# remove spaces from the headers
names(carpark) = str_replace_all(names(carpark), c(" " = "." , "," = "" ))
# remove the columns with no data (Claremont.Road, Grainger.Town, and Quarryfield.Road)
carpark = select(carpark, -c("Claremont.Road", "Grainger.Town", "Quarryfield.Road"))

#Create date and year columns
carpark$Date = ymd_hms(carpark$time)
carpark$year = year(carpark$Date)

# filter so only 2020 data is included
carpark = filter(carpark, year == "2020")

# cache('carpark')




################### STEP 3: pivot to long data frame format and add daily occupancy hours variable
# final cached data frame: carparkLONG

# Create a column of cumulative occupancy for each car park so the daily occupancy hours can be
# calculated by multiplying the total number by 15 (minutes)
# pivot table
carparkLONG = pivot_longer(
  carpark, 
  cols = -c("time", "Date"),
  names_to = "Car.Park",
  values_to = "Car.Counts")


# Add additonal date column with lubridate
carparkLONG$just.date = date(carparkLONG$Date)

# cache('carparkLONG')




################### STEP 4: create data frame of car park summary statistics
# final cached data frame: carparkSummary

# Calculate the daily car counts, daily minutes and daily hours
carparkSummary = carparkLONG %>%
  group_by(Car.Park, just.date) %>%
  summarise(
    daily.car.counts = sum(Car.Counts, na.rm = TRUE),
    daily.minutes = daily.car.counts*15,
    daily.hours = daily.minutes/60
  )


# add additional date columns
carparkSummary$day = day(carparkSummary$just.date)
carparkSummary$month = month(carparkSummary$just.date)
carparkSummary$year = year(carparkSummary$just.date)
carparkSummary$dayofweek = wday(carparkSummary$just.date)
carparkSummary$dayofweek2 = wday(carparkSummary$just.date, label=TRUE)
carparkSummary$weekend = ifelse(carparkSummary$dayofweek %in% c(1, 7), "weekend", "weekday")
carparkSummary$weekend = as.factor(carparkSummary$weekend)

carparkSummary = carparkSummary %>% rename(date = just.date) 
carparkSummary$Car.Park = gsub("[.]"," ",carparkSummary$Car.Park)

# cache('carparkSummary')

