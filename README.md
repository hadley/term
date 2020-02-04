
<!-- README.md is generated from README.Rmd. Please edit that file -->

# term

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.com/poissonconsulting/term.svg?branch=master)](https://travis-ci.com/poissonconsulting/term)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/poissonconsulting/term?branch=master&svg=true)](https://ci.appveyor.com/project/poissonconsulting/term)
[![Codecov test
coverage](https://codecov.io/gh/poissonconsulting/term/branch/master/graph/badge.svg)](https://codecov.io/gh/poissonconsulting/term?branch=master)
[![License:
MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Tinyverse
status](https://tinyverse.netlify.com/badge/term)](https://CRAN.R-project.org/package=term)
[![CRAN
status](https://www.r-pkg.org/badges/version/term)](https://cran.r-project.org/package=term)
![CRAN downloads](http://cranlogs.r-pkg.org/badges/term)
<!-- badges: end -->

`term` is an R package to create, manipulate, query and repair vectors
of parameter terms. Parameter terms are the labels used to reference
values in vectors, matrices and arrays. They represent the names in
coefficient tables and the column names in `mcmc` and `mcmc.list`
objects.

## Installation

To install the latest release from [CRAN](https://cran.r-project.org)

``` r
install.packages("term")
```

To install the developmental version from
[GitHub](https://github.com/poissonconsulting/term)

``` r
# install.packages("remotes")
remotes::install_github("poissonconsulting/term")
```

To install the latest developmental release from the Poisson drat
[repository](https://github.com/poissonconsulting/drat)

``` r
# install.packages("drat")
drat::addRepo("poissonconsulting")
install.packages("term")
```

## Demonstration

### Creating Term Vectors

``` r
library(term)

# term vectors can be constructed from character vectors
term <- term(
  "alpha[1]", "alpha[2]", "beta[1,1]", "beta[2,1]",
  "beta[1,2]", "beta[2,2]", "sigma"
)

# term vectors print like character vectors
term
#> <term[7]>
#> [1] alpha[1]  alpha[2]  beta[1,1] beta[2,1] beta[1,2] beta[2,2] sigma

# they are S3 class objects that also inherit from character
str(term)
#>  term [1:7] alpha[1], alpha[2], beta[1,1], beta[2,1], beta[1,2], beta[2,2],...

# term vectors can also be created from numeric atomic objects
as.term(matrix(1:4, 2), "theta")
#> <term[4]>
#> [1] theta[1,1] theta[2,1] theta[1,2] theta[2,2]
```

### Querying Term Vectors

``` r
# get the parameter names
pars(term)
#> [1] "alpha" "beta"  "sigma"
# and parameter dimensions
pdims(term)
#> $alpha
#> [1] 2
#> 
#> $beta
#> [1] 2 2
#> 
#> $sigma
#> [1] 1

# get the parameter names by term
pars_terms(term)
#> [1] "alpha" "alpha" "beta"  "beta"  "beta"  "beta"  "sigma"
# and the term indices
tindex(term)
#> $`alpha[1]`
#> [1] 1
#> 
#> $`alpha[2]`
#> [1] 2
#> 
#> $`beta[1,1]`
#> [1] 1 1
#> 
#> $`beta[2,1]`
#> [1] 2 1
#> 
#> $`beta[1,2]`
#> [1] 1 2
#> 
#> $`beta[2,2]`
#> [1] 2 2
#> 
#> $sigma
#> [1] 1
```

### Validating Term Vectors

``` r
# term vectors can be tested for whether they have (parseably) valid,
# (dimensionally) consistent and complete terms.

# valid terms
valid_term(term("a", "a[1]", "a [2]", " b [3  ] ", "c[1,10]"))
#> [1] TRUE TRUE TRUE TRUE TRUE

# invalid terms
valid_term(new_term(c("a a", "a[]", "a[2", " b[3 3]", "c[1,10]c")))
#> [1] FALSE FALSE FALSE FALSE FALSE

# consistent terms
consistent_term(term("a", "a[2]", "b[1,1]", "b[10,99]"))
#> [1] TRUE TRUE TRUE TRUE

# inconsistent terms
consistent_term(term("a", "a[2,1]", "b[1,1]", "b[10,99,1]"))
#> [1] FALSE FALSE FALSE FALSE

# complete terms
is_incomplete_terms(term("a", "a[2]", "b[1,1]", "b[2,1]"))
#> [1] FALSE

# incomplete terms
is_incomplete_terms(term("a", "a[3]", "b[1,1]", "b[2,2]"))
#> [1] TRUE
```

### Checking Term Vectors

``` r
x <- term("a[1]", "a[3]")
chk::chk_s3_class(x, "term")
chk_term(x, validate = "valid")
chk_term(x, validate = "complete")
#> Error: All elements of term vector `x` must be complete.
```

### Repairing Term Vectors

``` r
term <- new_term(c("b[4]", "b   [2]", "b", "b[1", "b[2, 2]", "b", "a [ 1 ] ", NA))
term
#> <term[8]>
#> [1] b[4]       `b   [2]`  b          b[1        `b[2, 2]`  b          `a [ 1 ] `
#> [8] <NA>

# valid terms can be repaired (invalid terms are converted to missing values)
term <- repair_terms(term)
term
#> <term[8]>
#> [1] b[4]   b[2]   b[1]   <NA>   b[2,2] b[1]   a      <NA>

# the `term()` constructor rejects invalid terms
term("b[4]", "b   [2]", "b", "b[1", "b[2, 2]", "b", "a [ 1 ] ", NA)
#> Error: All elements of term vector `unnamed_args_term` must be valid.

# missing values can easily removed
term <- term[!is.na(term)]
term
#> <term[6]>
#> [1] b[4]   b[2]   b[1]   b[2,2] b[1]   a

# and only unique values retained
term <- unique(term)
term
#> <term[5]>
#> [1] b[4]   b[2]   b[1]   b[2,2] a

# a term vector can be sorted by parameter name and index
term <- sort(term)
term
#> <term[5]>
#> [1] a      b[1]   b[2]   b[4]   b[2,2]

# an inconsistent term removed
term <- term[term != "b[2,2]"]
term
#> <term[4]>
#> [1] a    b[1] b[2] b[4]

# and incomplete terms completed
term <- sort(complete_terms(term))
term
#> <term[5]>
#> [1] a    b[1] b[2] b[3] b[4]
```

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/term/issues).

[Pull requests](https://github.com/poissonconsulting/term/pulls) are
always welcome.

Please note that the ‘term’ project is released with a [Contributor Code
of
Conduct](https://poissonconsulting.github.io/term/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
