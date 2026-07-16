**Methods**
  1. Derive the second-order Taylor expansion of the Pythagorean model 
  2. Fit the second-order model to each season to see whether the values of gamma can be extracted
  3. Compare the RMSE of the second-order models to the RMSE of the linear and Pythagorean models (observed)
  4. Define the (theoretical) second-order models for each season using the gamma values from **Gamma Estimation**
  5. Compare the theoretical RMSE of the second-order models to the theoretical RMSE of the linear models<br>
    - Shows the accuracy of the approximations to the Pythagorean model
    
**Results**
- Second-order Taylor expansion: 
  $f(x, y) \approx f(a, b) + f_x(a, b)(x - a) + f_y(a, b)(y - b) + \frac{1}{2}[f_{xx}(a, b)(x - a)^2 + 2f_{xy}(a, b)(x - a)(y - b) + f_{yy}(a, b)(y - b)^2$
- Second-order partial derivatives of the Pythagorean expectation formula:
  - $f_{xx}(x, y) = \frac{\gamma x^{\gamma - 2}y^\gamma[(\gamma - 1)y^\gamma - (\gamma + 1)x^\gamma]}{(x^\gamma + y^\gamma)^3}$
  - $f_{yy}(x, y) = \frac{\gamma x^\gamma y^{\gamma - 2}[(\gamma - 1)x^\gamma - (\gamma + 1)y^\gamma]}{(x^\gamma + y^\gamma)^3}$
  - $f_{xy}(x, y) = \frac{\gamma^2 x^{\gamma - 1}y^{\gamma - 1}(x^\gamma - y^\gamma)}{(x^\gamma + y^\gamma)^3}$
- Second-order partial derivatives evaluated at $(a, b) = (R_{avg}, R_{avg})$, where $R_{avg}$ = the average number of runs scored in the league:
  - $f_{xx}(R_{avg}, R_{avg}) = -\frac{\gamma}{4R_{avg}^2}$
  - $f_{yy}(R_{avg}, R_{avg}) = -\frac{\gamma}{4R_{avg}^2}$
  - $f_{xy}(R_{avg}, R_{avg}) = 0$
- Full second-order Taylor expansion of the Pythagorean expectation formula: 
  $E[W] = \frac{1}{2} + \frac{\gamma}{4R_{avg}}(RS - RA) - \frac{\gamma}{8R_{avg}^2}[(RS - R_{avg})^2 + (RA - R_{avg})^2]$
- Fit on observed data:
  - The coefficient for the second-order term is not significant
    - Unable to extract the correct value of gamma2
- Theoretical comparison:
  - The RMSE for the theoretical second-order model is considerably higher than that of the theoretical first-order model
  - The residuals for the second-order model increase at a much higher rate than that of the first-order model with distance from the expansion point
- From the model plot:
  - The error for the first-order model balances out because it underestimates for R < RA and overestimates for R > RA
  - The second-order model consistently underestimates (especially bad for R < RA)

**Follow-up**
- Explore why having $(R - R_{avg})^2 - (RA - R_{avg}^2)$ seems to result in a better model than even the Pythagorean formula
- Look into Pythagenport and Pythagenpat