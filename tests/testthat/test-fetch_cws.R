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

test_that("fetch_cws handles ellipses", {
  cws_1q <- fetch_cws(code == "Q1", .year = 2021, .name = "Connecticut")
  cws_grep <- fetch_cws(grepl("access to a car", question), .year = 2020, .name = "Connecticut")
  cws_lt <- fetch_cws(year < 2021, grepl("access to a car", question), .name = "Connecticut")

  expect_equal(nrow(cws_1q), 1)
  expect_equal(nrow(cws_grep), 1)
  expect_equal(nrow(cws_lt), 3)
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
  expect_warning(fetch_cws(code == "Q5"))
  expect_warning(fetch_cws(year > 2015, code == "Q5"))
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
