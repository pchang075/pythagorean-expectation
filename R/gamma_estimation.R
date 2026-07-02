library(ggplot2)
library(patchwork)

wl_data <- read.csv('data/wl_data.csv')

# Non-linear squares
nls_fit <- nls(
  formula = WinPct ~ R^gamma / (R^gamma + RA^gamma),
  data = wl_data,
  start = list(gamma = 2)
)

summary(nls_fit)
coef(nls_fit) + c(-1.96, 1.96)*summary(nls_fit)$parameters["gamma", "Std. Error"]
confint(nls_fit)
gamma_nls <- as.numeric(coef(nls_fit))
wl_data$nls_pred <- with(wl_data, R^gamma_nls / (R^gamma_nls + RA^gamma_nls))
wl_data$nls_resid <- wl_data$WinPct - wl_data$nls_pred



# Maximum likelihood
logL <- function(gamma, data) {
  p <- data$R^gamma / (data$R^gamma + data$RA^gamma)
  sum(
    dbinom(
      x = data$W,
      size = data$G,
      prob = p,
      log = TRUE
    )
  )
}

mle_fit <- optim(
  par = 2,
  fn = function(gamma) -logL(gamma, wl_data),
  method = 'L-BFGS-B',
  lower = 0,
  hessian = TRUE
)

mle_fit$par
mle_fit$par + c(-1.96, 1.96)*as.numeric(sqrt(solve(mle_fit$hessian)))
gamma_mle <- mle_fit$par
wl_data$mle_pred <- with(wl_data, R^gamma_mle / (R^gamma_mle + RA^gamma_mle))
wl_data$mle_resid <- wl_data$WinPct - wl_data$mle_pred

# Residual plots (save to /figures)
nls_resid_plot <- ggplot(wl_data, aes(x = nls_pred, y = nls_resid)) +
  geom_point() +
  geom_hline(yintercept = 0) +
  labs(
    title = 'NLS Residuals',
    x = 'Predicted Win Percentage',
    y = 'Residuals'
  )

mle_resid_plot <- ggplot(wl_data, aes(x = mle_pred, y = mle_resid)) +
  geom_point() +
  geom_hline(yintercept = 0) +
  labs(
    title = 'MLE Residuals',
    x = 'Predicted Win Percentage',
    y = 'Residuals'
  )

resid_plots <- nls_resid_plot + mle_resid_plot
resid_plots

ggsave('figures/gamma-estimation-residuals.png')
