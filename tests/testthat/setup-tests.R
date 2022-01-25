library(testthat)
library(dcws)

sample_paths <- function() {
  paths <- list.files("test_data", pattern = "\\.xlsx?", full.names = TRUE)
  tibble::tibble(path = paths,
                 year = as.numeric(stringr::str_extract(paths, "\\d{4}")))
}
