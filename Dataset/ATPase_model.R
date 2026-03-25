
library(tidyverse)
library(emmeans)
library(lme4)

df1 <- read.csv("TxS_final.csv") 
df_atp_only <- df1 %>%
  filter(var_name == "ATPase") %>%
  mutate(across(c(AT, AS, TT, genotype), as.factor)) %>%
  mutate(log_atp = log(var_measure), log_mass = log(mass))


m_atp_TT <- lmer(log_atp ~ AT * AS * TT + log_mass + 
    (1 + TT | genotype), 
  data = df_atp_only)

m_atp <- lmer(log_atp ~ AT*AS*TT + log_mass + 
                cs(AT*AS*TT | genotype), 
              data = df_atp_only)
summary(m_atp)
summary(m_atp_TT)



