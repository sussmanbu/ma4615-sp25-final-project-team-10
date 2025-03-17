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











