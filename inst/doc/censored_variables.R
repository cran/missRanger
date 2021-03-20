## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## -----------------------------------------------------------------------------
library(missRanger)
library(survival)
library(mice)
set.seed(65)

head(veteran)

# 1. Calculate Nelson-Aalen survival probabilities for each time point
nelson_aalen <- summary(
  survfit(Surv(time, status) ~ 1, data = veteran), 
  times = unique(veteran$time)
)[c("time", "surv")]
nelson_aalen <- data.frame(nelson_aalen)

# Add it to the original data set
veteran2 <- merge(veteran, nelson_aalen, all.x = TRUE)

# Add missing values to make things tricky
veteran2 <- generateNA(veteran2, p = c(age = 0.1, karno = 0.1, diagtime = 0.1))

# 2. Generate 20 complete data sets, representing "time" and "status" by "surv"
filled <- replicate(20, missRanger(veteran2, . ~ . - time - status, 
  verbose = 0, pmm.k = 3, num.trees = 25), simplify = FALSE)

# 3. Run a Cox regression for each of the completed data sets
models <- lapply(filled, function(x) coxph(Surv(time, status) ~ . - surv, x))

# 4. Pool the results by mice
summary(pooled_fit <- pool(models))

# On the original
summary(coxph(Surv(time, status) ~ ., veteran))$coefficients


