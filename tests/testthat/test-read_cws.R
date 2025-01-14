test_that("read_xtabs: test the test setup", {
    yrs <- as.character(c(2015, 2018, 2020, 2021, 2024))

    expect_equal(names(all_xt(read_xtabs)), yrs)
    expect_equal(names(all_xt(read_weights)), yrs)
})

# all_xt is a non-exported wrapper I wrote for the purposes of testing, see R/test_utils.R
test_that("read_xtabs removes weighted total rows", {
    has_wt_row <- all_xt(read_xtabs) |>
        purrr::map(dplyr::pull, x1) |>
        purrr::map(stringr::str_detect, "Weighted Total") |>
        purrr::map(any, na.rm = TRUE)
    purrr::walk(names(has_wt_row), function(yr) expect_false(has_wt_row[[!!yr]]))
})

test_that("read_weights handles both weight tables and weight headers", {
    wts <- all_xt(read_weights)
    # should each be data frame with 2 cols
    purrr::walk(names(wts), function(yr) expect_s3_class(wts[[!!yr]], "data.frame"))
    purrr::walk(names(wts), function(yr) expect_length(wts[[!!yr]], 2))
})

test_that("read_xtabs allows custom name prefixes", {
    xts <- all_xt(read_xtabs, list(name_prefix = "vv"))
    hdrs <- purrr::map(xts, function(x) sprintf("vv%d", seq_along(x)))
    expect_mapequal(purrr::map(xts, names), hdrs)
})

test_that("read_xtabs successfully passes to xtab2df", {
    yrs <- as.character(c(2015, 2018, 2020, 2021, 2024))
    xts_no_process <- all_xt(read_xtabs) |>
        purrr::map2(yrs, function(xt, yr) xtab2df(xt, year = yr))
    xts_process <- all_xt(read_xtabs, list(process = TRUE))
    expect_mapequal(xts_no_process, xts_process)

    xts_no_process_args <- all_xt(read_xtabs, list(name_prefix = "v")) |>
        purrr::map2(yrs, function(xt, yr) xtab2df(xt, yr, col = v1))
    xts_process_args <- all_xt(read_xtabs, list(name_prefix = "v", process = TRUE))
    expect_mapequal(xts_no_process_args, xts_process_args)
})

test_that("read_xtabs print parameters when passing to xtab2df", {
    expect_message(read_xtabs(demo_xt(2018), year = 2018, process = TRUE), "parameters")
    expect_message(read_xtabs(demo_xt(2015), year = 2015, process = TRUE), "\\=")

    expect_silent(dummy <- read_xtabs(demo_xt(2018), year = 2018, process = TRUE, verbose = FALSE))
})

test_that("read_cws passes verbose to cws_check_yr", {
    # message about guessing year; if verbose = TRUE, silent even if guessing
    expect_message(dummy <- read_xtabs(demo_xt(2024), year = NULL, process = TRUE, verbose = TRUE), "Guessing year")
    expect_message(dummy <- read_weights(demo_xt(2024), year = NULL, verbose = TRUE), "Guessing year")
    expect_silent(dummy <- read_xtabs(demo_xt(2024), year = NULL, process = TRUE, verbose = FALSE))
    expect_silent(dummy <- read_weights(demo_xt(2024), year = NULL, verbose = FALSE))
})
