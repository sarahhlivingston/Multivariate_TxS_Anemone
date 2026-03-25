17.03.26
1. Build model with fixed effects AT, AS, TT (and their interactions); genotype is a random effect; RMR, CS, ATPase, PCC, TBARS are responses.
2. Check model diagnostics, if okay, check summary 

20.03.26 - SV
1. I have changed the scale of all the variables to a log scale, and added code to melt the mass variables and measure variables together.

25.03.26 - SL
1. Multivariate model code in Dataset/ folder. The original dataset was used as it was already in the long format required by lme4. Since PCC and TBARS were only measured at TT, they were excluded from the model. The log values of the values and mass were applied to account for allometric scaling. 
  Fixed Effects: `0+var_name` forces the model to calculate an intercept for each trait.
  `var_name:(AT * AS * TT)` calculates the three-way interaction of acclimation temperature, acclimation salinity, and test temperature for each trait.
    - The full model is technically ... but too complicated for the amount of data. 
  `var_name:log_mass` for trait-specific mass scaling
  Random Effect: `(1 | genotype:var_name)` 

2. The ATPase-only model was created since it has the highest response in the experiment, and from what was found in the model above. Two different versions were made. `m_atp_TT` only measured for interaction in the test temperatures and `m__atp` included the cs version of the whole interaction since it was very complicated.
   - `log_atp ~ AT * AS * TT + log_mass`: fixed effect for both models.
   - `(1 + TT | genotype)`: random effect for genotype at different test temperatures and with a random intercept
   - `cs(AT*AS*TT | genotype)`: Assumes a constant variance across all treatment combinations for each genotype
