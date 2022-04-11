test_that("testing can access xlsx files", {
  paths <- sample_paths()
  expect_gt(length(paths), 0)
})

test_that("clean_lvls returns expected levels", {
  paths <- sample_paths() %>%
    dplyr::filter(!grepl("Connecticut", path))
  df <- purrr::pmap_dfr(paths, function(path, year) {
      suppressMessages(cwi::read_xtabs(path = path, year = year, process = TRUE))
    }, .id = "id") %>%
    dplyr::distinct(id, category, group) %>%
    dplyr::group_by(id) %>%
    dplyr::slice(-1:-2) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(dplyr::across(category:group, clean_lvls))

  expect_setequal(!!levels(df$category), c("Gender", "Age", "Race/Ethnicity", "Education", "Income", "With children"))
})

test_that("clean_paths returns expected locations", {
  paths <- readLines("all_paths.txt")
  paths <- clean_paths(paths)
  locs <- names(paths)
  expect_true(all(c("Connecticut", "Greater Hartford", "Greater Waterbury", "New Haven Inner Ring") %in% locs))
  expect_false(any(c("CRCOG", "Outer Ring Hartford", "Valley") %in% locs))
  expect_false(any(grepl("([a-z][A-Z]|\\d{2,}|Statewide|Cty|CCF)", locs)))
})

test_that("clean_lvls suppresses forcats warnings", {
  paths <- sample_paths()

  xtabs <- purrr::pmap_dfr(paths, function(path, year) {
    suppressMessages(cwi::read_xtabs(path = path, year = year, process = TRUE))
  }) %>%
    dplyr::distinct(category, group)

  expect_equal(names(xtabs), c("category", "group"))
  expect_silent(clean_lvls(xtabs$category))
  expect_silent(clean_lvls(xtabs$group))
})
