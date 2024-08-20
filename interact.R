# clear global environment ----
rm(list =ls())

# load packages ----
library(tidyverse)
library(here)
library(janitor)

# read in data ----
wb_indicators <- read_csv(here("data", "wb_indicators.csv"), na = c("..", ""))
wb_metadata <- read_csv(here("data", "wb_indicators_metadata.csv"))

# reformat data ----
wb_indicators_long <- wb_indicators %>%
  pivot_longer( cols = "2001 [YR2001]" : "2020 [YR2020]",
                names_to = "year",
                values_to = "indicator_value")
wb_data_clean <- wb_indicators_long %>%
  tidyr::separate(col = year, into = c("year", "year_chr"), sep =" ")
