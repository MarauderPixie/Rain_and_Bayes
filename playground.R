eval_fc  <- readRDS("data/eval_fc.rds")
eval_sky <- readRDS("data/eval_sky.rds")
rab_fin  <- readRDS("data/RaB_final.rds")
rab_mod  <- readRDS("data/RaB_Modulation_final.rds")
rab_raw  <- readRDS("data/BA_behav.rds")

rab <- rab_fin %>% 
  mutate(
    ID       = factor(ID),
    Gruppe   = as.character(Gruppe),
    Gruppe   = dplyr::recode_factor(Gruppe, `LL` = "A_ll", `ML` = "B_ml",
                                    `MM` = "C_mm", `MH` = "D_mh", `HH` = "E_hh",
                                    .ordered = FALSE),
    Decision = ifelse(Decision == "Schirm", 1, 0)
  ) %>% 
  group_by(ID, Run, Gruppe) %>% 
  summarise(
    PI = mean(Decision),
    RT = median(TTime)
  ) %>% 
  ungroup()


# Unfug:
# rt_fit <- brm(TTime ~ ID * Run + (1 || ID + Feedback), rab_fin)

pi_fit1 <- brm(PI ~ ID * Run + (1 + ID|| Gruppe), data = rab)
saveRDS(pi_fit1, "stanfits/pi_fit_alt.rds") # currently not converging well

pi_fit_max <- brm(PI ~ Run * Gruppe + (1 + Run + Gruppe || ID), data = rab)
saveRDS(pi_fit_max, "stanfits/pi_fit_max.rds")



rt_fit_max <- brm(RT ~ Run * Gruppe + (1 + Run * Gruppe || ID), data = rab)
saveRDS(rt_fit_max, "stanfits/pi_fit_max.rds")

## output of:
# > kfold(rt_fit_max, k = 10)
# 
# >   Based on 10-fold cross-validation
# >   
# >   Estimate   SE
# >   elpd_kfold  -1243.8 17.3
# >   p_kfold          NA   NA
# >   kfoldic      2487.5 34.7
#
# so basically... the model sucks. x)

pi_fixed <- brm(PI ~ Run * Condition + (1|ID), prior = c(set_prior("normal(0,1)")), data = rab)
# saveRDS(pi_fixed, "stanfits/pi_fixed.rds")
pi_fixed <- readRDS("stanfits/pi_fixed.rds")

pi_rnd_runs <- brm(PI ~ Run * Condition + (1 + Run || ID), data = rab)
pi_rnd_cond <- brm(PI ~ Run * Condition + (1 + Condition || ID), data = rab)
pi_rnd_both <- brm(PI ~ Run * Condition + (1 + Condition * Run || ID), data = rab)

# saveRDS(pi_rnd_runs, "stanfits/pi_random_runs.rds")
# saveRDS(pi_rnd_cond, "stanfits/pi_random_conditions.rds")
# saveRDS(pi_rnd_both, "stanfits/pi_random_both.rds")

pi_rnd_runs <- readRDS("stanfits/pi_random_runs.rds")
pi_rnd_cond <- readRDS("stanfits/pi_random_conditions.rds")
pi_rnd_both <- readRDS("stanfits/pi_random_both.rds")