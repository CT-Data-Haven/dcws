# Fetch and subset DCWS data

This function returns the split data from `cws_full_data` in a nicer
format, with options for subsetting. Filtering by year, location name,
and category are named options, any of which take a vector of one or
more values, but any valid conditions can be passed to `...` for more
flexible filtering. For any named options, `NULL`, the default, will
mean no filtering is done by that column.

## Usage

``` r
fetch_cws(
  ...,
  .year = NULL,
  .name = NULL,
  .category = NULL,
  .unnest = FALSE,
  .add_wts = FALSE,
  .drop_ct = TRUE,
  .incl_questions = TRUE
)
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

- .category:

  A vector of one or more strings giving the category(ies) to subset by.
  If `NULL`, no filtering is done by category.

- .unnest:

  Boolean: should data be returned nested into a column called `data`?
  Defaults to `FALSE`.

- .add_wts:

  Boolean: should groups' survey weights be attached, via a left-join
  with
  [`dcws::cws_full_wts`](https://ct-data-haven.github.io/dcws/reference/cws_full_wts.md)?
  This is useful if you need to collapse groups later; otherwise you
  might get stuck in annoying
  [`tidyr::unnest`](https://tidyr.tidyverse.org/reference/unnest.html)
  messes.

- .drop_ct:

  Boolean: should statewide totals be included for each crosstab
  extract? This can be useful for a single location in order to have
  Connecticut values to compare against, but becomes redundant with
  multiple locations. The default `TRUE` means statewide averages will
  not be included.

- .incl_questions:

  Boolean: should the full text of each question be included? If
  `FALSE`, questions will be demarcated by just their codes, which take
  up less space but can change year to year. Defaults `TRUE`.

## Value

A data frame, with between 5 and 10 columns, depending on arguments:

- Columns `year`, `span`, `name`, and `code` are always included

- If `.incl_questions = TRUE`, column `question` is included

- If `.unnest = TRUE`, the crosstab data will be in columns `category`,
  `group`, `response`, and `value`

- If `.unnest = FALSE`, crosstab data columns will be nested in a
  list-column called `data`

- If `.add_wts = TRUE`, column `weight` is included Note that the `span`
  column, a new addition, is a string giving the span of years included
  in that set of survey data. For single years, this will be the same as
  `year`; in the case of a pooled dataset 2015-2024, `year` will be
  `2024` and `span` will be `"2015_2024"`.

## See also

[`fetch_wts()`](https://ct-data-haven.github.io/dcws/reference/fetch_wts.md)
[cws_full_data](https://ct-data-haven.github.io/dcws/reference/cws_full_data.md)

Other accessing:
[`fetch_wts()`](https://ct-data-haven.github.io/dcws/reference/fetch_wts.md),
[`read_xtabs()`](https://ct-data-haven.github.io/dcws/reference/read_xtabs.md),
[`xtab2df()`](https://ct-data-haven.github.io/dcws/reference/xtab2df.md)

## Examples

``` r
# no filtering
fetch_cws()
#> # A tibble: 38,446 × 6
#>     year span  name  code  question                                     data    
#>    <dbl> <chr> <chr> <chr> <chr>                                        <list>  
#>  1  2015 2015  5CT   Q1    Are you satisfied with the city or area whe… <tibble>
#>  2  2015 2015  5CT   Q2    As a place to live, is the city or area whe… <tibble>
#>  3  2015 2015  5CT   Q3A   How responsive local government is to the n… <tibble>
#>  4  2015 2015  5CT   Q3B   The availability of the goods and services … <tibble>
#>  5  2015 2015  5CT   Q3C   The job done by the police to keep resident… <tibble>
#>  6  2015 2015  5CT   Q3D   The ability of residents to obtain suitable… <tibble>
#>  7  2015 2015  5CT   Q3E   As a place to raise children                 <tibble>
#>  8  2015 2015  5CT   Q3F   The condition of public parks and other pub… <tibble>
#>  9  2015 2015  5CT   Q4    Over the past 12 months, have you volunteer… <tibble>
#> 10  2015 2015  5CT   Q5    How would you describe your ability to infl… <tibble>
#> # ℹ 38,436 more rows

