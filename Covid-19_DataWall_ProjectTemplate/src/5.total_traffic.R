library('ProjectTemplate')
load.project()


# Total Traffic

# load packages
library(sf)
library(rgdal)

load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/TotalTrafficLongjoin.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/trafficLatLong.RData")

############### STEP 1: Identify the locations we will used initially
# the unique variable is timeseriesName

# We will use the same locations used on this page: https://covid.view.urbanobservatory.ac.uk/#traffic-summary
# The points have been selected because they indicate long distance travel or commuting behaviour.

##### Traffic volumes from A1 towards Newcastle upon Tyne
# J66 Angel (Northbound) (# Angel of the North | CAJT_GHA167_NB4_DR3.end.northbound | end)
# J69 Redheugh (Northbound) (# A184/A189 (Northbound) | CAJT_NCA189_DWR1_SJB1.start.northbound | start)
# J76 Blakelaw (Eastbound) to the north of the city (# B6324 Stamfordham Road (Eastbound) | CAJT_NCB6324_SR3_SR2.end.eastbound  | end)

# Let's take a look at the J66 Angel data
J66 = trafficLatLong %>% 
  filter(str_detect(pointDescription, "Angel"))
# There are two obvious matches (CAJT_GHA167_NB4_DR3 and CAJT_GHA167_DR3_NB4)

# Let's take a look at the J69 Redheugh data
J69 = trafficLatLong %>% 
  filter(str_detect(highwayDescription, "A184"))

# Place the locations onto a map of the North East
J69LatLong = trafficLatLong %>% 
  filter(str_detect(highwayDescription, "A184"))

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(lng = J69LatLong$Longitude,
             lat = J69LatLong$Latitude, 
             popup = J69LatLong$timeseriesName)

# These two points were identified from the map above
trafficLatLong %>% 
  filter(timeseriesName == "CAJT_NCA189_DWR1_SJB1.start.northbound")
trafficLatLong %>% 
  filter(timeseriesName == "CAJT_GHA184_RB_A1.end.westbound")


# Let's take a look at the J76 data
J76 = TotalTrafficLongjoin %>% 
  filter(str_detect(pointDescription, "J76"))
J76 %>% group_by(highwayDescription) %>% summarise(median = median(TrafficCount), mean = mean(TrafficCount))
# the means and medians are the same for both sets of highway descriptions so they must have very similar traffic counts. 
# I selected two. 



##### Traffic volumes at A1 leaving Newcastle upon Tyne
# J66 Angel (Southbound) (# Angel of the North | CAJT_GHA167_DR3_NB4.start.southbound | start)
# J69 Redheugh (Soutbound) (# A184 (Westbound) | CAJT_GHA184_RB_A1.end.westbound | end)
# J76 Blakelaw (Westbound) to the north of the city (# B6324 Stamfordham Road (Westbound) | CAJT_NCB6324_SR2_SR3.start.westbound | start)


##### Traffic volumes on Jesmond Road and Coast Road
# Central Motorway (Westbound) ("A1058 Coast Road (Eastbound)" | "CAJT_NCA1058_JR1_SR3.start.eastbound" | "start")
# Central Motorway (Eastbound) ("A1058 Coast Road (Westbound)" | "CAJT_NCA1058_SR3_JR1.end.westbound" | "end")

Jesmond = trafficLatLong %>% 
  filter(str_detect(pointDescription, "Central"))

# Place the locations onto a map of the North East
JesmondLatLong = trafficLatLong %>% 
  filter(str_detect(pointDescription, "Central"))

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(lng = JesmondLatLong$Longitude,
             lat = JesmondLatLong$Latitude, 
             popup = JesmondLatLong$systemCodeNumber)


##### Traffic volumes on River Tyne crossings
# Tyne Bridge (Northbound) (# A167 Gateshead Highway (Northbound)	| CAJT_GHA167_DR1_TB.end.northbound | end)
# Tyne Bridge (Southbound) (# A167 Gateshead Highway (Southbound) | CAJT_GHA167_TB_DR1.start.southbound | start)

TyneBridge = trafficLatLong %>% 
  filter(str_detect(pointDescription, "Tyne"))

# Place the locations onto a map of the North East
TyneBridgeLatLong = trafficLatLong %>% 
  filter(str_detect(pointDescription, "Tyne"))

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(lng = TyneBridge$Longitude,
             lat = TyneBridge$Latitude, 
             popup = TyneBridgeLatLong$systemCodeNumber)



