# Pythagorean Expectation

## Overview
This project explores the accuracy of expected win percentage models. The general form of the original Pythagorean Expectation model introduced by Bill James is given by:

$$\text{Win}\% = \frac{RS^\gamma}{RS^\gamma + RA^\gamma}$$

where RS is the number of runs scored by the team, RA is the number of runs allowed by the team, and $\gamma$ is an estimated parameter. Other related models will also be explored, such as this linear model proposed by Michael Jones and Linda Tappin:

$$\text{Win}\% = \frac{1}{2} + \beta(RS - RA)$$

where $\beta$ is an estimated parameter that is related to $\gamma$. This relationship is shown in this form derived by Kevin Dayaratna and Steven Miller:

$$\text{Win}\% = \frac{1}{2} + \frac{\gamma}{4\bar{R}}(RS - RA)$$

where $\bar{R}$ is the average number of runs scored by the league. Dayaratna and Miller showed that Jones and Tappin's linear model is a first-order approximation of James' Pythagorean Expectation model.

### Research Questions
1. What is the optimal value of the parameter $\gamma$ for the 2005-2025 MLB seasons?
2. How does the optimized Pythagorean Expectation model compare with Jones and Tappin's linear model?
3. How do higher order approximations compare with both models?

### Data
The data used for this project is sourced from Sean Lahman's Baseball Database via the [Lahman](https://lahman.r-forge.r-project.org/doc/) R package.

## Current Status
Finding the optimal value of the parameter $\gamma$ in James' original model for the 2005-2025 MLB seasons.