# filter by year, name, and/or category
fetch_cws(.name = c("Greater New Haven", "New Haven")) # all years
#> # A tibble: 1,217 × 6
#>     year span  name              code  question                         data    
#>    <dbl> <chr> <chr>             <chr> <chr>                            <list>  
#>  1  2015 2015  Greater New Haven Q1    Are you satisfied with the city… <tibble>
#>  2  2015 2015  Greater New Haven Q2    As a place to live, is the city… <tibble>
#>  3  2015 2015  Greater New Haven Q3A   How responsive local government… <tibble>
#>  4  2015 2015  Greater New Haven Q3B   The availability of the goods a… <tibble>
#>  5  2015 2015  Greater New Haven Q3C   The job done by the police to k… <tibble>
#>  6  2015 2015  Greater New Haven Q3D   The ability of residents to obt… <tibble>
#>  7  2015 2015  Greater New Haven Q3E   As a place to raise children     <tibble>
#>  8  2015 2015  Greater New Haven Q3F   The condition of public parks a… <tibble>
#>  9  2015 2015  Greater New Haven Q4    Over the past 12 months, have y… <tibble>
#> 10  2015 2015  Greater New Haven Q5    How would you describe your abi… <tibble>
#> # ℹ 1,207 more rows
fetch_cws(.year = 2024, .name = c("Greater New Haven", "New Haven"))
#> # A tibble: 244 × 6
#>     year span  name              code   question                        data    
#>    <dbl> <chr> <chr>             <chr>  <chr>                           <list>  
#>  1  2024 2024  Greater New Haven Q1     Are you satisfied with the cit… <tibble>
#>  2  2024 2024  Greater New Haven Q2     As a place to live, is the cit… <tibble>
#>  3  2024 2024  Greater New Haven Q4A    [KEY: Now I'm going to ask you… <tibble>
#>  4  2024 2024  Greater New Haven Q4D    The job done by the police to … <tibble>
#>  5  2024 2024  Greater New Haven Q4E    The ability of residents to ob… <tibble>
#>  6  2024 2024  Greater New Haven Q4F    As a place to raise children    <tibble>
#>  7  2024 2024  Greater New Haven Q4G    The condition of public parks … <tibble>
#>  8  2024 2024  Greater New Haven Q4H    The availability of affordable… <tibble>
#>  9  2024 2024  Greater New Haven Q6     How would you describe your ab… <tibble>
#> 10  2024 2024  Greater New Haven TRUSTA How much trust do you have in … <tibble>
#> # ℹ 234 more rows
fetch_cws(.year = "2015_2024", .name = "New Haven", .category = c("Total", "Age", "Gender"))
#> # A tibble: 92 × 6
#>     year span      name      code   question                            data    
#>    <dbl> <chr>     <chr>     <chr>  <chr>                               <list>  
#>  1  2024 2015_2024 New Haven Q1     Are you satisfied with the city or… <tibble>
#>  2  2024 2015_2024 New Haven Q2     As a place to live, is the city or… <tibble>
#>  3  2024 2015_2024 New Haven Q4A    [KEY: Now I'm going to ask you to … <tibble>
#>  4  2024 2015_2024 New Haven Q4D    The job done by the police to keep… <tibble>
#>  5  2024 2015_2024 New Haven Q4E    The ability of residents to obtain… <tibble>
#>  6  2024 2015_2024 New Haven Q4F    As a place to raise children        <tibble>
#>  7  2024 2015_2024 New Haven Q4G    The condition of public parks and … <tibble>
#>  8  2024 2015_2024 New Haven Q4H    The availability of affordable, hi… <tibble>
#>  9  2024 2015_2024 New Haven Q6     How would you describe your abilit… <tibble>
#> 10  2024 2015_2024 New Haven TRUSTA How much trust do you have in each… <tibble>
#> # ℹ 82 more rows

