library(glue)

# Fit the first-order model for each individual season from 2006-2025 ----
# Function that fits models for individual seasons
#   Returns the coefficient estimate, value of R_avg, gamma estimate, confidence interval, and R^2 value for each season
fit_first_order_model <- function (season) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  
  fit <- lm(
    formula = WinPct ~ I(R - RA),
    data = data
  )
  ci <- confint(fit)
  beta_hat <- as.numeric(coef(fit)[2])
  R_avg <- mean(data$R)
  
  results <- data.frame(
    season = season,
    alpha_hat = as.numeric(coef(fit)[1]),
    beta_hat = beta_hat,
    R_avg = R_avg,
    gamma_hat = 4 * R_avg * beta_hat,
    lower_bound = 4 * R_avg * ci[2, 1],
    upper_bound = 4 * R_avg * ci[2, 2],
    R_squared = as.numeric(summary(fit)$r.squared)
  )
  return(results)
}

# Fit models
first_order_params <- data.frame()
for (season in 2006:2025) {
  first_order_params <- rbind(first_order_params, fit_first_order_model(season))
}
write.csv(first_order_params, 'output/first-order-model-params.csv', row.names = FALSE)

# Compare the RMSE of the first-order model to the RMSE of the Pythagorean model ----
# Function that calculates the RMSE for the Pythagorean model
calculate_pythag_rmse <- function (season, data, gamma_hats) {
  gamma_hat <- gamma_hats$gamma_hat[gamma_hats$season == season]
  
  data$PredWinPct <- with(data, R^gamma_hat / (R^gamma_hat + RA^gamma_hat))
  data$Residuals <- with(data, WinPct - PredWinPct)
  
  rmse <- sqrt(mean(data$Residuals^2))
  return(rmse)
}

# Function that calculates the RMSE for the first-order model
calculate_first_order_rmse <- function (season, data, first_order_params) {
  alpha_hat <- first_order_params$alpha_hat[first_order_params$season == season]
  beta_hat <- first_order_params$beta_hat[first_order_params$season == season]
  
  data$PredWinPct <- with(data, alpha_hat + beta_hat*(R - RA))
  data$Residuals <- with(data, WinPct - PredWinPct)
  
  rmse <- sqrt(mean(data$Residuals^2))
  return(rmse)
}

# Wrapper function that calls `calculate_pythag_rmse()` and `calculate_first_order_rmse()`
#   Returns the RMSE values and the percent change relative to the Pythagorean model
calculate_rmse <- function (season, gamma_hats, first_order_params) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  
  pythag_rmse <- calculate_pythag_rmse(season, data, gamma_hats)
  first_order_rmse <- calculate_first_order_rmse(season, data, first_order_params)
  
  results <- data.frame(
    season = season,
    Pythag_RMSE = pythag_rmse,
    FirstOrder_RMSE = first_order_rmse,
    PF_PctChange = 100 * ((first_order_rmse - pythag_rmse) / pythag_rmse)
  )
  return(results)
}

# Calculate RMSE for the Pythagorean and first-order models
rmse <- data.frame()
gamma_hats <- read.csv('output/gamma-estimates.csv')
first_order_params <- read.csv('output/first-order-model-results.csv')
for (season in 2006:2025) {
  rmse <- rbind(rmse, calculate_rmse(season, gamma_hats, first_order_params))
}
write.csv(rmse, 'output/observed-rmse.csv', row.names = FALSE)