# Fetching DCWS data

This package has a dataset of all the data extracted from all (or at
least most) the crosstabs for every DataHaven Community Wellbeing Survey
wave, a total of files. It’s all been cleaned up so that names,
categories, and groups should be standardized to match across every
location and year, and should be the same in the weights as in the data
tables themselves. Every data point has its corresponding question text
and code.

When it’s all combined and unnested, there are a few million rows of
data, and no one needs all of that. Instead, use the function
`fetch_cws` to pull out just the data you need, whether that’s just one
location across multiple years, multiple locations, a single question,
or whatever.

Here are some pretty common examples of how we might work with DCWS data
using this package and some tidyverse. I’ll mostly use some of the more
straightforward questions that we ask every year, with Greater New Haven
as an example because I know most of our demographic groups are
available.

``` r
library(dplyr)
library(dcws)
library(forcats)
```

A common thing we’ll present is a question represented as a single
number (percent responding “yes”, percent responding “strongly agree” or
“somewhat agree”, etc.) for the state, the region, a couple groups
within that region, and large towns in the region. For this, I’ll use
named arguments for the year and categories of respondents, plus some of
the open-ended filtering. I’ll start out looking at food insecurity,
since it’s a simple yes or no. Since I’m doing this a couple times, I’ll
write a (pretty crappy) function.

``` r
calc_food <- function(data) {
    data |>
        # get order that makes sense for this subset
        # mutate(group = fct_inorder(fct_drop(group))) |>
        sub_nonanswers() |> # remove don't know/refused & rescale values
        filter(
            group != "Other race",
            response == "Yes"
        ) |> # other race is only available in 2015
        select(span, name, category, group, value) |>
        mutate(value = round(value, digits = 2))
}
```

## Analysis

### One question, one year, few categories

``` r
food_21 <- fetch_cws(grepl("^Have there been times .+ food", question),
    .name = "Greater New Haven", .category = c("Total", "Race/Ethnicity", "Gender"),
    .year = 2021, .unnest = TRUE
) |>
    calc_food()

knitr::kable(food_21)
```

| span | name              | category       | group             | value |
|:-----|:------------------|:---------------|:------------------|------:|
| 2021 | Greater New Haven | Total          | Greater New Haven |  0.13 |
| 2021 | Greater New Haven | Gender         | Male              |  0.11 |
| 2021 | Greater New Haven | Gender         | Female            |  0.15 |
| 2021 | Greater New Haven | Race/Ethnicity | White             |  0.08 |
| 2021 | Greater New Haven | Race/Ethnicity | Black             |  0.20 |
| 2021 | Greater New Haven | Race/Ethnicity | Latino            |  0.28 |

### One question, several years, one location

``` r
food_trend <- fetch_cws(grepl("^Have there been times .+ food", question),
    .name = "Greater New Haven", .category = c("Total", "Race/Ethnicity", "Gender"),
    .unnest = TRUE
) |>
    calc_food()

knitr::kable(food_trend)
```