# filter by conditions
fetch_cws(code == "Q4E", .year = 2018, .name = c("Greater New Haven", "New Haven"), .unnest = TRUE)
#> # A tibble: 240 × 9
#>     year span  name              code  question    category group response value
#>    <dbl> <chr> <chr>             <chr> <chr>       <fct>    <fct> <fct>    <dbl>
#>  1  2018 2018  Greater New Haven Q4E   The abilit… Total    Grea… Excelle…  0.08
#>  2  2018 2018  Greater New Haven Q4E   The abilit… Total    Grea… Good      0.34
#>  3  2018 2018  Greater New Haven Q4E   The abilit… Total    Grea… Fair      0.32
#>  4  2018 2018  Greater New Haven Q4E   The abilit… Total    Grea… Poor      0.11
#>  5  2018 2018  Greater New Haven Q4E   The abilit… Total    Grea… Don't k…  0.14
#>  6  2018 2018  Greater New Haven Q4E   The abilit… Total    Grea… Refused   0   
#>  7  2018 2018  Greater New Haven Q4E   The abilit… Gender   Male  Excelle…  0.08
#>  8  2018 2018  Greater New Haven Q4E   The abilit… Gender   Male  Good      0.35
#>  9  2018 2018  Greater New Haven Q4E   The abilit… Gender   Male  Fair      0.33
#> 10  2018 2018  Greater New Haven Q4E   The abilit… Gender   Male  Poor      0.12
#> # ℹ 230 more rows
fetch_cws(grepl("Q4[A-Z]", code), .year = 2018, .name = c("Greater New Haven", "New Haven"))
#> # A tibble: 12 × 6
#>     year span  name              code  question                         data    
#>    <dbl> <chr> <chr>             <chr> <chr>                            <list>  
#>  1  2018 2018  Greater New Haven Q4A   How responsive local government… <tibble>
#>  2  2018 2018  Greater New Haven Q4D   The job done by the police to k… <tibble>
#>  3  2018 2018  Greater New Haven Q4E   The ability of residents to obt… <tibble>
#>  4  2018 2018  Greater New Haven Q4F   As a place to raise children     <tibble>
#>  5  2018 2018  Greater New Haven Q4G   The condition of public parks a… <tibble>
#>  6  2018 2018  Greater New Haven Q4H   The availability of affordable,… <tibble>
#>  7  2018 2018  New Haven         Q4A   How responsive local government… <tibble>
#>  8  2018 2018  New Haven         Q4D   The job done by the police to k… <tibble>
#>  9  2018 2018  New Haven         Q4E   The ability of residents to obt… <tibble>
#> 10  2018 2018  New Haven         Q4F   As a place to raise children     <tibble>
#> 11  2018 2018  New Haven         Q4G   The condition of public parks a… <tibble>
#> 12  2018 2018  New Haven         Q4H   The availability of affordable,… <tibble>
fetch_cws(grepl("health insurance", question), year > 2015, .name = "New Haven")
#> # A tibble: 14 × 6
#>     year span      name      code   question                            data    
#>    <dbl> <chr>     <chr>     <chr>  <chr>                               <list>  
#>  1  2018 2018      New Haven Q26    Do you have health insurance?       <tibble>
#>  2  2018 2018      New Haven Q27    (If have health insurance) What ty… <tibble>
#>  3  2018 2018      New Haven Q30B   The doctor or hospital wouldn't ac… <tibble>
#>  4  2021 2021      New Haven Q26    Do you have health insurance?       <tibble>
#>  5  2021 2021      New Haven Q27    (If yes) What type of health insur… <tibble>
#>  6  2024 2015_2024 New Haven Q26    Do you have health insurance?       <tibble>
#>  7  2024 2015_2024 New Haven Q27    (If yes to Do you have health insu… <tibble>
#>  8  2024 2015_2024 New Haven Q30B   (Did you not get the medical care … <tibble>
#>  9  2024 2024      New Haven Q26    Do you have health insurance?       <tibble>
#> 10  2024 2024      New Haven Q27    (If yes to Do you have health insu… <tibble>
#> 11  2024 2024      New Haven Q30B   (Did you not get the medical care … <tibble>
#> 12  2024 2024      New Haven MENTHC (If yes to During the past 12 mont… <tibble>
#> 13  2024 2024      New Haven MENTHD (If yes to During the past 12 mont… <tibble>
#> 14  2024 2024      New Haven HCAS   CALCULATED: Health care access sco… <tibble>
fetch_cws(question %in% c("Diabetes", "Asthma"), .name = "Bridgeport")
#> # A tibble: 10 × 6
#>     year span      name       code  question data             
#>    <dbl> <chr>     <chr>      <chr> <chr>    <list>           
#>  1  2015 2015      Bridgeport Q23C  Diabetes <tibble [80 × 4]>
#>  2  2015 2015      Bridgeport Q23E  Asthma   <tibble [80 × 4]>
#>  3  2018 2018      Bridgeport Q23C  Diabetes <tibble [72 × 4]>
#>  4  2018 2018      Bridgeport Q23E  Asthma   <tibble [72 × 4]>
#>  5  2021 2021      Bridgeport Q23C  Diabetes <tibble [72 × 4]>
#>  6  2021 2021      Bridgeport Q23E  Asthma   <tibble [72 × 4]>
#>  7  2024 2015_2024 Bridgeport Q23C  Diabetes <tibble [72 × 4]>
#>  8  2024 2015_2024 Bridgeport Q23E  Asthma   <tibble [72 × 4]>
#>  9  2024 2024      Bridgeport Q23C  Diabetes <tibble [96 × 4]>
#> 10  2024 2024      Bridgeport Q23E  Asthma   <tibble [96 × 4]>

