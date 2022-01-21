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
  cols <- c(wts_nest = 3, wts_unnest = 4)
  expect_mapequal(tbls, cols)
})
