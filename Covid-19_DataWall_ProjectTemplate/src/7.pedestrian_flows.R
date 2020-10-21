library('ProjectTemplate')
load.project()


# ----- Pedestrian flows: overview ----- #
# The Urban Observatory dashboard has three pages on pedestrian flow
#   1. Pedestrian flows: Summary (Newcastle upon Tyne)
#   2. Pedestrian flows: Each during last 28 days (Newcastle upon Tyne)
#   3. Pedestrian flows: Comparison to typical profiles (Newcastle upon Tyne)

# ----- Pedestrian flows: Summary (Newcastle upon Tyne) ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#pedestrian-flows-summary

# WHAT DOES THIS DATA SHOW?
# This page contains two tables, which compare the footfall data at two strategic locations in Newcastle.
# One spanning the full width of Northumberland Street: 
#         "Northumberland.St.near.TK.Maxx..Walking.North"                                             
#         "Northumberland.St.near.TK.Maxx..Walking.South"  
# The other on the corner of Blackett Street and John Dobson Street (a thoroughfare to the shopping district):
#         "Pavement..south.side..corner.John.Dobson.St.and.Blackett.St..Walking.North"                
#         "Pavement..south.side..corner.John.Dobson.St.and.Blackett.St..Walking.South" 

# For each day and direction, the following percentages are given with respect to the average pedestrians per hour:
#         Change since the day before
#         Change since the same weekday last week
#         Change compared to the median for the same weekday calculated over the last year

# Statistics are provided for the morning peak, afternoon peak, inter-peak period 
# (essentially daytime outside of peak hours), and night. As footfall is unlikely to be evenly 
# distributed across these periods, the statistics for the current period will be volatile while data is still coming in.

# THINGS TO NOTE:
# 1. Confirm this is the data used on this page in the dashboard 
# 2. Get geographic references for the locations
# 3. For the calculation of the median for the same weekday calculated over the last year, what period is used? 15/03/19 - 14/03/20?
# 4. My summary stats do not matcht the numbers on the dashboard, therefore I need to confirm:
#       4a. How is missing data treated?
#       4b. How did they calculate the hourly average? 
#       4c. How did they calculate the percentage change?
#       4d. How did they calculate the median? 

# This file contains the original data pulled from the api
#load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/pedestrian.flow.RData")

# This file contains the original data, which has been pivoted to a long format. It also includes additional date information 
# including time categories (evening.peak, inter.peak etc).
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/pedestrian.flow.LONG.RData")

# This file builds upon pedestrian.flow.LONG by summarising the data by creating additional variables (hourly average, 
# % change from day before, % change from week before and % change from annual average) by grouping the data by location,
# timecat and just.date. 
#load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/ped.summary.RData")

# This file is made from ped.summary. It filters out only the observations from Northumberland Street. 
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/ped.flow.RData")

# This file is made from pedestrian.flow.LONG It filters out only the observations from Northumberland Street west and that take place after 2019-12-31
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/pedestrian.flow.LONG.NS.west.RData")

# This file is made from pedestrian.flow.LONG It filters out only the observations from Northumberland Street east and that take place after 2019-12-31
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/pedestrian.flow.LONG.NS.east.RData")






# Use pedestrian.flow.LONG.NS.west to plot the data
pedWS =  ggplot(pedestrian.flow.LONG.NS.west, aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) +
  ggtitle(label = "Pedestrian flow along the west side of Northumberland Street")



# Inspect ped.flow 
str(ped.flow)


test = ped.flow %>% 
  select(location, timecat, just.date, hourlyAverage, daily.pc, weekly.pc, pc.annual.median) %>%
  gather(variable, value, hourlyAverage, daily.pc, weekly.pc, pc.annual.median) %>%
  unite(var, variable, timecat) %>% 
  spread(var, value)

# remove the data from before January 2020
test = filter(test, just.date >= "2020-01-01")

# reorder the columns
colnames(test)

test = test %>%
  select(location, just.date, 
         hourlyAverage_morning.peak, daily.pc_morning.peak, weekly.pc_morning.peak, pc.annual.median_morning.peak,
         hourlyAverage_inter.peak, daily.pc_inter.peak, weekly.pc_inter.peak, pc.annual.median_inter.peak,
         hourlyAverage_evening.peak, daily.pc_evening.peak, weekly.pc_evening.peak, pc.annual.median_evening.peak,
         hourlyAverage_night, daily.pc_night, weekly.pc_night, pc.annual.median_night)






ped.flow$pc.annual.median
ped.summary2 = ped.summary %>%
  filter(location %in% c ("Northumberland.St.near.TK.Maxx..Walking.North", 
                          "Northumberland.St.near.TK.Maxx..Walking.South",
                          "Pavement..south.side..corner.John.Dobson.St.and.Blackett.St..Walking.North",                
                          "Pavement..south.side..corner.John.Dobson.St.and.Blackett.St..Walking.South"))

ped.summary3 = ped.summary %>%
  filter(just.date > "2020-05-31" & just.date < "2020-06-29")





# ----- Pedestrian flows: Each during the last 28 days (Newcastle upon Tyne) ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#pedestrian-flows-each

