This file contains raw data files used in the munge process:

* __coronavirus-cases_latest_20200702.csv:__ this file is used in the 01-A-cases.R munge file to extract the upper tier local authority (utla) names.
* __data_2020-Aug-12.csv:__ this 
* __ukpostcodes.csv:__ this file is used in the ?????????.R munge file to extract the postcodes of....


# Load UK data from csv file downloaded on 13 August 2020 from the 
# 'Daily cases by date reported' figure here: https://coronavirus.data.gov.uk/cases
UKcases = read_csv("~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/data/data_2020-Aug-12.csv")

### Create area.type column
UKcases$area.type = "United Kingdom"
### Create case.type column
UKcases$case.type = "Publish date"

