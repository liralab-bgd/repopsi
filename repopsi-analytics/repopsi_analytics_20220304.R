# Contains data and code for reproducing charts 
# at https://osf.io/5zb8p/wiki/repopsi-analytics/
# Code developed by Aleksandra Lazic
# Code updated 04-Mar-22

# Setup -------------------------------------------------------------------

# Check and install packages

list.of.packages = c("ggplot2", "dplyr", "hrbrthemes", "scales", "datapasta")
new.packages = 
  list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load packages

library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(scales)
library(datapasta)

# REPOPSI growth ---------------------------------------------------------------

# Input data
data_records = tribble( 
  ~date,	~records,
  '2020-03-01',	129,
  '2020-04-01',	129,
  '2020-05-01',	135,
  '2020-06-01',	135,
  '2020-07-01',	135,
  '2020-08-01',	140,
  '2020-09-01',	140,
  '2020-10-01',	140,
  '2020-11-01',	141,
  '2020-12-01',	141,
  '2021-01-01',	142,
  '2021-02-01',	142,
  '2021-03-01',	142,
  '2021-04-01',	150,
  '2021-05-01',	150,
  '2021-06-01',	150,
  '2021-07-01',	150,
  '2021-08-01',	153,
  '2021-09-01',	155,
  '2021-10-01',	155,
  '2021-11-01',	155,
  '2021-12-01',	160,
  '2022-01-01',	160,
  '2022-02-01',	164)

# Convert date characters to calendar dates (and order them)

data_records$date = as.Date(data_records$date)
data_records = data_records[order(data_records$date), ] 

#Set date breaks

datebreaks = seq(as.Date("2020-03-01"), as.Date("2022-02-01"), by = "1 months")

# Create the connected scatterplot

png(file="plot-growth_2022.png", width = 3984, height = 2352, res=300) #open PNG

data_records %>%
  ggplot(aes(x=date, y=records), ) +
  geom_line(color="grey") +
  geom_point(shape=21, color="black", fill="#4285F5", size=5) +
  theme_ipsum() +
  ggtitle("The total number of REPOPSI records over time") +
  scale_x_date(date_labels = "%Y-%b", breaks = datebreaks) +
  theme(axis.text.x=element_text(angle=40, hjust=1)) +  
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) + 
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )

dev.off() #close PNG

# REPOPSI records by type ------------------------------------------------------

# Input data

data_type = tribble( 
  ~date,                 ~availability,                  ~records,
  "2020-Mar",         "OA in REPOPSI",                  90,
  "2020-Mar",         "Upon request",                   36,
  "2020-Mar",         "Elsewhere online",               3,
  "2021-Mar",         "OA in REPOPSI",                  103,
  "2021-Mar",         "Upon request",                   37,
  "2021-Mar",         "Elsewhere online",               2,
  "2022-Mar",         "OA in REPOPSI",                  139,
  "2022-Mar",         "Upon request",                   23,
  "2022-Mar",         "Elsewhere online",               2)

# Sort availability labels

data_type$availability = factor(data_type$availability, 
                                levels = c("Elsewhere online", "Upon request", "OA in REPOPSI"))

# Create grouped barchart

png(file="plot-type_2022.png", width = 3723, height = 2382, res=300) #open PNG

ggplot(data_type, aes(fill=availability, y=records, x=date)) + 
  geom_bar(position="stack", stat="identity", width=0.65, color = "black") +
  scale_fill_manual(values = c("#d9e1ff", "#99b2fb", "#4285f5")) +
  ggtitle(label = "The number of REPOPSI records by availability") +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  theme_ipsum() +
  xlab("year") +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )

dev.off() #close PNG