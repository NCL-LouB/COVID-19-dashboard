library(shiny)
library(shinythemes)
library(ggplot2)
library(plyr)
library(dplyr)
library(plotly)
library(leaflet)

# Load the cached data
###
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/nationCases.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/regionCases.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/NEltlaCases.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/nationdeaths.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/regiondeaths.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/mediantrafficLONG.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/Commutingtrafficmap.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/CommutingtrafficDAY.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carpark.meta.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/carparkSummary.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/ped.daily.totals.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/NorthumberlandSt.east.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/NorthumberlandSt.west.RData")


# Define UI for app that draws a histogram ----
ui <- fluidPage(
    # App title ----
    titlePanel("COVID-19 in the North East"),
    # Add top level navigation bar
    navbarPage("Menu",
               tabPanel(title = "Home",
                        fluidRow(
                            column(12,
                                   tags$h4("What is the purpose of the dashboard?"),
                                   tags$h5("Background"),
                                   tags$p("The dashboard assembles and analyses national, regional and local open datasets, which document the effects of COVID-19 in the North East of England."),
                                   tags$p("Data relating to COVID-19 cases and deaths was sourced from the UK Government's Coronavirus API, which was developed by Public Health England and NHSX. Regional data relating to traffic, pedestrian 
                                     flow and car parks was sourced from Newcastle University Urban Observatory. More information about each can be found in the links below."),
                                   tags$ul(
                                       tags$li(tags$a(href="https://https://coronavirus.data.gov.uk/developers-guide", "Access UK Government coronavirus data")),
                                       tags$li(tags$a(href="https://covid.view.urbanobservatory.ac.uk", "Access Urban Observatory data"))
                                   ),
                                   fluidRow(
                                       column(6,
                                              tags$h5("How should this dashboard be used?"),
                                              tags$p("Browse through the different pages using the menu bar. Some pages have mulitple tabs, with additional plots and data."),
                                              tags$p("Each page includes:"),
                                              tags$ul(
                                                  tags$li("A title, which doubles as an aim for the page"),
                                                  tags$li("An 'Info' tab, which includes information about the data and search suggetions, such as questions to ask yourself when looking at the data"),
                                                  tags$li("Plot tabs which include interactive plots and tips on how to use the interactive features"),
                                              )
                                       ),
                                       column(6,
                                              tags$h5("Who is this dashboard for?"),
                                              tags$p("This dashboard is for members of the public with an interest in COVID-19 in the North East of England."),
                                              tags$p("The dashboard should be accessible to all so please get in contact if any plots or descriptions are not clear."),
                                              tags$a(href="mailto:e.braithwaite2@newcastle.ac.uk", "Email: e.braithwaite2@newcastle.ac.uk")
                                       )
                                   ),
                                   fluidRow(
                                       column(12,
                                              tags$h5("Data Licences"),
                                              tags$p('The cases and deaths data is available under the ', a(href = "https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/", 'Open Government Licence v3.0', .noWS = "outside"), '.', .noWS = c("after-begin", "before-end")),
                                              tags$p('The traffic, pedestrian flow and car park data is available to the public from the Urban Observatory subject to the terms laid out in the ', a(href = "https://creativecommons.org/licenses/by/4.0/", 'Creative Commons Attribution 4.0 licence', .noWS = "outside"), 
                                                '. Some of the data is sourced from a third-party, the Tyne and Wear Urban Traffic Management and Control (UTMC) open data service, which is provided under Open Government Licence.', .noWS = c("after-begin", "before-end"))
                                              )
                                   ),
                                   fluidRow(
                                       column(12,
                                              style = "border: 4px solid #FFDC00;",
                                              tags$h5(" Get involved"),
                                              tags$p(" This dashboard has been developed for the general public and is in constant review based upon the data available and the needs of the users. There are two ways we you can get involved with the project."),
                                              tags$ul(
                                                  tags$li("Identify data sources. We want to expand upon the data being presented, so please get in touch if you know of other data sources that document the effects of COVID-19 in the North East"),
                                                  tags$li("Shape the analysis. Do you have questions about the existing data that you cannot find the answer too? Send us your questions to help shape the design development")
                                              ),
                                              tags$a(href="mailto:e.braithwaite2@newcastle.ac.uk", " Email: e.braithwaite2@newcastle.ac.uk")
                                              )
                                   ),
                            )
                        )
               ),
               tabPanel(title = "Cases",
                        fluidRow(
                            column(
                                12, 
                                h4("How were lab-confirmed positive COVID-19 test results distributed across the nations, regions and the North East?"),
                                fluidRow(
                                    column(12,
                                           tabsetPanel(
                                               type = "tab",
                                               tabPanel(title = "Info",
                                                        h5("The Data"),
                                                        p("This page contains plots of the number of people with at least one lab-confirmed positive COVID-19 antigen test result."),
                                                        p("COVID-19 cases are identified by taking specimens from people and sending these specimens to laboratories around the UK to be tested 
                                                          for COVID-19 antigens. If the test is positive, this is a referred to as a lab-confirmed case. If a person has had more than one 
                                                          positive test they are only counted as one case."),
                                                        p("The case data for nations, regions and upper tier local authorities is presented by specimen date (the date when the 
                                                        sample was taken from the person being tested)."),
                                                        p("Cases are allocated to the person's area of residence."),
                                                        h5("Search Suggestions"),
                                                        tags$ul(
                                                            tags$li("What day were the most cases recorded in England?"),
                                                            tags$li("How does the rate of cases per every 100,000 people in the population North East region compare to other English regions?"),
                                                            tags$li("Which North East local authority has recorded the lowest number of cumulative cases?")
                                                        ),
                                                        
                                                        value = "tab1"),
                                               tabPanel(title = "National Cases",
                                                        h5("Interaction Tips"),
                                                        tags$ul(
                                                            tags$li("Individual data points are shown when the mouse moves over points on the plots"),
                                                            tags$li("Click on the plot to view the interaction options in the top right of the plot. It is possible to zoom in and pan around the plot. Use the home icon to reset the plot view")
                                                        ),
                                                        h5("Figure 1.1: National daily cases by specimen date"),
                                                        plotlyOutput(outputId = "dailycasesNation"),
                                                        h5("Figure 1.2: National cumulative cases by specimen date"),
                                                        plotlyOutput(outputId = "cumulativecasesNation"),
                                                        value = "tab2"),
                                               tabPanel(title = "Regional Cases",
                                                        h5("Interaction Tips"),
                                                        tags$ul(
                                                            tags$li("Compare the number of lab-confirmed positive COVID-19 cases in the North East against other English regions by selecting a region from the drop down menu"),
                                                            tags$li("Individual data points are shown when the mouse moves over points on the plots"),
                                                            tags$li("Regions can be deselected and selected by clicking on the names in the legend"),
                                                            tags$li("Click on the plot to view the interaction options in the top right of the plot. It is possible to zoom in and pan around the plot. Use the home icon to reset the plot view")
                                                        ),
                                                        selectInput(inputId = "region",
                                                                    label = "Select region to compare to the North East",
                                                                    choices = unique(regionCases$name),
                                                                    selected = "North West"),
                                                        h5("Figure 1.3: Regional daily cases by specimen date"),
                                                        plotlyOutput(outputId = "dailycasesRegion"),
                                                        h5("Figure 1.4: Regional cumulative cases by specimen date"),
                                                        plotlyOutput(outputId = "cumulativecasesRegion"),
                                                        h5("Figure 1.5: Regional rate of cumulative cases per 100,000 people in the population by specimen date"),
                                                        plotlyOutput(outputId = "cumrateRegion"),
                                                        value = "tab3"),
                                               tabPanel(title = "North East Cases",
                                                        h5("Interaction Tips"),
                                                        tags$ul(
                                                            tags$li("Compare the number of lab-confirmed positive COVID-19 cases in North East local authorities by selecting two local authorities from the drop down menus"),
                                                            tags$li("Individual data points are shown when the mouse moves over points on the plots"),
                                                            tags$li("Local authorities can be deselected and selected by clicking on the names in the legend"),
                                                            tags$li("Click on the plot to view the interaction options in the top right of the plot. It is possible to zoom in and pan around the plot. Use the home icon to reset the plot view")
                                                        ),
                                                        fluidRow(
                                                            column(6,
                                                                   selectInput(inputId = "NELA1",
                                                                               label = "Select a North East local authority",
                                                                               choices = unique(NEltlaCases$name),
                                                                               selected = "County Durham")
                                                                   ),
                                                            column(6,
                                                                   selectInput(inputId = "NELA2",
                                                                               label = "Select a second North East local authority",
                                                                               choices = unique(NEltlaCases$name),
                                                                               selected = "Darlington")
                                                                   )
                                                            ),
                                                        h5("Figure 1.6: North East daily cases by local authority and specimen date"),
                                                        plotlyOutput(outputId = "NELocalAuthorities"),
                                                        h5("Figure 1.7: North East cumulative cases by local authority and specimen date"),
                                                        plotlyOutput(outputId = "NELocalAuthoritiescum"),
                                                        h5("Figure 1.8: Rate of cumulative cases per 100,000 people in the population by North East local authority and specimen date"),
                                                        plotlyOutput(outputId = "NELocalAuthoritiesrate"),
                                                        value = "tab4")
                                               )
                                           )
                                    )
                                )
                            )
               ),
               tabPanel(title = "Deaths",
                        fluidRow(
                            column(12, 
                                   h4("How many COVID-19 deaths have been reported across the UK nations and English regions?"),
                                   tabsetPanel(
                                       type = "tab",
                                       tabPanel(title = "Info",
                                                h5("The Data"),
                                                p("Number of deaths of people who had had a positive test result for COVID-19 
                                                and died within 28 days of the first positive test. The actual cause of death 
                                                may not be COVID-19 in all cases. People who died from COVID-19 but had not 
                                                tested positive are not included and people who died from COVID-19 more than 28 
                                                days after their first positive test are not included. Data from the four nations 
                                                  are not directly comparable as methodologies and inclusion criteria vary."),
                                                h5("Search Suggestions"),
                                                tags$ul(
                                                    tags$li("Did daily deaths ever go above 70 in Scotland, Wales or Northern Ireland?"),
                                                    tags$li("Which region has recorded the lowest number of cumulative deaths?"),
                                                ),
                                                value = "tab1"),
                                       tabPanel(title = "National Deaths",
                                                h5("Interaction Tips"),
                                                tags$ul(
                                                    tags$li("Individual data points are shown when the mouse moves over points on the plots"),
                                                    tags$li("Click on the plot to view the interaction options in the top right of the plot. It is possible to zoom in and pan around the plot. Use the home icon to reset the plot view")
                                                ),
                                                h5("Figure 2.1: Daily deaths within 28 days of positive test by date of death, by nation"),
                                                plotlyOutput(outputId = "dailydeathsNation"),
                                                h5("Figure 2.2: Cumulative deaths within 28 days of positive test by date of death, by nation"),
                                                plotlyOutput(outputId = "cumulativedeathsNation"),
                                                value = "tab2"),
                                       tabPanel(title = "Regional Deaths",
                                                h5("Interaction Tips"),
                                                tags$ul(
                                                    tags$li("Compare the number of deaths within 28 days of positive test in the North East against other English regions by selecting a region from the drop down menu"),
                                                    tags$li("Individual data points are shown when the mouse moves over points on the plots"),
                                                    tags$li("Regions can be deselected and selected by clicking on the names in the legend"),
                                                    tags$li("Click on the plot to view the interaction options in the top right of the plot. It is possible to zoom in and pan around the plot. Use the home icon to reset the plot view")
                                                ),
                                                selectInput(inputId = "region2",
                                                            label = "Select region to compare to the North East",
                                                            choices = unique(regionCases$name),
                                                            selected = "North West"),
                                                h5("Figure 2.3: Daily deaths within 28 days of positive test by date of death, by region"),
                                                plotlyOutput(outputId = "dailydeathsRegion"),
                                                h5("Figure 2.4: Cumulative deaths within 28 days of positive test by date of death, by region"),
                                                plotlyOutput(outputId = "cumulativedeathsRegion"),
                                                value = "tab3")
                                   )  
                            )
                        )
               ),
               tabPanel(title = "Traffic",
                        fluidRow(
                            column(12, 
                                   h4("Did COVID-19 have an affect on Traffic in the Tyne and Wear region?"),
                                   p(""),
                                   tabsetPanel(
                                       type = "tab",
                                       tabPanel(title = "Info",
                                                fluidRow( #b
                                                    column(12,
                                                           h5("The Data"),
                                                           p("Two datasets were used for this page:"),
                                                           tags$ul(
                                                               tags$li("Average traffic volumes against a baseline"),
                                                               tags$li("Daily traffic counts")
                                                           ),
                                                           p("Both were sourced from the Urban Observatory and were generated from raw data collected by 
                                                           automatic numberplate recognition cameras (ANPR), used to invoke signal and traffic control strategies in the region. The raw data is 
                                                             provided by Tyne and Wear UTMC and archived by the Newcastle Urban Observatory."),
                                                           h5("Average traffic volumes against a baseline (figure 3.1)"),
                                                           p("The traffic volumes against a baseline data was processed by the Urban Observatory from aggregate statistics 
                                                           collected by ANPR cameras. The underlying ANPR data is aggregated to four minute intervals."),
                                                           p("The median percentage change value was calculated using the monitoring points in each region. Different regions have different numbers of monitoring points but all estimates indicate traffic change rather than volume. 
                                                             Region (number of monitoring points): Gateshead (52), Newcastle upon Tyne (123), Northumberland (4), North Tyneside (34), South Tyneside (40) and Sunderland (72)"),
                                                           p("The individual percentage change points are calculated using a baseline of the equivalent day from first week of February 2020."),
                                                           p("Please note that no data is available for 17 and 18 March, 10 May and 18 July."), 
                                                           h5("Daily traffic count from 1 January 2020 to 17 August 2020 (figure 3.2)"),
                                                           p("The daily traffic count data was calculated from data collected by ANPR cameras. The underlying ANPR data is aggregated to 16 minute intervals."),
                                                           p("The monitoring points used have been selected because they indicate long distance travel or commuting behaviour into and out of the Newcastle upon Tyne and Gateshead region.
                                                             The daily totals are used to demonstrate the change in traffic patterns from 1 January 2020 to 17 August 2020."),
                                                           h5("Search Suggestions"),
                                                           p("Can you answer any of the following questions?"),
                                                           tags$ul(
                                                               tags$li("Did all the Tyne and Wear regions follow the same pattern in traffic volumne change?"),
                                                               tags$li("Which monitoring point had the highest daily traffic count before the lockdown was announced by the Government on the 23 March 2020?"),
                                                               tags$li("Which monitoring point experienced the shortest change in pattern to daily traffic count following the Government lockdown?")
                                                           )
                                                    ) # close column 12 b
                                                ),
                                                value = "tab1"),
                                       tabPanel(title = "Average Traffic",
                                                h5("Interaction Tips"),
                                                tags$ul(
                                                    tags$li("Individual data points are shown when the mouse moves over points on the plot"),
                                                    tags$li("Regions can be deselected and selected by clicking on the names in the legend"),
                                                    tags$li("Click on the plot to view the interaction options in the top right of the plot. It is possible to zoom in and pan around the plot. Use the home icon to reset the plot view")
                                                ),
                                                h5("Figure 3.1: Average traffic volumes against a baseline"),
                                                p("The median was the average measure used"),
                                                plotlyOutput(outputId = "mediantraffic"),
                                                p(),
                                                value = "tab2"),
                                       tabPanel(title = "Total Traffic",
                                                h5("Interaction Tips"),
                                                tags$ul(
                                                    tags$li("Use the map to identify the location of the traffic cameras. Click on the points to identify the traffic camera names"),
                                                    tags$li("The drop down menu will update the data plotted in figure 3.2"),
                                                    tags$li("Individual data points are shown when the mouse moves over points on the plot")
                                                ),
                                                h5("Map 3.1: Locations of the automatic numberplate recognition cameras"),
                                                leafletOutput("commutingmap"),
                                                h5("Figure 3.2: Daily traffic count from 1 January 2020 to 17 August 2020"),
                                                selectInput(inputId = "Trafficcameralocation",
                                                            label = "Select traffic camera",
                                                            choices = c("A1058 Coast Road (Eastbound)", "A1058 Coast Road (Westbound)", 
                                                                        "A167 Durham Road (Northbound)", "A167 Gateshead Highway (Northbound)",
                                                                        "A167 Durham Road (Southbound)", "A167 Gateshead Highway (Southbound)",
                                                                        "A184 (Westbound)", "A184/A189 (Northbound)", "B1318 Great North Road (Northbound)",
                                                                        "B1318 Great North Road (Southbound)", "B6324 Stamfordham Road (Eastbound)",
                                                                        "B6324 Stamfordham Road (Westbound)"),
                                                            selected = "A1058 Coast Road (Eastbound)"),
                                                plotlyOutput(outputId = "TotalTraffic"),
                                                value = "tab3")
                                              )
                            )
                        )
               ),
               tabPanel(title = "Car Parks",
                        fluidRow(
                            column(12, 
                                   h4("How did car park use change during 2020 in Tyne and Wear?"),
                                   tabsetPanel(
                                       type = "tab",
                                       tabPanel(title = "Info",
                                                fluidRow( #b
                                                    column(12,
                                                           h5("Map 4.1: Locations of all the car parks"),
                                                           leafletOutput("CarParkMapALL"),
                                                           h5("The Data"),
                                                           p("Figure 4.1 plots the total number of vehicle-hours per day for each car 
                                                             park from the 1 January 2020 until the 17 August 2020."),
                                                           p("Daily vehicle-hours is calculated by adding together the duration each vehicle was parked in the car park on a single day. 
                                                           For example, if 3 cars used the car park and they stayed for 5 hours, 1 hour and 12 hours 
                                                           respectively the total vehicle-hours for that day would be 18 hours. Please note that the plots are presented individually, as the daily vehicle 
                                                             numbers are not comparable, as each car park has a different number of spaces."),
                                                           h5("Search Suggestions"),
                                                           p("Can you answer any of the following questions?"),
                                                           tags$ul(
                                                               tags$li("Was there a change in car parking practices across the year?"),
                                                               tags$li("Has car park use returned to pre-lockdown measures?"),
                                                               tags$li("Are there similarities in car park use trends across the different car parks?")
                                                           )
                                                    ) # close column 12 b
                                                ), # close fluid row b
                                                value = "tab1"),
                                       tabPanel(title = "Plots",
                                                h5("Interaction Tips"),
                                                tags$ul(
                                                    tags$li("Use the drop down menu to select a car park. This will update the map and the data plotted in figure 4.1. To see the car parks capacity click on the map marker"),
                                                    tags$li("Individual data points are shown when you move your mouse over the plot")
                                                ),
                                                selectInput(inputId = "carparks",
                                                            label = "Select Car Park",
                                                            choices = carpark.meta$CarPark,
                                                            selected = "BALTIC"), 
                                                fluidRow(
                                                    column(12,
                                                           h5("Map 4.2: Location of the selected car park"),
                                                           leafletOutput("CarParkMap"),
                                                           h5("Figure 4.1: Daily vehicle hours from 1 January 2020 to 17 August 2020"),
                                                           plotlyOutput(outputId = "CarPark"),
                                                           value = "tab1"
                                                    )
                                                )
                                       )
                                   ) # close tabsetPanel
                            ) # close column 12 a
                        ) # close fluid row a
               ),
               tabPanel(title = "Pedestrians",
                        fluidRow(
                            column(12, 
                                   h4("How did footfall in central Newcastle upon Tyne change during 2020?"),
                                   tabsetPanel(
                                       type = "tab",
                                       tabPanel(title = "Info",
                                                fluidRow( #b
                                                    column(12,
                                                           h5("Map 5.1: Location of the pedestrian flow monitoring point"),
                                                           leafletOutput("NorthumberlandStmap"),
                                                           h5("The Data"),
                                                           p("This page contains footfall data for the period 1 January 2020 to 17 August 2020, for one of the busiest shopping streets 
                                                             in Newcastle upon Tyne, Northumberland Street. There are four monitoring outputs from this location."),
                                                           tags$ul(
                                                               tags$li("Northumberland Street (east), pedestrian's walking north"),
                                                               tags$li("Northumberland Street (east), pedestrian's walking south"),
                                                               tags$li("Northumberland Street (west), pedestrian's walking north"),
                                                               tags$li("Northumberland Street (west), pedestrian's walking south")
                                                               ),
                                                           p("Figure 5.1 plots the sum of all recorded pedestrian counts by day for each of the four monitoring points. 
                                                             This plot can be used to identify general footfall trends across the entire January to August period."),
                                                           p("Figures 5.2 and 5.3 provide the hourly footfall counts for each of the four monitoring points. 
                                                             The date filter allows you to zoom into specific periods of interest."),
                                                           h5("Search Suggestions"),
                                                           p("Can you answer any of the following questions?"),
                                                               tags$ul(
                                                                   tags$li("Did the largest reduction in footfall happen before or after the lockdown was announced by the Government on the 23 March 2020?"),
                                                                   tags$li("Was there an increase in footfall after the lockdown measures were eased on the 4 June 2020?"),
                                                                   tags$li("After the lockdown eased, did Newcastle upon Tyne residents following the Council guidelines to walk along the east side of Northumberland Street when walking north and along the west side when walking south?")
                                                               )
                                                           ) # close column 12 b
                                                ), # close fluid row b
                                                value = "tab1"),
                                       tabPanel(title = "Plots",
                                                h5("Interaction Tips"),
                                                tags$ul(
                                                    tags$li("Figure 5.1: use the drop down menu to view the total daily pedestrian count along Northumberland street for each side of the street and direction"),
                                                    tags$li("Figure 5.2 and Figure 5.3: use the select date option to customise the plots to specific time frame"),
                                                    tags$li("Individual data points are shown when you move your mouse over the plots")
                                                ),
                                                h5("Figure 5.1: Total daily pedestrian count along Northumberland Street from 1 January 2020 to 17 August 2020"),
                                                selectInput(inputId = "pedpoints",
                                                            label = "Select monitoring point",
                                                            choices = c("Northumberland St (west) walking north" = "Northumberland Street (west) walking north", 
                                                                        "Northumberland St (west) walking south" = "Northumberland Street (west) walking south", 
                                                                        "Northumberland St (east) walking north" = "Northumberland Street (east) walking north", 
                                                                        "Northumberland St (east) walking south" = "Northumberland Street (east) walking south"),
                                                            selected = "Northumberland St (east) walking north"),
                                                plotlyOutput(outputId = 'dailypedcount'),
                                                h5("Figure 5.2: Hourly pedestrian count along the east side of Northumberland Street"),
                                                p(),
                                                dateRangeInput(inputId = "peddates", 
                                                               label = "Select date range", 
                                                               start = "2020-06-01",
                                                               end = "2020-06-20", 
                                                               min = "2020-01-01", 
                                                               max = "2020-08-17"),
                                                plotlyOutput(outputId = 'pedflowES'),
                                                h5("Figure 5.3: Hourly pedestrian count along the west side of Northumberland Street"),
                                                plotlyOutput(outputId = 'pedflowWS'),
                                                value = "tab2")
                                   ) # close tabsetPanel
                            ) # close column 12 a
                        ) # close fluid row a
               )
    ) # close navbarPage
) # close fluid page



# Define server logic required to draw a histogram ----
server = function(input, output) {
    
    # Prepare the Shiny outputs
    
    ### Figure 1.1
    output$dailycasesNation = renderPlotly({
        
        nationdaily = ggplot(nationCases[order(nationCases$cases.daily, decreasing = TRUE), ]) +
            geom_col(aes(x = date, y = cases.daily, fill = name),position = position_stack(reverse = TRUE))+
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            scale_fill_manual(values = c("England" = "#FF4136", "Scotland" = "#001F3F", 
                                         "Wales" = "#2ECC40", "Northern Ireland" = "#FFDC00"),
                              name = "") +
            ylab("Cases Daily") +
            xlab("Date") +
            labs(fill = "Nations")
        
        
        ggplotly(nationdaily) %>%
            layout(hovermode = "x")
        
    })
    
    
    ### Figure 1.2
    output$cumulativecasesNation = renderPlotly({
        
        nationcum = ggplot(nationCases[order(nationCases$cases.cumulative, decreasing = TRUE), ]) +
            geom_col(aes(x = date, y = cases.cumulative, fill = name),
                     position = position_stack(reverse = TRUE))+
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            scale_fill_manual(values = c("England" = "#FF4136", "Scotland" = "#001F3F", 
                                         "Wales" = "#2ECC40", "Northern Ireland" = "#FFDC00"),
                              name = "") +
            scale_y_continuous(name="Cumulative Cases", labels = scales::comma) +
            ylab("Cumulative Cases") +
            xlab("Date") +
            labs(fill = "Nations")
        
        
        ggplotly(nationcum) %>%
            layout(hovermode = "x")
        
    })
    
    
    ### Figure 1.3
    output$dailycasesRegion = renderPlotly({
        
        regiondaily = ggplot(data = filter(regionCases, name %in% c("North East", input$region))) +
            geom_line(mapping = aes(x = date, y = cases.daily, color = name)) +
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("East Midlands" = "#B10DC9", "East of England" = "#F012BE", 
                                          "London" = "#FFDC00", "North East" = "#001F3F", 
                                          "North West" = "#FF4136", "South East" = "#FF851B", 
                                          "South West" = "#01FF70", "West Midlands" = "#2ECC40",
                                          "Yorkshire and The Humber" = "#0074D9"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            ylab("Cases daily") +
            xlab("Date") +
            labs(color = "Region")
        
        ggplotly(regiondaily) %>%
            layout(hovermode = "x")
        
    })
    
    
    ### Figure 1.4
    output$cumulativecasesRegion = renderPlotly({
        
        regioncum = ggplot(data = filter(regionCases, name %in% c("North East", input$region))) +
            geom_line(mapping = aes(x = date, y = cases.cumulative, color = name)) +
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("East Midlands" = "#B10DC9", "East of England" = "#F012BE", 
                                          "London" = "#FFDC00", "North East" = "#001F3F", 
                                          "North West" = "#FF4136", "South East" = "#FF851B", 
                                          "South West" = "#01FF70", "West Midlands" = "#2ECC40",
                                          "Yorkshire and The Humber" = "#0074D9"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            ylab("Cumulative cases") +
            xlab("Date") +
            labs(color = "Region")
        
        ggplotly(regioncum) %>%
            layout(hovermode = "x")
        
    })
    
    
    ### Figure 1.5
    output$cumrateRegion = renderPlotly({
        
        regioncumrate = ggplot(data = filter(regionCases, name %in% c("North East", input$region))) +
            geom_line(mapping = aes(x = date, y = cases.rate, color = name)) +
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("East Midlands" = "#B10DC9", "East of England" = "#F012BE", 
                                          "London" = "#FFDC00", "North East" = "#001F3F", 
                                          "North West" = "#FF4136", "South East" = "#FF851B", 
                                          "South West" = "#01FF70", "West Midlands" = "#2ECC40",
                                          "Yorkshire and The Humber" = "#0074D9"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            ylab("Rate of cumulative cases") +
            xlab("Date") +
            labs(color = "Region")
        
        ggplotly(regioncumrate) %>%
            layout(hovermode = "x")
        
    })
    

    ### Figure 1.6
    output$NELocalAuthorities = renderPlotly({
        
        NELocalAuthorities = ggplot(data = filter(NEltlaCases, name %in% c(input$NELA1, input$NELA2))) +
            geom_line(mapping = aes(x = date, y = cases.daily, color = name)) +
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("County Durham" = "#001F3F", "Darlington" = "#7FDBFF", 
                                          "Hartlepool" = "#01FF70", "Middlesbrough" = "#AAAAAA",
                                          "Redcar and Cleveland" = "#B10DC9", "Stockton-on-Tees" = "#FF851B",
                                          "Sunderland" = "#0074D9", "Gateshead" = "#FFDC00", 
                                          "South Tyneside" = "#2ECC40", "North Tyneside" = "#FF4136", 
                                          "Newcastle upon Tyne" = "#F012BE", "Northumberland" = "#85144B"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            ylab("Cases daily") +
            xlab("Date") +
            labs(color = "Local Authority")
        
        
        
        ggplotly(NELocalAuthorities) %>%
            layout(hovermode = "x")
        
    })
    
    
    ### Figure 1.7
    output$NELocalAuthoritiescum = renderPlotly({
        
        NELocalAuthoritiescum = ggplot(data = filter(NEltlaCases, name %in% c(input$NELA1, input$NELA2))) +
            geom_line(mapping = aes(x = date, y = cases.cumulative, color = name)) +
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("County Durham" = "#001F3F", "Darlington" = "#7FDBFF", 
                                          "Hartlepool" = "#01FF70", "Middlesbrough" = "#AAAAAA",
                                          "Redcar and Cleveland" = "#B10DC9", "Stockton-on-Tees" = "#FF851B",
                                          "Sunderland" = "#0074D9", "Gateshead" = "#FFDC00", 
                                          "South Tyneside" = "#2ECC40", "North Tyneside" = "#FF4136", 
                                          "Newcastle upon Tyne" = "#F012BE", "Northumberland" = "#85144B"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            ylab("Cumulative cases") +
            xlab("Date") +
            labs(color = "Local Authority")
        
        
        
        ggplotly(NELocalAuthoritiescum) %>%
            layout(hovermode = "x")
        
    })
    
    
    ### Figure 1.8
    output$NELocalAuthoritiesrate = renderPlotly({
        
        NELocalAuthoritiesrate = ggplot(data = filter(NEltlaCases, name %in% c(input$NELA1, input$NELA2))) +
            geom_line(mapping = aes(x = date, y = cases.rate, color = name)) +
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("County Durham" = "#001F3F", "Darlington" = "#7FDBFF", 
                                          "Hartlepool" = "#01FF70", "Middlesbrough" = "#AAAAAA",
                                          "Redcar and Cleveland" = "#B10DC9", "Stockton-on-Tees" = "#FF851B",
                                          "Sunderland" = "#0074D9", "Gateshead" = "#FFDC00", 
                                          "South Tyneside" = "#2ECC40", "North Tyneside" = "#FF4136", 
                                          "Newcastle upon Tyne" = "#F012BE", "Northumberland" = "#85144B"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            ylab("Cumulative cases") +
            xlab("Date") +
            labs(color = "Local Authority")
        
        
        
        ggplotly(NELocalAuthoritiesrate) %>%
            layout(hovermode = "x")
        
    })
    
    
    ### Figure 2.1
    output$dailydeathsNation = renderPlotly({ 
        
        nationdailydeaths = ggplot(nationdeaths[order(nationdeaths$deaths.daily, decreasing = TRUE), ]) +
            geom_col(aes(x = date, y = deaths.daily, fill = name),position = position_stack(reverse = TRUE)) +
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_fill_manual(values = c("England" = "#FF4136", "Scotland" = "#001F3F", 
                                         "Wales" = "#2ECC40", "Northern Ireland" = "#FFDC00"),
                              name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            xlab("Date") +
            ylab("Daily deaths")
        
        ggplotly(nationdailydeaths) %>%
            layout(hovermode = "x")
        
        
        
    })
    
    
    ### Figure 2.2
    output$cumulativedeathsNation = renderPlotly({
        
        nationcumdeaths = ggplot(nationdeaths[order(nationdeaths$deaths.cumulative, decreasing = TRUE), ]) +
            geom_col(aes(x = date, y = deaths.cumulative, fill = name),
                     position = position_stack(reverse = TRUE)) +
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            scale_fill_manual(values = c("England" = "#FF4136", "Scotland" = "#001F3F", 
                                         "Wales" = "#2ECC40", "Northern Ireland" = "#FFDC00"),
                              name = "") +
            xlab("Date") +
            ylab("Cumulative deaths")
        
        
        ggplotly(nationcumdeaths) %>%
            layout(hovermode = "x")
        
    })

    

    ### Figure 2.3
    output$dailydeathsRegion = renderPlotly({ 
        
        regiondailydeaths = ggplot(data = filter(regiondeaths, name %in% c("North East", input$region2))) +
            geom_line(mapping = aes(x = date, y = deaths.daily, color = name)) +
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("East Midlands" = "#B10DC9", "East of England" = "#F012BE", 
                                          "London" = "#FFDC00", "North East" = "#001F3F", 
                                          "North West" = "#FF4136", "South East" = "#FF851B", 
                                          "South West" = "#01FF70", "West Midlands" = "#2ECC40",
                                          "Yorkshire and The Humber" = "#0074D9"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            ylab("Cases daily") +
            xlab("Date") +
            labs(color = "Region")
        
        ggplotly(regiondailydeaths) %>%
            layout(hovermode = "x")
        
    })
    
    
    ### Figure 2.4
    output$cumulativedeathsRegion = renderPlotly({
        
        regioncumdeaths = ggplot(data = filter(regiondeaths, name %in% c("North East", input$region2))) +
            geom_line(mapping = aes(x = date, y = deaths.cumulative, color = name)) +
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("East Midlands" = "#B10DC9", "East of England" = "#F012BE", 
                                          "London" = "#FFDC00", "North East" = "#001F3F", 
                                          "North West" = "#FF4136", "South East" = "#FF851B", 
                                          "South West" = "#01FF70", "West Midlands" = "#2ECC40",
                                          "Yorkshire and The Humber" = "#0074D9"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            ylab("Cases daily") +
            xlab("Date") +
            labs(color = "Region")
        
        
        ggplotly(regioncumdeaths) %>%
            layout(hovermode = "x")
        
    })
        
    
    ### Figure 3.1
    output$mediantraffic = renderPlotly({
        static = ggplot(mediantrafficLONG, aes(date, Percentage, color = Region)) +
            geom_line() +
            
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_color_manual(values = c("Sunderland" = "#0074D9", "Gateshead" = "#FFDC00", 
                                          "South.Tyneside" = "#2ECC40", "North.Tyneside" = "#FF4136", 
                                          "Newcastle.upon.Tyne" = "#F012BE", "Northumberland" = "#85144B"),
                               name = "") +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            xlab("Date")
        
        ggplotly(static) %>%
            layout(hovermode = "x")
        
    })

    
    
    ### Map 3.1 for use alongside Figure 3.2
    output$commutingmap = renderLeaflet({
        
        
        leaflet(data = Commutingtrafficmap) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            addMarkers(lng = Commutingtrafficmap$Longitude,
                       lat = Commutingtrafficmap$Latitude, 
                       popup = Commutingtrafficmap$highwayDescription)
    })
    
    
    ### Figure 3.2
    output$TotalTraffic = renderPlotly({ 
        
        totaltrafficplot = ggplot(data = filter(CommutingtrafficDAY, highwayDescription == input$Trafficcameralocation)) +
            geom_col(mapping = aes(x=date, y=dailycount, fill = weekend)) +
            
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            scale_fill_manual(values = c("weekend" = "#FF851B", "weekday" = "#0074D9"),
                              name = "") +
            xlab("Date") +
            ylab("Daily Traffic Count")

        ggplotly(totaltrafficplot)

        
    })
    
    
    ### Map 4.1 for use on Car Parks intro tab
    output$CarParkMapALL = renderLeaflet({
        
        
        
        leaflet(data = carpark.meta) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            addMarkers(lng = carpark.meta$longitude,
                       lat = carpark.meta$latitude, 
                       label = paste0(carpark.meta$CarPark, sep = ". Capacity: ", carpark.meta$capacity, sep = " spaces"),
                       popup = paste0(carpark.meta$CarPark, sep = ". Capacity: ", carpark.meta$capacity, sep = " spaces"))
    })
    
    
    ### Functionality for Figure 4.1 and CarParkMap
    filteredData <- reactive({
        filter(carpark.meta, CarPark == input$carparks)
    })
    
    
    ### Map 4.2 for use alongside Figure 4.1
    output$CarParkMap = renderLeaflet({
        
        
        
        leaflet(data = carpark.meta) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            addMarkers(lng = filteredData()$longitude,
                       lat = filteredData()$latitude, 
                       label = paste0(filteredData()$CarPark, sep = ". Capacity: ", filteredData()$capacity, sep = " spaces"),
                       popup = paste0(filteredData()$CarPark, sep = ". Capacity: ", filteredData()$capacity, sep = " spaces"))
    })
    

    
    
    ### Figure 4.1
    output$CarPark = renderPlotly({
        
        carparkplot = ggplot(data = filter(carparkSummary, Car.Park == input$carparks)) +
            geom_col(mapping = aes(x=date, y=daily.hours, fill = weekend)) +
            
            
            theme_classic() +
            theme(
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            scale_x_date(date_labels = "%b-%d",
                         breaks = "1 month") +
            scale_fill_manual(values = c("weekend" = "#FF851B", "weekday" = "#0074D9"),
                              name = "") +
            ylab("Daily vehicle hours") +
            xlab("Date")
            
        ggplotly(carparkplot)
        
        
    })
    
    
    ### Map 5.2 for use on Pedestrian intro tab
    output$NorthumberlandStmap = renderLeaflet({
        
        
        leaflet() %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            addMarkers(lng = -1.612320,
                       lat = 54.975123, 
                       label =  "Northumberland Street",
                       popup = "Northumberland Street")
    })
    
    
    ### Figure 5.1
    output$dailypedcount = renderPlotly({
        
        
        ggplotly(
            ggplot(ped.daily.totals %>% filter(Point == input$pedpoints)) +
                geom_line(aes(x = Date, y = Daily.pedestrian.count), color = "#0074D9") +
                theme_classic() +
                theme(
                    axis.text.x = element_text(color = "black", angle=60, hjust=1),
                    axis.text.y = element_text(color = "black")) +
                scale_x_date(date_labels = "%b-%d",
                             breaks = "1 month") +
                ylab("Daily pedestrian count") +
                theme(legend.position = "none")
        ) 
    })
    
    ### Functionality for Figure 5.2 and 5.3
    ped.data1 <- reactive({
        filter(NorthumberlandSt.east, between(just.date ,as.Date(input$peddates[1]), as.Date(input$peddates[2])))
    })
    
    
    ### Functionality for Figure 5.2 and 5.3
    ped.data2 <- reactive({
        filter(NorthumberlandSt.west, between(just.date ,as.Date(input$peddates[1]), as.Date(input$peddates[2])))
    }) 
    
    
    ### Figure 5.2
    output$pedflowES = renderPlotly({
    # Northumberland St near Fenwick (east side)
    pedES = ggplot(ped.data1(), aes(x = Date, y = hourly.pedestrian.count, fill = Direction)) +
        geom_col() + 
        facet_grid(Direction ~ .) +
        theme_classic()+
        
        theme(
            legend.position = "none",
            axis.text.x = element_text(color = "black", angle=60, hjust=1),
            axis.text.y = element_text(color = "black")) +
        ylab("Hourly pedestrian count") +
        scale_fill_manual(values = c("Walking North" = "#0074D9", 
                                     "Walking South" = "#FF851B"))
    
    
        
    ggplotly(pedES)
    })
    
    
    ### Figure 5.3
    output$pedflowWS = renderPlotly({
    # Northumberland St near Fenwick (west side)
        pedWS =  ggplot(ped.data2(), aes(x = Date, y = hourly.pedestrian.count, fill = Direction)) +
            geom_col() + 
            facet_grid(Direction ~ .) +
            theme_classic()+
            theme(
                legend.position = "none",
                axis.text.x = element_text(color = "black", angle=60, hjust=1),
                axis.text.y = element_text(color = "black")) +
            ylab("Hourly pedestrian count") +
            scale_fill_manual(values = c("Walking North" = "#0074D9", 
                                         "Walking South" = "#FF851B"))
        
        ggplotly(pedWS)
        
    })
        
}

shinyApp(ui = ui, server = server)
