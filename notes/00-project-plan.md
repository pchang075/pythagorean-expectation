**Gamma Estimation** 
  1. Load data from the 2006-2025 seasons 
  2. Estimate gamma for the entire period 
  3. Estimate gamma for each individual season 
  4. Compare individual gammas to the accepted value of gamma (1.82)

**First-Order (Linear) Model Comparison** 
  1. Recreate Dayaratna and Miller's (DM's) empirical analysis using data from the 2006-2025 seasons (fit a model for each season) 
  2. Compare results to DM's results 
    - Including whether the appropriate values of gamma are extracted 
  3. Compare the RMSE of the linear models to the RMSE of the Pythagorean models 
    - Add ExpWinPct (calculated using the Pythagorean model), RMSE_Pythag, RMSE_Linear, and RMSE_Change (%) columns to DM's table

**Second-Order Model Comparison** 
  1. Derive the second-order Taylor expansion of the Pythagorean model 
  2. Fit the second-order model to each season to see whether the values of gamma can be extracted 
   *If gamma1 and gamma2 are not equal (highly likely according to experience)...* 
    2a. Define the second-order models for each season using the gamma values from **Gamma Estimation** 
  3. Compare the RMSE of the second-order models to the RMSE of the linear and Pythagorean models
  4. Compare the theoretical RMSE of the second-order models to the theoretical RMSE of the linear model
