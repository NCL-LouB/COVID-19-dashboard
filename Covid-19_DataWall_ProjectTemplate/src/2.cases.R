library('ProjectTemplate')
load.project()
# load processed data
load(file = "~/Covid-19_Data_Wall/Covid-19_DataWall_ProjectTemplate/cache/cases.RData")

# packages used for moving averages 'zoo'     

# General information about the cases data
# The data sets covers the time period 	2020-01-03 until 2020-08-24

# Number of area names per area type
cases %>% 
  group_by(area.type) %>% 
  summarise(NameCount = length(unique(name)),
            CodeCount = length(unique(code))
            )

# How many UTLA names are the same as LTLA names? 
# create vector of unique ltla names
ltlaName = cases %>%
  filter(area.type == "ltla") %>%
  select(name) %>%
  unique


utlaName = cases %>%
  filter(area.type == "utla") %>%
  select(name) %>%
  unique

# which names are in the ltla list but not utla?
setdiff(ltlaName, utlaName) # 192
# which names are in the utla list but not ltla?
setdiff(utlaName, ltlaName) #26 
# There are 123 
149-26 
# 123
315-123 
# 192
# There are 123 UTLA names that are the same as LTLA names 26 of the UTLA names
# are unique to UTLA regions and 192 LTLA names are unique to LTLA regions



# Nations
# Nations: date of first case
cases %>% 
  filter(cases.daily > 0 & area.type == "nation") %>% 
  group_by(name) %>% 
  filter(date == min(date)) %>% 
  select(area.type, firstcases=date, cases.daily) %>%
  arrange(firstcases)

# Nations: date of first case (publish)
cases %>% 
  filter(cases.dailyPublish > 0 & area.type == "nation") %>% 
  group_by(name) %>% 
  filter(date == min(date)) %>% 
  select(area.type, firstcases=date, cases.dailyPublish) %>%
  arrange(firstcases)


# Nations: worst daily number of cases
cases %>% 
  filter(area.type == "nation") %>% 
  group_by(name) %>% 
  slice(which.max(cases.daily))  %>%
  arrange(date)

# Nations: worst daily number of cases (publish)
cases %>% 
  filter(area.type == "nation") %>% 
  group_by(name) %>% 
  filter(cases.dailyPublish == max(cases.dailyPublish)) %>%
  arrange(date)


# Regions
# Regions: date of first case
cases %>% 
  filter(cases.daily > 0 & area.type == "region") %>% 
  group_by(name) %>% 
  filter(date == min(date)) %>% 
  select(area.type, firstcases=date, cases.daily) %>%
  arrange(firstcases)


# Regions: worst daily number of cases
cases %>% 
  filter(area.type == "region") %>% 
  group_by(name) %>% 
  slice(which.max(cases.daily)) %>%
  arrange(date)


# UTLA
# UTLA: date of first case
utlafirstcase = cases %>% 
  filter(cases.daily > 0 & area.type == "utla") %>% 
  group_by(name) %>% 
  filter(date == min(date)) %>% 
  select(area.type, firstcases=date, cases.daily) %>%
  arrange(firstcases)

# plot the first cases for utla regions
ggplot(utlafirstcase) +
  geom_bar(aes(x = firstcases))

# UTLA: worst daily number of cases
cases %>% 
  filter(area.type == "utla") %>% 
  group_by(name) %>% 
  slice(which.max(cases.daily)) %>%
  arrange(date)


worstdailycases = cases %>% 
  filter(area.type == "utla") %>% 
  group_by(name) %>% 
  filter(cases.daily == max(cases.daily)) %>%
  select(date, name, worstdailycases=cases.daily) %>%
  arrange(date)
 

# plot the worst daily cases for utla regions
worstdailycasesplot = ggplot(worstdailycases) +
  geom_bar(aes(x = date))



# Aim: to recreate some of the summary stats and plots on the government's dashboard: https://coronavirus.data.gov.uk/cases
# UK
# 1. Summary stats
# People tested positive

# Total on 12 August 2020
sum(cases %>% filter(
  date == "2020-08-12", 
  area.type == "nation") %>%
    select(cases.cumulative), na.rm = TRUE)

# Figure 1: Daily cases by date reported

# Prepare the data
figure1data = cases %>% 
  filter(name == "United Kingdom") %>%
  mutate(roll7daily = round(zoo::rollmean(cases.dailyPublish, k = 7, fill = NA),digits = 1),
         roll7cummulative = round(zoo::rollmean(cases.cumulativePublish, k = 7, fill = NA),digits = 1))


# Prepare daily plot
ggplot(figure1data) +
  geom_col(aes(x = date, y = cases.dailyPublish)) +
  geom_line(mapping = aes(date, roll7daily), color = 'red', na.rm = TRUE, group = 1)


# Prepare cumulative plot
ggplot(figure1data) +
  geom_col(aes(x = date, y = cases.cumulativePublish)) 



# Figure 2: Cases by date reported, by nation
# Prepare daily plot
ggplot(nationCases[order(nationCases$cases.dailyPublish, decreasing = TRUE), ]) +
  geom_col(aes(x = date, y = cases.dailyPublish, fill = name),position = position_stack(reverse = TRUE))

