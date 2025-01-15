# can't use process = TRUE to read because that cleans levels
# beyond testing this on a sample of files, should be done as part of data QA
paths <- list.files("data-raw/crosstabs", "xls", full.names = TRUE) |>
  parse_cws_paths()

set.seed(1)
test_cases <- paths |> dplyr::slice_sample(n = 10, by = year)
xt_read <- test_cases |>
  dplyr::mutate(data = purrr::map(path, read_xtabs, verbose = FALSE))

xtabs <- xt_read |>
  dplyr::mutate(data = purrr::map(data, dplyr::select, -1)) |>
  dplyr::mutate(data = purrr::map(data, janitor::remove_empty, "rows")) |>
  dplyr::mutate(data = purrr::map2(data, year, function(df, yr) {
    if (yr >= 2024) {
      out <- df[1, ]
      out <- dplyr::add_row(out, .before = 1)
    } else {
      out <- df[1:2, ]
    }
    out$h <- c("category", "group")
    out
  })) |>
  dplyr::mutate(data = purrr::map(data, tidyr::pivot_longer, -h)) |>
  dplyr::mutate(data = purrr::map(data, tidyr::pivot_wider, names_from = h, values_from = value)) |>
  dplyr::mutate(data = purrr::map(data, tidyr::fill, category, .direction = "down")) |>
  dplyr::mutate(data = purrr::map(data, dplyr::mutate, category = tidyr::replace_na(category, "Total"))) |>
  dplyr::mutate(data = purrr::map(data, dplyr::select, -name)) |>
  tidyr::unnest(data) |>
  dplyr::filter(!grepl("0\\.", group)) |>
  dplyr::distinct(category, group) |>
  dplyr::filter(category != "Total")

saveRDS(xtabs, "tests/testthat/test_data/grp_test_cases.rds")
