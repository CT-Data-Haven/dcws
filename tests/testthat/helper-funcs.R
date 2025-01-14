sample_paths <- function() {
    # fill in tag from package internal
    base_dir <- file.path("..", "..", "data-raw", "crosstabs")
    paths <- tibble::tibble(
        path = readLines(testthat::test_path("test_paths.txt")),
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

all_xt <- function(.fun, args = NULL) {
    c(2015, 2018, 2020, 2021, 2024) |>
        rlang::set_names() |>
        purrr::map(demo_xt) |>
        purrr::imap(~ R.utils::doCall(.fcn = .fun, path = .x, year = .y, args = args))
}

multi_test <- function(src = "acs",
                       table = "B01003",
                       year = 2021,
                       towns = "all",
                       regions = NULL,
                       counties = "all",
                       state = "09",
                       neighborhoods = NULL,
                       tracts = NULL,
                       blockgroups = NULL,
                       pumas = NULL,
                       msa = FALSE,
                       us = FALSE,
                       new_england = TRUE,
                       nhood_name = "name",
                       nhood_geoid = NULL,
                       dataset = "acs5",
                       verbose = TRUE,
                       key = NULL) {
    multi_geo_prep(src, table, year, towns, regions, counties, state, neighborhoods, tracts, blockgroups, pumas, msa, us, new_england, {{ nhood_name }}, {{ nhood_geoid }}, dataset, verbose, key)
}
