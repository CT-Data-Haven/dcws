# DCWS maximum margins of error

This is a data frame listing the maximum margin of error for estimates
for each location and year. The values are extracted from the headers of
the crosstab spreadsheets, but many are missing, especially for 2015.
It's unlikely anyone will need this often beyond the community profiles
on our website, so they're not filtered for the same subset of locations
as the main data and weights datasets.

## Usage

``` r
cws_max_moe
```

## Format

A data frame with 386 rows and 4 variables:

- year:

  Numeric, year of survey

- span:

  Character, span of years of the survey (e.g. "2015_2024")

- name:

  Text of location

- moe:

  Numeric, value of maximum MOE

## Source

Compiled DCWS crosstabs

## Examples

``` r
cws_max_moe
#> # A tibble: 386 × 4
#>     year span  name                 moe
#>    <dbl> <chr> <chr>              <dbl>
#>  1  2015 2015  5CT                0.011
#>  2  2015 2015  Bridgeport         0.036
#>  3  2015 2015  Bristol            0.068
#>  4  2015 2015  Greater Waterbury  0.027
#>  5  2015 2015  Connecticut        0.011
#>  6  2015 2015  Greater Hartford   0.023
#>  7  2015 2015  Danbury            0.06 
#>  8  2015 2015  Fairfield County   0.019
#>  9  2015 2015  Greater Bridgeport 0.027
#> 10  2015 2015  Greater New Haven  0.031
#> # ℹ 376 more rows
```
