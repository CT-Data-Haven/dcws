# DCWS codebook

This is a data frame of all the codes and questions, and corresponding
possible responses, for each year of the survey. Previously this was
part of the `cws_full_data` data frame, but is now split out on its own
to reduce redundancy and save space. Note that surveys are identified
only by year, not span; pooled data use codes following their endyears.

## Usage

``` r
cws_codebook
```

## Format

A data frame with 905 rows and 4 variables:

- year:

  Numeric, year of survey

- code:

  Character, question code

- question:

  Character, full text of survey question

- responses:

  List of character vectors, of all possible responses for each question

## Source

Compiled DCWS crosstabs

## Examples

``` r
cws_codebook |>
    dplyr::filter(grepl("adequate shelter", question))
#> # A tibble: 7 × 4
#>    year code  question                                                 responses
#>   <dbl> <chr> <chr>                                                    <list>   
#> 1  2015 Q66   In the last 12 months, have you not had enough money to… <chr [4]>
#> 2  2018 Q64   In the last 12 months, have you not had enough money to… <chr [4]>
#> 3  2020 Q64   In the last 12 months, have you not had enough money to… <chr [4]>
#> 4  2021 Q64   In the last 12 months, have you not had enough money to… <chr [4]>
#> 5  2022 Q132  In the last 12 months, have you not had enough money to… <chr [4]>
#> 6  2024 Q64   In the last 12 months, have you not had enough money to… <chr [4]>
#> 7  2025 Q64   In the last 12 months, have you not had enough money to… <chr [4]>

cws_codebook |>
    dplyr::filter(grepl("adequate shelter", question), year == 2024) |>
    tidyr::unnest(responses)
#> # A tibble: 4 × 4
#>    year code  question                                                 responses
#>   <dbl> <chr> <chr>                                                    <chr>    
#> 1  2024 Q64   In the last 12 months, have you not had enough money to… Yes      
#> 2  2024 Q64   In the last 12 months, have you not had enough money to… No       
#> 3  2024 Q64   In the last 12 months, have you not had enough money to… Don't kn…
#> 4  2024 Q64   In the last 12 months, have you not had enough money to… Refused  
```
