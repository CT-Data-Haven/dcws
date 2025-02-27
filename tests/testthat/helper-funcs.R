sample_paths <- function() {
    # fill in tag from package internal
    base_dir <- file.path("..", "..", "data-raw", "crosstabs")
    paths <- tibble::tibble(
        path = readLines(testthat::test_path("test_data/test_paths.txt")),
        span = stringr::str_extract(path, "(?<=\\D)\\d{4}([\\-_]\\d{4})?")
    ) |>
        dplyr::mutate(tag = tags[span]) |>
        dplyr::mutate(path = purrr::map2_chr(path, tag, function(p, t) stringr::str_glue_data(list(tag = t), p))) |>
        # dplyr::mutate(path = testthat::test_path("..", "..", "data-raw", "crosstabs", path)) |>
        dplyr::mutate(year = strsplit(span, "_") |>
            purrr::map_chr(dplyr::last) |>
            as.numeric()) |>
        dplyr::select(path, year)
    paths
}

demo_xt <- function(f) {
    system.file("extdata", sprintf("test_xtab%s.xlsx", f), package = "dcws")
}

all_xt <- function(.fun, ...) {
    yrs <- c(2015, 2018, 2020, 2021, 2024)
    paths <- purrr::map(yrs, demo_xt)
    res <- purrr::map2(paths, yrs, function(path, yr) {
        purrr::partial(.fun, path = path, year = yr)(...)
    })
    setNames(res, yrs)
}
