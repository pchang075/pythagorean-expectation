library(ggplot2)
library(patchwork)

# Function that plots the Pythagorean, first-order, and second-order curves in a single plot
#   Varies either gamma or R_avg, holding the other constant
draw_plot <- function (gamma_hat, R_avg) {
  gamma_hat = round(gamma_hat, 2)
  R_avg = round(R_avg, 2)
  
  # Create slice
  d <- seq(-2 * R_avg, 2 * R_avg, by = 1)
  slice <- data.frame(
    Diff = d, # R - RA
    R = R_avg + 0.5 * d,
    RA = R_avg - 0.5 * d
  )
  
  # Calculate models
  slice$pythag <- with(slice, R^gamma_hat / (R^gamma_hat + RA^gamma_hat))
  slice$first_order <- with(slice, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA))
  slice$second_order <- with(slice, 0.5 + (gamma_hat / (4 * R_avg)) * (R - RA) - (gamma_hat / (8 * R_avg^2)) * ((R - R_avg)^2 + (RA - R_avg)^2))
  
  head(slice)
  
  # Plot
  plot <- ggplot(slice, aes(x = Diff)) +
    geom_line(aes(y = pythag, color = 'Pythagorean')) +
    geom_line(aes(y = first_order, color = 'First-order')) +
    geom_line(aes(y = second_order, color = 'Second-order')) +
    scale_color_manual(
      values = c('Pythagorean' = 'black', 'First-order' = 'red', 'Second-order' = 'blue'),
      breaks = c('Pythagorean', 'First-order', 'Second-order')  
    ) +
    labs(
      x = "Run Differential (R - RA)",
      y = "Expected Win Percentage",
      title = bquote(hat(gamma) == .(gamma_hat) ~ ", " ~ R[avg] == .(R_avg)),
      color = "Model"
    )
  return(plot)
}

# Wrapper function that calls draw_curves()
plot_models <- function (param = 'gamma') {
  plots <- list()
  if (param == 'gamma') {
    R_avg <- median(read.csv('tables/first_order_model_params.csv')$R_avg)
    quartiles <- as.numeric(quantile(read.csv('tables/gamma_estimates.csv')$gamma_hat, probs = c(0, 0.25, 0.5, 0.75, 1), type = 1))
    
    for (gamma_hat in quartiles) {
      plots[[length(plots) + 1]] <- draw_plot(gamma_hat, R_avg)
    }
  } else if (param == 'R') {
    gamma_hat <- median(read.csv('tables/gamma_estimates.csv')$gamma_hat)
    quartiles <- as.numeric(quantile(read.csv('tables/first_order_model_params.csv')$R_avg, probs = c(0, 0.25, 0.5, 0.75, 1), type = 1))
    
    for (R_avg in quartiles) {
      plots[[length(plots) + 1]] <- draw_plot(gamma_hat, R_avg)
    }
  } else {
    stop("Argument for plot_models() must be 'gamma' or 'R_avg'")
  }
  return(plots)
}

# Plot models
# gamma_hat plots (spoiler: they all look the same) ----
gamma_plots <- plot_models('gamma')
wrap_plots(gamma_plots, ncol = 3) +
  plot_layout(guides = 'collect') &
  theme(
    legend.position = 'bottom', 
    plot.title = element_text(size = 10))

# R_avg plots (spoiler: ... yeah... they also all look the same) ----
R_plots <- plot_models('R')
wrap_plots(R_plots, ncol = 3) +
  plot_layout(guides = 'collect') &
  theme(
    legend.position = 'bottom', 
    plot.title = element_text(size = 10))

# Single plot(s) ----
draw_plot(gamma = 1.953, R_avg = 786.63)
draw_plot(gamma = 1.628915, R_avg = 720.4667) # 2025
ggsave('figures/model_comparison_plot.png')
