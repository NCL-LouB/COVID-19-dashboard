######################################### DEATHS

############# DEATHS: NATIONS
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
  deaths = list(
    daily = "newDeaths28DaysByDeathDate",
    cumulative = "cumDeaths28DaysByDeathDate",
    rate = "cumDeaths28DaysByDeathDateRate",
    dailypublish = "newDeaths28DaysByPublishDate",
    cumulativepublish = "cumDeaths28DaysByPublishDate",
    ratepublish = "cumDeaths28DaysByPublishDateRate"
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
df_nationsD = jsonlite::fromJSON(json_text)
df_nationsD = data_frame(df_nationsD$data)
df_nationsD = as.data.frame(do.call(cbind, df_nationsD))




############# DEATHS: REGION

# create get nation data function
getregiondata = function(areaname) {
  AREA_TYPE = "region"
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
    deaths = list(
      daily = "newDeaths28DaysByDeathDate",
      cumulative = "cumDeaths28DaysByDeathDate",
      rate = "cumDeaths28DaysByDeathDateRate",
      dailypublish = "newDeaths28DaysByPublishDate",
      cumulativepublish = "cumDeaths28DaysByPublishDate",
      ratepublish = "cumDeaths28DaysByPublishDateRate"
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
df_regionsD = data.frame()
for (i in regionnames) {
  df = getregiondata(areaname = i)
  df_regionsD = rbind(df_regionsD, df)
} 



# Pull together the DEATHS data from: df_nationsD and df_regionsD

### Rename column headers
df_regionsD = rename(df_regionsD,
                     date = data.date,
                     name = data.name,
                     code = data.code,
                     deaths.daily = data.deaths.daily,
                     deaths.cumulative = data.deaths.cumulative,
                     deaths.rate = data.deaths.rate,
                     deaths.dailypublish = data.deaths.dailypublish,
                     deaths.cumulativepublish = data.deaths.cumulativepublish,
                     deaths.ratepublish = data.deaths.ratepublish
)



### Create area.type column
df_nationsD$area.type = "nation"
df_regionsD$area.type = "region"


# Identify common columns
common_cols = intersect(colnames(df_regionsD), colnames(df_nationsD))

# Bind the observations by common columns
deaths = rbind(
  df_regionsD[, common_cols],
  df_nationsD[, common_cols]
)

# Use lubridate
deaths$date = ymd(deaths$date)

# cache data
# cache('deaths')

# Remove the data frames and values no longer needed 
rm(df)
rm(df_nationsD)
rm(df_regionsD)


# ADDITIONAL DATA PREP AFTER INITIAL EDA
# THE CODE BELOW HAS BEEN HASHED OUT AS IT IS A MANUAL FIX AND ANY NEW DATA FRAMES WILL NEED 
# TO BE INSPECTED BEFORE FURTHER CLEANING OCCURS

# deaths = select(deaths, date, name, area.type, code, 
#                deaths.daily, deaths.cumulative, deaths.rate)

# deaths = filter(deaths, date <= "2020-08-17")

# Scotland
# Change deaths.daily NA value to 0 for Scotland 
# deaths[1964,5] = 0

# England
# Change deaths.daily NA value to 0 for England for dates(2020-03-04,	2020-03-06,	2020-03-07
# Change deaths.cumulative NA value to 0 for England for dates(2020-03-04,	2020-03-06, 2020-03-07) 
# deaths[1637,5] = 0
# deaths[1635,5] = 0
# deaths[1634,5] = 0
# deaths[1637,6] = 3
# deaths[1635,6] = 6
# deaths[1634,6] = 6

# East Midlands
# Change deaths.daily NA value to 0 for East Midlands for dates 2020-08-15, 2020-03-17, 2020-03-15, 
# 2020-03-11, 2020-03-10, 2020-03-09, 2020-03-08, 2020-03-07, 2020-03-06, 2020-03-05, 2020-03-04.
# Change deaths.cumulative NA value to 0 for East Midlands for dates 2020-08-15, 2020-03-17, 2020-03-15, 
# 2020-03-11, 2020-03-10, 2020-03-09, 2020-03-08, 2020-03-07, 2020-03-06, 2020-03-05, 2020-03-04.
# deaths[3,5] = 0
# deaths[3,6] = 2934
# deaths[167:160,5] = 0
# deaths[167:160,6] = 1
# deaths[156,5] = 0
# deaths[156,6] = 4
# deaths[154,5] = 0
# deaths[154,6] = 8


# East of England
# Change deaths.daily NA value to 0 for East of England for dates 2020-03-03, 2020-03-04, 2020-03-05, 2020-03-06, 
# 2020-03-07, 2020-03-08, 2020-03-10, 2020-03-11, 2020-03-12, 2020-03-14.
# Change deaths.cumulative NA value to 0 for East of England for dates 2020-03-03, 2020-03-04, 2020-03-05, 2020-03-06, 
# 2020-03-07, 2020-03-08, 2020-03-10, 2020-03-11, 2020-03-12, 2020-03-14.
# deaths[325,5] = 0
# deaths[325,6] = 3
# deaths[327:329,5] = 0
# deaths[327:329,6] = 2
# deaths[331:336,5] = 0
# deaths[331:336,6] = 1


# North East
# Change deaths.daily NA value to 0 for North East for dates 2020-08-16, 2020-08-05, 2020-07-16, 2020-03-17, 2020-03-16
# Change deaths.cumulative NA value to 0 for North East for dates 2020-08-16, 2020-08-05, 2020-07-16, 2020-03-17, 2020-03-16
# deaths[501,5] = 0
# deaths[501,6] = 2120
# deaths[512,5] = 0
# deaths[512,6] = 2119
# deaths[532,5] = 0
# deaths[532,6] = 2117
# deaths[653:654,5] = 0
# deaths[653:654,6] = 1


# North West
# Change deaths.daily NA value to 0 for North West for dates 2020-03-09, 2020-03-10, 2020-03-12
# Change deaths.cumulative NA value to 0 for North West for dates 2020-03-09, 2020-03-10, 2020-03-12
# deaths[814,5] = 0
# deaths[814,6] = 2
# deaths[816:817,5] = 0
# deaths[816:817,6] = 1

# South East
# Change deaths.daily NA value to 0 for South East for dates 2020-03-04, 2020-03-06, 2020-03-07, 2020-03-12 
# Change deaths.cumulative NA value to 0 for South East for dates 2020-03-04, 2020-03-06, 2020-03-07, 2020-03-12 
# deaths[985,5] = 0
# deaths[985,6] = 1
# deaths[982:983,5] = 0
# deaths[982:983,6] = 3
# deaths[977,5] = 0
# deaths[977,6] = 7


# South West
# Change deaths.daily NA value to 0 for South West for dates 2020-08-01, 2020-07-28, 2020-07-22, 2020-07-06, 2020-03-16,
# 2020-03-13, 2020-03-12, 2020-03-10
# Change deaths.cumulative NA value to 0 for South West for dates 2020-08-01, 2020-07-28, 2020-07-22, 2020-07-06, 2020-03-16,
# 2020-03-13, 2020-03-12, 2020-03-10
# deaths[1003,5] = 0
# deaths[1003,6] = 1876
# deaths[1007,5] = 0
# deaths[1007,6] = 1875
# deaths[1013,5] = 0
# deaths[1013,6] = 1875
# deaths[1028,5] = 0
# deaths[1028,6] = 1867
# deaths[1141,5] = 0
# deaths[1141,6] = 4
# deaths[1144:1145,5] = 0
# deaths[1144:1145,6] = 2
# deaths[1147,5] = 0
# deaths[1147,6] = 1



# West Midlands
# Change deaths.daily NA value to 0 for West Midlands for dates 2020-08-01, 2020-03-09
# Change deaths.cumulative NA value to 0 for West Midlands for dates 2020-08-01, 2020-03-09
# deaths[1165,5] = 0
# deaths[1165,6] = 4536
# deaths[1310,5] = 0
# deaths[1310,6] = 1


# Yorkshire and The Humber
# Change deaths.daily NA value to 0 for Yorkshire and The Humber for dates 	2020-03-14, 2020-03-13
# Change deaths.cumulative NA value to 0 for Yorkshire and The Humber for dates 2020-03-14, 2020-03-13 
# deaths[1468:1469,5] = 0
# deaths[1468:1469,6] = 1


# cache data
# cache('deaths')




########## DATA PREPARATION FOR SHINY DASHBOARD

nationdeaths = deaths %>% filter(area.type == "nation")
regiondeaths = deaths %>% filter(area.type == "region")

# cache data
# cache('nationdeaths')
# cache('regiondeaths')

