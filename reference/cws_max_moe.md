# DCWS maximum margins of error and sample sizes

This is a data frame listing the maximum margin of error for estimates
for each location and year, as well as the sample size. The values are
stored in different parts of the crosstab spreadsheets depending on
year.

## Usage

``` r
cws_max_moe
```

## Format

A data frame with 386 rows and 5 variables:

- year:

  Numeric, year of survey

- span:

  Character, span of years of the survey (e.g. "2015_2024")

- name:

  Text of location

- moe:

  Numeric, value of maximum MOE

- sample_size:

  Numeric, weighted sample size of the survey for that location

## Source

Compiled DCWS crosstabs

## Examples

``` r
cws_max_moe
#> # A tibble: 386 × 5
#>     year span  name                 moe sample_size
#>    <dbl> <chr> <chr>              <dbl>       <dbl>
#>  1  2015 2015  5CT                0.011       16219
#>  2  2015 2015  Bridgeport         0.036        1010
#>  3  2015 2015  Bristol            0.068         276
#>  4  2015 2015  Greater Waterbury  0.027        1919
#>  5  2015 2015  Connecticut        0.011       16219
#>  6  2015 2015  Greater Hartford   0.023        3493
#>  7  2015 2015  Danbury            0.06          400
#>  8  2015 2015  Fairfield County   0.019        4962
#>  9  2015 2015  Greater Bridgeport 0.027        1850
#> 10  2015 2015  Greater New Haven  0.031        1810
#> # ℹ 376 more rows
```
