library(tidyverse)
library(reshape2)
library(corrplot)
library(Matrix)
library(emmeans)

df1 <- read.csv("TxS_final.csv") |>
  filter(!var_name %in% c("PCC", "TBARS")) |>
  mutate(across(c(AT,AS,TT), factor))

library(lmerTest)

## if we're fitting a very complicated model we might
## need to override some warnings
## control <- lmerControl(check.nobs.vs.nRE = "ignore")

m0 <- lmer(var_measure ~ 0 + var_name:(AT*AS*TT) +
             (0+var_name|genotype),
           ##             (0 + var_name:(AT*AS*TT)|genotype),
           data = df1)

## make diagonal
m1 <- update(m0, . ~ . - (0+var_name|genotype) +
                   diag(0+var_name|genotype))

## could ?? try to look only at ATPase * treatment variation
## across genotypes (maybe with a separate model??)
## * select only ATPase responses
## var_measure ~ AT*AS*TT + (AT*AS*TT|genotype)
## if that's too complicated, try cs() or diag() to simplify ...




VarCorr(m1)

## extract the covariance matrix for genotype effects
## and convert to a correlation matrix
cc <- cov2cor(VarCorr(m1)$genotype)

corrplot.mixed(cc, lower = "ellipse", upper = "number")

image(Matrix(
heatmap()


