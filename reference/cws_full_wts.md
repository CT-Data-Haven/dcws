# DCWS weights

This is a nested data frame containing each survey's weights, used for
combining groups to calculate average values. These can be joined to
DCWS data with `fetch_cws`, or manually. Note that in some larger areas
for 2018 (maybe also 2015), groups might not all line up between data
and weights–check for NAs in your weights column if need be.

## Usage

``` r
cws_full_wts
```

## Format

A data frame with 386 rows and 4 variables:

- year:

  Numeric, year of survey

- span:

  Character, span of years of the survey (e.g. "2015_2024")

- name:

  Text of location

- weights:

  A list of nested data frames, each of which has 2 columns for group
  and weight.

## Source

Compiled DCWS crosstabs

## See also

[`fetch_cws()`](https://ct-data-haven.github.io/dcws/reference/fetch_cws.md),
[`fetch_wts()`](https://ct-data-haven.github.io/dcws/reference/fetch_wts.md)

## Examples

``` r
cws_full_wts
#> # A tibble: 386 × 4
#>     year span  name               weights          
#>    <dbl> <chr> <chr>              <list>           
#>  1  2015 2015  5CT                <tibble [2 × 2]> 
#>  2  2015 2015  Bridgeport         <tibble [21 × 2]>
#>  3  2015 2015  Bristol            <tibble [14 × 2]>
#>  4  2015 2015  Greater Waterbury  <tibble [25 × 2]>
#>  5  2015 2015  Connecticut        <tibble [27 × 2]>
#>  6  2015 2015  Greater Hartford   <tibble [24 × 2]>
#>  7  2015 2015  Danbury            <tibble [18 × 2]>
#>  8  2015 2015  Fairfield County   <tibble [27 × 2]>
#>  9  2015 2015  Greater Bridgeport <tibble [25 × 2]>
#> 10  2015 2015  Greater New Haven  <tibble [25 × 2]>
#> # ℹ 376 more rows

cws_full_wts |>
    dplyr::filter(name == "Greater New Haven") |>
    tidyr::unnest(weights)
#> # A tibble: 118 × 5
#>     year span  name              group             weight
#>    <dbl> <chr> <chr>             <fct>              <dbl>
#>  1  2015 2015  Greater New Haven Connecticut        1    
#>  2  2015 2015  Greater New Haven Greater New Haven  1    
#>  3  2015 2015  Greater New Haven Male               0.47 
#>  4  2015 2015  Greater New Haven Female             0.53 
#>  5  2015 2015  Greater New Haven Ages 18-34         0.292
#>  6  2015 2015  Greater New Haven Ages 35-49         0.244
#>  7  2015 2015  Greater New Haven Ages 50-64         0.236
#>  8  2015 2015  Greater New Haven Ages 65+           0.173
#>  9  2015 2015  Greater New Haven White              0.727
#> 10  2015 2015  Greater New Haven Black              0.158
#> # ℹ 108 more rows
```