# Prepare cumulative plot
ggplot(nationCases[order(nationCases$cases.dailyPublish, decreasing = TRUE), ]) +
  geom_col(aes(x = date, y = cases.cumulativePublish, fill = name),
           position = position_stack(reverse = TRUE))


# Table 1: Cases by area: nation


cases %>% filter(
       area.type == "nation",
       date == "2020-08-12") %>%

select(name, cases.cumulativePublish, cumcases.rate)

# Table 1: Cases by area: region

cases %>% filter(
  area.type == "region",
  date == "2020-08-11") %>%
  
  select(name, cases.cumulative, cumcases.rate)

# Table 1: Cases by area: Upper Tier LA

cases %>% filter(
  area.type == "utla",
  date == "2020-08-11") %>%
  
  select(name, cases.cumulative, cumcases.rate)

# Table 1: Cases by area: Lower Tier LA

cases %>% filter(
  area.type == "ltla",
  date == "2020-08-11") %>%
  
  select(name, cases.cumulative, cumcases.rate)

# Figure 3: Cases by date reported, by region

# Prepare the data
figure3data = cases %>% 
  filter(area.type == "region")

# Prepare daily plot
ggplot(figure3data[order(figure3data$cases.daily, decreasing = TRUE), ]) +
  geom_col(aes(x = date, y = cases.daily, fill = name),position = position_stack(reverse = TRUE))

# Prepare cumulative plot
ggplot(figure3data[order(figure3data$cases.daily, decreasing = TRUE), ]) +
  geom_col(aes(x = date, y = cases.cumulative, fill = name),
           position = position_stack(reverse = TRUE))


##### Local Authorities in the North East
# Questions
# Which North East local authority has the highest number of COVID-19 cases?
# Which North East local authority has the highest rate of COVID-19 cases?



################ ################ ################ LOCAL AUTHORITIES ################ ################ 


ltla = cases %>% 
  filter(area.type == "ltla")
length(unique(ltla$name))

ltlanames = unique(ltla$name)

NEltlaCases = filter(ltla, code %in% c("E06000057", "E08000021", "E08000022", 
                                  "E08000023", "E08000037", "E08000024", 
                                  "E06000047", "E06000005", "E06000001", 
                                  "E06000004", "E06000002", "E06000003")) 

# Which NE local authority has had the most recorded lab-confirmed cases?

# County Durham has the most recorded cases but Middlesborough has the highest rate of cases
NEltlaCases %>% filter(date == "2020-08-11") %>%
  select(name, cases.cumulative, cumcases.rate) %>%
  arrange(desc(cumcases.rate))

# Which NE local authority has had the most recorded lab-confirmed cases in a single day?
NEltlaCases %>% group_by(name) %>%
  summarise(worst.day = max(cases.daily, na.rm = TRUE)) %>%
  arrange(desc(worst.day))

# How do the NE local authority rates compare to others in the country?
cases.comparison = cases %>% filter(area.type == "ltla" & date == "2020-08-11") %>%
  select(name, code, cases.cumulative, cumcases.rate) %>%
  arrange(desc(cumcases.rate)) 

cases.comparison = cases.comparison %>% mutate(rank.cumcases.rate = row_number())
cases.comparison = cases.comparison %>% arrange(desc(cases.cumulative)) %>%
  mutate(cases.cumulative.rate = row_number())

cases.comparison = cases.comparison %>% 
  select(name, code, cases.cumulative, cases.cumulative.rate, 
         cumcases.rate, rank.cumcases.rate)

filter(cases.comparison, code %in% c("E06000057", "E08000021", "E08000022", 
                         "E08000023", "E08000037", "E08000024", 
                         "E06000047", "E06000005", "E06000001", 
                         "E06000004", "E06000002", "E06000003")) %>%
  arrange(rank.cumcases.rate)

length(unique(cases.comparison$name))
# There are 315 local authority regions included in this data set. 
315/100*25
# 7 of the 12 (over half of the NE regions are ranked in the top 25% of the country)


ggplot(NEltlaCases) +
  geom_line(mapping = aes(x = date, y = cases.daily, color = name))

NEltlaCases %>% filter(date >= "2020-03-01") %>%
  ggplot(aes(x=date)) +
  geom_col(
    aes(y = cases.daily, fill = name),
    position = "dodge")


### STACKED plot of cases in North East local authorities
stacked =  ggplot(NEltlaCases[order(NEltlaCases$cases.daily, decreasing = TRUE), ]) +
  geom_col(aes(x = date, y = cases.daily, fill = name),position = position_stack(reverse = TRUE))

ggplotly(stacked) 

filter(NEltlaCases, date %in% c("2020-04-27", "2020-04-28", "2020-04-29")) %>%
         group_by(name, date) %>%
         summarise(cases.2020-04-27 = cases.daily) %>%
         arrange(desc(name))


ggplot(nationCases[order(nationCases$cases.daily, decreasing = TRUE), ]) +
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
 