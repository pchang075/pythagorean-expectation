library(glue)

# Fit the first-order model for each individual season from 2006-2025
# Function that fits the first-order model for individual seasons
#   Returns (for each season):
#     - alpha_hat
#     - beta_hat
#     - R_avg
#     - gamma_hat
#     - Confidence interval for gamma_hat
#     - R^2
fit_first_order_model <- function (season) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  R_avg <- mean(data$R)
  
  fit <- lm(
    formula = WinPct ~ I(R - RA),
    data = data
  )
  beta_hat <- as.numeric(coef(fit)[2])
  ci <- confint(fit)
  
  results <- data.frame(
    season = season,
    alpha_hat = as.numeric(coef(fit)[1]),
    alpha_hat_p_value = summary(fit)$coefficients[1, 4],
    beta_hat = beta_hat,
    beta1_hat_p_value = summary(fit)$coefficients[2, 4],
    R_avg = R_avg,
    gamma_hat = 4 * R_avg * beta_hat,
    lower_bound = 4 * R_avg * ci[2, 1],
    upper_bound = 4 * R_avg * ci[2, 2],
    R_squared = as.numeric(summary(fit)$r.squared)
  )
  return(results)
}

# Fit models ----
first_order_params <- data.frame()
for (season in 2006:2025) {
  first_order_params <- rbind(first_order_params, fit_first_order_model(season))
}
write.csv(first_order_params, 'tables/first_order_model_params.csv', row.names = FALSE)

# Compare the RMSE of the first-order model to the RMSE of the Pythagorean model
# Function that calculates the RMSE for the Pythagorean model
calculate_pythag_rmse <- function (season, data, gamma_hats) {
  gamma_hat <- gamma_hats$gamma_hat[gamma_hats$season == season]
  
  data$PredWinPct <- with(data, R^gamma_hat / (R^gamma_hat + RA^gamma_hat))
  data$Residuals <- with(data, WinPct - PredWinPct)
  
  rmse <- sqrt(mean(data$Residuals^2))
  return(rmse)
}

# Function that calculates the RMSE of the first-order model
calculate_first_order_rmse <- function (season, data, first_order_params) {
    alpha_hat <- first_order_params$alpha_hat[first_order_params$season == season]
    beta_hat <- first_order_params$beta_hat[first_order_params$season == season]
    
    data$PredWinPct <- with(data, alpha_hat + beta_hat * (R - RA))
    data$Residuals <- with(data, WinPct - PredWinPct)
    
    rmse <- sqrt(mean(data$Residuals^2))
    return(rmse)
}

# Wrapper function that calls calculate_pythag_rmse() and calculate_first_order_rmse()
#   Returns the RMSE values and the percent change relative to the Pythagorean model
calculate_rmse <- function (season, gamma_hats, first_order_params) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  
  pythag_rmse <- calculate_pythag_rmse(season, data, gamma_hats)
  first_order_rmse <- calculate_first_order_rmse(season, data, first_order_params)
  
  results <- data.frame(
    season = season,
    Pythag_RMSE = pythag_rmse,
    FirstOrder_RMSE = first_order_rmse,
    PctChange = 100 * ((first_order_rmse - pythag_rmse) / pythag_rmse)
  )
  return(results)
}

# Calculate RMSE for the Pythagorean and first-order models ----
rmse <- data.frame()
gamma_hats <- read.csv('tables/gamma_estimates.csv')
first_order_params <- read.csv('tables/first_order_model_params.csv')
for (season in 2006:2025) {
  rmse <- rbind(rmse, calculate_rmse(season, gamma_hats, first_order_params))
}
write.csv(rmse, 'tables/rmse.csv', row.names = FALSE)