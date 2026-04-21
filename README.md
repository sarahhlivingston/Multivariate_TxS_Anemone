# Exploring mechanisms of acclimation responses to thermal and saline stress in the cnidarian, _Nematostella vectensis_ 

## Background and study design 
Starlet sea anemones (_Nematostella vectensis_) are cnidarians endemic to estuarine environments along the Atlantic coast of North America. Across this broad latitudinal range, natural growth habitats vary drastically, particularly in terms of temperature, salinity, reactive oxidative species (ROS), and pollution. Using anemones collected from New Hampshire, USA, we aimed to explore the effects of interactions between thermal and saline stress, characterize their acclimation responses, and determine their capacity for plasticity. The anemones were acclimated using a two-factor design — warm and cold treatments at 16°C or 24°C, and high and low salinity treatments at 30‰ or 15‰ ASW. Leveraging the clonal nature of these anemones, 4 clones from 8 genotypes were used across the 4 treatment groups (genotype was treated as a random effect). After an acclimation period of 2 weeks, routine metabolic rates (RMRs), enzyme activities of citrate synthase (CS), which is a marker of mitochondrial activity, and the osmoregulatory activities of ATPases were measured acutely, both at their acclimation temperature and at the orthogonal temperature. Further, two markers of ROS damage, namely protein carbonyl content (PCC) and thiobarbituric acid reactive substances (TBARS), were also measured at the respective acclimation temperatures (these are endpoint measures). 

## Hypothesis and predictions
Hypothesis: Trade-offs in acclimation responses should be largely seen in metabolic and osmoregulatory pathways, as these are major energetic challenges faced by the anemones.
Predictions:
(1)	Routine metabolic rate and enzyme activities will increase with acute test temperature,
(2)	Cold-acclimated anemones will exhibit higher routine metabolic rates and enzyme activities than warm-acclimated anemones when measured at a common test temperature, consistent with compensatory thermal acclimation, and   
(3)	The magnitude of this acclimation response will differ between salinities, with acclimation effects expected to be strongest in the cold and high salinity-acclimated treatment.  

## Data description 
The datafile, `TxS_final.csv` contains all the data that has been collected so far in this project. 

This file includes columns on the acclimation and test conditions for each data point: acclimation temperature ('AT') in degrees Celsius, acclimation salinity ('AS') in parts per thousand (ppt), and test temperature ('TT') in degrees Celsius. 

The `genotype` column serves as an ID indicating which genotype the data point was collected from.

The column `mass` refers to the mass (in mg) of the sample used for the corresponding measurement.

The column `var_name` contains the variable name. This can be RMR, CS, PCC, ATPase or TBARS (so far). 

The `var_measure` column refers to the measured value of the variable. 

The `units` column refers to the units of the measured variable. 

Finally, the columns `day` and `plate` are variables specific to the RMR measures. As the names suggest, these variables refer to the day that the experiment was run on and the plate ID of the microplate used.

## Analysis and reproducibility
The data was analysed using a multivariate mixed model. Further details are included in the project report, found as "BIO-708_report.pdf"

The multivariate model containing RMR, CS and ATPase ("Multivariate_model.R") and the oxidative damage models ("ROS_damage_mlm.R") are both located in the `\Models` folder. The dataset used for these models is the `TxS_final.csv` within the `\Data` folder and can be used directly in both models.  
