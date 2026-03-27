library(tidyverse)
library(emmeans)
library(lme4)

options(contrasts = c("contr.sum", "contr.poly"), digits = 3)

df1 <- read.csv("TxS_final.csv") %>%
  filter(var_name %in% c("RMR", "CS", "ATPase")) %>%
  mutate(across(c(AT, AS, TT, genotype, var_name), as.factor)) %>%
  mutate(
    log_measure = log(var_measure),
    log_mass = log(mass)
  )

m1_final <- lmer(
  log_measure ~ 0 + var_name + 
    var_name:(AT * AS * TT) + 
    var_name:log_mass + 
    (1 | genotype:var_name), 
  data = df1
)

summary(m1_final)
anova(m1_final)

ems_means <- emmeans(m1_final, ~ AT * TT | var_name, type = "response")
ems_means

contrast(ems_means, interaction = c("pairwise", "pairwise"), by = "var_name")

