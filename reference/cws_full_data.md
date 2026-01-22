# Contents of DataHaven Community Wellbeing Crosstabs

This is a list of data frames; previously it was one data frame with 2
levels of nesting. Each data frame in the list represents a combination
of survey endyear, timespan, and location, delimited with periods. For
example, `cws_full_data[["2024.2015_2024.Greater New Haven"]]` holds the
2015-2024 pooled data for Greater New Haven. The switch from a nested
data frame to a list of data frames was needed to speed things up as the
extent of the survey and number of crosstabs has ballooned. This also
used to include full text of every question, but those are now in the
`cws_codebook` data frame.

## Usage

``` r
cws_full_data
```

## Format

A list of 386 data frames, each with 8 columns and varying numbers of
rows:

- year:

  Numeric, endyear of survey (e.g. 2024)

- span:

  Character, span of years of the survey (e.g. "2015_2024")

- name:

  Text of location

- code:

  Question code, e.g. "Q2", "Q4E", "RENTEVICT"

- category:

  Factor: participant group categories, e.g. "Gender", "Age"

- group:

  Factor: participant group, e.g. "Male", "Ages 65+"

- response:

  Factor: text of responses, depending on question

- value:

  Share of participants giving each response

## Source

Compiled DCWS crosstabs

## Details

The recommended way of accessing this data is using `fetch_cws`, which
filters and combines it for you.

## See also

[`fetch_cws()`](https://ct-data-haven.github.io/dcws/reference/fetch_cws.md),
[cws_codebook](https://ct-data-haven.github.io/dcws/reference/cws_codebook.md)

## Examples

``` r
# get specific question based on code
cws_full_data[["2024.2015_2024.Greater New Haven"]] |>
    dplyr::filter(code == "Q64")
#> # A tibble: 76 × 8
#>     year span      name              code  category group       response   value
#>    <dbl> <chr>     <chr>             <fct> <fct>    <fct>       <fct>      <dbl>
#>  1  2024 2015_2024 Greater New Haven Q64   Total    Connecticut Yes      0.100  
#>  2  2024 2015_2024 Greater New Haven Q64   Total    Connecticut No       0.894  
#>  3  2024 2015_2024 Greater New Haven Q64   Total    Connecticut Don't k… 0.00152
#>  4  2024 2015_2024 Greater New Haven Q64   Total    Connecticut Refused  0.00410
#>  5  2024 2015_2024 Greater New Haven Q64   Total    Greater Ne… Yes      0.112  
#>  6  2024 2015_2024 Greater New Haven Q64   Total    Greater Ne… No       0.882  
#>  7  2024 2015_2024 Greater New Haven Q64   Total    Greater Ne… Don't k… 0.00175
#>  8  2024 2015_2024 Greater New Haven Q64   Total    Greater Ne… Refused  0.00395
#>  9  2024 2015_2024 Greater New Haven Q64   Gender   Male        Yes      0.112  
#> 10  2024 2015_2024 Greater New Haven Q64   Gender   Male        No       0.882  
#> # ℹ 66 more rows

# bind, then join with codebook to find question by text
cws_full_data[["2024.2015_2024.Greater New Haven"]] |>
    dplyr::left_join(cws_codebook, by = c("year", "code")) |>
    dplyr::filter(grepl("adequate shelter", question))
#> # A tibble: 76 × 10
#>     year span     name  code  category group response   value question responses
#>    <dbl> <chr>    <chr> <chr> <fct>    <fct> <fct>      <dbl> <chr>    <list>   
#>  1  2024 2015_20… Grea… Q64   Total    Conn… Yes      0.100   In the … <chr [4]>
#>  2  2024 2015_20… Grea… Q64   Total    Conn… No       0.894   In the … <chr [4]>
#>  3  2024 2015_20… Grea… Q64   Total    Conn… Don't k… 0.00152 In the … <chr [4]>
#>  4  2024 2015_20… Grea… Q64   Total    Conn… Refused  0.00410 In the … <chr [4]>
#>  5  2024 2015_20… Grea… Q64   Total    Grea… Yes      0.112   In the … <chr [4]>
#>  6  2024 2015_20… Grea… Q64   Total    Grea… No       0.882   In the … <chr [4]>
#>  7  2024 2015_20… Grea… Q64   Total    Grea… Don't k… 0.00175 In the … <chr [4]>
#>  8  2024 2015_20… Grea… Q64   Total    Grea… Refused  0.00395 In the … <chr [4]>
#>  9  2024 2015_20… Grea… Q64   Gender   Male  Yes      0.112   In the … <chr [4]>
#> 10  2024 2015_20… Grea… Q64   Gender   Male  No       0.882   In the … <chr [4]>
#> # ℹ 66 more rows

# make things easier with fetch_cws: flexibly grab by location, year, and/or
# filter conditions
fetch_cws(grepl("adequate shelter", question),
    .year = "2015_2024",
    .name = c("Connecticut", "Greater New Haven", "New Haven")
)
#> # A tibble: 3 × 6
#>    year span      name              code  question                      data    
#>   <dbl> <chr>     <chr>             <chr> <chr>                         <list>  
#> 1  2024 2015_2024 Connecticut       Q64   In the last 12 months, have … <tibble>
#> 2  2024 2015_2024 Greater New Haven Q64   In the last 12 months, have … <tibble>
#> 3  2024 2015_2024 New Haven         Q64   In the last 12 months, have … <tibble>
```
