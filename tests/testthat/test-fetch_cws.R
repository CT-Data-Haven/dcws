test_that("fetch_cws returns correct dimensions", {
  cws_full <- fetch_cws()
  cws_unnest <- fetch_cws(.unnest = TRUE)
  cws_vec <- fetch_cws(.year = c(2015, 2018))

  expect_length(unique(cws_full$year), 4)
  expect_length(unique(cws_vec$year), 2)

  # 70 qs in 2020
  n20 <- cws_full %>%
    dplyr::filter(name == "Connecticut", year == 2020) %>%
    dplyr::pull(code) %>%
    unique()
  expect_length(n20, 70)

  # number of columns, nested vs unnested
  expect_length(cws_full, 5)
  expect_length(cws_unnest, 8)
})

test_that("fetch_cws drops CT totals", {
  cws_no_ct <- fetch_cws(.name = "Fairfield County", .drop_ct = TRUE, .unnest = TRUE)
  cws_w_ct <-  fetch_cws(.name = "Fairfield County", .drop_ct = FALSE, .unnest = TRUE)
  expect_equal(dplyr::n_distinct(cws_w_ct$group) - 1, dplyr::n_distinct(cws_no_ct$group))

  cws_ct1 <- fetch_cws(.name = "Connecticut", .year = 2021, .drop_ct = TRUE)
  cws_ct2 <- fetch_cws(.name = "Connecticut", .year = 2021, .drop_ct = FALSE)
  expect_equal(cws_ct1, cws_ct2)
})

test_that("fetch_cws drops excess factor levels", {
  # use gnh to compare--2018 had more income groups
  cws_gnh18 <- fetch_cws(.name = "Greater New Haven", .year = 2018, .unnest = TRUE)
  cws_gnh21 <- fetch_cws(.name = "Greater New Haven", .year = 2021, .unnest = TRUE)
  cws_mfd <- fetch_cws(.name = "Milford", .year = 2021, .unnest = TRUE)

  expect_true("<$15K" %in% levels(cws_gnh18$group))
  expect_false("<$15K" %in% levels(cws_gnh21$group))

  expect_true("Black" %in% levels(cws_gnh21$group))
  expect_false("Black" %in% levels(cws_mfd$group))
})

test_that("fetch_cws handles ellipses", {
  tbls <- purrr::map_dbl(list(
    by_code = fetch_cws(code == "Q1", .year = 2020, .name = "Connecticut"),
    by_grep = fetch_cws(grepl("access to a car", question), .year = 2020, .name = "Connecticut"),
    by_ineq = fetch_cws(grepl("access to a car", question), year < 2021, .name = "Connecticut")
  ), nrow)

  rows <- c(by_code = 1, by_grep = 1, by_ineq = 3) # last should be 2015, 2018, 2020

  expect_mapequal(tbls, rows)
})

test_that("fetch_cws has no/few blank codes", {
  cws_ct <- fetch_cws(.name = "Connecticut") %>%
    dplyr::distinct(year, code, question) %>%
    dplyr::filter(code == "")
  # fewer than 10 blanks?
  expect_lt(nrow(cws_ct), 10)
})

test_that("fetch_cws messages when no matches", {
  expect_message(fetch_cws(year > 2020, .year = 2015))
  expect_message(fetch_cws(.year = 2021, .name = "Bethany"))
  expect_equal(nrow(suppressMessages(fetch_cws(.year = 2021, .name = "Bethany"))), 0)
})

test_that("fetch_cws warns on multi-year code filters", {
  expect_message(fetch_cws(code == "Q5"))
  expect_message(fetch_cws(year > 2015, code == "Q5"))
})

test_that("fetch_cws filters nested data", {
  cws_cat_nest <- fetch_cws(.year = 2021, .name = "New Haven", .category = "Gender", .unnest = FALSE)
  cws_cat_unnest <- fetch_cws(.year = 2021, .name = "New Haven", .category = "Gender", .unnest = TRUE)

  expect_length(unique(cws_cat_unnest$category), 1)
  expect_length(unique(cws_cat_unnest$group), 2)

  expect_identical(tidyr::unnest(cws_cat_nest, data), cws_cat_unnest)
})

test_that("fetch_cws adds weights properly", {
  tbls <- purrr::map_dbl(list(
    nest_unwt   = fetch_cws(.year = 2021, .unnest = FALSE, .add_wts = FALSE),
    nest_wt     = fetch_cws(.year = 2021, .unnest = FALSE, .add_wts = TRUE),
    unnest_unwt = fetch_cws(.year = 2021, .unnest = TRUE,  .add_wts = FALSE),
    unnest_wt   = fetch_cws(.year = 2021, .unnest = TRUE,  .add_wts = TRUE)
  ), ncol)
  cols <- c(nest_unwt = 5, nest_wt = 5, unnest_unwt = 8, unnest_wt = 9)
  expect_mapequal(tbls, cols)
})
