# Remove non-answers and rescale percentage values

This is a convenience function for removing what might be considered
non-answers ("don't know", "refused", etc.) and rescaling the remaining
values to add to 1.0.

## Usage

``` r
sub_nonanswers(
  data,
  response = response,
  value = value,
  nons = c("Don't know", "Refused"),
  factor_response = TRUE,
  rescale = FALSE
)
```

## Arguments

- data:

  A data frame

- response:

  Bare column name of where responses are found, including those
  considered to be non-answers. Default: response

- value:

  Bare column name of values, Default: value

- nons:

  Character vector of responses to be removed. Default: c("Don't know",
  "Refused")

- factor_response:

  Logical: if `TRUE` (default), returns response variable as a factor.
  This is likely a more useful way to handle response categories once
  non-answers have been removed.

- rescale:

  Logical: if `TRUE`, values will be scaled based on their total. If
  `FALSE` (the default), values are scaled based on an assumption that
  all responses add to 1. In some cases, crosstabs with heavy rounding
  might not add up to 1 when they should, so rescaling helps handle
  that.

## Value

A data frame with the same number of columns as the original, but fewer
rows

## See also

Other data manipulation functions:
[`collapse_n_wt()`](https://ct-data-haven.github.io/dcws/reference/collapse_n_wt.md),
[`combine_response()`](https://ct-data-haven.github.io/dcws/reference/combine_response.md)

## Examples

``` r
if (interactive()) {
  sub_nonanswers(cws_demo)
}
```
