## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## -----------------------------------------------------------------------------
library(missRanger)
library(mice)

set.seed(19)

irisWithNA <- generateNA(iris, p = c(0, 0.1, 0.1, 0.1, 0.1))

# Generate 20 complete data sets
filled <- replicate(20, missRanger(irisWithNA, verbose = 0, num.trees = 50, pmm.k = 5), simplify = FALSE)
                           
# Run a linear model for each of the completed data sets                          
models <- lapply(filled, function(x) lm(Sepal.Length ~ ., x))

# Pool the results by mice
summary(pooled_fit <- pool(models))

# Compare with model on original data
summary(lm(Sepal.Length ~ ., data = iris))


