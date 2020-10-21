library(shiny)
library(shinythemes)
library(ggplot2)
library(plyr)
library(dplyr)
library(plotly)
library(leaflet)



# Define UI for app that draws a histogram ----
ui <- fluidPage(
  # App title ----
  titlePanel("COVID-19 in the North East"),
  # Add top level navigation bar
  navbarPage("Menu",
             tabPanel(title = "Home",
                        fluidRow(
                          column(12,
                                 h5("Background"),
                                 p("This dashboard assembles and analyses national, regional and local open datasets, which document the effecrts of COVID-19 in the North East of England.
                                   The data relating to COVID-19 cases, healthcare and deaths was sourced from the UK Government's Coronavirus API.  
                                   The regional data relating to traffic, pedestrian flow and car parks was sourced from the Urban Observatory. More information about each can be found in the links below."),
                                 tags$a(href="https://https://coronavirus.data.gov.uk/developers-guide", "Access Government Coronavirus data"),
                                 p(),
                                 tags$a(href="https://covid.view.urbanobservatory.ac.uk", "Access Urban Observatory data"),
                          fluidRow(
                            column(4,
                                 h5("How should this dashboard be used?"),
                                 p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
                                 incididunt ut labore et dolore magna aliqua. Pellentesque habitant morbi tristique
                                 senectus et netus et malesuada fames. Sagittis nisl rhoncus mattis rhoncus urna 
                                 neque viverra justo. Mauris commodo quis imperdiet massa tincidunt. Tellus orci ac 
                                 auctor augue. Etiam sit amet nisl purus in. Tellus orci ac auctor augue mauris 
                                 augue neque gravida in. Mi quis hendrerit dolor magna. Integer enim neque volutpat ac 
                                 tincidunt vitae semper. Eu tincidunt tortor aliquam nulla facilisi cras fermentum. Morbi 
                                 tristique senectus et netus et malesuada. Pretium nibh ipsum consequat nisl. Eros donec
                                 ac odio tempor. Quam vulputate dignissim suspendisse in est ante. Vulputate enim nulla
                                 aliquet porttitor lacus luctus accumsan. Eros in cursus turpis massa tincidunt dui 
                                 ut ornare. Eget gravida cum sociis natoque.")
                                 ),
                            column(4,
                                 h5("Who is this dashboard for?"),
                                 p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
                                 incididunt ut labore et dolore magna aliqua. Pellentesque habitant morbi tristique
                                 senectus et netus et malesuada fames. Sagittis nisl rhoncus mattis rhoncus urna 
                                 neque viverra justo. Mauris commodo quis imperdiet massa tincidunt. Tellus orci ac 
                                 auctor augue. Etiam sit amet nisl purus in. Tellus orci ac auctor augue mauris 
                                 augue neque gravida in. Mi quis hendrerit dolor magna. Integer enim neque volutpat ac 
                                 tincidunt vitae semper. Eu tincidunt tortor aliquam nulla facilisi cras fermentum. Morbi 
                                 tristique senectus et netus et malesuada. Pretium nibh ipsum consequat nisl. Eros donec
                                 ac odio tempor. Quam vulputate dignissim suspendisse in est ante. Vulputate enim nulla
                                 aliquet porttitor lacus luctus accumsan. Eros in cursus turpis massa tincidunt dui 
                                 ut ornare. Eget gravida cum sociis natoque.")
                                 ),
                            column(4,
                                 h5("What data was used?"),
                                 p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
                                 incididunt ut labore et dolore magna aliqua. Pellentesque habitant morbi tristique
                                 senectus et netus et malesuada fames. Sagittis nisl rhoncus mattis rhoncus urna 
                                 neque viverra justo. Mauris commodo quis imperdiet massa tincidunt. Tellus orci ac 
                                 auctor augue. Etiam sit amet nisl purus in. Tellus orci ac auctor augue mauris 
                                 augue neque gravida in. Mi quis hendrerit dolor magna. Integer enim neque volutpat ac 
                                 tincidunt vitae semper. Eu tincidunt tortor aliquam nulla facilisi cras fermentum. Morbi 
                                 tristique senectus et netus et malesuada. Pretium nibh ipsum consequat nisl. Eros donec
                                 ac odio tempor. Quam vulputate dignissim suspendisse in est ante. Vulputate enim nulla
                                 aliquet porttitor lacus luctus accumsan. Eros in cursus turpis massa tincidunt dui 
                                 ut ornare. Eget gravida cum sociis natoque.")
                                )
                              )
                          )
                        )
              ),
             tabPanel(title = "Cases",
                      fluidRow(
                        column(
                          12, 
                          h3("Lab-Confirmed Positive COVID-19 Test Results"),
                          p("UPDATE THIS TEXT: This data plots the number of people with at least one lab-confirmed positive COVID-19 antigen test result. 
                            The case data for regions and upper tier local authorities is presented by specimen date (the date when the 
                            sample was taken from the person being tested) and the case data for Nations is presented by reporting date 
                            (the date the case was first included in the published totals)"),
                          h3("By Nation"),
                          fluidRow(
                            column(12,
                                   tabsetPanel(
                                     type = "tab",
                                     tabPanel(title = "National: Daily Cases",
                                              plotlyOutput(outputId = "dailycasesNation"),
                                              value = "tab1"),
                                     tabPanel(title = "National: Cumulative Cases",
                                              plotlyOutput(outputId = "cumulativecasesNation"),
                                              value = "tab2")
                                   ),
                                   h3("By Region"),
                                   tabsetPanel(
                                     type = "tab",
                                     tabPanel(title = "Regional: Daily Cases",
                                              plotlyOutput(outputId = "dailycasesRegion"),
                                              value = "tab1"),
                                     tabPanel(title = "Regional: Cumulative Cases",
                                              plotlyOutput(outputId = "cumulativecasesRegion"),
                                              value = "tab2"),
                                     tabPanel(title = "Regional: Rate of Cumulative Cases",
                                              h5("How does the rate of cases per every 100,000 people in the population North East region compare to other English regions?"),
                                              plotlyOutput(outputId = "cumrateRegion"),
                                              value = "tab3")
                                   ),
                                   h3("North East Local Authorities"), ###################################################
                                   tabsetPanel(
                                     type = "tab",
                                     tabPanel(title = "Plot",
                                              plotlyOutput(outputId = "NELocalAuthorities"),
                                              value = "tab1"),
                                     tabPanel(title = "Info",
                                              value = "tab2")
                                   )
                            ) 
                          ),
                          h3("By Local Authority"),
                          fluidRow(
                            column(3,
                                   selectInput(inputId = "Local.authority",
                                               label = "Select Local Authority",
                                               choices = ltlanames,
                                               selected = "Newcastle upon Tyne")
                            ),
                            column(9,
                                   tabsetPanel(
                                     type = "tab",
                                     tabPanel(title = "Local Authority: Daily cases",
                                              plotlyOutput(outputId = "dailycasesltla"),
                                              value = "tab1"),
                                     tabPanel(title = "Local Authority: Cumulative cases",
                                              plotlyOutput(outputId = "cumulativecasesltla"),
                                              value = "tab2"),
                                     tabPanel(title = "Data",
                                              value = "tab3")
                                   ) 
                            )
                          ),
                          fluidRow(
                            column(3,
                                   htmlOutput("areatype_selector"),#add selectinput boxs
                                   htmlOutput("name_selector")# from objects created in server
                            ),
                            column(9,
                                   tabsetPanel(
                                     type = "tab",
                                     tabPanel(title = "Daily cases",
                                              plotlyOutput(outputId = "dailycases"),
                                              value = "tab1"),
                                     tabPanel(title = "Cumulative cases",
                                              plotlyOutput(outputId = "cumulativecases"),
                                              value = "tab2"),
                                     tabPanel(title = "Data",
                                              value = "tab3")
                                   )
                                  )
                                )
                        )
                      )
             ),
             tabPanel(title = "Hospitalisations",
                      fluidRow(
                        column(12, 
                               h3("Here is some text about cases"),
                               p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
                                 incididunt ut labore et dolore magna aliqua. Pellentesque habitant morbi tristique
                                 senectus et netus et malesuada fames. Sagittis nisl rhoncus mattis rhoncus urna 
                                 neque viverra justo. Mauris commodo quis imperdiet massa tincidunt. Tellus orci ac 
                                 auctor augue. Etiam sit amet nisl purus in. Tellus orci ac auctor augue mauris 
                                 augue neque gravida in. Mi quis hendrerit dolor magna. Integer enim neque volutpat ac 
                                 tincidunt vitae semper. Eu tincidunt tortor aliquam nulla facilisi cras fermentum. Morbi 
                                 tristique senectus et netus et malesuada. Pretium nibh ipsum consequat nisl. Eros donec
                                 ac odio tempor. Quam vulputate dignissim suspendisse in est ante. Vulputate enim nulla
                                 aliquet porttitor lacus luctus accumsan. Eros in cursus turpis massa tincidunt dui 
                                 ut ornare. Eget gravida cum sociis natoque."),
                               fluidRow(
                                 column(3,
                                        checkboxGroupInput(inputId = "regions",
                                                           label = "Select regions to compare",
                                                           choices = c("North East", "North West", "Yorkshire and The Humber",
                                                                       "West Midlands", "East Midlands", "East of England",
                                                                       "South West", "South East", "London"),
                                                           selected = "North East")
                                    ),
                                 column(9,
                                        tabsetPanel(
                                          type = "tab",
                                          tabPanel(title = "Hospitalisations",
                                                   value = "tab1"),
                                          tabPanel(title = "Plots",
                                                   value = "tab2"),
                                          tabPanel(title = "Data",
                                                   value = "tab3")
                                                  )
                                    )
                                  )
                              )
                          )
             ),
             tabPanel(title = "Deaths",
                      fluidRow(
                        column(12, 
                               h3("Median traffic volumes against a baseline"),
                               p("The traffic volumes against a baseline for this region are obtained from aggregate statistics collected by automatic numberplate recognition cameras (ANPR), used to invoke signal and traffic control strategies in the region. The underlying ANPR data is aggregated to four minute intervals. The data is provided by Tyne and Wear UTMC and archived by the Newcastle Urban Observatory."),
                               tabsetPanel(
                                 type = "tab",
                                 tabPanel(title = "Median traffic",
                                          plotlyOutput(outputId = "mediantraffic"),
                                          value = "tab1"),
                                 tabPanel(title = "Data",
                                          value = "tab2")
                               ),
                               p("Sunderland: Data is the median across 72 monitoring points in Sunderland. Each point is first considered individually relative to baseline data for that day of the week, calculated over the last six months."),
                               p("South Tyneside: Data is the median across 40 monitoring points in South Tyneside. Each point is first considered individually relative to baseline data for that day of the week, calculated over the last six months."),
                               p("North Tyneside: Data is the median across 34 monitoring points in North Tyneside. Each point is first considered individually relative to baseline data for that day of the week, calculated over the last six months."),
                               p("Newcastle upon Tyne: Data is the median across 123 monitoring points in Newcastle upon Tyne. Each point is first considered individually relative to baseline data for that day of the week, calculated over the last six months."),
                               p("Gateshead: Data is the median across 52 monitoring points in Gateshead. Each point is first considered individually relative to baseline data for that day of the week, calculated over the last six months."),
                               p("Northumberland: Data is the median across 4 monitoring points in Northumberland. Each point is first considered individually relative to baseline data for that day of the week, calculated over the last six months.")
                            )
                          )
              ),
             tabPanel(title = "Traffic",
                      fluidRow(
                        column(12, 
                               h3("Here is some text about cases"),
                               p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
                                 incididunt ut labore et dolore magna aliqua. Pellentesque habitant morbi tristique
                                 senectus et netus et malesuada fames. Sagittis nisl rhoncus mattis rhoncus urna 
                                 neque viverra justo. Mauris commodo quis imperdiet massa tincidunt. Tellus orci ac 
                                 auctor augue. Etiam sit amet nisl purus in. Tellus orci ac auctor augue mauris 
                                 augue neque gravida in. Mi quis hendrerit dolor magna. Integer enim neque volutpat ac 
                                 tincidunt vitae semper. Eu tincidunt tortor aliquam nulla facilisi cras fermentum. Morbi 
                                 tristique senectus et netus et malesuada. Pretium nibh ipsum consequat nisl. Eros donec
                                 ac odio tempor. Quam vulputate dignissim suspendisse in est ante. Vulputate enim nulla
                                 aliquet porttitor lacus luctus accumsan. Eros in cursus turpis massa tincidunt dui 
                                 ut ornare. Eget gravida cum sociis natoque."),
                               fluidRow(
                                 column(3,
                                        selectInput(inputId = "Metropolitan.Borough",
                                                    label = "Select region",
                                                    choices = c("Gateshead", "Newcastle upon Tyne" = "Newcastle.upon.Tyne", 
                                                                "Northumberland", "North Tyneside" = "North.Tyneside",
                                                                "South Tyneside" = "South.Tyneside","Sunderland"),
                                                    selected = "Gateshead")
                                 ),
                                 column(9,
                                        tabsetPanel(
                                          type = "tab",
                                          tabPanel(title = "Median Traffic",
                                                   plotlyOutput(outputId = "trafficmed"),
                                                   value = "tab1"),
                                          tabPanel(title = "Total Traffic",
                                                   leafletOutput("commutingmap"),
                                                   value = "tab2"),
                                          tabPanel(title = "Data",
                                                   value = "tab3")
                                        )
                                 )
                               )
                        )
                      )
             ),
             tabPanel(title = "Car parks",
                      fluidRow(
                        column(12, 
                               h3("Here is some text about Car parks"),
                               p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
                                 incididunt ut labore et dolore magna aliqua. Pellentesque habitant morbi tristique
                                 senectus et netus et malesuada fames. Sagittis nisl rhoncus mattis rhoncus urna 
                                 neque viverra justo. Mauris commodo quis imperdiet massa tincidunt. Tellus orci ac 
                                 auctor augue. Etiam sit amet nisl purus in. Tellus orci ac auctor augue mauris 
                                 augue neque gravida in. Mi quis hendrerit dolor magna. Integer enim neque volutpat ac 
                                 tincidunt vitae semper. Eu tincidunt tortor aliquam nulla facilisi cras fermentum. Morbi 
                                 tristique senectus et netus et malesuada. Pretium nibh ipsum consequat nisl. Eros donec
                                 ac odio tempor. Quam vulputate dignissim suspendisse in est ante. Vulputate enim nulla
                                 aliquet porttitor lacus luctus accumsan. Eros in cursus turpis massa tincidunt dui 
                                 ut ornare. Eget gravida cum sociis natoque."),
                               fluidRow(
                                 column(3,
                                        selectInput(inputId = "carparks",
                                                    label = "Select Car Park",
                                                    choices = carpark.meta$CarPark,
                                                    selected = "Dean Street"), 
                                        leafletOutput("CarParkMap"),
                                 ),
                                 column(9,
                                        tabsetPanel(
                                          type = "tab",
                                          tabPanel(title = "Car Park",
                                                   plotlyOutput(outputId = "CarPark"),
                                                   value = "tab1"),
                                          tabPanel(title = "Summary",
                                                   value = "tab2"),
                                          tabPanel(title = "Data",
                                                   value = "tab3")
                                        )
                                 )
                               )
                        )
                      )
              ),
             tabPanel(title = "Pedestrian flow",
                      fluidRow(
                        column(12, 
                      h3("Here is some text about Car parks"),
                      p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
                                 incididunt ut labore et dolore magna aliqua. Pellentesque habitant morbi tristique
                                 senectus et netus et malesuada fames. Sagittis nisl rhoncus mattis rhoncus urna 
                                 neque viverra justo. Mauris commodo quis imperdiet massa tincidunt. Tellus orci ac 
                                 auctor augue. Etiam sit amet nisl purus in. Tellus orci ac auctor augue mauris 
                                 augue neque gravida in. Mi quis hendrerit dolor magna. Integer enim neque volutpat ac 
                                 tincidunt vitae semper. Eu tincidunt tortor aliquam nulla facilisi cras fermentum. Morbi 
                                 tristique senectus et netus et malesuada. Pretium nibh ipsum consequat nisl. Eros donec
                                 ac odio tempor. Quam vulputate dignissim suspendisse in est ante. Vulputate enim nulla
                                 aliquet porttitor lacus luctus accumsan. Eros in cursus turpis massa tincidunt dui 
                                 ut ornare. Eget gravida cum sociis natoque."),
                      fluidRow(
                        column(3,
                               h3("Here is some text about Car parks")
                               
                        ),
                        column(9,
                               tabsetPanel(
                                 type = "tab",
                                 tabPanel(title = "Pedestrian Flow",
                                          value = "tab1"),
                                 tabPanel(title = "Summary",
                                          value = "tab2"),
                                 tabPanel(title = "Data",
                                          value = "tab3")
                               )
                        )
                      )
                  )
                )
              )
             ) # close navbarPage
) # close fluid page



# Define server logic required to draw a histogram ----
server = function(input, output) {
  
  # Load the cached data
  ###
  load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/nationCases.RData")
  load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/cases2.RData")
  load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/ltla.RData")
  load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/Commutingtrafficmap.RData")
  
  ltlanames = unique(ltla$name)
  
  ############## CAR PARK ############## CAR PARK ############## CAR PARK ############## CAR PARK ############## CAR PARK 
  filteredData <- reactive({
    filter(carpark.meta, CarPark == input$carparks)
  })
  
  
  output$CarParkMap = renderLeaflet({
    
    
    leaflet(data = carpark.meta) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(lng = filteredData()$longitude,
                 lat = filteredData()$latitude, 
                 label = filteredData()$CarPark)
  })
  

  output$CarParkMap = renderLeaflet({
    
    
    leaflet(data = carpark.meta) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(lng = carpark.meta$longitude,
                 lat = carpark.meta$latitude, 
                 label = carpark.meta$CarPark)
  })
  
  
  ############## CAR PARK ############## CAR PARK ############## CAR PARK ############## CAR PARK ############## CAR PARK
  
  
  # Prepare the Shiny outputs
  
  ###
  output$dailycasesNation = renderPlotly({
    
    nationdaily = ggplot(nationCases[order(nationCases$cases.dailyPublish, decreasing = TRUE), ]) +
      geom_col(aes(x = date, y = cases.dailyPublish, fill = name),position = position_stack(reverse = TRUE))
    
    ggplotly(nationdaily)
    
  })
  
  
  ###
  output$cumulativecasesNation = renderPlotly({
    
    nationcum = ggplot(nationCases[order(nationCases$cases.dailyPublish, decreasing = TRUE), ]) +
      geom_col(aes(x = date, y = cases.cumulativePublish, fill = name),
               position = position_stack(reverse = TRUE))
    
    
    ggplotly(nationcum)
    
  })
  
  
  ###
  output$dailycasesRegion = renderPlotly({
    
    regiondaily = ggplot(data = filter(cases2, area.type == "region")) +
                    geom_line(mapping = aes(x = date, y = cases.daily, color = name))
    
    ggplotly(regiondaily)
    
  })
  
  
  ###
  output$cumulativecasesRegion = renderPlotly({
    
    regioncum = ggplot(data = filter(cases2, area.type == "region")) +
                  geom_line(mapping = aes(x = date, y = cases.cumulative, color = name))
    
    ggplotly(regioncum)
    
  })
  
  
  ###
  output$cumrateRegion = renderPlotly({
    
    regioncumrate = ggplot(data = filter(cases2, area.type == "region")) +
      geom_line(mapping = aes(x = date, y = cumcases.rate, color = name))
    
    ggplotly(regioncumrate)
    
  })
  
  ###
  output$dailycasesltla = renderPlotly({
    
    ltladaily = ggplot(data = filter(ltla, name %in% c(input$Local.authority, "Gateshead"))) +
                  geom_line(mapping = aes(x = date, y = cases.daily, color = name))
    
    ggplotly(ltladaily)
    
  })
  
  
  ###
  output$cumulativecasesltla = renderPlot({
    
    ltlacum = ggplot(data = filter(ltla, name == input$Local.authority)) +
                geom_line(mapping = aes(x = date, y = cases.cumulative, color = name))
    
    ggplotly(ltlacum)
    
  })
   
  
  ###
  output$NELocalAuthorities = renderPlotly({
    
    NELocalAuthorities = ggplot(data = filter(ltla, code %in% c("E06000057", "E08000021", "E08000022", "E08000023", "E08000037", "E08000024", "E06000047", "E06000005", "E06000001", "E06000004", "E06000002", "E06000003"))) +
      geom_line(mapping = aes(x = date, y = cases.daily, color = name))
    
    ggplotly(NELocalAuthorities)
    
  })
  
  
  ###
  output$areatype_selector = renderUI({ #creates State select box object called in ui
    selectInput(inputId = "areatype", #name of input
                label = "Area type:", #label displayed in ui
                choices = c("Region" = "region", "Upper Tier Local Authority" = "utla"),
                # calls unique values from the State column in the previously created table
                selected = "region") #default choice (not required)
  })
  output$name_selector = renderUI({#creates County select box object called in ui
    
    data_available = unique(cases2[cases2$area.type == input$areatype, "name"])
    #creates a reactive list of available counties based on the State selection made
    
    selectInput(inputId = "name", #name of input
                label = "Name:", #label displayed in ui
                choices = data_available, #calls list of available counties
                selected = data_available[1])
  })
  
  
  ###
  output$dailycases = renderPlotly({
    
    test1 = ggplot(data = filter(cases2, 
                         area.type == input$areatype,
                         name == input$name)) +
      geom_line(mapping = aes(x = date, y = cases.daily, 
                              color = name))
    
    
    ggplotly(test1)
    
  })
  
  
  ###
  output$cumulativecases = renderPlot({
    
    test2 = ggplot(data = filter(cases2, 
                         area.type == input$areatype,
                         name == input$name)) +
      geom_line(mapping = aes(x = date, y = cases.cumulative, 
                              color = name))
    ggplotly(test2)
    
  })
  

  ###
  output$trafficmed = renderPlotly({
    
    trafficmed = ggplot(data = filter(trafficLONG, Region == input$Metropolitan.Borough)) +
      geom_line(mapping = aes(date, Percentage), color = "#0038A8", size = 1) +
      
      theme_classic() +
      theme(plot.title = element_text(face = "bold", size = 14),
            plot.subtitle = element_text(size = 10),
            axis.title.x = element_text(size=10),
            axis.title.y = element_text(size=10),
            axis.text.x = element_text(size=10),
            axis.text.y = element_text(size=10),
            plot.caption = element_text(size = 10))
    
    ggplotly(trafficmed)

  })
  
  
  ###
  output$mediantraffic = renderPlotly({
    static = ggplot(trafficLONG, aes(date, Percentage, color = Region)) +
      geom_line() +
      geom_point() +
      
      
      theme_classic() +
      theme(plot.title = element_text(face = "bold", size = 14),
            plot.subtitle = element_text(size = 10),
            axis.title.x = element_text(size=10),
            axis.title.y = element_text(size=10),
            axis.text.x = element_text(size=10),
            axis.text.y = element_text(size=10),
            plot.caption = element_text(size = 10)) +
      scale_color_manual(values = c("Sunderland" = "#FFC312", "Gateshead" = "#A3CB38", 
                                    "South.Tyneside" = "#12CBC4", "North.Tyneside" = "#FDA7DF", 
                                    "Newcastle.upon.Tyne" = "#ED4C67", "Northumberland" = "#0652DD"))
    
    ggplotly(static)
    
  })
  
  
  ###
  output$CarPark = renderPlotly({
    
    carparkplot = ggplot(data = filter(carparkSummaryShort, Car.Park == input$CarParkNames)) +
      geom_bar(stat = "identity", mapping = aes(x=date, y=daily.hours, fill = wkend))
    
    ggplotly(carparkplot)
    

  })
  
  
  ###
  output$commutingmap = renderLeaflet({
    
    
    leaflet(data = Commutingtrafficmap) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(lng = Commutingtrafficmap$Longitude,
                 lat = Commutingtrafficmap$Latitude, 
                 popup = Commutingtrafficmap$pointDescription)
  })

  
  ### Figure 2.3a
  output$dailydeathsRegiona = renderPlotly({ 
    
    regiondailydeathsa = ggplot(regiondeaths[order(regiondeaths$deaths.daily, decreasing = TRUE), ]) +
      geom_col(aes(x = date, y = deaths.daily, fill = name),position = position_stack(reverse = TRUE)) +
      
      theme_classic() +
      theme(
        axis.text.x = element_text(color = "black", angle=60, hjust=1),
        axis.text.y = element_text(color = "black")) +
      scale_x_date(date_labels = "%b-%d",
                   breaks = "1 month") +
      scale_fill_manual(values = c("East Midlands" = "#FFC312", "East of England" = "#A3CB38", 
                                   "London" = "#c8102e", "North East" = "#012169", 
                                   "North West" = "#0652DD", "South East" = "#00AD36", 
                                   "South West" = "#ff9900", "West Midlands" = "#ff33cc",
                                   "Yorkshire and The Humber" = "#660033")) +
      xlab("Date") +
      ylab("Daily deaths")
    
    ggplotly(regiondailydeathsa)
    
  })
  
  
  ### Figure 2.4a
  output$cumulativedeathsRegiona = renderPlotly({
    
    regioncumdeathsa = ggplot(regiondeaths[order(regiondeaths$deaths.cumulative, decreasing = TRUE), ]) +
      geom_col(aes(x = date, y = deaths.cumulative, fill = name),
               position = position_stack(reverse = TRUE)) +
      
      theme_classic() +
      theme(
        axis.text.x = element_text(color = "black", angle=60, hjust=1),
        axis.text.y = element_text(color = "black")) +
      scale_x_date(date_labels = "%b-%d",
                   breaks = "1 month") +
      scale_fill_manual(values = c("East Midlands" = "#FFC312", "East of England" = "#A3CB38", 
                                   "London" = "#c8102e", "North East" = "#012169", 
                                   "North West" = "#0652DD", "South East" = "#00AD36", 
                                   "South West" = "#ff9900", "West Midlands" = "#ff33cc",
                                   "Yorkshire and The Humber" = "#660033")) +
      xlab("Date") +
      ylab("Cumulative deaths")
    
    
    ggplotly(regioncumdeathsa)
    
  })
  
  
  
}

shinyApp(ui = ui, server = server)