| span      | name              | category       | group             | value |
|:----------|:------------------|:---------------|:------------------|------:|
| 2015      | Greater New Haven | Total          | Greater New Haven |  0.14 |
| 2015      | Greater New Haven | Gender         | Male              |  0.11 |
| 2015      | Greater New Haven | Gender         | Female            |  0.16 |
| 2015      | Greater New Haven | Race/Ethnicity | White             |  0.11 |
| 2015      | Greater New Haven | Race/Ethnicity | Black             |  0.25 |
| 2015      | Greater New Haven | Race/Ethnicity | Latino            |  0.24 |
| 2018      | Greater New Haven | Total          | Greater New Haven |  0.13 |
| 2018      | Greater New Haven | Gender         | Male              |  0.12 |
| 2018      | Greater New Haven | Gender         | Female            |  0.14 |
| 2018      | Greater New Haven | Race/Ethnicity | White             |  0.09 |
| 2018      | Greater New Haven | Race/Ethnicity | Black             |  0.20 |
| 2018      | Greater New Haven | Race/Ethnicity | Latino            |  0.38 |
| 2021      | Greater New Haven | Total          | Greater New Haven |  0.13 |
| 2021      | Greater New Haven | Gender         | Male              |  0.11 |
| 2021      | Greater New Haven | Gender         | Female            |  0.15 |
| 2021      | Greater New Haven | Race/Ethnicity | White             |  0.08 |
| 2021      | Greater New Haven | Race/Ethnicity | Black             |  0.20 |
| 2021      | Greater New Haven | Race/Ethnicity | Latino            |  0.28 |
| 2015_2024 | Greater New Haven | Total          | Greater New Haven |  0.17 |
| 2015_2024 | Greater New Haven | Gender         | Male              |  0.14 |
| 2015_2024 | Greater New Haven | Gender         | Female            |  0.20 |
| 2015_2024 | Greater New Haven | Race/Ethnicity | White             |  0.12 |
| 2015_2024 | Greater New Haven | Race/Ethnicity | Black             |  0.26 |
| 2015_2024 | Greater New Haven | Race/Ethnicity | Latino            |  0.31 |
| 2024      | Greater New Haven | Total          | Greater New Haven |  0.21 |
| 2024      | Greater New Haven | Gender         | Male              |  0.18 |
| 2024      | Greater New Haven | Gender         | Female            |  0.23 |
| 2024      | Greater New Haven | Race/Ethnicity | White             |  0.16 |
| 2024      | Greater New Haven | Race/Ethnicity | Black             |  0.31 |
| 2024      | Greater New Haven | Race/Ethnicity | Latino            |  0.33 |

### One question, one year, compare groups and locations

I want just the location-wide values for towns in Greater New Haven, or
by race for Greater New Haven. I could do this filtering inside
`fetch_cws` if I wanted to dig into the nested data with `purrr`, but I
don’t, so I’ll just be a little redundant.

``` r
gnh_towns <- c("New Haven", "Hamden", "West Haven", "Milford")
food_towns <- fetch_cws(grepl("^Have there been times .+ food", question),
    .name = c("Greater New Haven", gnh_towns),
    .year = 2021, .unnest = TRUE
) |>
    filter((name == "Greater New Haven" & category %in% c("Total", "Race/Ethnicity")) |
        (group %in% gnh_towns)) |>
    calc_food() |>
    mutate(category = as_factor(ifelse(name == "Greater New Haven",
        as.character(category),
        "By town"
    )))

knitr::kable(food_towns)
```

| span | name              | category       | group             | value |
|:-----|:------------------|:---------------|:------------------|------:|
| 2021 | Greater New Haven | Total          | Greater New Haven |  0.13 |
| 2021 | Greater New Haven | Race/Ethnicity | White             |  0.08 |
| 2021 | Greater New Haven | Race/Ethnicity | Black             |  0.20 |
| 2021 | Greater New Haven | Race/Ethnicity | Latino            |  0.28 |
| 2021 | New Haven         | By town        | New Haven         |  0.15 |
| 2021 | Hamden            | By town        | Hamden            |  0.14 |
| 2021 | West Haven        | By town        | West Haven        |  0.18 |
| 2021 | Milford           | By town        | Milford           |  0.11 |

### Several questions with same responses

Usually I like to analyze questions separately because they might not
have the same set of responses, but for a bank of related questions you
can do them all at once. In 2020 we added a question about trust in
several types of institutions. I can’t remember the codes for them but
they all have “trust” in the question text. Using the `cws_codebook`
dataset, I can look up what those codes were by pattern-matching.

``` r
cws_codebook |>
    filter(grepl("How much trust", question)) |>
    filter(year == 2024) |>
    distinct(year, code, question)
#> # A tibble: 5 × 3
#>    year code   question                                                         
#>   <dbl> <chr>  <chr>                                                            
#> 1  2024 TRUSTA How much trust do you have in each of the following to look out …
#> 2  2024 TRUSTB How much trust do you have in each of the following to look out …
#> 3  2024 TRUSTC How much trust do you have in each of the following to look out …
#> 4  2024 TRUSTD How much trust do you have in each of the following to look out …
#> 5  2024 TRUSTE How much trust do you have in each of the following to look out …
```

Oh duh, the codes are all “TRUST” and then a letter!

The responses for these questions are a great deal, a fair amount, not
very much, or none at all. I’m going to collapse great deal and fair
amount into one, then present just that. Each question has the same
beginning text, then at the end names the institution being asked about.

