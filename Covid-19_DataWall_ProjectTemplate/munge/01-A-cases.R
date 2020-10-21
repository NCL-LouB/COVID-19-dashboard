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
rm(response)
rm(structure)
rm(extra_codes)
rm(AREA_TYPE)


######################## DATA PREPARATION FOR SHINY DASHBOARD

# Create data frame of cases by nation ONLY
# Prepare the data
nationCases = cases %>% 
  filter(area.type == "nation")

nationCases$cases.daily[is.na(nationCases$cases.daily)] = 0
nationCases$cases.cumulative[is.na(nationCases$cases.cumulative)] = 0

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
