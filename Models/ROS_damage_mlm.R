library(tidyverse)
library(ggthemes)
library(DHARMa)
library(lme4)
library(emmeans)
theme_set(theme_linedraw() %+replace%
            theme(text = element_text(face = "bold", size = 15),
                  legend.background = element_rect(linewidth = 0.5, colour = "black"),
                  strip.background = element_rect(
                    color="black", fill="gray88", linewidth = 0.5),
                  strip.text.x = element_text (size = 11, color = "black"),
                  strip.text.y = element_text (size = 11, color = "black")))

options(contrasts = c("contr.sum", "contr.poly"), digits = 3)
df2 <- read.csv("TxS_final.csv") %>%
  filter(var_name %in% c("PCC", "TBARS")) %>%
  mutate(across(c(AT, AS, TT, genotype, var_name), as.factor)) %>%
  mutate(
    log_measure = log(var_measure),
    log_mass = log(mass))

m2_final <- lmer(
  log_measure ~ 0 + var_name + 
    var_name:(AT * AS) + 
    var_name:log_mass + 
    (1 | 0 + genotype:var_name),
  data = df2)

summary(m2_final)
anova(m2_final)

plot(simulateResiduals(m1_final))

em2 <- emmeans(m2_final, ~ AT * AS | var_name, type = "response")
em2

contrast(em2,  by = "var_name")

plotdf2 <- as.data.frame(confint(contrast(em2,  by = "var_name")))
ggplot(data = plotdf2, aes(x = contrast, y = estimate, group = var_name, colour = var_name)) +
  geom_point(aes(shape = var_name),
             position = position_dodge(width = 0.5), 
             size = 4) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL),
                position = position_dodge(width = 0.5),
                width = 0.3,
                linewidth = 0.75) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  scale_color_manual(values = c("darkorchid", "plum3","deepskyblue3")) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10))