``` r
trust_insts <- fetch_cws(grepl("^TRUST[A-Z]$", code),
    .name = "Greater New Haven", .year = 2021,
    .category = c("Total", "Age"), .unnest = TRUE
) |>
    mutate(
        response = fct_collapse(response, trust = c("A great deal", "A fair amount")),
        question = stringr::str_extract(question, "([\\w\\s]+)$") |>
            trimws() |>
            as_factor(),
        group = fct_inorder(fct_drop(group))
    ) |>
    group_by(category, group, question, response) |>
    summarise(value = sum(value)) |>
    sub_nonanswers() |>
    filter(response == "trust") |>
    mutate(value = round(value, digits = 2)) |>
    ungroup()

trust_insts |>
    tidyr::pivot_wider(id_cols = group, names_from = question) |>
    knitr::kable()
```

| group             | The Federal government | State government | Local government | Local health officials and healthcare workers | Local police and law enforcement |
|:------------------|-----------------------:|-----------------:|-----------------:|----------------------------------------------:|---------------------------------:|
| Greater New Haven |                   0.54 |             0.69 |             0.78 |                                          0.88 |                             0.82 |
| Ages 18-34        |                   0.43 |             0.69 |             0.81 |                                          0.85 |                             0.72 |
| Ages 35-49        |                   0.60 |             0.66 |             0.69 |                                          0.85 |                             0.85 |
| Ages 50-64        |                   0.47 |             0.66 |             0.75 |                                          0.87 |                             0.89 |
| Ages 65+          |                   0.64 |             0.70 |             0.79 |                                          0.91 |                             0.91 |

Lots of ways you could chop this data up now that you’ve got several
groups and several questions together.

### Comparing to the state

All the crosstabs include Connecticut total values to compare to. The
script that extracts all the crosstab data includes these, because
they’re sometimes useful: most of the tables and charts we publish of
survey data for one location includes state values. The benefit is that
if you want, say, Greater New Haven data, you don’t have to do anything
special to also have Connecticut totals. However, if you pull data for
multiple locations, this would be annoyingly redundant. So I’ve added an
argument `.drop_ct` that defaults to true, in which case Connecticut
values from other locations’ crosstabs are dropped before your data are
returned.

With `.drop_ct = TRUE` (the default):

``` r
fetch_cws(code == "Q1",
    .year = 2021, .name = "Greater New Haven",
    .category = c("Total", "Gender"), .unnest = TRUE
) |>
    distinct(year, name, category, group)
#> # A tibble: 3 × 4
#>    year name              category group            
#>   <dbl> <chr>             <fct>    <fct>            
#> 1  2021 Greater New Haven Total    Greater New Haven
#> 2  2021 Greater New Haven Gender   Male             
#> 3  2021 Greater New Haven Gender   Female
```

With `.drop_ct = FALSE`:

``` r
fetch_cws(code == "Q1",
    .year = 2021, .name = "Greater New Haven",
    .category = c("Total", "Gender"), .unnest = TRUE, .drop_ct = FALSE
) |>
    distinct(year, name, category, group)
#> # A tibble: 4 × 4
#>    year name              category group            
#>   <dbl> <chr>             <fct>    <fct>            
#> 1  2021 Greater New Haven Total    Connecticut      
#> 2  2021 Greater New Haven Total    Greater New Haven
#> 3  2021 Greater New Haven Gender   Male             
#> 4  2021 Greater New Haven Gender   Female
```

## Weights

The crosstabs each have a table of survey weights for each group, either
as a standalone section at the bottom of the Excel spreadsheet or as a
couple rows at the top of each question. `read_weights` now works with
either of these formats; for the latter, the weights are taken from the
first question (always the satisfied with your area question, which
every participant receives). Just like preparing this package meant
extracting all the data, there’s also a stash of all the weights from
all the files. These are useful for operations like collapsing multiple
small groups into larger ones, usually income brackets or other
groupings that may not be consistent between years or locations
otherwise.

There’s a function for getting weights on their own, with most of the
same arguments as for getting data…

