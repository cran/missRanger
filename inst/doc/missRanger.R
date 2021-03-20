## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## -----------------------------------------------------------------------------
library(missRanger)
library(dplyr)

set.seed(84553)

head(iris)

# Generate data with missing values in all columns
head(irisWithNA <- generateNA(iris, p = 0.2))
 
# Impute missing values with missRanger
head(irisImputed <- missRanger(irisWithNA, num.trees = 100))


## -----------------------------------------------------------------------------
head(irisImputed <- missRanger(irisWithNA, pmm.k = 3, num.trees = 100))

## -----------------------------------------------------------------------------
head(irisImputed_et <- missRanger(irisWithNA, pmm.k = 3, splitrule = "extratrees", num.trees = 50))

## -----------------------------------------------------------------------------
iris %>% 
  generateNA() %>% 
  missRanger(verbose = 0) %>% 
  head()
  

## -----------------------------------------------------------------------------
# Impute all variables with all (default behaviour). Note that variables without
# missing values will be skipped from the left hand side of the formula.
head(m <- missRanger(irisWithNA, formula = . ~ ., pmm.k = 3, num.trees = 10))

# Same
head(m <- missRanger(irisWithNA, pmm.k = 3, num.trees = 10))

# Impute all variables with all except Species
head(m <- missRanger(irisWithNA, . ~ . - Species, pmm.k = 3, num.trees = 10))

# Impute Sepal.Width by Species 
head(m <- missRanger(irisWithNA, Sepal.Width ~ Species, pmm.k = 3, num.trees = 10))

# No success. Why? Species contains missing values and thus can only be used for imputation if it is being imputed as well
head(m <- missRanger(irisWithNA, Sepal.Width + Species ~ Species, pmm.k = 3, num.trees = 10))

# Impute all variables univariatly
head(m <- missRanger(irisWithNA, . ~ 1))


## -----------------------------------------------------------------------------
# Count the number of non-missing values per row
non_miss <- rowSums(!is.na(irisWithNA))
table(non_miss)

# No weighting
head(m <- missRanger(irisWithNA, num.trees = 20, pmm.k = 3, seed = 5))

# Weighted by number of non-missing values per row. 
head(m <- missRanger(irisWithNA, num.trees = 20, pmm.k = 3, seed = 5, case.weights = non_miss))


