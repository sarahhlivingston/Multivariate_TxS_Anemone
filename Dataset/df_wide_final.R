library(tidyverse)

df <- read.csv("TxS_final.csv")

perf_vars <- c("RMR", "CS", "ATPase")

df_perf_measures <- df %>%
  filter(va2r_name %in% perf_vars) %>%
  select(AT, AS, TT, genotype, var_name, var_measure) %>%
  pivot_wider(names_from = var_name, values_from = var_measure)

df_perf_masses <- df %>%
  filter(var_name %in% perf_vars) %>%
  select(AT, AS, TT, genotype, var_name, mass) %>%
  pivot_wider(names_from = var_name, values_from = mass, names_prefix = "mass_")

df_final <- left_join(df_perf_measures, df_perf_masses, by = c("AT", "AS", "TT", "genotype"))

saveRDS(df_final, file="df_wide_final.rds")
