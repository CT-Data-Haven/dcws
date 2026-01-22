# Collapse survey groups and get weighted means

This is just a quick wrapper for a common, tedious task of collapsing
several demographic groups, such as income brackets, into larger groups
and taking a weighted mean based on a set of survey weights.

## Usage

``` r
collapse_n_wt(
  data,
  ...,
  .lvls,
  .group = group,
  .value = value,
  .weight = weight,
  .fill_wts = FALSE,
  .digits = NULL
)
```

## Arguments

- data:

  A data frame, such as returned by
  [`xtab2df()`](https://ct-data-haven.github.io/dcws/reference/xtab2df.md)
  joined with survey weights as returned by
  [`read_weights()`](https://ct-data-haven.github.io/dcws/reference/read_xtabs.md).
  The default column names here match those returned by `xtab2df`
  (`group`, `value`) and `read_weights` (`weight`).

- ...:

  Bare column names to use for grouping, including the `.group` column,
  such as location, year, category, response, etc–probably everything
  except values and weights.

- .lvls:

  A named list, where values are character vectors of smaller groups
  (e.g. `c("<$15K", "$15K-$30K")`) and names are the groups those will
  be replaced by (e.g. `"<$30K"`). This will be split into the arguments
  to
  [`forcats::fct_collapse()`](https://forcats.tidyverse.org/reference/fct_collapse.html).

- .group:

  Bare column name of where groups should be found. Default: group

- .value:

  Bare column name of where values should be found. Default: value

- .weight:

  Bare column name of where group weights should be found. Default:
  weight

- .fill_wts:

  Logical: if `TRUE`, missing weights will be filled in with 1, i.e.
  unweighted. This defaults to `FALSE`, because missing weights is a
  useful way to find that there's a mismatch between the group labels in
  the data and those in the weights table, which is very often the case.
  Therefore, only set this to `TRUE` if you've already accounted for
  labeling discrepancies.

- .digits:

  Numeric: if given, weighted means will be rounded to this number of
  digits. If `NULL` (the default), values are returned unrounded.

## Value

A data frame with summarized values. The column specified in `.group`
will have the collapsed groups, and the column specified in `.value`
will have average values.

## See also

[`xtab2df()`](https://ct-data-haven.github.io/dcws/reference/xtab2df.md),
[`read_weights()`](https://ct-data-haven.github.io/dcws/reference/read_xtabs.md),
[`forcats::fct_collapse()`](https://forcats.tidyverse.org/reference/fct_collapse.html)

Other manipulating:
[`sub_nonanswers()`](https://ct-data-haven.github.io/dcws/reference/sub_nonanswers.md)

## Examples

``` r
# collapse income groups, such that <$15K, $15K-$30K become <$30K, etc
income_lvls <- list(
    "<$30K" = c("<$15K", "$15K-$30K"),
    "$30K-$100K" = c("$30K-$50K", "$50K-$75K", "$75K-$100K"),
    "$100K+" = c("$100K-$200K", "$200K+")
)
cws_demo |>
    dplyr::filter(category %in% c("Greater New Haven", "Income")) |>
    collapse_n_wt(code:response, .lvls = income_lvls, .digits = 2)
#> # A tibble: 12 × 5
#>    code  category group      response   value
#>    <chr> <fct>    <fct>      <fct>      <dbl>
#>  1 Q1    Income   <$30K      Yes         0.72
#>  2 Q1    Income   <$30K      No          0.27
#>  3 Q1    Income   <$30K      Don't know  0.01
#>  4 Q1    Income   <$30K      Refused     0   
#>  5 Q1    Income   $30K-$100K Yes         0.84
#>  6 Q1    Income   $30K-$100K No          0.16
#>  7 Q1    Income   $30K-$100K Don't know  0   
#>  8 Q1    Income   $30K-$100K Refused     0   
#>  9 Q1    Income   $100K+     Yes         0.86
#> 10 Q1    Income   $100K+     No          0.13
#> 11 Q1    Income   $100K+     Don't know  0.01
#> 12 Q1    Income   $100K+     Refused     0   
```
