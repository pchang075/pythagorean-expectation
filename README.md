# Pythagorean Expectation

### Overview
This project explores the accuracy of expected win percentage models. The general form of the original Pythagorean expectation model introduced by Bill James is given by:

$$
E[W] = \frac{RS^\gamma}{RS^\gamma + RA^\gamma}
$$

where $E[W]$ is the expected win percentage, $RS$ is the number of runs scored by the team, $RA$ is the number of runs allowed by the team, and $\gamma$ is an estimated parameter. Other related models will also be explored, such as this linear model proposed by Michael Jones and Linda Tappin:

$$
E[W] = \frac{1}{2} + \beta(RS - RA)
$$

where $\beta$ is an estimated parameter that is related to $\gamma$. This relationship is shown in this form derived by Kevin Dayaratna and Steven Miller:

$$
E[W] = \frac{1}{2} + \frac{\gamma}{4R_{avg}}(RS - RA)
$$

where $R_{avg}$ is the average number of runs scored (or allowed) by the league. Dayaratna and Miller showed that Jones and Tappin's linear model is a first-order approximation of James' Pythagorean model.

### Research Questions
1. What is the optimal value of the parameter $\gamma$ for the 2006-2025 MLB seasons?
2. How does the optimized Pythagorean model compare with the first-order approximation?
3. How does the second-order approximation compare with the Pythagorean and first-order models?

### Data
The data from the 20 most recent complete MLB seasons (2006-2025) will be used. This time period was chosen because it represents the current era of MLB. The data are sourced from Sean Lahman's Baseball Database via the [Lahman](https://lahman.r-forge.r-project.org/doc/) R package.

### Current Status
Writing paper...