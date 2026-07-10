library(Lahman)
library(dplyr)
library(glue)

# Win-loss data for 2006-2025
wl_data <- Teams %>%
  filter(yearID >= 2006 & yearID <= 2025) %>%
  select(
    yearID,
    teamID,
    name,
    G,
    R, 
    RA,
    W,
    L
  ) %>%
  mutate(WinPct = W / (W + L))
write.csv(wl_data, 'data/wl_data_2006-2025.csv', row.names = FALSE)

# Win-loss data for individual seasons from 2006-2025
for (season in 2006:2025) {
  data <- Teams %>%
    filter(yearID == season) %>%
    select(
      yearID,
      teamID,
      name,
      G,
      R,
      RA,
      W,
      L
    ) %>%
    mutate(WinPct = W / (W + L))
  write.csv(data, glue('data/wl_data_{season}.csv'), row.names = FALSE)
}
