# Combine multiple response categories into one indicator-style one

This is a function to speed up a common task of combining multiple
responses (e.g. "Excellent", "Good") into a single one (e.g. "Excellent
/ Good"). It's useful for converting questions in their original format
into one where we can use a single number to show the percentage of
people who rated something excellent or good. Two additional steps are
optional but done by default: non-answers are dropped with
[`sub_nonanswers()`](https://ct-data-haven.github.io/dcws/reference/sub_nonanswers.md),
and the data is filtered for *only* the named aggregated responses. Both
of these steps can be disabled independently.

## Usage

``` r
combine_response(
  data,
  categories,
  response = response,
  value = value,
  filter_responses = TRUE,
  drop_nonanswers = TRUE,
  nons = c("Don't know", "Refused"),
  ...
)
```

## Arguments

- data:

  A data frame with groups maintained.

- categories:

  A named list of vectors. Each list item should be a character vector
  of response categories to lump together, and each vector's name should
  be the new name for the aggregated response. This follows the `...`
  argument of
  [`forcats::fct_collapse()`](https://forcats.tidyverse.org/reference/fct_collapse.html),
  as that is where it is passed directly.

- response:

  Bare column name of where responses are found, including those
  considered to be non-answers. Default: response

- value:

  Bare column name of values, Default: value

- filter_responses:

  Logical: if `TRUE` (the default), only responses matching the names of
  the `categories` argument will be kept.

- drop_nonanswers:

  Logical: if `TRUE` (the default), will drop nonanswers with
  [`sub_nonanswers()`](https://ct-data-haven.github.io/dcws/reference/sub_nonanswers.md)
  after aggregating.

- nons:

  Character vector of responses to be removed. Default: c("Don't know",
  "Refused")

- ...:

  Arguments passed on to
  [`sub_nonanswers`](https://ct-data-haven.github.io/dcws/reference/sub_nonanswers.md)

  `factor_response`

  :   Logical: if `TRUE` (default), returns response variable as a
      factor. This is likely a more useful way to handle response
      categories once non-answers have been removed.

  `rescale`

  :   Logical: if `TRUE`, values will be scaled based on their total. If
      `FALSE` (the default), values are scaled based on an assumption
      that all responses add to 1. In some cases, crosstabs with heavy
      rounding might not add up to 1 when they should, so rescaling
      helps handle that.

## Value

A data frame with groups maintained. It will have fewer rows, depending
on arguments passed for filtering and dropping nonanswers.

## Details

A few gotchas are possible with this function:

- Unless you're using a data frame with only one location, category, and
  group, you'll likely want to use this on a grouped data frame. This
  function *maintains* all groups of the data frame passed in, but it is
  outside the purview of this function to *create* any groups. You
  should do that in advance yourself (see examples).

- Removing non-answers and filtering happen independently but are
  informed by each other. If you decide to filter the data but not drop
  non-answers, the values of `nons` will be included as response
  categories to keep. This is to avoid a situation where more data is
  dropped than you might intend.

## See also

[`sub_nonanswers()`](https://ct-data-haven.github.io/dcws/reference/sub_nonanswers.md)
[`forcats::fct_collapse()`](https://forcats.tidyverse.org/reference/fct_collapse.html)

Other data manipulation functions:
[`collapse_n_wt()`](https://ct-data-haven.github.io/dcws/reference/collapse_n_wt.md),
[`sub_nonanswers()`](https://ct-data-haven.github.io/dcws/reference/sub_nonanswers.md)

## Examples

``` r
  xt <- system.file("extdata/test_xtab2021.xlsx", package = "dcws") |>
      read_xtabs(process = TRUE, year = 2021)
#> ℹ xtab2df is being called on the data with the following parameters:
#> → year = 2021
#> → col = x1
#> → code_pattern = `NULL` (filling in default pattern)
#> → verbose = TRUE
# how responsive is local govt?
  local_govt <- dplyr::filter(xt, code == "Q4A", category == "Age")
  unique(local_govt$response)
#> [1] "Excellent"                                 
#> [2] "Good"                                      
#> [3] "Fair"                                      
#> [4] "Poor"                                      
#> [5] "Don't know enough about it in order to say"
#> [6] "Refused"                                   
# combine excellent & good, drop non-answers, filter
# note that this question has different wording for "Don't know" response
  local_govt |>
     dplyr::group_by(category, group) |>
     combine_response(
         list(excellent_good = c("Excellent", "Good")),
         nons = c("Don't know enough about it in order to say", "Refused")
     )
#> # A tibble: 4 × 4
#> # Groups:   category, group [4]
#>   category group      response       value
#>   <fct>    <fct>      <fct>          <dbl>
#> 1 Age      Ages 18-34 excellent_good 0.253
#> 2 Age      Ages 35-49 excellent_good 0.176
#> 3 Age      Ages 50-64 excellent_good 0.319
#> 4 Age      Ages 65+   excellent_good 0.560
# combine but no filtering or dropping
local_govt |>
     dplyr::group_by(category, group) |>
     combine_response(
         list(excellent_good = c("Excellent", "Good")),
         nons = c("Don't know enough about it in order to say", "Refused"),
         filter_responses = FALSE,
         drop_nonanswers = FALSE
     )
#> # A tibble: 20 × 4
#> # Groups:   category, group [4]
#>    category group      response                                   value
#>    <fct>    <fct>      <fct>                                      <dbl>
#>  1 Age      Ages 18-34 Don't know enough about it in order to say  0.17
#>  2 Age      Ages 18-34 excellent_good                              0.21
#>  3 Age      Ages 18-34 Fair                                        0.34
#>  4 Age      Ages 18-34 Poor                                        0.27
#>  5 Age      Ages 18-34 Refused                                     0   
#>  6 Age      Ages 35-49 Don't know enough about it in order to say  0.15
#>  7 Age      Ages 35-49 excellent_good                              0.15
#>  8 Age      Ages 35-49 Fair                                        0.27
#>  9 Age      Ages 35-49 Poor                                        0.42
#> 10 Age      Ages 35-49 Refused                                     0   
#> 11 Age      Ages 50-64 Don't know enough about it in order to say  0.06
#> 12 Age      Ages 50-64 excellent_good                              0.3 
#> 13 Age      Ages 50-64 Fair                                        0.35
#> 14 Age      Ages 50-64 Poor                                        0.28
#> 15 Age      Ages 50-64 Refused                                     0   
#> 16 Age      Ages 65+   Don't know enough about it in order to say  0.16
#> 17 Age      Ages 65+   excellent_good                              0.47
#> 18 Age      Ages 65+   Fair                                        0.2 
#> 19 Age      Ages 65+   Poor                                        0.18
#> 20 Age      Ages 65+   Refused                                     0   

# multiple combined categories--useful for Likert questions
area_change <- dplyr::filter(xt, code == "Q2", category == "Gender")
unique(area_change$response)
#> [1] "Much better"     "Somewhat better" "About the same"  "Somewhat worse" 
#> [5] "Much worse"      "Don't know"      "Refused"        
# using default filtering, this drops middle category ("About the same")
area_change |>
  dplyr::group_by(category, group) |>
  combine_response(
     list(
         `Getting better` = c("Much better", "Somewhat better"),
         `Getting worse` = c("Much worse", "Somewhat worse")
     ))
#> # A tibble: 4 × 4
#> # Groups:   category, group [2]
#>   category group  response       value
#>   <fct>    <fct>  <fct>          <dbl>
#> 1 Gender   Male   Getting better 0.455
#> 2 Gender   Male   Getting worse  0.222
#> 3 Gender   Female Getting better 0.305
#> 4 Gender   Female Getting worse  0.337
# instead turn off filtering but keep non-answer dropping
# unfortunately now responses are out of order...
area_change |>
  dplyr::group_by(category, group) |>
  combine_response(
     list(
         `Getting better` = c("Much better", "Somewhat better"),
         `Getting worse` = c("Much worse", "Somewhat worse")
     ), filter_responses = FALSE)
#> # A tibble: 6 × 4
#> # Groups:   category, group [2]
#>   category group  response       value
#>   <fct>    <fct>  <fct>          <dbl>
#> 1 Gender   Male   About the same 0.323
#> 2 Gender   Male   Getting better 0.455
#> 3 Gender   Male   Getting worse  0.222
#> 4 Gender   Female About the same 0.368
#> 5 Gender   Female Getting better 0.305
#> 6 Gender   Female Getting worse  0.337
# ...unless response is already a factor, in which case levels stick
area_change |>
  dplyr::group_by(category, group) |>
  dplyr::mutate(response = forcats::as_factor(response)) |>
  combine_response(
     list(
         `Getting better` = c("Much better", "Somewhat better"),
         `Getting worse` = c("Much worse", "Somewhat worse")
     ), filter_responses = FALSE)
#> # A tibble: 6 × 4
#> # Groups:   category, group [2]
#>   category group  response       value
#>   <fct>    <fct>  <fct>          <dbl>
#> 1 Gender   Male   Getting better 0.455
#> 2 Gender   Male   About the same 0.323
#> 3 Gender   Male   Getting worse  0.222
#> 4 Gender   Female Getting better 0.305
#> 5 Gender   Female About the same 0.368
#> 6 Gender   Female Getting worse  0.337
```
