17.03.26
1. Build model with fixed effects AT, AS, TT (and their interactions); genotype is a random effect; RMR, CS, ATPase, PCC, TBARS are responses.
2. Check model diagnostics, if okay, check summary 

20.03.26 - SV
1. I have changed the scale of all the variables to a log scale, and added code to melt the mass variables and measure variables together.

25.03.26 - SL
1. Multivariate model code in Dataset/ folder. The original dataset was used as it was already in the long format required by lme4. Since PCC and TBARS were only measured at TT, they were excluded from the model. The log values of the values and mass were applied to account for allometric scaling. 
  - Fixed Effects: `0+var_name` forces the model to calculate an intercept for each trait.
  `var_name:(AT * AS * TT)` calculates the three-way interaction of acclimation temperature, acclimation salinity, and test temperature for each trait.
    - The full model is technically `(0 + var_name:(AT*AS*TT)|genotype)` but too complicated for the amount of data. 
  `var_name:log_mass` for trait-specific mass scaling
  1Random Effect: `(1 | genotype:var_name)` 

2. The ATPase-only model was created since it has the highest response in the experiment, and from what was found in the model above. Two different versions were made: `m_atp_TT` measured only the interaction at the test temperatures, and `m__atp` included the cs version of the whole interaction, since it was very complicated.
   - `log_atp ~ AT * AS * TT + log_mass`: fixed effect for both models.
   - `(1 + TT | genotype)`: random effect for genotype at different test temperatures and with a random intercept
   - `cs(AT*AS*TT | genotype)`: Assumes a constant variance across all treatment combinations for each genotype

01/04/2026 - SL
1. Updated Multivariate_model.R script with diagnostic, inferential and prediction plots.
2. Updated library loading for plotting.

14/04/26 - SV
1. Added model for TBARS, PCC in "ROS_damage_mlm.R"
3. Tried to include (1 | 0 + day) as random effect to main model - this skewed results by a lot, I think this is because there's more resolution between days in RMR measures, but both CS and ATPase were done on a day each. I've chosen to exclude this random effect, can supplement manuscript with a small experiment showing variation in RMR measured across different days for the genotypes used - this is beyond the scope of this project though.
4. Edited Multivariate_model.R script with contrast plots
5. Maybe the CS diagnostics are odd in the first multivariate model because the CS values are also corrected to protein content and is thus smaller? It was also measured in "umol" change compared to ATPases, which are measured in "mmol".
