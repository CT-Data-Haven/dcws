# definitions of moving questions from scales to indicators,
# e.g. trust neighbors as strongly agree thru strongly disagree --> single number
cws_qs <- cws_full_data |>
  tidyr::unnest(survey) |>
  tidyr::unnest(data) |>
  dplyr::mutate(question = tolower(question) |>
                  stringr::str_remove_all("\\(.+\\)") |>
                  stringr::str_remove_all("\\[.+\\]") |>
                  stringr::str_remove_all("[[:punct:]]") |>
                  stringr::str_squish()) |>
  dplyr::distinct(year, code, question, response) |>
  dplyr::group_by(year, code, question) |>
  dplyr::summarise(responses = paste(response, collapse = ", ")) |>
  dplyr::filter(!grepl("^Yes", responses) | grepl("(job|smok|personal doctor)", question))

readr::write_tsv(cws_qs, "data-raw/misc_input/cws_defs.tsv")

# wrote up in libre office
cws_defs <- readr::read_csv("data-raw/misc_input/cws_defs_filled.csv") |>
  dplyr::filter(!is.na(indicator)) |>
  dplyr::mutate(question = stringr::str_remove(question, "^on another topic ")) |>
  dplyr::mutate(indicator = forcats::as_factor(indicator)) |>
  dplyr::group_by(indicator) |>
  dplyr::slice_head(n = 1) |>
  dplyr::ungroup() |>
  dplyr::select(indicator, question, collapsed_responses, universe, calculation)


usethis::use_data(cws_defs, overwrite = TRUE)
