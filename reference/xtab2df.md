# Extract survey data and descriptions from crosstabs into a tidy data frame

Like `read_xtab` & `read_weights`, this is a bespoke function to make it
easier to extract data from the DataHaven Community Wellbeing Survey.
Applications to other crosstabs are probably limited unless their
formatting is largely the same. After reading a crosstab excel file,
`xtab2df` extracts the question codes (e.g. Q4A), question text,
categories, and demographic groups, and joins those descriptions with
survey responses and values, making it ready for analysis. Under the
hood there are 2 versions of this function: one for crosstabs generated
from SPSS (pre-2024 DCWS), and one for crosstabs generated at DataHaven
starting in 2024. Those in-house crosstabs don't have categories
included in headings in excel, but this function will add them.

## Usage

``` r
xtab2df(data, year, col = x1, code_pattern = NULL, verbose = TRUE)
```

## Arguments

- data:

  A data frame as returned from `read_xtab`.

- year:

  Numeric: year of the survey (or end year, in the case of pooled data).
  This tells the functions how to read the files, since formatting has
  changed across years of the survey. Because the ability to read a file
  depends so much on the year for which it was produced, this argument
  no longer has a default; instead it must be supplied explicitly.

- col:

  The bare column name of where to find question codes and text.
  Default: x1, based on names assigned by `read_xtab`

- code_pattern:

  String: regex pattern denoting how to find cells that contain only a
  question code, such as "Q10", "Q4B", or "ASTHMA", or to split codes
  and question text within the same cell. This is pretty finicky, so you
  probably don't want to change it. If `NULL` (the default), the
  function will fill in `"^[A-Z\\d_]{2,20}$"` for years before 2024, or
  `"^[A-Z\\d_]+(?=\\. )"` for 2024 onward.

- verbose:

  Boolean: whether to print helpful information to the console. Defaults
  `TRUE`.

## Value

A data frame with the following columns:

- code (if questions have codes in crosstabs)

- q_number (if questions don't have codes in crosstabs, assigned in
  order they occur)

- question

- category (e.g. age, gender)

- group (e.g. 18-34, male)

- response

- value

## See also

[`read_xtabs()`](https://ct-data-haven.github.io/dcws/reference/read_xtabs.md)

Other data accessing functions:
[`fetch_cws()`](https://ct-data-haven.github.io/dcws/reference/fetch_cws.md),
[`fetch_wts()`](https://ct-data-haven.github.io/dcws/reference/fetch_wts.md),
[`read_xtabs()`](https://ct-data-haven.github.io/dcws/reference/read_xtabs.md)

## Examples

``` r
if (interactive()) {
    xt <- system.file("extdata/test_xtab2018.xlsx", package = "dcws")
    xtab <- read_xtabs(xt, year = 2018)
    xtab2df(xtab, year = 2018)
}
```
