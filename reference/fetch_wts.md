# Fetch and subset weights for DCWS data

This function returns the nested `cws_full_wts` data, meant as a
counterpart to `fetch_cws`.

## Usage

``` r
fetch_wts(..., .year = NULL, .name = NULL, .unnest = FALSE)
```

## Arguments

- ...:

  Any number of conditions to filter by, which will be passed to
  [`dplyr::filter`](https://dplyr.tidyverse.org/reference/filter.html).
  These don't override the named options, so if you filter by
  `year > 2020` but then set `.year = 2015` you're not going to get any
  data.

- .year:

  A vector of one or more year(s) to subset by. If this is a character
  that contains a separator (`"_"`, `"-"`, or a space character), it
  will be assumed to be a span of years, such as for multi-year pooled
  crosstabs (e.g. `"2015_2024"`). Otherwise it's assumed this is a
  single year of the survey. If `NULL`, no filtering is done by year.

- .name:

  A vector of one or more strings giving the name(s) to subset by. If
  `NULL`, no filtering is done by name.

- .unnest:

  Boolean: should data be returned nested into a column called `data`?
  Defaults to `FALSE`.

## Value

A data frame, with either 3 columns (if `.unnest = FALSE`) or 4 columns
(if `.unnest = TRUE`).

- For `.unnest = FALSE`: columns are `year`, `name`, and a list of
  nested data frames `weights`

- For `.unnest = TRUE`: `year`, `name`, `group`, and `weight`

## See also

[`fetch_cws()`](https://ct-data-haven.github.io/dcws/reference/fetch_cws.md)
[cws_full_wts](https://ct-data-haven.github.io/dcws/reference/cws_full_wts.md)

Other data accessing functions:
[`fetch_cws()`](https://ct-data-haven.github.io/dcws/reference/fetch_cws.md),
[`read_xtabs()`](https://ct-data-haven.github.io/dcws/reference/read_xtabs.md),
[`xtab2df()`](https://ct-data-haven.github.io/dcws/reference/xtab2df.md)

## Examples

``` r
# no filtering
fetch_wts()
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

# weights are generally useful in combination with actual data
# but unless you unnest in advance, this is messy
fetch_cws(code == "Q4E",
    .year = 2021,
    .name = c("Greater New Haven", "New Haven"), .unnest = TRUE
) |>
    dplyr::left_join(fetch_wts(.unnest = TRUE), by = c("year", "span", "name", "group"))
#> # A tibble: 216 × 10
#>     year span  name          code  question category group response value weight
#>    <dbl> <chr> <chr>         <chr> <chr>    <fct>    <fct> <fct>    <dbl>  <dbl>
#>  1  2021 2021  Greater New … Q4E   The abi… Total    Grea… Excelle…  0.09  1    
#>  2  2021 2021  Greater New … Q4E   The abi… Total    Grea… Good      0.39  1    
#>  3  2021 2021  Greater New … Q4E   The abi… Total    Grea… Fair      0.26  1    
#>  4  2021 2021  Greater New … Q4E   The abi… Total    Grea… Poor      0.07  1    
#>  5  2021 2021  Greater New … Q4E   The abi… Total    Grea… Don't k…  0.19  1    
#>  6  2021 2021  Greater New … Q4E   The abi… Total    Grea… Refused   0     1    
#>  7  2021 2021  Greater New … Q4E   The abi… Gender   Male  Excelle…  0.1   0.471
#>  8  2021 2021  Greater New … Q4E   The abi… Gender   Male  Good      0.41  0.471
#>  9  2021 2021  Greater New … Q4E   The abi… Gender   Male  Fair      0.24  0.471
#> 10  2021 2021  Greater New … Q4E   The abi… Gender   Male  Poor      0.08  0.471
#> # ℹ 206 more rows

# instead, use fetch_cws with .add_wts = TRUE to get these weights joined for you
fetch_cws(code == "Q4E",
    .year = 2021,
    .name = c("Greater New Haven", "New Haven"),
    .add_wts = TRUE
)
#> # A tibble: 2 × 6
#>    year span  name              code  question                          data    
#>   <dbl> <chr> <chr>             <chr> <chr>                             <list>  
#> 1  2021 2021  Greater New Haven Q4E   The ability of residents to obta… <tibble>
#> 2  2021 2021  New Haven         Q4E   The ability of residents to obta… <tibble>
```
