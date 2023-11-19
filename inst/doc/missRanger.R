## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## -----------------------------------------------------------------------------
library(missRanger)

set.seed(84553)

head(iris)

# Generate data with missing values in all columns
irisWithNA <- generateNA(iris, p = 0.2)
head(irisWithNA)
 
# Impute missing values with missRanger
irisImputed <- missRanger(irisWithNA, num.trees = 100, verbose = 0)
head(irisImputed)

## -----------------------------------------------------------------------------
irisImputed <- missRanger(irisWithNA, pmm.k = 3, num.trees = 100, verbose = 0)
head(irisImputed)

## -----------------------------------------------------------------------------
irisImputed_et <- missRanger(
  irisWithNA, 
  pmm.k = 3, 
  splitrule = "extratrees", 
  num.trees = 50, 
  verbose = 0
)
head(irisImputed_et)

## -----------------------------------------------------------------------------
(imp <- missRanger(irisWithNA, data_only = FALSE, verbose = 0))

# Summary
summary(imp)

## -----------------------------------------------------------------------------
# Impute all variables with all (default behaviour). Note that variables without
# missing values will be skipped from the left hand side of the formula.
m <- missRanger(
  irisWithNA, formula = . ~ ., pmm.k = 3, num.trees = 10, seed = 1, verbose = 0
)
head(m)

# Same
m <- missRanger(irisWithNA, pmm.k = 3, num.trees = 10, seed = 1, verbose = 0)
head(m)

# Impute all variables with all except Species
m <- missRanger(irisWithNA, . ~ . - Species, pmm.k = 3, num.trees = 10, verbose = 0)
head(m)

# Impute Sepal.Width by Species 
m <- missRanger(
  irisWithNA, Sepal.Width ~ Species, pmm.k = 3, num.trees = 10, verbose = 0
)
head(m)

# No success. Why? Species contains missing values and thus can only 
# be used for imputation if it is being imputed as well
m <- missRanger(
  irisWithNA, Sepal.Width + Species ~ Species, pmm.k = 3, num.trees = 10, verbose = 0
)
head(m)

# Impute all variables univariatly
m <- missRanger(irisWithNA, . ~ 1, verbose = 0)
head(m)

## -----------------------------------------------------------------------------
# Count the number of non-missing values per row
non_miss <- rowSums(!is.na(irisWithNA))
table(non_miss)

# No weighting
m <- missRanger(irisWithNA, num.trees = 20, pmm.k = 3, seed = 5, verbose = 0)
head(m)

# Weighted by number of non-missing values per row. 
m <- missRanger(
  irisWithNA, num.trees = 20, pmm.k = 3, seed = 5, verbose = 0, case.weights = non_miss
)
head(m)

