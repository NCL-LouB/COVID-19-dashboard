Here you'll store any data sets that (a) are generated during a preprocessing step and (b) don't need to be regenerated every single time you analyze your data. You can use the `cache()` function to store data to this directory automatically. Any data set found in both the `cache` and `data` directories will be drawn from `cache` instead of `data` based on ProjectTemplate's priority rules.


All these files were generated during the preprocessing stage. The code to generate the files can be found in the munge file. 

The files listed below are used in the Shiny app and are loaded when the app is run.

__CASES:__  
* nationCases.R (figures 1.1, 1.2)
* regionCases.R (figures 1.3, 1.4, 1.5)
* NEltlaCases.R (figures 1.6, 1.7, 1.8)

__DEATHS:__  
* nationdeaths (figures 2.1, 2.2)  
* regiondeaths (figures 2.3, 2.4)  

__TRAFFIC:__  
* mediantrafficLONG (figure 3.1)  
* Commutingtrafficmap (map 3.1)  
* CommutingtrafficDAY (figure 3.2)  

__CAR PARKS:__  
* carpark.meta (map 4.1, 4.2)  
* carparkSummary (figure 4.1)  

__PEDESTRIANS:__  
* ped.daily.totals (figure 5.1)  
* NorthumberlandSt.east (figure 5.2)  
* NorthumberlandSt.west (figure 5.3)  


The files listed below were generated during the data preprocessing and exploratory data analysis stages. 

__CASES:__  
* case.R (the data pulled from the government API. The api requests were compiled into one data frame and the data was cleaned)

__DEATHS:__  
* deaths.R (the data pulled from the government API. The api requests were compiled into one data frame and the data was cleaned)

__MEDIAN TRAFFIC:__  
* trafficAll.R	(median traffic before most preprocessing)  
* mediantraffic.R	(median traffic with selected North East areas)

__TOTAL TRAFFIC:__  
* anpr.volumes.meta.R (original file pulled from the Urban Observatory, no preprocessing)  
* anpr.volumes.point.meta.R (original file pulled from the Urban Observatory, no preprocessing)  
* trafficLatLong.R (meta data for all the anpr traffic points with the latitude and longitude added)  
* TotalTrafficLongjoin.R (anpr traffic count data for all traffic sites, large file of 12,610,800 observations)  
* Commutingtraffic.R (anpr traffic count data (TotalTrafficLongjoin) filtered to include only the 12 commuting locations)  

__CAR PARKS:__  
* carpark.R (original data with some preprocessing. The car parks with no data were removed and observations not from 2020 were removed)  
* carparkLONG.R (the carpark data frame is pivoted to long format and a daily occupancy hours variable is created)  

__PEDESTRIANS:__  
* pedestrian.flow.R (original file pulled from the Urban Observatory, no preprocessing)  
* pedestrian.flow.LONG.R (original data frame pivoted into long format with time category and direction added)  
* ped.summary.R	(data frame of summary statistics for all locations)  
* ped.flow.R (data frame of summary statistics filtered to include just Northumberland St near Fenwicks location)  

__HEATH CARE:__  
* health.R (this data was pulled using the government API but was not used for the dashboard, preprocessing has been applied)