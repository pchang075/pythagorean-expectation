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
write.csv(second_order_params, 'tables/second_order_model_params.csv', row.names = FALSE)

# Compare the approximation error of the second-order model to the approximation error of the first-order model
# Function that calculates the approximation error of the second-order model
calculate_second_order_error <- function (season, data, gamma_hats) {
  gamma_hat <- gamma_hats$gamma_hat[gamma_hats$season == season]
  R_avg <- mean(data$R)
  
  data$ExpWinPct <- with(data, R^gamma_hat / (R^gamma_hat + RA^gamma_hat))
  data$PredWinPct <- with(data, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA) - (gamma_hat / (8 * R_avg^2)) * ((R - R_avg)^2 + (RA - R_avg)^2))
  data$Residuals <- with(data, ExpWinPct - PredWinPct)
  
  approx_errors <- sqrt(mean(data$Residuals^2))
  return(approx_errors)
}

# Function that calculates the approximation error of the first-order model
calculate_first_order_error <- function (season, data, gamma_hats) {
    gamma_hat <- gamma_hats$gamma_hat[gamma_hats$season == season]
    R_avg <- mean(data$R)
    
    data$ExpWinPct <- with(data, R^gamma_hat / (R^gamma_hat + RA^gamma_hat))
    data$PredWinPct <- with(data, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA))
    data$Residuals <- with(data, ExpWinPct - PredWinPct)
    
    approx_errors <- sqrt(mean(data$Residuals^2))
    return(approx_errors)
}

# Wrapper function that calls calculate_first_order_error() and calculate_second_order_error()
#   Returns the approximation errors and the percent change relative to the first-order model
calculate_approx_error <- function (season, gamma_hats) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  
  first_order_errors <- calculate_first_order_error(season, data, gamma_hats)
  second_order_errors <- calculate_second_order_error(season, data, gamma_hats)
  
  approx_errors <- data.frame(
    season = season,
    FirstOrder_Error = first_order_errors,
    SecondOrder_Error = second_order_errors,
    PctChange = 100 * ((second_order_errors - first_order_errors) / first_order_errors)
  )
  return(approx_errors)
}

# Calculate approximation errors for the first- and second-order models ----
approx_errors <- data.frame()
gamma_hats <- read.csv('tables/gamma_estimates.csv')
for (season in 2006:2025) {
  approx_errors <- rbind(approx_errors, calculate_approx_error(season, gamma_hats))
}
write.csv(approx_errors, 'tables/approximation_error.csv', row.names = FALSE)

# Error plots
# Function that plots approximation errors for the first- and second-order models
plot_approx_errors <- function (season, approx_errors, gamma_hats, tags = FALSE) {
  data <- read.csv(glue('data/wl_data_{season}.csv'))
  gamma_hat <- gamma_hats$gamma_hat[gamma_hats$season == season]
  R_avg <- mean(data$R)
  PctChange <- round(approx_errors$PctChange[approx_errors$season == season], 2)
  
  e <- data.frame(
    teamID = data$teamID,
    Dist = with(data, sqrt((R - R_avg)^2 + (RA - R_avg)^2)),
    ExpWinPct = with(data, R^gamma_hat / (R^gamma_hat + RA^gamma_hat)),
    PredWinPct1 = with(data, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA)),
    PredWinPct2 = with(data, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA) - (gamma_hat / (8 * R_avg^2)) * ((R - R_avg)^2 + (RA - R_avg)^2))
  )
  e$Error1 <- with(e, ExpWinPct - PredWinPct1)
  e$Error2 <- with(e, ExpWinPct - PredWinPct2)
  
  plot <- ggplot(e, aes(x = Dist)) +
    geom_point(aes(y = abs(Error1), color = 'First-order'), alpha = 0.7) +
    geom_point(aes(y = abs(Error2), color = 'Second-order'), alpha = 0.7) +
    scale_color_manual(values = c('First-order' = 'red', 'Second-order' = 'blue')) +
    labs(
      x = bquote("Euclidean Distance from Expansion Point (" ~ R[avg] * "," ~ R[avg] * ")"),
      y = "Absolute Approximation Errors",
      title = glue("Season: {season}\nPercent Increase in Error: {PctChange}%"),
      color = "Model"
    )
  
  if (tags) {
    outliers <- subset(e, abs(Error1) > 0.02 | abs(Error2) > 0.02)
    plot <- plot + 
      geom_text_repel(
        data = outliers,
        aes(y = Error1, label = teamID, color = 'First-order'),
        show.legend = FALSE
      ) + 
      geom_text_repel(
        data = outliers,
        aes(y = Error2, label = teamID, color = 'Second-order'),
        show.legend = FALSE
      ) 
  }
  return(plot)
}

# Draw plots
error_plots <- list()
seasons <- list()
for (q in as.numeric(quantile(approx_errors$PctChange, probs = c(0, 0.5, 1), type = 1))) {
  seasons[[length(seasons) + 1]] <- approx_errors$season[approx_errors$PctChange == q]
}

# Multi-plot ----
for (s in seasons) {
  error_plots[[length(error_plots) + 1]] <- plot_approx_errors(s, approx_errors, gamma_hats)
}
wrap_plots(error_plots, ncol = 1)

# Single plots ----
plot_approx_errors(seasons[1], approx_errors, gamma_hats) # best
ggsave(glue('figures/approximation_error_plot_{seasons[1]}.png'))
plot_approx_errors(seasons[2], approx_errors, gamma_hats) # median
ggsave(glue('figures/approximation_error_plot_{seasons[2]}.png'))
plot_approx_errors(seasons[3], approx_errors, gamma_hats) # worst
ggsave(glue('figures/approximation_error_plot_{seasons[3]}.png'))
plot_approx_errors(2025, approx_errors, gamma_hats, tags = TRUE)
