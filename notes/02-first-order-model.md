**Method**
  1. Recreate Dayaratna and Miller's (DM's) empirical analysis using data from the 2006-2025 seasons (fit a model for each season) 
  2. Compare results to DM's results 
    - Including whether the appropriate values of gamma are extracted 
  3. Compare the RMSE of the linear models to the RMSE of the Pythagorean models 
    - Add ExpWinPct (calculated using the Pythagorean model), RMSE_Pythag, RMSE_Linear, and RMSE_Change (%) columns to DM's table

**Results**
- Successfully recreated DM's analysis 
  - The accepted value of 1.82 falls inside the CI for each season except for 2010 and 2025
    - The former agrees with DM's results (2025 wasn't included in their data)
    - The accepted value fell in the CI for 2025 when using NLS with the Pythagorean model
  - Supports the expansion point of (R_avg, R_avg) (alpha_hat is approximately 0.5)