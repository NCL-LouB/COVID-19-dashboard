The following packages will be installed when running the 01-G-traffictotal.R file:

* sf
* rgdal

Please note:

1. the healthcare data was not used in the Shiny dashboard but the munge file remains as this could be added to the dashboard during the next round of development. 
2. all of the cache() functions have been hashed (#) out to ensure the original cached files are not accidently written over.  If you wish to pull in fresh data and process the data again delete the # from the cache lines in each file
3. in file 01-B-deaths.R lines 178:300 are manual data fixes, as the initial EDA identifiedmissing values for dates and regions that had values on the governments dashboard. For the completeness of the project the missing values were manually replaced. These lines have been hashed out, as the manual fixes may not be needed if the API request are made at a later date. 
4. in file 01-C-healthcare.R lines 195:2324 are manual data fixes, as the initial EDA identified missing values for dates and regions that had values on the governments dashboard. For the completeness of the project the missing values were manually replaced. These lines have been hashed out, as the manual fixes may not be needed if the API request are made at a later date. 