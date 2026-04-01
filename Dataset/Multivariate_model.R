library(tidyverse)
library(emmeans)
library(lme4)
library(broom.mixed)
library(dotwhisker)
library(dplyr)
library(tidyr)
library(ggplot2)
library(DHARMa)

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

############################
#        Plotting
############################

#Diagnostic plots
qqnorm(residuals(m1_final))
plot(simulateResiduals(m1_final))

#Full dw-plot
full <- tidy(m1_final, conf.int=TRUE, conf.method="profile")
dwplot(full) +
  scale_y_discrete(labels = function(x) gsub("var_name", "", x)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  theme_bw()

#faceted dw-plot
  #coefficients for fixed effects
cc1_clean <- tidy(m1_final, effect = "fixed") %>%
  mutate(model = "Joint_Model") %>% 
  separate(term, into = c("trait", "fixeff"), sep = ":", 
           extra = "merge", fill = "left", remove = FALSE) %>%
  mutate(
    trait = gsub("var_name", "", trait),
    fixeff = ifelse(is.na(fixeff), "Baseline_Intercept", fixeff),
    term = trait
  )
dwplot(cc1_clean) +
  facet_wrap(~fixeff, scales = "free", ncol = 3) +
  aes(color = trait) +
  geom_vline(xintercept = 0, linetype = "dashed", alpha = 0.5) +
  theme_bw() +
  theme(
    axis.text.y = element_text(size = 9),
    strip.text = element_text(face = "bold", size = 10),
    legend.position = "bottom"
  ) 

# 3-way interaction emmeans
ems_df <- emmeans(m1_final, ~ AT * TT * AS| var_name, type = "response") %>%
  as.data.frame()
plot(ems_df) #normal emmeans plot

#emmeans plot as line graph
ggplot(ems_df, aes(x = as.factor(TT), 
                     y = if("response" %in% names(ems_df)) response else emmean, 
                     color = as.factor(AT), 
                     group = AT)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), width = 0.1, linewidth = 0.8) +
  
  facet_grid(var_name ~ AS, scales = "free_y", 
             labeller = labeller(AS = c("15" = "Salinity: 15 ppt", 
                                        "30" = "Salinity: 30 ppt"))) +
  theme_bw() +
  scale_color_manual(values = c("16" = "#377eb8", "24" = "#e41a1c")) +
  labs(
    x = "Test Temperature (°C)",
    y = "Predicted Trait Value (Log Scale)",
    color = "Acclimation Temperature (°C)"
  ) +
  theme(
    strip.text = element_text(face = "bold", size = 11),
    strip.background = element_rect(fill = "#f0f0f0"),
    legend.position = "bottom"
  )

# check random effects (genotype:var_name)
lattice::dotplot(ranef(m1_final))


#Effects of salinity
sal_means <- emmeans(m1_final, ~ AS | var_name)
pairs(sal_means)
plot(sal_means)