# WHAT DOES THIS DATA SHOW?
# The page provides 11 graphs of data generated by 11 cameras over the last 28 days.  
# Plot titles: 
#   Blackett St crossing from John Dobson St to Northumberland St (west side) 
#   John Dobson St (east side) pavement near The Stack 
#   John Dobson St (west side) pavement near Goldsmiths 
#   John Dobson St crossing island between Blackett St and New Bridge Street St West 
#   New Bridge St West crossing John Dobson St to Northumberland St (east side) 
#   Northumberland St near Fenwick (east side) 
#   Northumberland St near Fenwick (west side) 
#   Northumberland St near TK Maxx 
#   Pavement (south side) corner John Dobson St and Blackett St 
#   Pavement (south side) corner John Dobson St and New Bridge St West 
#   Science Square at Newcastle Helix 

# The plots include 28 bar charts (??) of the number of pedestrians recorded per minute. 
# There is one bar chart for each day represented on the plot. At the end of the plot the last 48 
# hours is presented in a little more detail, with the hours 6am, 12pm, 6pm and 12am provided to 
# show the changes across the 48 hour period.  
# The plots use a mirror format so the data for the direction of travel can be represented. 

# THINGS TO NOTE:
# 1. The plots say they are pedestrians per minute... but the data is only provided in 15 minute intervals. 
#    How is this calculated?

# Each camera during the period 1-28 June 2020 
# Blackett St crossing from John Dobson St to Northumberland St (west side)
pedestrian.flow.LONG %>%
  filter(location %in% c("Blackett.St.crossing.from.John.Dobson.St.to.Northumberland.St..west.side...Walking.North",
                         "Blackett.St.crossing.from.John.Dobson.St.to.Northumberland.St..west.side...Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# John Dobson St (east side) pavement near The Stack
pedestrian.flow.LONG %>%
  filter(location %in% c("John.Dobson.St..east.side..pavement.near.The.Stack..Walking.North",                         
                         "John.Dobson.St..east.side..pavement.near.The.Stack..Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# John Dobson St (west side) pavement near Goldsmiths
pedestrian.flow.LONG %>%
  filter(location %in% c("John.Dobson.St..west.side..pavement.near.Goldsmiths..Walking.North",                        
                         "John.Dobson.St..west.side..pavement.near.Goldsmiths..Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# John Dobson St crossing island between Blackett St and New Bridge St West
pedestrian.flow.LONG %>%
  filter(location %in% c("John.Dobson.St.crossing.island.between.Blackett.St.and.New.Bridge.St.West..Walking.East",
                         "John.Dobson.St.crossing.island.between.Blackett.St.and.New.Bridge.St.West..Walking.West" ),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# New Bridge St West crossing John Dobson St to Northumberland St (east side)
pedestrian.flow.LONG %>%
  filter(location %in% c("New.Bridge.St.West.crossing.John.Dobson.St.to.Northumberland.St..east.side...Walking.North",
                         "New.Bridge.St.West.crossing.John.Dobson.St.to.Northumberland.St..east.side...Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# Northumberland St near Fenwick (east side)
pedestrian.flow.LONG %>%
  filter(location %in% c("Northumberland.St.near.Fenwick..east.side...Walking.North",                         
                         "Northumberland.St.near.Fenwick..east.side...Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# Northumberland St near Fenwick (west side)
pedestrian.flow.LONG %>%
  filter(location %in% c("Northumberland.St.near.Fenwick..west.side...Walking.North",                         
                         "Northumberland.St.near.Fenwick..west.side...Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# Northumberland St near TK Maxx
pedestrian.flow.LONG %>%
  filter(location %in% c("Northumberland.St.near.TK.Maxx..Walking.North",                               
                         "Northumberland.St.near.TK.Maxx..Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# Pavement (south side) corner John Dobson St and Blackett St
pedestrian.flow.LONG %>%
  filter(location %in% c("Pavement..south.side..corner.John.Dobson.St.and.Blackett.St..Walking.North",               
                         "Pavement..south.side..corner.John.Dobson.St.and.Blackett.St..Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# Pavement (south side) corner John Dobson St and New Bridge St West
pedestrian.flow.LONG %>%
  filter(location %in% c("Pavement..south.side..corner.John.Dobson.St.and.New.Bridge.St.West..Walking.North",   
                         "Pavement..south.side..corner.John.Dobson.St.and.New.Bridge.St.West..Walking.South"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 


# Science Square at Newcastle Helix
pedestrian.flow.LONG %>%
  filter(location %in% c("Science.Square.at.Newcastle.Helix..Walking.East",                   
                         "Science.Square.at.Newcastle.Helix..Walking.West"),
         just.date > "2020-05-31" & just.date < "2020-06-29") %>%
  ggplot(aes(x = Date, y = pedestrian.counts, fill = direction)) +
  geom_bar(stat = "identity") + 
  facet_grid(direction ~ .) 









# ----- Pedestrian flows: Comparison to typical profiles (Newcastle upon Tyne) ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#pedestrian-flows-comparison

# WHAT DOES THIS DATA SHOW?
# This page compares the data from a recent date (today or yesterday) against data from the year before.
# The shaded area represents a normal percentile boundary obtained for that day of the week during the last year before the outbreak.
# The dotted line represents the median, so an average on that day of the week.
# The solid line represents the actual observed data.

# Location directions
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





# Categorise the locations into directions eg. walking north, walking south or walking east, walking west
ped.flow$direction = str_sub(ped.flow$location,-13,-1)
ped.flow$direction = gsub("[.]","",ped.flow$direction)
  
  