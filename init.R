library(tidyverse)
library(rstan)
library(ggmcmc)

### I'll probably need (one of) these:
library(brms)   # especially this!
                # promised jetpack: use the usual r-syntax for lm()
# library(BayesFactor)  # this also has it's benefits; it's faster, for example
                        # but can't deal with mixed effects, so not helpful here

setwd("./Bayesian_Cognitive_Modeling/ParameterEstimation/")
theme_set(hrbrthemes::theme_modern_rc())

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)
