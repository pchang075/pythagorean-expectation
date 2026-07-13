library(ggplot2)
library(ggrepel)
library(glue)
library(patchwork)

# Fit the second-order model for each individual season from 2006-2025
# Function that fits the second-order model for individual seasons
#   Returns (for each season):
#     - alpha_hat
#     - p-value for alpha_hat
#     - beta1_hat
#     - p-value for beta1_hat
#     - beta2_hat
#     - p-value for beta2_hat
#     - R_avg
#     - gamma1_hat
#     - Confidence interval for gamma1
#     - gamma2_hat
#     - Confidence interval for gamma2
#     - R^2
fit_second_order_model <- function (season) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  R_avg <- mean(data$R)
  
  fit <- lm(
    formula = WinPct ~ I(R - RA) + I(-((R - R_avg)^2 + (RA - R_avg)^2)),
    data = data
  )
  beta1_hat <- as.numeric(coef(fit)[2])
  beta2_hat <- as.numeric(coef(fit)[3])
  ci <- confint(fit)
  
  results <- data.frame(
    season = season,
    alpha_hat = as.numeric(coef(fit)[1]),
    alpha_hat_p_value = summary(fit)$coefficients[1, 4],
    beta1_hat = beta1_hat,
    beta1_hat_p_value = summary(fit)$coefficients[2, 4],
    beta2_hat = beta2_hat,
    beta2_hat_p_value = summary(fit)$coefficients[3, 4],
    R_avg = R_avg,
    gamma1_hat = 4 * R_avg * beta1_hat,
    gamma1_lower = 4 * R_avg * ci[2, 1],
    gamma1_upper = 4 * R_avg * ci[2, 2],
    gamma2_hat = 8 * R_avg^2 * beta2_hat,
    gamma2_lower = 8 * R_avg^2 * ci[3, 1],
    gamma2_upper = 8 * R_avg^2 * ci[3, 2],
    R_squared = as.numeric(summary(fit)$r.squared)
  )
  return(results)
}

# Fit models ----
second_order_params <- data.frame()
for (season in 2006:2025) {
  second_order_params <- rbind(second_order_params, fit_second_order_model(season))
}
write.csv(second_order_params, 'output/second_order_model_params.csv', row.names = FALSE)

# Compare the theoretical RMSE of the second-order model to the theoretical RMSE of the first-order model
# Function that calculates the RMSE of the second-order model
calculate_second_order_rmse <- function (season, data, gamma_hats) {
  gamma_hat <- gamma_hats$gamma_hat[gamma_hats$season == season]
  R_avg <- mean(data$R)
  
  data$ExpWinPct <- with(data, R^gamma_hat / (R^gamma_hat + RA^gamma_hat))
  data$PredWinPct <- with(data, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA) - (gamma_hat / (8 * R_avg^2)) * ((R - R_avg)^2 + (RA - R_avg)^2))
  data$Residuals <- with(data, ExpWinPct - PredWinPct)
  
  rmse <- sqrt(mean(data$Residuals^2))
  return(rmse)
}

# Function that calculates the RMSE of the first-order model
calculate_first_order_rmse <- function (season, data, params, theoretical = FALSE) {
  if (theoretical) {
    gamma_hat <- params$gamma_hat[params$season == season]
    R_avg <- mean(data$R)
    
    data$ExpWinPct <- with(data, R^gamma_hat / (R^gamma_hat + RA^gamma_hat))
    data$PredWinPct <- with(data, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA))
    data$Residuals <- with(data, ExpWinPct - PredWinPct)
    
    rmse <- sqrt(mean(data$Residuals^2))
    return(rmse)
  } else {
    alpha_hat <- params$alpha_hat[params$season == season]
    beta_hat <- params$beta_hat[params$season == season]
    
    data$PredWinPct <- with(data, alpha_hat + beta_hat * (R - RA))
    data$Residuals <- with(data, WinPct - PredWinPct)
    
    rmse <- sqrt(mean(data$Residuals^2))
    return(rmse)
  }
}

