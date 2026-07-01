library(Lahman)
library(dplyr)

# Get and clean win-loss data and save it to /data
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
write.csv(wl_data, 'data/wl_data.csv', row.names = FALSE)