``` r
head(fetch_wts(.year = 2021, .name = "Greater New Haven", .unnest = TRUE))
#> # A tibble: 6 × 5
#>    year span  name              group             weight
#>   <dbl> <chr> <chr>             <fct>              <dbl>
#> 1  2021 2021  Greater New Haven Connecticut        1    
#> 2  2021 2021  Greater New Haven Greater New Haven  1    
#> 3  2021 2021  Greater New Haven Male               0.471
#> 4  2021 2021  Greater New Haven Female             0.529
#> 5  2021 2021  Greater New Haven Ages 18-34         0.313
#> 6  2021 2021  Greater New Haven Ages 35-49         0.238
```

…or you can just use the `.add_wts` argument in `fetch_cws` to do this
for you. You can also use `collapse_n_wt` to help with the calculation,
but basically you’re collapsing several levels, then getting weighted
means.

One reason for doing this is that locations might have different income
brackets depending on sample size, and we’ve moved toward using larger
income brackets in the latest wave of the survey. So in addition to
sample size, you might also collapse groups so you can compare across
locations or years.

For example, check out how obnoxious this is:

``` r
satisfied_area <- fetch_cws(grepl("satisfied with the city", question),
    .name = c("Connecticut", "Greater New Haven", "New Haven"),
    .unnest = TRUE, .category = c("Total", "Income")
)

satisfied_area |>
    filter(category == "Income") |>
    distinct(year, name, group) |>
    mutate(value = "x", id = paste(name, year)) |>
    tidyr::pivot_wider(
        id_cols = group,
        names_from = id,
        values_from = value,
        names_sort = TRUE,
        values_fill = ""
    ) |>
    arrange(group) |>
    knitr::kable()
```

| group         | Connecticut 2015 | Connecticut 2018 | Connecticut 2020 | Connecticut 2021 | Connecticut 2022 | Connecticut 2024 | Connecticut 2025 | Greater New Haven 2015 | Greater New Haven 2018 | Greater New Haven 2021 | Greater New Haven 2024 | New Haven 2015 | New Haven 2018 | New Haven 2021 | New Haven 2024 |
|:--------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------------|:-----------------------|:-----------------------|:-----------------------|:---------------|:---------------|:---------------|:---------------|
| \<\$15K       | x                | x                | x                |                  | x                |                  |                  | x                      | x                      |                        |                        |                |                |                |                |
| \$15K-\$30K   | x                | x                | x                |                  | x                |                  |                  | x                      | x                      |                        |                        |                |                |                |                |
| \<\$30K       |                  |                  |                  | x                |                  | x                | x                |                        |                        | x                      | x                      | x              | x              | x              | x              |
| \$30K-\$50K   | x                | x                | x                |                  | x                |                  |                  | x                      | x                      |                        |                        |                |                |                |                |
| \$30K-\$75K   |                  |                  |                  |                  |                  |                  |                  |                        |                        |                        |                        | x              | x              |                |                |
| \$30K-\$100K  |                  |                  |                  | x                |                  | x                | x                |                        |                        | x                      | x                      |                |                | x              | x              |
| \$50K-\$75K   | x                | x                | x                |                  | x                |                  |                  | x                      | x                      |                        |                        |                |                |                |                |
| \$75K-\$100K  | x                | x                | x                |                  | x                |                  |                  | x                      | x                      |                        |                        |                |                |                |                |
| \$75K+        |                  |                  |                  |                  |                  |                  |                  |                        |                        |                        |                        | x              | x              |                |                |
| \$100K-\$200K | x                | x                | x                |                  | x                | x                | x                | x                      | x                      |                        |                        |                |                |                |                |
| \$100K+       |                  |                  |                  | x                |                  |                  |                  |                        |                        | x                      | x                      |                |                | x              | x              |
| \$200K+       | x                | x                | x                |                  | x                | x                | x                | x                      | x                      |                        |                        |                |                |                |                |

Yikes

So you’ll probably want to collapse some of those, like so:

``` r
asthma18 <- fetch_cws(question == "Asthma",
    .year = 2018, .name = "Greater New Haven",
    .category = c("Total", "Income", "Race/Ethnicity"), .add_wts = TRUE, .unnest = TRUE
) |>
    collapse_n_wt(year:response,
        .lvls = list(
            "<$30K" = c("<$15K", "$15K-$30K"),
            "$30K-$100K" = c("$30K-$50K", "$50K-$75K", "$75K-$100K"),
            "$100K+" = c("$100K-$200K", "$200K+")
        )
    ) |>
    sub_nonanswers() |>
    mutate(value = round(value, digits = 2)) |>
    filter(response == "Yes")

knitr::kable(asthma18)
```