# how you might use this to make a beautiful table
fetch_cws(code == "Q1", .year = 2021, .category = c("Income", "Gender"), .unnest = TRUE) |>
    dplyr::group_by(name, category, group) |>
    # might want to remove refused, don't know responses
    sub_nonanswers() |>
    dplyr::filter(response == "Yes") |>
    tidyr::pivot_wider(id_cols = name, names_from = group, values_from = value)
#> # A tibble: 34 × 6
#> # Groups:   name [34]
#>    name               Male Female `<$30K` `$30K-$100K` `$100K+`
#>    <chr>             <dbl>  <dbl>   <dbl>        <dbl>    <dbl>
#>  1 Bridgeport        0.788  0.778   0.758        0.778    0.814
#>  2 Bristol           0.78   0.888  NA           NA       NA    
#>  3 Connecticut       0.888  0.889   0.798        0.879    0.919
#>  4 Danbury           0.94   0.929   0.99         0.94     0.929
#>  5 Fairfield County  0.87   0.899   0.798        0.889    0.929
#>  6 Greater Hartford  0.898  0.89    0.828        0.908    0.960
#>  7 Greater New Haven 0.869  0.879   0.828        0.899    0.87 
#>  8 Greater Waterbury 0.85   0.837   0.7          0.828    0.92 
#>  9 Greenwich         0.89   0.980   0.94         0.929    0.939
#> 10 Hartford          0.716  0.75    0.673        0.760    0.818
#> # ℹ 24 more rows

# adding weights to collapse groups (e.g. combining income brackets)
fetch_cws(code == "Q1", .year = 2021, .add_wts = TRUE)
#> # A tibble: 35 × 6
#>     year span  name              code  question                         data    
#>    <dbl> <chr> <chr>             <chr> <chr>                            <list>  
#>  1  2021 2021  Bridgeport        Q1    Are you satisfied with the city… <tibble>
#>  2  2021 2021  Bristol           Q1    Are you satisfied with the city… <tibble>
#>  3  2021 2021  Connecticut       Q1    Are you satisfied with the city… <tibble>
#>  4  2021 2021  Danbury           Q1    Are you satisfied with the city… <tibble>
#>  5  2021 2021  Fairfield County  Q1    Are you satisfied with the city… <tibble>
#>  6  2021 2021  Greater Hartford  Q1    Are you satisfied with the city… <tibble>
#>  7  2021 2021  Greater New Haven Q1    Are you satisfied with the city… <tibble>
#>  8  2021 2021  Greater Waterbury Q1    Are you satisfied with the city… <tibble>
#>  9  2021 2021  Greenwich         Q1    Are you satisfied with the city… <tibble>
#> 10  2021 2021  Hartford          Q1    Are you satisfied with the city… <tibble>
#> # ℹ 25 more rows
fetch_cws(
    .year = 2021, .name = "New Haven", .category = c("Total", "Age", "Income"),
    .add_wts = TRUE, .unnest = TRUE
)
#> # A tibble: 3,294 × 10
#>     year span  name      code  question     category group response value weight
#>    <dbl> <chr> <chr>     <chr> <chr>        <fct>    <fct> <fct>    <dbl>  <dbl>
#>  1  2021 2021  New Haven Q1    Are you sat… Total    New … Yes       0.82  1    
#>  2  2021 2021  New Haven Q1    Are you sat… Total    New … No        0.17  1    
#>  3  2021 2021  New Haven Q1    Are you sat… Total    New … Don't k…  0.01  1    
#>  4  2021 2021  New Haven Q1    Are you sat… Total    New … Refused   0     1    
#>  5  2021 2021  New Haven Q1    Are you sat… Age      Ages… Yes       0.8   0.456
#>  6  2021 2021  New Haven Q1    Are you sat… Age      Ages… No        0.2   0.456
#>  7  2021 2021  New Haven Q1    Are you sat… Age      Ages… Don't k…  0     0.456
#>  8  2021 2021  New Haven Q1    Are you sat… Age      Ages… Refused   0     0.456
#>  9  2021 2021  New Haven Q1    Are you sat… Age      Ages… Yes       0.82  0.219
#> 10  2021 2021  New Haven Q1    Are you sat… Age      Ages… No        0.18  0.219
#> # ℹ 3,284 more rows
```
