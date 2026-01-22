# DCWS group metadata

This is a reference dataset listing what categories and groups are
available for each survey by year and location. Not all questions are
available for all groups, and not all groups are available every year or
for every location.

## Usage

``` r
cws_group_meta
```

## Format

A data frame with 386 rows and 4 variables:

- year:

  Numeric, year of survey

- span:

  Character, span of years of the survey (e.g. "2015_2024")

- name:

  Text of location

- groups:

  A list of nested data frames, each of which has 2 columns for category
  and group.

## Source

Compiled DCWS crosstabs

## Examples

``` r
# larger areas have more groups available each year (see number of rows per nested tibble)
cws_group_meta
#> # A tibble: 386 × 4
#>     year span  name               groups           
#>    <dbl> <chr> <chr>              <list>           
#>  1  2015 2015  5CT                <tibble [6 × 2]> 
#>  2  2015 2015  Bridgeport         <tibble [21 × 2]>
#>  3  2015 2015  Bristol            <tibble [14 × 2]>
#>  4  2015 2015  Connecticut        <tibble [26 × 2]>
#>  5  2015 2015  Danbury            <tibble [18 × 2]>
#>  6  2015 2015  Fairfield County   <tibble [26 × 2]>
#>  7  2015 2015  Greater Bridgeport <tibble [25 × 2]>
#>  8  2015 2015  Greater Hartford   <tibble [24 × 2]>
#>  9  2015 2015  Greater New Haven  <tibble [25 × 2]>
#> 10  2015 2015  Greater New London <tibble [23 × 2]>
#> # ℹ 376 more rows

cws_group_meta |>
    dplyr::filter(name == "Greater New Haven") |>
    tidyr::unnest(groups)
#> # A tibble: 114 × 5
#>     year span  name              category       group            
#>    <dbl> <chr> <chr>             <fct>          <fct>            
#>  1  2015 2015  Greater New Haven Total          Connecticut      
#>  2  2015 2015  Greater New Haven Total          Greater New Haven
#>  3  2015 2015  Greater New Haven Gender         Male             
#>  4  2015 2015  Greater New Haven Gender         Female           
#>  5  2015 2015  Greater New Haven Age            Ages 18-34       
#>  6  2015 2015  Greater New Haven Age            Ages 35-49       
#>  7  2015 2015  Greater New Haven Age            Ages 50-64       
#>  8  2015 2015  Greater New Haven Age            Ages 65+         
#>  9  2015 2015  Greater New Haven Race/Ethnicity White            
#> 10  2015 2015  Greater New Haven Race/Ethnicity Black            
#> # ℹ 104 more rows

# this is useful if you want to know what locations have data for a certain
# set of conditions, e.g. 2021 values by income
cws_group_meta |>
    tidyr::unnest(groups) |>
    dplyr::filter(year == 2021, category == "Income")
#> # A tibble: 96 × 5
#>     year span  name        category group     
#>    <dbl> <chr> <chr>       <fct>    <fct>     
#>  1  2021 2021  Bridgeport  Income   <$30K     
#>  2  2021 2021  Bridgeport  Income   $30K-$100K
#>  3  2021 2021  Bridgeport  Income   $100K+    
#>  4  2021 2021  Connecticut Income   <$30K     
#>  5  2021 2021  Connecticut Income   $30K-$100K
#>  6  2021 2021  Connecticut Income   $100K+    
#>  7  2021 2021  Danbury     Income   <$30K     
#>  8  2021 2021  Danbury     Income   $30K-$100K
#>  9  2021 2021  Danbury     Income   $100K+    
#> 10  2021 2021  EHHD        Income   <$30K     
#> # ℹ 86 more rows
```
