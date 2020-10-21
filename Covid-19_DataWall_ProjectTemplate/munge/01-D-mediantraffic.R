# --- URBAN OBSERVATORY: Traffic --- #
# Pull in the median traffic data
mediantraffic = read_csv(url("https://covid.view.urbanobservatory.ac.uk/output/all-traffic-relative.csv"))
# remove spaces from the headers
names(mediantraffic) = str_replace_all(names(mediantraffic), c(" " = "." , "," = "" ))
# Use lubridate
mediantraffic$datetime = ymd_hms(mediantraffic$Date)
# Extract the date
mediantraffic$date = date(mediantraffic$datetime)
# Select the cells needed
trafficAll = select(mediantraffic, date, Sunderland, South.Tyneside,
                    North.Tyneside, Newcastle.upon.Tyne, Gateshead,
                    County.Durham, Northumberland, All.authorities,
                    Hull, Sheffield)


# cache('trafficAll')


mediantraffic = select(mediantraffic, date, Sunderland, 
                       South.Tyneside, North.Tyneside, 
                       Newcastle.upon.Tyne, Gateshead,
                       Northumberland)

# Round the percentage values
mediantraffic$Sunderland = round(mediantraffic$Sunderland)
mediantraffic$South.Tyneside = round(mediantraffic$South.Tyneside)
mediantraffic$North.Tyneside = round(mediantraffic$North.Tyneside)
mediantraffic$Newcastle.upon.Tyne = round(mediantraffic$Newcastle.upon.Tyne)
mediantraffic$Gateshead = round(mediantraffic$Gateshead)
mediantraffic$Northumberland = round(mediantraffic$Northumberland)

# cache('mediantraffic')


# Create a long version
mediantrafficLONG = pivot_longer(
  mediantraffic, 
  cols = -c("date"),
  names_to = "Region",
  values_to = "Percentage")

# Round the percentage values
mediantrafficLONG$Percentage = round(mediantrafficLONG$Percentage)

# cache('mediantrafficLONG')