##### Traffic volumes on Great North Road
# highwayDescription | systemCodeNumber | end
# Broadway (Southbound) (# Broadway CAJT_NCB1318_GNR3_GNR2.start.southbound  | start)
# Broadway (Northbound) (# Broadway | CAJT_NCB1318_GNR2_GNR3.end.northbound | end)

Broadway = trafficLatLong %>% 
  filter(str_detect(pointDescription, "Broadway"))

# Place the locations onto a map of the North East
BroadwayLatLong = trafficLatLong %>% 
  filter(str_detect(pointDescription, "Broadway"))

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(lng = BroadwayLatLong$Longitude,
             lat = BroadwayLatLong$Latitude, 
             popup = BroadwayLatLong$systemCodeNumber)





############### STEP X: load cached data for the identified sites

# Munge code can be found in the munge directory under file Traffic_Total_Prepartion.R

load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/Commutingtrafficmap.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/Commutingtraffic.RData")


############### STEP X: plot the total traffic numbers for each anpr camera

length(unique(Commutingtraffic$systemCodeNumber))

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

cache('CommutingtrafficDAY')

Commutingtraffic %>% 
  filter(date >= "2020-01-01") %>%
  group_by('timeseriesName', 'date') %>%
  summarise(dailycount = sum(TrafficCount))



# Let's inspect A167 Gateshead Highway (Northbound)	CAJT_GHA167_DR1_TB end

CAJT_GHA167_DR1_TB = TotalTrafficLongjoin %>% 
  filter(systemCodeNumber == "CAJT_GHA167_DR1_TB" & end == "end" & date >= "2020-01-01") %>%
  group_by(date) %>%
  summarise(dailycount = sum(TrafficCount))

CAJT_GHA167_DR1_TB$dayofweek = wday(CAJT_GHA167_DR1_TB$date) # numbered 1,2,3
CAJT_GHA167_DR1_TB$wkend = ifelse(CAJT_GHA167_DR1_TB$dayofweek %in% c(1, 7), "weekend", "weekday")

CAJT_GHA167_DR1_TB_PLOT = ggplot(CAJT_GHA167_DR1_TB) +
  geom_point(aes(x=date, y=dailycount, color = wkend)) +
  geom_line(aes(x=date, y=dailycount), color = "#0652DD") +
  scale_color_manual(values = c("weekend" = "#12CBC4", "weekday" = "#0652DD"))

ggplotly(CAJT_GHA167_DR1_TB_PLOT)



# Let's inspect one location (Coast Road)
test = TotalTrafficLongjoin %>% 
  filter(systemCodeNumber == "CAJT_NCA1058_JR1_SR3" & end == "start" & date >= "2020-01-01") %>%
  group_by(date) %>%
  summarise(dailycount = sum(TrafficCount))

test$dayofweek = wday(test$date) # numbered 1,2,3
test$wkend = ifelse(test$dayofweek %in% c(1, 7), "weekend", "weekday")

eg = ggplot(test) +
  geom_point(aes(x=date, y=dailycount, color = wkend)) +
  geom_line(aes(x=date, y=dailycount), color = "#0652DD") +
  scale_color_manual(values = c("weekend" = "#12CBC4", "weekday" = "#0652DD"))
  


# Let's inspect another location
TotalTrafficLongjoin[100,]
#[1] "1561938480"                          "CAJT_GHA167_TB_DR1.start.southbound" "15"                                 
#[4] "129"                                 "CAJT_GHA167_TB_DR1"                  "start"                              
#[7] "Tyne Bridge (South)"                 "A167 Gateshead Highway (Southbound)" "425462"                             
#[10] "563547"                              "1"                                   "18078"   



test2 = TotalTrafficLongjoin %>% 
  filter(systemCodeNumber == "CAJT_GHA167_TB_DR1" & end == "start" & date >= "2020-01-01") %>%
  group_by(date) %>%
  summarise(dailycount = sum(TrafficCount))

test2$dayofweek = wday(test2$date) # numbered 1,2,3
test2$wkend = ifelse(test2$dayofweek %in% c(1, 7), "weekend", "weekday")

ggplot(test2) +
  geom_point(aes(x=date, y=dailycount, color = wkend)) +
  geom_line(aes(x=date, y=dailycount), color = "#0652DD") +
  scale_color_manual(values = c("weekend" = "#12CBC4", "weekday" = "#0652DD"))



bycam = TotalTrafficLongjoin %>% 
  group_by(systemCodeNumber, end, date) %>%
  summarise(total = sum(TrafficCount))

  



