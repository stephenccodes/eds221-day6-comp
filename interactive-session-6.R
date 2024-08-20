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
  tidyr::separate(col = year, into = c("year", "year_chr"), sep =" ") %>%
  dplyr::select(-year_chr, -`Country Code`, - `Series Code`)

wb_data_tidy <- wb_data_clean %>%
  tidyr::drop_na("Series Name") %>%
  tidyr::pivot_wider(names_from = "Series Name",
                     values_from = indicator_value)

names(wb_data_tidy) <- c("country",
                         "year",
                         "access_clean_fuels_pp",
                         "access_electricity_pp",
                         "co2_emissions_kt",
                         "fossil_fuel_cons_pt",
                         "water_stress"
                         )

us_wb <- wb_data_tidy %>%
  dplyr::filter(country == "United States")


nicaragua_co2 <- wb_data_tidy %>%
  dplyr::filter(country == "Nicaragua")%>%
  select(year, co2_emissions_kt)


wb_subset <- wb_data_tidy %>%
  select(-c(water_stress, access_electricity_pp))

wb_newnames <- wb_data_tidy %>%
  rename(elec = access_electricity_pp, co2 = co2_emissions_kt)

# check the class of a column
class(wb_data_tidy$year)

#change the class from character to numeric
wb_data_tidy$year <- as.numeric(wb_data_tidy$year)
#another way to achieve this
wb_data_tidy <- wb_data_tidy %>%
  mutate(year = as.numeric(year))

#unit conversions----
wb_co2_tons <- wb_data_tidy %>%
  mutate(co2_tons = co2_emissions_kt * 1000)

view(wb_co2_tons)

# group by a single variable
co2_total <- wb_data_tidy %>%
  group_by(country) %>%
  summarize(total_co2_kt = sum(co2_emissions_kt, na.rm = TRUE))


----

us_ca <- wb_data_tidy %>%
  filter(country %in% c("United States", "Canada"))

data_2020 <- wb_data_tidy %>%
  filter(year == 2020)

----


co2_annual <- wb_data_tidy %>%
  group_by(year) %>%
  summarize(anual_total_co2_kt = sum(co2_emissions_kt, na.rm, = TRUE))

ggplot(data = co2_annual, aes(x = year, y = annual_totat_co2_kt)) +
  geom_line()
