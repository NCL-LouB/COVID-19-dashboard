library('ProjectTemplate')
load.project()


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

# Create a one month "buffer" at the start and end of the timeline
month_buffer = 1 

month_date_range = seq(min(lockdown.measures$date) - months(month_buffer), max(lockdown.measures$date) + months(month_buffer), by='month')


# We are adding one month before and one month after the earliest and latest 
## We want the format of the months to be in the 3 letter abbreviations of each month.
month_format = format(month_date_range, '%b') 
month_df = data.frame(month_date_range, month_format)


year_date_range = seq(min(lockdown.measures$date) - months(month_buffer), max(lockdown.measures$date) + months(month_buffer), by='year')

# We will only show the years for which we have a december to january transition.
year_date_range <- as.Date(
  intersect(
    ceiling_date(year_date_range, unit="year"),
    floor_date(year_date_range, unit="year")),  
  origin = "1970-01-01") 

# We want the format to be in the four digit format for years.
year_format <- format(year_date_range, '%Y') 
year_df <- data.frame(year_date_range, year_format)







# Text analysis

milestones = policy.tracker %>%
  select(Date, Milestone)

milestones = milestones %>%
  mutate(line = row_number()) 

#install.packages('tidytext')
library(tidytext)

policymilestones = milestones %>% 
  unnest_tokens(word, Milestone)

# view tibble
policymilestones 

# remove stop words
data("stop_words")
policymilestones = policymilestones %>%
  anti_join(stop_words)

# use count to find common words
policymilestones %>%
  count(word, sort = TRUE)

# plot the most common words
policymilestones %>%
  count(word, sort = TRUE) %>%
  filter(n > 25) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# filter out the rows that mention "prime" and "minister"
test = policymilestones %>%
  filter(word %in% c("prime", "minister")) 
# summarise to see where the

show = test %>%
  group_by(line) %>%
  summarise(count = n())



test = policymilestones %>%
  filter(word == "prime" & word == "minister")


