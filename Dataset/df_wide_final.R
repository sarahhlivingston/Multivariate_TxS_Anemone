library(tidyverse)
library(reshape2)

df1 <- read.csv("TxS_final.csv")

perf_vars <- c("RMR", "CS", "ATPase")
perf_vars_mass <- paste0("mass_", perf_vars)

df_perf_measures <- df1
  |> filter(var_name %in% perf_vars) 
  |>  select(AT, AS, TT, genotype, var_name, var_measure) 
  |> pivot_wider(names_from = var_name, values_from = var_measure)

df_perf_masses <- (df1 
  |> filter(var_name %in% perf_vars)
  |> select(AT, AS, TT, genotype, var_name, mass) 
  |> pivot_wider(names_from = var_name, values_from = mass, names_prefix = "mass_")
)

df_final <- left_join(df_perf_measures, df_perf_masses, by = c("AT", "AS", "TT", "genotype"))

df_final<- (df_final
             |> mutate(across(c(perf_vars,perf_vars_mass), log))
)

df1_melt <- melt(df_final, id.vars = c("AT","AS","TT","genotype"), 
                 measure.vars = c(perf_vars,perf_vars_mass),
                 variable.name = "measure")

saveRDS(df1_melt, file="df_wide_final.rds")
