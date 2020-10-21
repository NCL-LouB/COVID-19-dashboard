# Dissertation Project: Covid-19 Interactive Data Visualization 

This repository holds all the material relavent to my Data Science MSc dissertation project on interactive data visualizations.

The project using the ProjectTemplate directory structure. More details of what is contained in each folder and how to get the dashboard up and running is included in the sections below.


## Motivation
The purpose of this project was to create an interactive data visualisation, for the general public, which tells the story of COVID-19 in the North East by assembling and analysing national, regional and local open datasets which document the effects of COVID-19. The project took initial inspiration from two existing COVID-19 dashboards made by colleagues at Newcastle University:

1. ['COVID-19 in Northern England'](https://app.powerbi.com/view?r=eyJrIjoiYTU0YjU3MmYtZGQ3NC00YWFlLWJiYWQtZWU2MTQyMDM4ZDAwIiwidCI6IjljNTAxMmM5LWI2MTYtNDRjMi1hOTE3LTY2ODE0ZmJlM2U4NyIsImMiOjh9) created by Professor Nick Holliman 
2. ['Effects of Virus Measures'](https://covid.view.urbanobservatory.ac.uk/#intro) created by the Newcastle Urban Observatory


## Data  
The project works with time series data for the period January 2020 to August 2020 (exact dates vary between datasets). 

The data was taken from the [Urban Observatory](https://covid.view.urbanobservatory.ac.uk/output) and the [Government's Coronvirus API](https://coronavirus.data.gov.uk/developers-guide). The time series chunks are located in the cache directory.

If you want to update the data sets to incorporate more recent dates you can use the munge files in the munge directory to access and munge.


## Installation 
1. Download the 'Covid-19_DataWall_ProjectTemplate' file 
2. Open RStudio
3. `setwd()` into the directory where this README file is located. Then run the following two lines of R code:
```

library('ProjectTemplate')
setwd('my-project')
load.project()

```
4. Open app.R file located in V1 directory
5. Run app

The following libraries will need to be installed to run the project: reshape2, plyr, tidyverse, stringr, lubridate, readxl, jsonlite, httr, shiny, plotly

```

install.packages('insertpackagename')

```

## Directory Guide
* __archived:__ Files that may be helpful for future work.  
* __cache:__ Data sets that (a) are generated during a preprocessing step and (b) don’t need to be regenerated every single time you analyze your data. These files do not authomatically load, as they do not need to be loaded in the environment for the Shiny app to run.   
* __config:__ The ProjectTemplate configurations settings for the project.   
* __data:__ The raw data files - please note that most of the raw data is stored in the cache directory as it was pulled from the interet.   
* __diagnostics:__ this directory was not used.  
* __docs: Documentation about preprocessing and analysis.__  
* __graphs:__ Here you can store any graphs that you produce.  
* __lib:__ This directory was not used.   
* __logs:__ This directory was not used.  
* __munge:__ Preprocessing/ data munging code for the project.  
* __profiling:__ This directory was not used.  
* __README.md:__ Notes to help orient any newcomers to the project.  
* __reports:__ This directory was not used.  
* __src:__ Here you’ll store your final statistical analysis scripts. You should add the following piece of code to the start of each analysis script: library('ProjectTemplate); load.project(). You should also do your best to ensure that any code that’s shared between the analyses in src is moved into the munge directory; if you do that, you can execute all of the analyses in the src directory in parallel. A future release of ProjectTemplate will provide tools to automatically execute every individual analysis from src in parallel.  
* __shiny:__ The Shiny app.  
* __tests:__ This directory was not used.  
* __TODO:__ This directory was not used.  


