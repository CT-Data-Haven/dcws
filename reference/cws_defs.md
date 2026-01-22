# DCWS indicator definitions

This data frame is a reference of how indicators are defined, such as
Likert questions that get collapsed into a single number (e.g. strongly
agree & somewhat agree –\> percent agree). It also has more complicated
indicators, such as smoking rate and underemployment, and responses used
to calculate each. Responses should be consistent across years.

## Usage

``` r
cws_defs
```

## Format

A data frame with 33 rows and 3 variables:

- indicator:

  Text of abbreviated indicator name, e.g. "safe biking"

- question:

  Text of question as given on the survey with punctuation and capital
  letters removed, e.g. "there are places to bicycle in or near my
  neighborhood that are safe from traffic such as on the street or on
  special lanes separate paths or trails"

- `collapsed_responses`:

  Comma-separated text of responses that are collapsed into the
  indicator, e.g. "Strongly agree, Somewhat agree".

## Source

Handwritten by Camille for the upcoming glossary project

## Examples

``` r
cws_defs
#> # A tibble: 33 × 3
#>    indicator                 question                        collapsed_responses
#>    <chr>                     <chr>                           <chr>              
#>  1 financial_insecurity      How well would you say you are… just getting by / …
#>  2 food_insecurity           Have there been times in the p… yes / no           
#>  3 housing_insecurity        In the last 12 months, have yo… yes / no           
#>  4 transport_insecurity      In the past 12 months, did you… yes / no           
#>  5 car_access                Do you have access to a car wh… very often / fairl…
#>  6 locations_in_walking_dist Many stores, banks, markets or… strongly agree / a…
#>  7 safe_biking               There are places to bicycle in… strongly agree / a…
#>  8 local_rec_facilities      My neighborhood has several fr… strongly agree / a…
#>  9 safe_to_walk_at_night     I do not feel safe to go on wa… strongly disagree …
#> 10 trust_neighbors           People in this neighborhood ca… strongly agree / a…
#> # ℹ 23 more rows
```
