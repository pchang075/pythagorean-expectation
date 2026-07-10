library(dplyr)

wl_data <- read.csv('data/wl_data.csv')
R_avg <- mean(wl_data$R)
gamma <- 1.776348

# Second-order model
model <- lm(
  formula = I(WinPct - 0.5) ~ 0 + I(R - RA) + I(-((R - R_avg)^2 + (RA - R_avg)^2)),
  data = wl_data
)
summary(model) # β2 is not different from 0 (Pr(>|t|) = 0.931)
gamma1 <- 4*R_avg*as.numeric(coef(model)[1])
gamma2 <- 8*R_avg^2*as.numeric(coef(model)[2])
paste(gamma1, gamma2)

# Theoretical second-order model (using calculated expected win percentage with γ = 1.776348)
wl_data$ExpWinPct <- wl_data$R^gamma / (wl_data$R^gamma + wl_data$RA^gamma)
theo_fit <- lm(
  formula = I(WinPct - 0.5) ~ 0 + I(R - RA) + I(-((R - R_avg)^2 + (RA - R_avg)^2)),
  data = wl_data
)
summary(theo_fit)
theo_gamma1 <- 4*R_avg*as.numeric(coef(theo_fit)[1]) 
theo_gamma2 <- 8*R_avg^2*as.numeric(coef(theo_fit)[2])
paste(theo_gamma1, theo_gamma2) # same as for the model on the observed data

# Model with only the constant and quadratic terms
simple_fit <-lm(
  formula = I(WinPct - 0.5) ~ 0 + I(-((R - R_avg)^2 + (RA - R_avg)^2)),
  data = wl_data
)
summary(simple_fit)
simple_gamma <- 8*R_avg^2*as.numeric(coef(simple_fit)) 
simple_gamma # still doesn't agree with the estimated value of γ

# Constrained second-order model (fit a single γ)
gamma_fit <- lm(
  formula = I(WinPct - 0.5) ~ 0 + I((R - RA)/(4*R_avg) - ((R - R_avg)^2 + (RA - R_avg)^2)/(8*R_avg^2)),
  data = wl_data
)
summary(gamma_fit) # closer to γ = 1.78 but still not quite (in between 1.78 and 0)

# Restricted second-order model (only teams near the expansion point a.k.a. league average)
restricted_fit <- lm(
  formula = I(WinPct - 0.5) ~ 0 + I(R - RA) + I(-((R - R_avg)^2 + (RA - R_avg)^2)),
  data = wl_data %>% 
    filter(abs(R - R_avg) < 100 & abs(RA - R_avg) < 100)
)
summary(restricted_fit) 
restricted_gamma1 <- 4*R_avg*as.numeric(coef(restricted_fit)[1])
restricted_gamma2 <- 8*R_avg^2*as.numeric(coef(restricted_fit)[2]) 
paste(restricted_gamma1, restricted_gamma2)

# Theoretical model (with γ = 1.776348) for RMSE comparison
wl_data$pred <- 0.5 + (gamma / (4*R_avg))*(wl_data$R - wl_data$RA) - (gamma / (8*R_avg^2))*((wl_data$R - R_avg)^2 + (wl_data$RA - R_avg)^2)
wl_data$resid <- wl_data$WinPct - wl_data$pred
pythag_rmse <- 0.0254709505732679
linear_rmse <- 0.0282604007789553
second_rmse <- sqrt(mean(wl_data$resid^2))
second_rmse
100*((second_rmse - pythag_rmse) / pythag_rmse) # RMSE increase compared to the Pythagorean model
100*((second_rmse - linear_rmse) / linear_rmse) # RMSE increase compared to the linear model

wl_data$pred_f <- 0.5 + (gamma / (4*R_avg))*(wl_data$R - wl_data$RA)
second_rmse_theo <- sqrt(mean((wl_data$ExpWinPct - wl_data$pred)^2))
linear_rmse_theo <- sqrt(mean((wl_data$ExpWinPct - wl_data$pred_f)^2))
paste(second_rmse_theo, linear_rmse_theo)

