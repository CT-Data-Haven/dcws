paths <- list.files("data-raw/crosstabs", pattern = "\\.xlsx?", full.names = TRUE) %>%
  clean_paths() %>%
  tibble::enframe(value = "path") %>%
  dplyr::mutate(year = as.numeric(stringr::str_extract(path, "\\d{4}")),
                name = dplyr::recode(name, Valley = "Lower Naugatuck Valley"))

# 5cts doesn't get weights, although they're in the 2018 file
# monroe 2021 doesn't have breakdowns so no weights
safe_wts <- purrr::possibly(
  cwi::read_weights,
  tibble::tibble(group = character(), weight = numeric())
)

# filter to keep just locations & years that have data
cws_full_wts <- paths %>%
  dplyr::mutate(weights = path %>%
                  purrr::map(safe_wts) %>%
                  purrr::map(dplyr::mutate, group = clean_lvls(group))) %>%
  dplyr::select(year, name, weights) %>%
  dplyr::semi_join(cws_full_data, by = c("year", "name"))

usethis::use_data(cws_full_wts, overwrite = TRUE, version = 3)