# Wrapper function that calls calculate_first_order_rmse() and calculate_second_order_rmse()
#   Returns the RMSE values and the percent change relative to the first-order model
calculate_theoretical_rmse <- function (season, gamma_hats) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  
  first_order_rmse <- calculate_first_order_rmse(season, data, gamma_hats, theoretical = TRUE)
  second_order_rmse <- calculate_second_order_rmse(season, data, gamma_hats)
  
  results <- data.frame(
    season = season,
    FirstOrder_RMSE = first_order_rmse,
    SecondOrder_RMSE = second_order_rmse,
    PctChange = 100 * ((second_order_rmse - first_order_rmse) / first_order_rmse)
  )
  return(results)
}

# Calculate theoretical RMSE for the first- and second-order models ----
rmse <- data.frame()
gamma_hats <- read.csv('output/gamma_estimates.csv')
for (season in 2006:2025) {
  rmse <- rbind(rmse, calculate_theoretical_rmse(season, gamma_hats))
}
write.csv(rmse, 'output/theoretical_rmse.csv', row.names = FALSE)

# Residual plots
# Function that plots residuals for the first- and second-order models
plot_residuals <- function (season, gamma_hats) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  gamma_hat <- gamma_hats$gamma_hat[gamma_hats$season == season]
  R_avg <- mean(data$R)
  PctChange <- round(rmse$PctChange[rmse$season == season], 2)
  
  residuals <- data.frame(
    teamID = data$teamID,
    Dist = with(data, sqrt((R - R_avg)^2 + (RA - R_avg)^2)),
    ExpWinPct = with(data, R^gamma_hat / (R^gamma_hat + RA^gamma_hat)),
    PredWinPct1 = with(data, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA)),
    PredWinPct2 = with(data, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA) - (gamma_hat / (8 * R_avg^2)) * ((R - R_avg)^2 + (RA - R_avg)^2))
  )
  residuals$Residual1 <- with(residuals, ExpWinPct - PredWinPct1)
  residuals$Residual2 <- with(residuals, ExpWinPct - PredWinPct2)
  
  outliers <- subset(residuals, Residual1 > 0.02 | Residual2 > 0.02)
  
  plot <- ggplot(residuals, aes(x = Dist)) +
    geom_point(aes(y = Residual1, color = 'First-order'), alpha = 0.7) +
    geom_point(aes(y = Residual2, color = 'Second-order'), alpha = 0.7) +
    geom_text_repel(
      data = outliers,
      aes(y = Residual1, label = teamID, color = 'First-order'),
      show.legend = FALSE
    ) + 
    geom_text_repel(
      data = outliers,
      aes(y = Residual2, label = teamID, color = 'Second-order'),
      show.legend = FALSE
    ) + 
    scale_color_manual(values = c('First-order' = 'red', 'Second-order' = 'blue')) +
    labs(
      x = bquote("Euclidean Distance from Expansion Point (" ~ R[avg] * "," ~ R[avg] * ")"),
      y = "Residuals",
      title = glue("Season: {season}\nRMSE Change (first order to second order): {PctChange}%"),
      color = "Model"
    )
  return(plot)
}

# Draw plots
residual_plots <- list()
quartiles <- as.numeric(quantile(rmse$PctChange, probs = c(0, 0.5, 1), type = 1))
seasons <- list()
for (q in quartiles) {
  seasons[[length(seasons) + 1]] <-rmse$season[rmse$PctChange == q]
}

# Multi-plots ----
for (s in seasons) {
  residual_plots[[length(residual_plots) + 1]] <- plot_residuals(s, gamma_hats)
}
wrap_plots(residual_plots, ncol = 1)

# Single plots ----
plot_residuals(seasons[1], gamma_hats) # best
plot_residuals(seasons[2], gamma_hats) # median
plot_residuals(seasons[3], gamma_hats) # worst
plot_residuals(2025, gamma_hats)
