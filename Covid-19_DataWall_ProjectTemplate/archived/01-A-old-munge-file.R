# Pulling data from the gov Covid-19 api v.1: https://coronavirus.data.gov.uk/developers-guide

############# CASES: NATIONS
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
  cases = list( 
    daily = "newCasesBySpecimenDate",
    cumulative = "cumCasesBySpecimenDate",
    rate = "cumCasesBySpecimenDateRate",
    dailyPublish = "newCasesByPublishDate",
    cumulativePublish = "cumCasesByPublishDate"
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
df_nations = jsonlite::fromJSON(json_text)
df_nations = data_frame(df_nations$data)
df_nations = as.data.frame(do.call(cbind, df_nations))




############# CASES: REGION

# create vector of area names
regionnames = c("east midlands", "east of england", "london", 
                "north east", "north west", "south east", 
                "south west", "west midlands", "yorkshire and the humber")

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
    cases = list(
      daily = "newCasesBySpecimenDate",
      cumulative = "cumCasesBySpecimenDate",
      rate = "cumCasesBySpecimenDateRate"
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
df_regions = data.frame()
for (i in regionnames) {
  df = getregiondata(areaname = i)
  df_regions = rbind(df_regions, df)
} 



############# CASES: Upper Tier Local Authority

daily.lab.confirmed.cases = read_csv("~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/data/coronavirus-cases_latest_20200702.csv")
# remove spaces from the headers
names(daily.lab.confirmed.cases) = str_replace_all(names(daily.lab.confirmed.cases), c(" " = "." , "," = "","-" = "."))

utlanames =  daily.lab.confirmed.cases %>% filter(Area.type == "Upper tier local authority")
utlanames = as.vector(utlanames$Area.name)
utlanames = unique(utlanames)

# Hackney and City of London are combined so
# replace "Hackney" with "Hackney and City of London" 
utlanames = replace(utlanames, utlanames =="Hackney", "Hackney and City of London")
# remove "City of London"
utlanames = utlanames[-59]

# The utla names in this file do not match so do not use.
# Load local authority name data from http://geoportal.statistics.gov.uk/datasets/41828627a5ae4f65961b0e741258d210_0/data?orderBy=UTLA17NM
# localauthority = read_csv("~/Downloads/Lower_Tier_Local_Authority_to_Upper_Tier_Local_Authority__December_2017__Lookup_in_England_and_Wales.csv")

# create get nation data function
getUTLAdata = function(areaname) {
  AREA_TYPE = "utla"
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
    cases = list(
      daily = "newCasesBySpecimenDate",
      cumulative = "cumCasesBySpecimenDate",
      rate = "cumCasesBySpecimenDateRate"
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
df_utla = data.frame()
for (i in utlanames) {
  df = getUTLAdata(areaname = i)
  df_utla = rbind(df_utla, df)
} 




############# CASES: Lower Tier Local Authority

# create vector of area names
ltlanames =  daily.lab.confirmed.cases %>% filter(Area.type == "Lower tier local authority")
ltlanames = as.vector(ltlanames$Area.name)
ltlanames = unique(ltlanames)

# Hackney and City of London are combined so
# replace "Hackney" with "Hackney and City of London" 
ltlanames = replace(ltlanames, ltlanames =="Hackney", "Hackney and City of London")
# remove "City of London"
ltlanames = ltlanames[-33]


# create get nation data function
getLTLAdata = function(areaname) {
  AREA_TYPE = "ltla"
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
    cases = list(
      daily = "newCasesBySpecimenDate",
      cumulative = "cumCasesBySpecimenDate",
      rate = "cumCasesBySpecimenDateRate"
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
df_ltla = data.frame()
for (i in ltlanames) {
  df = getLTLAdata(areaname = i)
  df_ltla = rbind(df_ltla, df)
} 


# Pull together the CASES data from: df_nations, df_regions, df_utla and df_ltla 
# Fields needed from df_nations: date, name, code, cases.daily, cases.cumulative, area.type (create field), case.type (create field)
# Fields needed from df_regions: data.date, data.name, data.code, data.cases.daily, data.cases.cumulative, area.type (create field), case.type (create field)
# Fields needed from df_utla: data.date, data.name, data.code, data.cases.daily, data.cases.cumulative, area.type (create field), case.type (create field)
# Fields needed from df_ltla: data.date, data.name, data.code, data.cases.daily, data.cases.cumulative, area.type (create field), case.type (create field)

### Rename column headers
df_regions = rename(df_regions,
                    date = data.date,
                    name = data.name,
                    code = data.code,
                    cases.daily = data.cases.daily,
                    cases.cumulative = data.cases.cumulative,
                    cases.rate = data.cases.rate
)

df_utla = rename(df_utla,
                 date = data.date,
                 name = data.name,
                 code = data.code,
                 cases.daily = data.cases.daily,
                 cases.cumulative = data.cases.cumulative,
                 cases.rate = data.cases.rate
)

df_ltla = rename(df_ltla,
                 date = data.date,
                 name = data.name,
                 code = data.code,
                 cases.daily = data.cases.daily,
                 cases.cumulative = data.cases.cumulative,
                 cases.rate = data.cases.rate
)

### Create area.type column
df_nations$area.type = "nation"
df_regions$area.type = "region"
df_utla$area.type = "utla"
df_ltla$area.type = "ltla"

### Create case.type column
df_nations$case.type = "Publish date"
df_regions$case.type = "Specimen date"
df_utla$case.type = "Specimen date"
df_ltla$case.type = "Specimen date"

# Identify common columns
common_cols = intersect(colnames(df_regions), colnames(df_ltla))
# Bind the observations by common columns
cases = rbind(
  df_regions[, common_cols],
  df_utla[, common_cols],
  df_ltla[, common_cols]
)

# Create empty columns for the published cases data
cases$cases.dailyPublish = NA
cases$cases.cumulativePublish = NA

# Identify common columns
common_cols = intersect(colnames(df_nations), colnames(cases))

# Bind the observations by common columns
cases = rbind(
  cases[, common_cols],
  df_nations[, common_cols]
)


# Use lubridate
cases$date = ymd(cases$date)


# Load UK data from csv file downloaded on 13 August 2020 from the 
# 'Daily cases by date reported' figure here: https://coronavirus.data.gov.uk/cases
UKcases = read_csv("~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/data/data_2020-Aug-12.csv")

### Create area.type column
UKcases$area.type = "United Kingdom"
### Create case.type column
UKcases$case.type = "Publish date"


### Rename column headers
UKcases = rename(UKcases,
                 name = areaName,
                 code = areaCode,
                 cases.dailyPublish = newCasesByPublishDate,
                 cases.cumulativePublish = cumCasesByPublishDate)

# Create empty columns for the specimen cases data
UKcases$cases.daily = NA
UKcases$cases.cumulative = NA
UKcases$cases.rate = NA

# Order columns
UKcases = select(UKcases, date, name, code, 
                 cases.daily, cases.cumulative, cases.rate,
                 cases.dailyPublish, cases.cumulativePublish,
                 area.type, case.type)

# Use lubridate
UKcases$date = ymd(UKcases$date)

# Identify common columns
common_cols = intersect(colnames(UKcases), colnames(cases))

# Bind the observations by common columns
cases = rbind(
  cases[, common_cols],
  UKcases[, common_cols]
)


# Import the 2019 mid-year population data.
# Downloaded from: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland
setwd("~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/data")
population = read_excel("ukmidyearestimates20192020ladcodes.xls", sheet = "MYE2 - Persons", range = "A5:D431")


# rename Code to code
population = population %>%
  rename(code = Code)

# Buckinghamshire E10000002 is in the spreadsheet under a different code. Update code in population data and join again
population$code[267] = "E10000002"

# Identify common codes (350)
common_codes = intersect(cases$code, population$code)
# Identify common codes (76)
extra_codes = setdiff(population$code, common_codes)
# View extra codes
extras = population %>% 
  filter(code %in% c(extra_codes))

# Add the population data to the cases data frame
cases = right_join(y=cases, x=population, by = 'code')

# These Local Authority Districts are missing from the population data:
# Aylesbury Vale E07000004
# Chiltern E07000005
# South Bucks E07000006
# Wycombe E07000007

#rename column
cases = cases %>%
  rename(population = "All ages")

# Select cases columns
cases = select(cases, date, name, code, 
               cases.daily, cases.cumulative, cases.rate, 
               cases.dailyPublish, cases.cumulativePublish,
               area.type, case.type, population)

# Calculate the rate
cases = cases %>%
  mutate(cumcases.rate = round(cases.cumulative/population * 100000, digits = 1))


sum(is.na(cases$cases.rate))
sum(is.na(cases$cumcases.rate))
# There are less NAs in governments data so remove my column.
cases = select(cases, date, area.type, name, code, 
               cases.daily, cases.cumulative, cases.rate, 
               cases.dailyPublish, cases.cumulativePublish,
               case.type, population)



# Cache data 
#cache('cases')

# Remove the data frames and values no longer needed 
rm(daily.lab.confirmed.cases)
rm(df)
rm(df_ltla)
rm(df_nations)
rm(df_regions)
rm(df_utla)
rm(extras)
rm(population)
rm(response)
rm(structure)
rm(UKcases)
rm(extra_codes)



# Create data frame of cases by nation ONLY
# Prepare the data
nationCases = cases %>% 
  filter(area.type == "nation")
cache('nationCases')


# Create data frame of cases by region ONLY
# Prepare the data
regionCases = filter(cases, area.type == "region")
cache('regionCases')

# Create data frame of cases by North East Local Authority ONLY
# Prepare the data
NEltlaCases = cases %>% 
  filter(area.type == "ltla" & 
           code %in% c("E06000057", "E08000021", "E08000022", 
                       "E08000023", "E08000037", "E08000024", 
                       "E06000047", "E06000005", "E06000001", 
                       "E06000004", "E06000002", "E06000003")) 

cache('NEltlaCases')


# This is not use in the shiny app but may be used for EDA
cases2 = filter(cases, area.type %in% c("nation", "region", "utla"))
# cache('cases2')


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
cache('deaths')

# Remove the data frames and values no longer needed 
rm(df)
rm(df_nationsD)
rm(df_regionsD)

# ADDITIONAL DATA PREP AFTER INITIAL EDA

deaths = select(deaths, date, name, area.type, code, 
                deaths.daily, deaths.cumulative, deaths.rate)

deaths = filter(deaths, date <= "2020-08-17")

# Scotland
# Change deaths.daily NA value to 0 for Scotland 
deaths[1964,5] = 0

# England
# Change deaths.daily NA value to 0 for England for dates(2020-03-04,	2020-03-06,	2020-03-07
# Change deaths.cumulative NA value to 0 for England for dates(2020-03-04,	2020-03-06, 2020-03-07) 
deaths[1637,5] = 0
deaths[1635,5] = 0
deaths[1634,5] = 0
deaths[1637,6] = 3
deaths[1635,6] = 6
deaths[1634,6] = 6

# East Midlands
# Change deaths.daily NA value to 0 for East Midlands for dates 2020-08-15, 2020-03-17, 2020-03-15, 
# 2020-03-11, 2020-03-10, 2020-03-09, 2020-03-08, 2020-03-07, 2020-03-06, 2020-03-05, 2020-03-04.
# Change deaths.cumulative NA value to 0 for East Midlands for dates 2020-08-15, 2020-03-17, 2020-03-15, 
# 2020-03-11, 2020-03-10, 2020-03-09, 2020-03-08, 2020-03-07, 2020-03-06, 2020-03-05, 2020-03-04.
deaths[3,5] = 0
deaths[3,6] = 2934
deaths[167:160,5] = 0
deaths[167:160,6] = 1
deaths[156,5] = 0
deaths[156,6] = 4
deaths[154,5] = 0
deaths[154,6] = 8


# East of England
# Change deaths.daily NA value to 0 for East of England for dates 2020-03-03, 2020-03-04, 2020-03-05, 2020-03-06, 
# 2020-03-07, 2020-03-08, 2020-03-10, 2020-03-11, 2020-03-12, 2020-03-14.
# Change deaths.cumulative NA value to 0 for East of England for dates 2020-03-03, 2020-03-04, 2020-03-05, 2020-03-06, 
# 2020-03-07, 2020-03-08, 2020-03-10, 2020-03-11, 2020-03-12, 2020-03-14.
deaths[325,5] = 0
deaths[325,6] = 3
deaths[327:329,5] = 0
deaths[327:329,6] = 2
deaths[331:336,5] = 0
deaths[331:336,6] = 1


# North East
# Change deaths.daily NA value to 0 for North East for dates 2020-08-16, 2020-08-05, 2020-07-16, 2020-03-17, 2020-03-16
# Change deaths.cumulative NA value to 0 for North East for dates 2020-08-16, 2020-08-05, 2020-07-16, 2020-03-17, 2020-03-16
deaths[501,5] = 0
deaths[501,6] = 2120
deaths[512,5] = 0
deaths[512,6] = 2119
deaths[532,5] = 0
deaths[532,6] = 2117
deaths[653:654,5] = 0
deaths[653:654,6] = 1


# North West
# Change deaths.daily NA value to 0 for North West for dates 2020-03-09, 2020-03-10, 2020-03-12
# Change deaths.cumulative NA value to 0 for North West for dates 2020-03-09, 2020-03-10, 2020-03-12
deaths[814,5] = 0
deaths[814,6] = 2
deaths[816:817,5] = 0
deaths[816:817,6] = 1

# South East
# Change deaths.daily NA value to 0 for South East for dates 2020-03-04, 2020-03-06, 2020-03-07, 2020-03-12 
# Change deaths.cumulative NA value to 0 for South East for dates 2020-03-04, 2020-03-06, 2020-03-07, 2020-03-12 
deaths[985,5] = 0
deaths[985,6] = 1
deaths[982:983,5] = 0
deaths[982:983,6] = 3
deaths[977,5] = 0
deaths[977,6] = 7


# South West
# Change deaths.daily NA value to 0 for South West for dates 2020-08-01, 2020-07-28, 2020-07-22, 2020-07-06, 2020-03-16,
# 2020-03-13, 2020-03-12, 2020-03-10
# Change deaths.cumulative NA value to 0 for South West for dates 2020-08-01, 2020-07-28, 2020-07-22, 2020-07-06, 2020-03-16,
# 2020-03-13, 2020-03-12, 2020-03-10
deaths[1003,5] = 0
deaths[1003,6] = 1876
deaths[1007,5] = 0
deaths[1007,6] = 1875
deaths[1013,5] = 0
deaths[1013,6] = 1875
deaths[1028,5] = 0
deaths[1028,6] = 1867
deaths[1141,5] = 0
deaths[1141,6] = 4
deaths[1144:1145,5] = 0
deaths[1144:1145,6] = 2
deaths[1147,5] = 0
deaths[1147,6] = 1



# West Midlands
# Change deaths.daily NA value to 0 for West Midlands for dates 2020-08-01, 2020-03-09
# Change deaths.cumulative NA value to 0 for West Midlands for dates 2020-08-01, 2020-03-09
deaths[1165,5] = 0
deaths[1165,6] = 4536
deaths[1310,5] = 0
deaths[1310,6] = 1


# Yorkshire and The Humber
# Change deaths.daily NA value to 0 for Yorkshire and The Humber for dates 	2020-03-14, 2020-03-13
# Change deaths.cumulative NA value to 0 for Yorkshire and The Humber for dates 2020-03-14, 2020-03-13 
deaths[1468:1469,5] = 0
deaths[1468:1469,6] = 1


# cache data
cache('deaths')


nationdeaths = deaths %>% filter(area.type == "nation")
regiondeaths = deaths %>% filter(area.type == "region")

# cache data
cache('nationdeaths')
cache('regiondeaths')


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
cache('health')

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
health = select(health, -health.plannedcapacity)

# remove observations after 19 August 2020
health = filter(health, date <= "2020-08-19")


# Scotland
# Manually update the health.newadmissions NA values for Scotland based 
# on the data in the tables here:  https://coronavirus.data.gov.uk/healthcare?areaType=nation&areaName=Scotland
# date(daily admission number): 2020-08-19(2), 2020-08-18(1), 2020-08-17(1), 2020-08-16(1), 2020-08-15(4), 2020-08-14(2), 2020-08-13(1)
# date(cumulative admission number): 2020-08-19(5970), 2020-08-18(5968), 2020-08-17(5967), 2020-08-16(5966), 2020-08-15(5965), 2020-08-14(5961), 2020-08-13(5959)
health[1405,4] = 2
health[1405,5] = 5970
health[1406,4] = 1
health[1406,5] = 5968
health[1407,4] = 1
health[1407,5] = 5967
health[1408,4] = 1
health[1408,5] = 5966
health[1409,4] = 4
health[1409,5] = 5965
health[1410,4] = 2
health[1410,5] = 5961
health[1411,4] = 1
health[1411,5] = 5959
  

# Ireland
# Manually update the health.newadmissions NA values for Northern Ireland based 
# on the data in the tables here:  https://coronavirus.data.gov.uk/healthcare?areaType=nation&areaName=Northern%20Ireland
# date(daily admission number): 2020-03-01(0)
# date(cumulative admission number): 2020-03-01(0)
health[1404,4] = 0
health[1404,5] = 0

# cache data
cache('health')


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


# --- URBAN OBSERVATORY: Car Park --- #
# Pull in the car park meta data
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

# cache
cache('carpark.meta')




# Pull in the car park data
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
# cache last cached 17 August 2020
cache('carpark')

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

cache('carparkLONG')

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
cache('carparkSummary')


rm(carpark)
rm(carparkLONG)

 
# --- URBAN OBSERVATORY: Pedestrian Flow Data --- #
# Pull in the pedestrian flow data
pedestrian.flow = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/recent-pedestrian-flows-pd.csv"))
# I have no idea what this data is for...
# cache last cached 17 August 2020
# cache('pedestrian.flow')

load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/pedestrian.flow.RData")

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

# Select only the values relating to Northumberland St near Fenwick (east side) and Northumberland St near Fenwick (west side)

ped.flow = ped.summary %>%
  filter(location %in% c ("Northumberland.St.near.Fenwick..east.side...Walking.North", 
                          "Northumberland.St.near.Fenwick..east.side...Walking.South",
                          "Northumberland.St.near.Fenwick..west.side...Walking.North",
                          "Northumberland.St.near.Fenwick..west.side...Walking.South"))



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




## Cache pedestrian.flow.LONG, ped.summary and ped.flow
cache('pedestrian.flow.LONG') 
cache('ped.summary') 
cache('ped.flow')
cache('NorthumberlandSt.west')
cache('NorthumberlandSt.east')

## Cache ped.summary and ped.flow
cache('ped.summary') 
cache(ped.flow)


rm(ped.flow.median)
rm(ped.flow.median2)
rm(ped.flow.Summary)
rm(ped.flow.Summary2)
rm(pedestrian.flow.LONG)
rm(getTimeCat)
rm(hourlyAV)


# --- URBAN OBSERVATORY: Traffic Data --- #
# Pull in the anpr volumes meta data
anpr.volumes.meta = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/t%26w-anpr-volumes-link-metadata-pd.csv"))
# I have no idea what this data is for...
# cache last cached 17 August 2020
# cache('anpr.volumes.meta')

# Pull in the anpr volumes pd 16min data
anpr.volumes.16min = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/t%26w-anpr-volumes-pd-16min.csv"))
# I have no idea what this data is for...
# cache last cached 17 August 2020
# cache('anpr.volumes.16min')

# Pull in the anpr volumes meta mapping data
anpr.volumes.mapping = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/t%26w-anpr-volumes-point-metadata-original-id-mapping.csv"))
# I have no idea what this data is for...
# cache last cached 17 August 2020
# cache('anpr.volumes.mapping')

# Pull in the anpr volumes meta mapping data
anpr.volumes.point.meta = read.csv(url("https://covid.view.urbanobservatory.ac.uk/output/t%26w-anpr-volumes-point-metadata-pd.csv"))
# I have no idea what this data is for...
# cache last cached 17 August 2020
# cache('anpr.volumes.point.meta')


#### Data preparation for these items is located in munge/Traffic_Total_Preparation.R


# --- Office of National Statistics --- #
#weeklydeaths = read_excel("~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/data/weeklydeathswk23.xlsx", 
#           sheet = "Covid-19 - Weekly registrat (2)")

#weeklydeathsLONG = pivot_longer(
#  weeklydeaths, 
#  cols = -c("Week.ended", "Week.number"),
#  names_to = "Region",
#  values_to = "Weekly.deaths")




# --- # Lockdown timeline # --- #

# based on code from this website: https://www.themillerlab.io/post/timelines_in_r/

date = ymd(c("2020-03-23", "2020-04-30", "2020-05-13",
             "2020-05-13", "2020-05-22", "2020-06-01",
             "2020-06-08", "2020-06-08", "2020-06-13",
             "2020-06-15", "2020-06-15", "2020-06-17",
             "2020-06-22", "2020-06-23", "2020-06-29",
             "2020-07-04"))

lockdown.category = c(
  "Lockdown starts", "Past the peak", "Workers who cannot work from home are urged to return to the workplace", 
  "People are allowed to meet one other person outdoors as long as they stay 2m apart", "Guardian Dominic Cummoings story breaks",
  "Schools are allowed to reopen for reception, year 1 and year 6 pupils", "14 day quarantine measures introduced for all arrivals in the UK",
  "Dentists are allowed to reopen for the first time to provide non-emergency care", "The first social “bubble” is announced, with single person households allowed to meet and stay overnight with another household",
  "All non-essential shops can re-open", "No10 states that all pupils are allowed to return to school if it is possible to do so with strict social distancing rules in place, including 15-pupil caps on classes",
  "Premier League football restarts", "Spain allows UK holidays to travel without quarantine on arrival", "4th July identified as the date where 2m social distancing rule can be relaxed to 1m",
  "The first local lockdown is introduced in Leicester", "Pubs, restaurants and hair salons reopen")

lockdown.measures = data_frame(date, lockdown.category)

lockdown.measures$day = day(lockdown.measures$date)
lockdown.measures$month = month(lockdown.measures$date)
lockdown.measures$year = year(lockdown.measures$date)

lockdown.measures$event_type = c("restrictions tightened", "news report", "restrictions loosened",
                                 "restrictions loosened", "news report", "restrictions loosened",
                                 "restrictions tightened", "restrictions loosened", "restrictions loosened",
                                 "restrictions loosened", "restrictions loosened", "restrictions loosened",
                                 "restrictions loosened", "news report", "restrictions tightened",
                                 "restrictions loosened")
                                 
# Add a specified order to these event type labeles
event_type_levels = c("restrictions tightened", "news report", "restrictions loosened") 

# Define the colors for the event types in the specified order. 
## These hashtagged codes represent the colors (green, yellow, red) as hexadecimal color codes.
event_type_colors = c("#FFC000",  "#00B050", "#0070C0" ) 


# Make the Event_type vector a factor using the levels we defined above
lockdown.measures$event_type = factor(lockdown.measures$event_type, levels= event_type_levels, ordered=TRUE)


lockdown.measures$position = c(0.5, -0.5, 1.0, -1.0, 1.25, -1.25, 1.5, -1.5, 0.5, -0.5, 1.0, -1.0, 1.25, -1.25, 1.5, -1.5)

# Set the directions we will use for our milestone, for example above and below.
lockdown.measures$direction = c(1, -1, 1, -1, 1, -1, 1, -1,
                1, -1, 1, -1, 1, -1, 1, -1) 


# cache('lockdown.measures')
