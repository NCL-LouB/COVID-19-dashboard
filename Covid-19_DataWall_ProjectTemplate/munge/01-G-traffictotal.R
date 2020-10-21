# --- URBAN OBSERVATORY: Traffic Data --- #
# Total Traffic Data Preparation

# AIM: to add the locations of the traffic  ANPR cameras to this map:
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  setView(lng = -1.600000, lat = 54.966667, zoom = 9)


################### STEP 1: pull in the anpr traffic data files from the urban observatory
anpr.volumes.16min = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/t%26w-anpr-volumes-pd-16min.csv"))
# cache('anpr.volumes.16min')

anpr.volumes.point.meta = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/t%26w-anpr-volumes-point-metadata-pd.csv"))
# cache('anpr.volumes.point.meta')

anpr.volumes.meta = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/t%26w-anpr-volumes-link-metadata-pd.csv"))
# cache('anpr.volumes.meta')

anpr.volumes.mapping = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/t%26w-anpr-volumes-point-metadata-original-id-mapping.csv"))
# cache('anpr.volumes.mapping')




############### STEP 2: Convert northing and easting to latitude and longitude
# Here is a way to do it with the sf package in R. 
# https://stackoverflow.com/questions/50296985/convert-coordinates-from-british-national-grid-easting-northing-to-wgs84-lat


utm = anpr.volumes.point.meta
df = data.frame(Easting=utm$easting, Northing=utm$northing)


# We take the table and convert to point geometries, specifying that these values are in the BNG coordinate reference system. 
# Then we transform to WGS84, extract the coordinates as a matrix, and return a data frame.
# The British National Grid has EPSG code 27700.

latlong = df %>%
  st_as_sf(coords = c("Easting", "Northing"), crs = 27700) %>%
  st_transform(4326) %>%
  st_coordinates() %>%
  as_tibble()
#> # A tibble: 6 x 2

# rename columns
names(latlong)[names(latlong) == "Y"] = "Latitude"
names(latlong)[names(latlong) == "X"] = "Longitude"

# create column to join the data
utm$ID = seq.int(nrow(utm))
latlong$ID = seq.int(nrow(latlong))

# merge the data back together
trafficLatLong = merge(utm, latlong,by="ID")




############### STEP 3: Cache a copy of this data frame
# Save a copy
# cache('trafficLatLong')




############### STEP 4: Check that this has worked by viewing on a map
# Place the locations onto a map of the North East
popup = trafficLatLong$timeseriesName
leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(lng = trafficLatLong$Longitude,
             lat = trafficLatLong$Latitude, 
             popup = popup)




############### STEP 5: Prepare the anpr.volumes.16min data
# Duplicate the data
TotalTraffic = anpr.volumes.16min

# Fix date and time into lubridate format
TotalTraffic$datetime = ymd_hms(TotalTraffic$time, tz = "Europe/London")

# check it is showing BST rather than UTC
head(TotalTraffic$datetime)

# Check the dates and time convertion has worked
head(select(TotalTraffic, time, datetime))

# Remove the old time format 
TotalTraffic = select(TotalTraffic, -time)

# Pivot long
TotalTrafficLong = pivot_longer(
  TotalTraffic, 
  cols = -c("datetime"),
  names_to = "timeseriesName",
  values_to = "TrafficCount")

# Map the data in the anpr.volumes.point.meta data frame to the TotalTrafficLong data frame
TotalTrafficLongjoin = left_join(TotalTrafficLong, trafficLatLong, by = "timeseriesName")

# create date only column 
TotalTrafficLongjoin$date = date(TotalTrafficLongjoin$datetime)




############### STEP 6: Cache a copy of this data frame 
# Save a copy
# cache('TotalTrafficLongjoin')



############### STEP 7: filter out the observations from anpr cameras associated with commuting

commutingpoints = c("CAJT_GHA167_NB4_DR3.end.northbound", "CAJT_NCA189_DWR1_SJB1.start.northbound", "CAJT_NCB6324_SR3_SR2.end.eastbound",
                    "CAJT_GHA167_DR3_NB4.start.southbound", "CAJT_GHA184_RB_A1.end.westbound", "CAJT_NCB6324_SR2_SR3.start.westbound",
                    "CAJT_NCA1058_JR1_SR3.start.eastbound", "CAJT_NCA1058_SR3_JR1.end.westbound", "CAJT_GHA167_DR1_TB.end.northbound",
                    "CAJT_GHA167_TB_DR1.start.southbound", "CAJT_NCB1318_GNR3_GNR2.start.southbound", "CAJT_NCB1318_GNR2_GNR3.end.northbound")


Commutingtraffic = TotalTrafficLongjoin %>% filter(timeseriesName %in% commutingpoints)

length(commutingpoints)
length(unique(Commutingtraffic$timeseriesName))

Commutingtrafficmap = trafficLatLong %>% filter(timeseriesName %in% commutingpoints)
leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(lng = Commutingtrafficmap$Longitude,
             lat = Commutingtrafficmap$Latitude, 
             popup = Commutingtrafficmap$pointDescription)



############### STEP 8: plot the total traffic numbers for each anpr camera
CommutingtrafficDAY = Commutingtraffic %>% 
  filter(date >= "2020-01-01") %>%
  group_by(systemCodeNumber, date) %>%
  summarise(dailycount = sum(TrafficCount))


jointable = Commutingtraffic %>% select(highwayDescription, systemCodeNumber, date) %>%
  filter(date == "2020-05-01")

jointable = jointable[1:12,]
jointable = jointable[,1:2]

CommutingtrafficDAY = full_join(CommutingtrafficDAY, jointable, by = "systemCodeNumber")

CommutingtrafficDAY$dayofweek = wday(CommutingtrafficDAY$date)
CommutingtrafficDAY$weekend = ifelse(CommutingtrafficDAY$dayofweek %in% c(1, 7), "weekend", "weekday")
CommutingtrafficDAY$weekend = as.factor(CommutingtrafficDAY$weekend)



# Cache dfs needed
# cache('Commutingtrafficmap')
# cache('Commutingtraffic')
# cache('CommutingtrafficDAY')