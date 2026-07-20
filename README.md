# Pythagorean Expectation

### Overview
This project explores the Pythagorean expectation model and other related models. The general form of the Pythagorean expectation model is:

$$
E[W] = \frac{RS^\gamma}{RS^\gamma + RA^\gamma}
$$

where $E[W]$ is a team's expected win percentage, $RS$ is the number of runs scored by the team, $RA$ is the number of runs allowed by the team, and $\gamma$ is an estimated parameter.

### Data
The data used for this project are sourced from Sean Lahman's Baseball Database via the [Lahman](https://lahman.r-forge.r-project.org/doc/) R package.

### Research Questions
1. How does the second-order Taylor approximation of the Pythagorean expectation model compare with the first-order approximation?
2. Does the third-order Taylor approximation perform better than the second-order approximation?

### Results (see papers/ for more information)
1. The second-order approximation is inferior to the first-order approximation in both explaining real MLB data and approximating the Pythagorean expectation model.<br>

### Current Status
Finished writing *An Analysis of the Second-Order Taylor Approximation of the Pythagorean Expectation Win-Loss Model* (see papers/).