| year | span | name              | code | question | category       | group             | response | value |
|-----:|:-----|:------------------|:-----|:---------|:---------------|:------------------|:---------|------:|
| 2018 | 2018 | Greater New Haven | Q23E | Asthma   | Total          | Greater New Haven | Yes      |  0.15 |
| 2018 | 2018 | Greater New Haven | Q23E | Asthma   | Race/Ethnicity | White             | Yes      |  0.13 |
| 2018 | 2018 | Greater New Haven | Q23E | Asthma   | Race/Ethnicity | Black             | Yes      |  0.19 |
| 2018 | 2018 | Greater New Haven | Q23E | Asthma   | Race/Ethnicity | Latino            | Yes      |  0.25 |
| 2018 | 2018 | Greater New Haven | Q23E | Asthma   | Income         | \<\$30K           | Yes      |  0.22 |
| 2018 | 2018 | Greater New Haven | Q23E | Asthma   | Income         | \$30K-\$100K      | Yes      |  0.13 |
| 2018 | 2018 | Greater New Haven | Q23E | Asthma   | Income         | \$100K+           | Yes      |  0.14 |

## Single year vs pooled years

One thing we added with the 2024 survey was a set of crosstabs for
multiple years, pooled together and weighted accordingly. For small
locations or groups with small sample sizes, this lets us get more
granularity than we would have for a single year. So far 2024 is the
only year/endyear this applies to, but presumably future survey waves
will have this available as well.

Usually your argument for `year` will be a single number, the year the
survey was carried out. Pooled crosstabs are labeled with the endpoints,
so crosstabs made up of surveys between 2015 and 2024 will be labeled
`"2015_2024"`. When you call `fetch_cws`, there are now 2 year-related
columns: a numeric one, `year`, with the last year of the crosstabs, and
a character one, `span`, with the range of years included. For crosstabs
of only 2024 data, both will say `2024`, but for crosstabs of 2015-2024
data, the year will be `2024` and the span will be `2015_2024`. If you
want single-year data, give the year as a single numeric year; if you
want pooled data, give the year in this `"{start_year}_{end_year}"`
format.

``` r
fetch_cws(
    code == "Q1",
    .year = "2015_2024",
    .name = "New Haven",
    .category = "Age"
)
#> # A tibble: 1 × 6
#>    year span      name      code  question                              data    
#>   <dbl> <chr>     <chr>     <chr> <chr>                                 <list>  
#> 1  2024 2015_2024 New Haven Q1    Are you satisfied with the city or a… <tibble>
```

If you want both single and pooled data (you probably don’t), you can
utilize the filtering done in the `...` argument instead, as they’ll
both have an endyear of 2024:

``` r
fetch_cws(
    year == 2024,
    code == "Q1",
    .name = "New Haven",
    .category = "Age"
)
#> # A tibble: 2 × 6
#>    year span      name      code  question                              data    
#>   <dbl> <chr>     <chr>     <chr> <chr>                                 <list>  
#> 1  2024 2015_2024 New Haven Q1    Are you satisfied with the city or a… <tibble>
#> 2  2024 2024      New Haven Q1    Are you satisfied with the city or a… <tibble>
```

If you’re getting multiple years but *don’t* want any pooled data, you
can instead use the filtering to only get surveys where year and span
match:

``` r
fetch_cws(
    as.character(year) == span,
    code == "Q1",
    .name = "New Haven",
    .category = "Age"
)
#> # A tibble: 4 × 6
#>    year span  name      code  question                                  data    
#>   <dbl> <chr> <chr>     <chr> <chr>                                     <list>  
#> 1  2015 2015  New Haven Q1    Are you satisfied with the city or area … <tibble>
#> 2  2018 2018  New Haven Q1    Are you satisfied with the city or area … <tibble>
#> 3  2021 2021  New Haven Q1    Are you satisfied with the city or area … <tibble>
#> 4  2024 2024  New Haven Q1    Are you satisfied with the city or area … <tibble>
```

## Output

That’s it! Usually I’ll save a bunch of related analyses into lists of
data frames, and then write those out to rds files for easy loading.
