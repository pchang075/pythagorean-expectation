**Methods**
- Second-order Taylor expansion: 
  $f(x, y) \approx f(a, b) + f_x(a, b)(x - a) + f_y(a, b)(y - b) + \frac{1}{2}[f_{xx}(a, b)(x - a)^2 + 2f_{xy}(a, b)(x - a)(y - b) + f_{yy}(a, b)(y - b)^2$
- Second-order partial derivatives of the Pythagorean expectation formula:
  - $f_{xx}(x, y) = \frac{\gamma x^{\gamma - 2}y^\gamma[(\gamma - 1)y^\gamma - (\gamma + 1)x^\gamma]}{(x^\gamma + y^\gamma)^3}$
  - $f_{yy}(x, y) = \frac{\gamma x^\gamma y^{\gamma - 2}[(\gamma - 1)x^\gamma - (\gamma + 1)y^\gamma]}{(x^\gamma + y^\gamma)^3}$
  - $f_{xy}(x, y) = \frac{\gamma^2 x^{\gamma - 1}y^{\gamma - 1}(x^\gamma - y^\gamma)}{(x^\gamma + y^\gamma)^3}$
    
**Results**
- Second-order partial derivatives evaluated at $(a, b) = (\bar{R}, \bar{R})$, where $\bar{R}$ = the average number of runs scored in the league:
  - $f_{xx}(\bar{R}, \bar{R}) = -\frac{\gamma}{4\bar{R}^2}$
  - $f_{yy}(\bar{R}, \bar{R}) = -\frac{\gamma}{4\bar{R}^2}$
  - $f_{xy}(\bar{R}, \bar{R}) = 0$
- Full second-order Taylor expansion of the Pythagorean expectation formula: 
  $E[W] = \frac{1}{2} + \frac{\gamma}{4\bar{R}}(RS - RA) - \frac{\gamma}{8\bar{R}^2}[(RS - \bar{R})^2 + (RA - \bar{R})^2]$
- With 2020 data:
  - Estimates: $\gamma_1$ = 1.709610 and $\gamma_2$ = -0.004721
    - NLS would give the same results (same problem, different method)
  - Fitting a model with only the constant and quadratic terms results in $\beta$ = 1.387e-08 for the quadratic term
    - The magnitude of the coefficient is near zero: The quadratic term has little effect on win percentage
  - Restricted $\gamma$'s:
    - Deviations < 100: $\gamma_1$ =  1.71, $\gamma_2$ =   -0.98 (p-values: <2e-16,    0.216)
    - Deviations <  50: $\gamma_1$ =  1.64, $\gamma_2$ =   -9.93 (p-values:  6.39e-15, 0.0793)
    - Deviations <  25: $\gamma_1$ =  1.37, $\gamma_2$ =   47.14 (p-values:  0.0221,   0.1504)
    - Deviations <  10: $\gamma_1$ =  7.76, $\gamma_2$ = -306.34 (p-values:  0.209,    0.634)
    - Deviations <   7: $\gamma_1$ = -8.68, $\gamma_2$ =      NA (1 data point)
  - RMSE: 0.04745585
    - 86.31% greater than for the Pythagorean model
    - 67.92% greater than for the first-order model
- Without 2020 data:
   - Estimates: $\gamma_1$ = 1.7476250407443 and $\gamma_2$ = 0.826699626397206
   - RMSE: 0.02598408
    - 2.01% greater than for the Pythagorean model
    - 8.05% LESS than for the first-order model

**Discussion**
- Second-order term is always negative ($(RS - \bar{R})^2 + (RA - \bar{R})^2 \geq 0$)
  - Second-order approximation will always be less than or equal to the first-order approximation
- The second-order term depends on the sum of the squared deviations of RS and RA from the league average
  - Magnitude increases quadratically with distance from league average 
- No interaction term: Offensive and defensive deviations from the league average contribute independently
- $\bar{R}^2 \gg \gamma$: The second-order term is largely inconsequential (very small)

**Follow-up**
- Explore why having $(R - \bar{R})^2 - (RA - \bar{R}^2)$ seems to be a better model than even the Pythagorean formula
- Run on simulated data