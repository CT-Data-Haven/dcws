# Read crosstab data and weights

These two functions facilitate reading in Excel spreadsheets of
crosstabs generated from SPSS. Note that they're likely only useful for
working with the DataHaven Community Wellbeing Survey.

## Usage

``` r
read_xtabs(
  path,
  year = NULL,
  name_prefix = "x",
  marker = "Nature of the [Ss]ample",
  process = FALSE,
  verbose = TRUE,
  ...
)

read_weights(
  path,
  year = NULL,
  marker = "Nature of the [Ss]ample",
  verbose = TRUE
)
```

## Arguments

- path:

  Path to an excel file

- year:

  Numeric: year of the survey (or end year, in the case of pooled data).
  This tells the functions how to read the files, since formatting has
  changed across years of the survey. Because the ability to read a file
  depends so much on the year for which it was produced, this argument
  no longer defaults to a specific year. Instead, if `NULL` (the
  default), it will be guessed from the path. Supplying it explicitly is
  better, but this serves as a fallback.

- name_prefix:

  String used to create column names such as x1, x2, x3, ..., Default:
  'x'

- marker:

  String/regex pattern used to demarcate crosstabs from weight table. If
  `NULL`, it will be assumed that the file contains only crosstab data
  *or* weights, and no filtering will be done. If `marker` is never
  found, it's assumed that weights are in headers above the data, such
  as for 2021, in which case a different operation is done but the same
  weights table is returned. Default: `"Nature of the [Ss]ample"`

- process:

  Boolean: if `FALSE` (the default), this will return the crosstab data
  to be processed, most likely by passing along to `xtab2df`. If `TRUE`,
  `xtab2df` will be called, and you'll receive a nice, clean data frame
  ready for analysis. This is *only* recommended if you already know for
  sure what the crosstab data looks like, so you don't accidentally lose
  some questions or important description. As a sanity check, you'll see
  a message listing the parameters used in the `xtab2df` call.

- verbose:

  Boolean: if `process` is true, should parameters being passed to
  `xtab2df` be printed? Defaults to `TRUE` to encourage you to double
  check that you're passing arguments intentionally.

- ...:

  Additional arguments passed on to `xtab2df` if `process = TRUE`.

## Value

A data frame. For `read_xtabs` with `process = FALSE`, there will be one
column per demographic/geographic group included, plus one or two for
the questions & answers (in some years these were in a single column;
others have two). If `process = TRUE`, the output follows what is
returned by `xtab2df`.

For `read_weights`, only 2 columns, one for demographic groups and one
for their associated weights.

## See also

[`xtab2df()`](https://ct-data-haven.github.io/dcws/reference/xtab2df.md)

Other data accessing functions:
[`fetch_cws()`](https://ct-data-haven.github.io/dcws/reference/fetch_cws.md),
[`fetch_wts()`](https://ct-data-haven.github.io/dcws/reference/fetch_wts.md),
[`xtab2df()`](https://ct-data-haven.github.io/dcws/reference/xtab2df.md)

## Examples

``` r
if (interactive()) {
    xt <- system.file("extdata/test_xtab2018.xlsx", package = "dcws")
    read_weights(xt, year = 2018)

    # returns a not-very-pretty data frame of the crosstabs to be processed
    read_xtabs(xt, year = 2018)
    # returns a pretty data frame ready for analysis
    read_xtabs(xt, year = 2018, process = TRUE)
}
```
