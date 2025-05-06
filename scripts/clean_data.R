# This file is purely as an example.
# Note, you may end up creating more than one cleaned data set and saving that
# to separate files in order to work on different aspects of your project

#library(tidyverse)

#loan_data <- read_csv(here::here("dataset", "loan_refusal.csv"))

## CLEAN the data
#loan_data_clean <- loan_data |>
#  pivot_longer(2:5, names_to = "group", values_to = "refusal_rate")

#write_rds(loan_data_clean, file = here::here("dataset", "loan_refusal_clean.rds"))
###
#OUR CODE STARTS BELOW
###

library(tidyverse)
library(here)
library(readr)

# Read the exoneration dataset
exoneration_data <- read_csv(here::here("dataset", "publicspreadsheet.csv"))

# Clean column names
exoneration_data <- exoneration_data %>% 
  rename_with(~ gsub(" ", "_", .))

# Convert Age to integer (if any non-numeric values exist, they will become NA)
exoneration_data <- exoneration_data %>% 
  mutate(Age = as.integer(Age))

# Clean Date_of_Crime_Year column (remove commas and convert to integer)
exoneration_data <- exoneration_data %>% 
  mutate(Date_of_Crime_Year = as.integer(gsub(",", "", Date_of_Crime_Year)))

# Handle missing values (replace NaN with NA)
exoneration_data <- exoneration_data %>% 
  mutate(across(everything(), ~ ifelse(is.na(.), NA, .)))

# Save cleaned dataset
write_rds(exoneration_data, file = here::here("dataset", "exoneration_data_clean.rds"))

# Filter exoneration cases to only Cook County
exoneration_data_cook <- exoneration_data %>%
  filter(str_to_lower(County) == "cook")

# Save the Cook County subset separately
write_rds(exoneration_data_cook, file = here::here("dataset", "exoneration_data_cook.rds"))


# DATASET #2
library(tidyverse)
library(here)

# Efficiently read only necessary columns and filter early using read_csv and col_types
crime_data_raw <- read_csv(
  here::here("dataset-ignore", "Crimes_-_2001_to_Present.csv"),
  col_types = cols_only(
    ID = col_double(),
    `Date` = col_character(),
    `Primary Type` = col_character(),
    `Description` = col_character(),
    `Location Description` = col_character(),
    `Arrest` = col_logical(),
    `Domestic` = col_logical(),
    `Year` = col_integer(),
    `Latitude` = col_double(),
    `Longitude` = col_double()
  )
)


# Filter for crimes from 2010 and later
crime_data_2010 <- crime_data_raw %>%
  filter(Year >= 2010)

# Save the filtered dataset as RDS for faster access later
write_rds(crime_data_2010, file = here::here("dataset-ignore", "crime_data_2010.rds"))

# for interactive:
crime_small <- crime_data_2010 %>%
  filter(Year >= 2017) %>%
  
  # 3) Keep only the two columns your app actually uses:
  select(Year, `Primary Type`)

# 4) Write out the tiny RDS
write_rds(crime_small, here("dataset", "crime_data_shiny.rds"))



##############################
# code to view the column headers of the original raw dataset
library(readr)
library(here)

# Read just the first row to inspect column names
crime_data_head <- read_csv(
  here::here("dataset-ignore", "Crimes_-_2001_to_Present.csv"),
  n_max = 1
)

# Print column names to console
print(colnames(crime_data_head))

# Optionally save this 1-row snapshot to a smaller CSV or RDS for reference
write_csv(crime_data_head, here::here("dataset-ignore", "crime_data_head.csv"))
write_rds(crime_data_head, here::here("dataset-ignore", "crime_data_head.rds"))

################3

