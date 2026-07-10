library(glue)

# Estimate gamma for 2006-2025
pythag_fit <- nls(
  formula = WinPct ~ R^gamma / (R^gamma + RA^gamma),
  data = read.csv('data/wl_data_2006-2025.csv'),
  start = list(gamma = 2)
)
summary(pythag_fit)
as.numeric(confint(pythag_fit))

# Estimate gamma for each individual season from 2006-2025 ----
# Function that fits models for individual seasons 
#   Returns the gamma estimate and confidence interval for each season as a data frame row
fit_pythag_model <- function (season) {
  fit <- nls(
    formula = WinPct ~ R^gamma / (R^gamma + RA^gamma),
    data = read.csv(glue('data/wl_data_{season}.csv')),
    start = list(gamma = 2)
  )
  ci <- as.numeric(confint(fit))
  
  results <- data.frame(
    season = season, 
    gamma_hat = as.numeric(coef(fit)),
    lower_bound = ci[1],
    upper_bound = ci[2]
  )
  return(results)
}

# Fit models
gamma_hats <- data.frame()
for (season in 2006:2025) {
  gamma_hats <- rbind(gamma_hats, fit_pythag_model(season))
}
write.csv(gamma_hats, 'output/gamma-estimates.csv', row.names = FALSE)

