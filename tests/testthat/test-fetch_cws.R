## FETCH_CWS ----
test_that("fetch_cws returns correct dimensions", {
  cws_full <- fetch_cws()
  cws_unnest <- fetch_cws(.unnest = TRUE)
  yrs <- c(2015, 2018)
  cws_vec <- fetch_cws(.year = yrs)
  cws_no_q <- fetch_cws(.year = yrs, .incl_questions = FALSE)

  expect_setequal(unique(cws_full$year), c(2015, 2018, 2020, 2021, 2022, 2024)) # 2015, 2018, 2020, 2021, 2022
  expect_setequal(unique(cws_vec$year), yrs)

  # number of columns, nested vs unnested
  univ_cols <- c("year", "span", "name", "code", "question")
  expect_named(cws_full, c(univ_cols, "data"))
  expect_named(cws_unnest, c(univ_cols, "category", "group", "response", "value"))
  expect_named(cws_no_q, c(univ_cols[1:4], "data"))
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
  cws_ct <- fetch_cws(.name = "Connecticut") |>
    dplyr::distinct(year, code, question) |>
    dplyr::filter(code == "")
  # fewer than 10 blanks?
  expect_lt(nrow(cws_ct), 10)
})

test_that("fetch_cws errors when no matches", {
  expect_error(fetch_cws(year > 2020, .year = 2015))
  expect_error(fetch_cws(.year = 2021, .name = "Bethany"))
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
  univ_cols <- c("year", "span", "name", "code", "question")
  nest_wt <- fetch_cws(.year = 2024, .unnest = FALSE, .add_wts = TRUE)
  unnest_wt <- fetch_cws(.year = 2024, .unnest = TRUE, .add_wts = TRUE)
  pool_wt <- fetch_cws(.year = "2015_2024", .add_wts = TRUE)
  expect_named(nest_wt, c(univ_cols, "data"))
  expect_named(nest_wt$data[[1]], c("category", "group", "response", "value", "weight"))
  expect_named(unnest_wt, c(univ_cols, "category", "group", "response", "value", "weight"))
  expect_true(all(pool_wt$span == "2015_2024"))
})

test_that("fetch_cws handles pooled data", {
  single <- fetch_cws(.year = 2024)
  pooled <- fetch_cws(.year = "2015_2024")
  expect_s3_class(single, "data.frame")
  expect_s3_class(pooled, "data.frame")
})

## FETCH_WTS ----
test_that("fetch_wts adds total weights = 1", {
  wts_5ct <- fetch_wts(.year = 2015, .name = "5CT", .unnest = TRUE)
  wts_nhv <- fetch_wts(.name = "New Haven", .unnest = TRUE)

  expect_gt(nrow(wts_5ct), 0)
  expect_true(all(c("Connecticut", "New Haven") %in% wts_nhv$group))
})

test_that("fetch_wts has proper number of columns", {
  tbls <- purrr::map_dbl(list(
    wts_nest = fetch_wts(.unnest = FALSE),
    wts_unnest = fetch_wts(.unnest = TRUE)
  ), ncol)
  wts_nest <- fetch_wts(.unnest = FALSE)
  wts_unnest <- fetch_wts(.unnest = TRUE)
  expect_named(wts_nest, c("year", "span", "name", "weights"))
  expect_named(wts_unnest, c("year", "span", "name", "group", "weight"))
})
