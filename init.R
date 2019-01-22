library(tidyverse)
library(rstan)
library(ggmcmc)

setwd("./Bayesian_Cognitive_Modeling/ParameterEstimation/")
theme_set(hrbrthemes::theme_ipsum_rc())

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)
