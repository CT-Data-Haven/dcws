# Clean up categories and groups from crosstabs

This is a bunch of string cleaning to standardize the categories
(Gender, Age, etc) and groups (Male, Ages 65+, etc) across all available
crosstabs. This does the same operation on both categories and groups
because there is some overlap. The lists of regex and other replacements
aren't exported, but they aren't hidden either: access them at
`dcws:::to_replace`, `dcws:::to_remove`, `dcws:::to_recode`, or
`dcws:::to_collapse` if you need them.

## Usage

``` r
clean_cws_lvls(x, is_category = FALSE, order = FALSE)
```

## Arguments

- x:

  A vector. If not a factor already, will be coerced to one.

- is_category:

  Boolean: if `FALSE`, assume these are groups (e.g. "High school or
  less", "Some college or Associate's") rather than categories (e.g.
  "Education").

- order:

  Boolean: if `TRUE`, groups will be put into logical order (e.g.
  \<\$30K, \$30K-\$100K). This only applies to groups (i.e.
  `is_category = FALSE`), and only really affects ages and income
  groups. If `FALSE` (default), levels will be kept in the same order as
  they were received.

## Value

A factor of the same length as `x`

## Examples

``` r
# vector of strings as read in from crosstabs
categories <- c(
    "Connecticut", "NH Inner Ring", "Gender", "Age",
    "Race/Ethnicity", "Education", "Income", "Children in HH"
)
levels(clean_cws_lvls(categories, is_category = TRUE))
#> [1] "Connecticut"          "New Haven Inner Ring" "Gender"              
#> [4] "Age"                  "Race/Ethnicity"       "Education"           
#> [7] "Income"               "With children"       

groups <- c(
    "M", "F", "18-34", "35 to 49", "65 and older",
    "Black/Afr Amer", "African American/Black", "High School",
    "Less than $15,000", "$15,000 to $30,000", "No"
)
levels(clean_cws_lvls(groups))
#>  [1] "Male"        "Female"      "Ages 18-34"  "Ages 35-49"  "Ages 65+"   
#>  [6] "Black"       "High school" "<$15K"       "$15K-$30K"   "No kids"    
```
