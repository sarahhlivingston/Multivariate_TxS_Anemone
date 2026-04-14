library(tidyverse)
library(emmeans)
library(lme4)
library(broom.mixed)
library(dotwhisker)
library(ggthemes)
library(DHARMa)
theme_set(theme_linedraw() %+replace%
            theme(text = element_text(face = "bold", size = 15),
                  legend.background = element_rect(linewidth = 0.5, colour = "black"),
                  strip.background = element_rect(
                    color="black", fill="gray88", linewidth = 0.5),
                  strip.text.x = element_text (size = 11, color = "black"),
                  strip.text.y = element_text (size = 11, color = "black")))

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
    (1 | 0 + genotype:var_name), 
  data = df1
)

summary(m1_final)
anova(m1_final)

############################
#        Diagnostics 
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
                   
# check random effects (genotype:var_name)
lattice::dotplot(ranef(m1_final))
                   
############################
#  emmeans and contrasts
############################

# 3-way interaction emmeans
ems_df <- emmeans(m1_final, ~ AT * TT * AS| var_name, type = "response") %>%
  as.data.frame()
plot(ems_df) 

#contrasts
contrast(ems_means,  by = "var_name")
df_contrasts <- as.data.frame(confint(contrast(ems_means,  by = "var_name")))
                   
#emmeans plot as line graph
ggplot(ems_df, aes(x = as.factor(TT), 
                     y = if("response" %in% names(ems_df)) response else emmean, 
                     color = as.factor(AT), 
                     group = AT)) +
  geom_line(linewidth = 1) +
  geom_point(position = position_dodge(width = 0.2), 
             size = 4) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), 
                position = position_dodge(width = 0.2),
                width = 0.3, linewidth = 0.75) +
  facet_grid(var_name ~ AS, scales = "free_y", 
             labeller = labeller(AS = c("15" = "Salinity: 15 ppt", 
                                        "30" = "Salinity: 30 ppt"))) +
  scale_color_manual(values = c("16" = "#377eb8", "24" = "#e41a1c")) +
  labs(
    x = "Test Temperature (°C)",
    y = "Predicted Trait Value (Log Scale)",
    color = "Acclimation Temperature (°C)") +
  theme(legend.position = "bottom")

#contrast plot
ggplot(data = df_contrasts, aes(x = contrast, y = estimate, group = var_name, colour = var_name)) +
  geom_point(aes(shape = var_name),
             position = position_dodge(width = 0.5), 
             size = 4) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL),
                position = position_dodge(width = 0.5),
                width = 0.3, linewidth = 0.75) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  scale_color_manual(values = c("darkorchid", "plum3","deepskyblue3")) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10))
                   
