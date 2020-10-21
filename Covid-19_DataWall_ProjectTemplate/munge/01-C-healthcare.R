##################################### HEALTH DATA

############# HEALTH DATA: NATIONS
AREA_TYPE = "nation"

endpoint <- "https://api.coronavirus.data.gov.uk/v1/data"

# Create filters:
filters <- c(
  sprintf("areaType=%s", AREA_TYPE)
)

# Create the structure as a list or a list of lists:
structure <- list(
  date = "date", 
  name = "areaName", 
  code = "areaCode",
  health = list(
    newadmissions = "newAdmissions",
    cumadmissions = "cumAdmissions",
    occbeds = "covidOccupiedMVBeds",
    hospitalcases = "hospitalCases",
    plannedcapacity = "plannedCapacityByPublishDate"
  )
)

# The "httr::GET" method automatically encodes 
# the URL and its parameters:
httr::GET(
  # Concatenate the filters vector using a semicolon.
  url = endpoint,
  
  # Convert the structure to JSON (ensure 
  # that "auto_unbox" is set to TRUE).
  query = list(
    filters = paste(filters, collapse = ";"),
    structure = jsonlite::toJSON(structure, auto_unbox = TRUE)
  ),
  
  # The API server will automatically reject any
  # requests that take longer than 10 seconds to 
  # process.
  timeout(10)
) -> response

# Handle errors:
if (response$status_code >= 400) {
  err_msg = httr::http_status(response)
  stop(err_msg)
}

# Convert response from binary to JSON:
json_text <- content(response, "text")
df_nationsH = jsonlite::fromJSON(json_text)
df_nationsH = data_frame(df_nationsH$data)
df_nationsH = as.data.frame(do.call(cbind, df_nationsH))




############# HEALTH DATA: NHS REGION

# create vector of area names
nhsregionnames = c("East of England", "London", "Midlands",
                   "North East and Yorkshire", "North West", 
                   "South East", "South West")

# create get nation data function
getregiondata = function(areaname) {
  AREA_TYPE = "nhsRegion"
  AREA_NAME = areaname
  
  endpoint <- "https://api.coronavirus.data.gov.uk/v1/data"
  
  # Create filters:
  filters <- c(
    sprintf("areaType=%s", AREA_TYPE),
    sprintf("areaName=%s", AREA_NAME)
  )
  
  # Create the structure as a list or a list of lists:
  structure <- list(
    date = "date", 
    name = "areaName", 
    code = "areaCode", 
    health = list(
      newadmissions = "newAdmissions",
      cumadmissions = "cumAdmissions",
      occbeds = "covidOccupiedMVBeds",
      hospitalcases = "hospitalCases",
      plannedcapacity = "plannedCapacityByPublishDate"
    )
  )
  
  # The "httr::GET" method automatically encodes 
  # the URL and its parameters:
  httr::GET(
    # Concatenate the filters vector using a semicolon.
    url = endpoint,
    
    # Convert the structure to JSON (ensure 
    # that "auto_unbox" is set to TRUE).
    query = list(
      filters = paste(filters, collapse = ";"),
      structure = jsonlite::toJSON(structure, auto_unbox = TRUE)
    ),
    
    # The API server will automatically reject any
    # requests that take longer than 10 seconds to 
    # process.
    timeout(10)
  ) -> response
  
  # Handle errors:
  if (response$status_code >= 400) {
    err_msg = httr::http_status(response)
    stop(err_msg)
  }
  
  # Convert response from binary to JSON:
  json_text <- content(response, "text")
  data = jsonlite::fromJSON(json_text)
  data = as.data.frame(data)
  data = as.data.frame(do.call(cbind, data))
  data = as_tibble(data)
  print(data)
}

# create for loop to run through the different names and save as a new dataframe
df_nhsregions = data.frame()
for (i in nhsregionnames) {
  df = getregiondata(areaname = i)
  df_nhsregions = rbind(df_nhsregions, df)
} 


# Pull together the HEALTH data from: df_nationsH and df_nhsregions

### Rename column headers
df_nhsregions = rename(df_nhsregions,
                       date = data.date,
                       name = data.name,
                       code = data.code,
                       health.newadmissions = data.health.newadmissions,
                       health.cumadmissions = data.health.cumadmissions,
                       health.occbeds = data.health.occbeds,
                       health.hospitalcases = data.health.hospitalcases,
                       health.plannedcapacity = data.health.plannedcapacity
)



### Create area.type column
df_nationsH$area.type = "nation"
df_nhsregions$area.type = "nhsregion"


# Identify common columns
common_cols = intersect(colnames(df_nhsregions), colnames(df_nationsH))

# Bind the observations by common columns
health = rbind(
  df_nhsregions[, common_cols],
  df_nationsH[, common_cols]
)

# Use lubridate
health$date = ymd(health$date)

# cache data
# cache('health')

# Remove the data frames, functions and values no longer needed 
rm(df)
rm(df_nationsH)
rm(df_nhsregions)
rm(response)
rm(structure)
rm(AREA_TYPE)
rm(common_codes)
rm(common_cols)
rm(endpoint)
rm(filters)
rm(i)
rm(json_text)
rm(ltlanames)
rm(nhsregionnames)
rm(regionnames)
rm(utlanames)
rm(getLTLAdata)
rm(getregiondata)
rm(getUTLAdata)


# ADDITIONAL DATA PREP AFTER INITIAL EDA

# remove health.plannedcapacity column
# health = select(health, -health.plannedcapacity)

# remove observations after 19 August 2020
# health = filter(health, date <= "2020-08-19")


# Scotland
# Manually update the health.newadmissions NA values for Scotland based 
# on the data in the tables here:  https://coronavirus.data.gov.uk/healthcare?areaType=nation&areaName=Scotland
# date(daily admission number): 2020-08-19(2), 2020-08-18(1), 2020-08-17(1), 2020-08-16(1), 2020-08-15(4), 2020-08-14(2), 2020-08-13(1)
# date(cumulative admission number): 2020-08-19(5970), 2020-08-18(5968), 2020-08-17(5967), 2020-08-16(5966), 2020-08-15(5965), 2020-08-14(5961), 2020-08-13(5959)
# health[1405,4] = 2
# health[1405,5] = 5970
# health[1406,4] = 1
# health[1406,5] = 5968
# health[1407,4] = 1
# health[1407,5] = 5967
# health[1408,4] = 1
# health[1408,5] = 5966
# health[1409,4] = 4
# health[1409,5] = 5965
# health[1410,4] = 2
# health[1410,5] = 5961
# health[1411,4] = 1
# health[1411,5] = 5959


# Ireland
# Manually update the health.newadmissions NA values for Northern Ireland based 
# on the data in the tables here:  https://coronavirus.data.gov.uk/healthcare?areaType=nation&areaName=Northern%20Ireland
# date(daily admission number): 2020-03-01(0)
# date(cumulative admission number): 2020-03-01(0)
# health[1404,4] = 0
# health[1404,5] = 0

# cache data
# cache('health')
