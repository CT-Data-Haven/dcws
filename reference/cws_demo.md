# DCWS demo data

This is a small sample of 2018 DataHaven Community Wellbeing Survey data
for Greater New Haven with weights attached, saved here for use in
examples and testing. It was created with the `fetch_cws` function.

## Usage

``` r
cws_demo
```

## Format

A data frame with 32 rows and 9 variables:

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

- weight:

  Weights per group for aggregating

## Source

Sample of DCWS crosstabs

## See also

[`fetch_cws()`](https://ct-data-haven.github.io/dcws/reference/fetch_cws.md)

## Examples

``` r
cws_demo
#> # A tibble: 32 × 9
#>     year span  name              code  category group      response value weight
#>    <dbl> <chr> <chr>             <chr> <fct>    <fct>      <fct>    <dbl>  <dbl>
#>  1  2018 2018  Greater New Haven Q1    Total    Greater N… Yes       0.81   1   
#>  2  2018 2018  Greater New Haven Q1    Total    Greater N… No        0.18   1   
#>  3  2018 2018  Greater New Haven Q1    Total    Greater N… Don't k…  0.01   1   
#>  4  2018 2018  Greater New Haven Q1    Total    Greater N… Refused   0      1   
#>  5  2018 2018  Greater New Haven Q1    Income   <$15K      Yes       0.73   0.09
#>  6  2018 2018  Greater New Haven Q1    Income   <$15K      No        0.26   0.09
#>  7  2018 2018  Greater New Haven Q1    Income   <$15K      Don't k…  0      0.09
#>  8  2018 2018  Greater New Haven Q1    Income   <$15K      Refused   0      0.09
#>  9  2018 2018  Greater New Haven Q1    Income   $15K-$30K  Yes       0.72   0.11
#> 10  2018 2018  Greater New Haven Q1    Income   $15K-$30K  No        0.27   0.11
#> # ℹ 22 more rows
```
