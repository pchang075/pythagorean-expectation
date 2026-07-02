**Methods**
- Non-linear squares
  - The Pythagorean expectation formula is non-linear
  - Easy to implement
- Maximum Likelihood Estimation
  - Wins (for each team) follow a Binomial distribution where n = the number of games and p is Pythagorean expectation
  - Wins are approximately independent
    - The outcome of a game doesn't directly impact the outcome of another game
    - Factors such as injuries, fatigue, etc. can be ignored when considering full seasons
  - Minimized negative log-likelihood
   
**Results**
- NLS: $\gamma$ = 1.776348
  - SE: 0.02549
  - 95% confidence interval: (1.722681, 1.830015)
  - 95% profile confidence interval: (1.722653, 1.830214)
    - Better estimate
- MLE: $\gamma$ = 1.772128
  - SE: 0.04196501 (estimated by taking the square root of the inverse of the Hessian)
    - The Hessian estimates the Fisher information
  - 95% confidence interval: (1.689876, 1.854379)

**Discussion**
- The values for both methods are basically identical
- Accepted value: $\gamma$ = 1.83
  - Falls just inside the upper bound of both NLS CIs
  - Falls inside the MLE CI (also towards upper bound)
  - Bill James' original value of 2 does not fall within either CI
- Residual plots look good

**Next Steps**
- Use the NLS estimate for comparing the Pythagorean model to the linear model (will use method of least squares)
- Estimate $\gamma$ for each season from 2006-2025?