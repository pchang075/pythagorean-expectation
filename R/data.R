library(Lahman)
library(dplyr)

# Get and clean data
data <- Teams %>%
  filter(yearID >= 2006 & yearID <= 2025) %>%
  select(
    yearID,
    teamID,
    name,
    R, 
    RA,
    W,
    L
  ) %>%
  mutate(WinPct = W/(W+L))

# Save cleaned dataset to /data
write.csv(data, 'data/wl_data.csv', row.names=FALSE)