### Repeat without 2020 data ###
wl_data <- read.csv('data/wl_data.csv') %>% filter(yearID != 2020)
R_avg <- mean(wl_data$R)
gamma <- 1.77040

# Second-order model
model <- lm(
  formula = I(WinPct - 0.5) ~ 0 + I(R - RA) + I(-((R - R_avg)^2 - (RA - R_avg)^2)),
  data = wl_data
)
summary(model) # β2 is not different from 0 (Pr(>|t|) = 0.931)
gamma1 <- 4*R_avg*as.numeric(coef(model)[1])
gamma2 <- 8*R_avg^2*as.numeric(coef(model)[2])
paste(gamma1, gamma2)

# Theoretical second-order model (using calculated expected win percentage with γ = 1.776348)
wl_data$ExpWinPct <- wl_data$R^gamma / (wl_data$R^gamma + wl_data$RA^gamma)
theo_fit <- lm(
  formula = I(ExpWinPct - 0.5) ~ 0 + I(R - RA) + I(-((R - R_avg)^2 + (RA - R_avg)^2)),
  data = wl_data
)
summary(theo_fit)
theo_gamma1 <- 4*R_avg*as.numeric(coef(theo_fit)[1])
theo_gamma2 <- 8*R_avg^2*as.numeric(coef(theo_fit)[2]) 
paste(theo_gamma1, theo_gamma2) # NOT the same as for the model on the observed data (without 2020 data)

# Model with only the constant and quadratic terms
simple_fit <-lm(
  formula = I(WinPct - 0.5) ~ 0 + I(-((R - R_avg)^2 + (RA - R_avg)^2)),
  data = wl_data
)
summary(simple_fit)
simple_gamma <- 8*R_avg^2*as.numeric(coef(simple_fit)) 
simple_gamma # still doesn't agree with the estimated value of γ

# Constrained second-order model (fit a single γ)
gamma_fit <- lm(
  formula = I(WinPct - 0.5) ~ 0 + I((R - RA)/(4*R_avg) - ((R - R_avg)^2 + (RA - R_avg)^2)/(8*R_avg^2)),
  data = wl_data
)
summary(gamma_fit) # closer to γ = 1.78 but still not quite (in between 1.78 and 0)

# Restricted second-order model (only teams near the expansion point a.k.a. league average)
restricted_fit <- lm(
  formula = I(WinPct - 0.5) ~ 0 + I(R - RA) + I(-((R - R_avg)^2 + (RA - R_avg)^2)),
  data = wl_data %>% 
    filter(abs(R - R_avg) < 100 & abs(RA - R_avg) < 100)
)
summary(restricted_fit) 
restricted_gamma1 <- 4*R_avg*as.numeric(coef(restricted_fit)[1])
restricted_gamma2 <- 8*R_avg^2*as.numeric(coef(restricted_fit)[2]) 
paste(restricted_gamma1, restricted_gamma2)

# Theoretical model (with γ = 1.776348) for RMSE comparison
wl_data$pred <- 0.5 + (gamma / (4*R_avg))*(wl_data$R - wl_data$RA) - (gamma / (8*R_avg^2))*((wl_data$R - R_avg)^2 + (wl_data$RA - R_avg)^2)
wl_data$resid <- wl_data$WinPct - wl_data$pred
pythag_rmse <- 0.0254709505732679
linear_rmse <- 0.0282604007789553
second_rmse <- sqrt(mean(wl_data$resid^2))
second_rmse
100*((second_rmse - pythag_rmse) / pythag_rmse) # RMSE increase compared to the Pythagorean model
100*((second_rmse - linear_rmse) / linear_rmse) # RMSE DECREASED compared to the linear model

wl_data$pred_f <- 0.5 + (gamma / (4*R_avg))*(wl_data$R - wl_data$RA)
second_rmse_theo <- sqrt(mean((wl_data$ExpWinPct - wl_data$pred)^2))
linear_rmse_theo <- sqrt(mean((wl_data$ExpWinPct - wl_data$pred_f)^2))
paste(second_rmse_theo, linear_rmse_theo)

### ESTIMATE FOR SEPARATE SEASONS ###