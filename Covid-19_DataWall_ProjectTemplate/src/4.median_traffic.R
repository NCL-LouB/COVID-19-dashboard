library('ProjectTemplate')
load.project()

# ----- MEDIAN Traffic data  ----- #
# Trying to recreate this page: https://covid.view.urbanobservatory.ac.uk/#traffic-national

# WHAT DOES THIS DATA SHOW?
# The change in motor vehicle traffic, relative to a baseline.

# Load the data from cache folder
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/mediantraffic.RData")
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/mediantrafficLONG.RData")



str(mediantraffic)
length(is.na(mediantraffic$County.Durham))
# There are no values for County Durham. This variable has been removed from the cached data frame. 

sum(is.na(mediantraffic$Sunderland) == TRUE)
sum(is.na(mediantraffic$South.Tyneside) == TRUE)
sum(is.na(mediantraffic$North.Tyneside) == TRUE)
sum(is.na(mediantraffic$Newcastle.upon.Tyne) == TRUE)
sum(is.na(mediantraffic$Gateshead) == TRUE)
sum(is.na(mediantraffic$County.Durham) == TRUE)
sum(is.na(mediantraffic$Northumberland) == TRUE)
# Missing data for days 17 and 18 March, 10 May and 18 July, across all variables. 

# There are no values for County Durham so this variable will be removed from the dataframe 
# and saved as traffic
# mediantrafficLONG is a pivoted dataframe of the remaining areas (Sunderland, South.Tyneside, 
#North.Tyneside, Newcastle.upon.Tyne, Gateshead and Northumberland)

# create a summary of the traffic data
summary(mediantraffic)
mediantrafficLONG %>%
  group_by(Region) %>%
  summarize(mean = mean(Percentage))

# Sunderland
ggplot(data = filter(mediantrafficLONG, Region == "Sunderland")) +
  geom_line(mapping = aes(x = date, y = Percentage)) +
  geom_point(mapping = aes(x = date, y = Percentage))

# South Tyneside
ggplot(data = filter(mediantrafficLONG, Region == "South.Tyneside")) +
  geom_line(mapping = aes(x = date, y = Percentage)) +
  geom_point(mapping = aes(x = date, y = Percentage))

# North Tyneside
ggplot(data = filter(mediantrafficLONG, Region == "North.Tyneside")) +
  geom_line(mapping = aes(x = date, y = Percentage)) +
  geom_point(mapping = aes(x = date, y = Percentage))

# Newcastle upon Tyne
ggplot(data = filter(mediantrafficLONG, Region == "Newcastle.upon.Tyne")) +
  geom_line(mapping = aes(x = date, y = Percentage)) +
  geom_point(mapping = aes(x = date, y = Percentage))

# Gateshead
ggplot(data = filter(mediantrafficLONG, Region == "Gateshead")) +
  geom_line(mapping = aes(x = date, y = Percentage)) +
  geom_point(mapping = aes(x = date, y = Percentage))

# Northumberland
ggplot(data = filter(mediantrafficLONG, Region == "Northumberland")) +
  geom_line(mapping = aes(x = date, y = Percentage)) +
  geom_point(mapping = aes(x = date, y = Percentage))


# Plot all together
MTplot = ggplot(mediantrafficLONG, aes(date, Percentage, color = Region)) +
  geom_line() +
  
  
  theme_classic() +
  theme(plot.title = element_text(face = "bold", size = 14),
        plot.subtitle = element_text(size = 10),
        axis.title.x = element_text(size=10),
        axis.title.y = element_text(size=10),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        plot.caption = element_text(size = 10))

ggplotly(MTplot)


# Plot all together with updated colours
MTplot2 = ggplot(mediantrafficLONG, aes(date, Percentage, color = Region)) +
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


ggplotly(MTplot2)


# TRYING TO GET PLOTLY TO WORK WITHOUT GGPLOT
MTplotly = mediantrafficLONG %>%
  group_by(Region) %>%
  plot_ly(x=~date, y=~Percentage, type="scatter",color=~Region, mode="lines+markers")
MTplotly





