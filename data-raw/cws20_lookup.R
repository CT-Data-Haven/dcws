# since it didn't take args anyway,
# changing to a dataset to ship instead of a function that doesn't get used
# 2020 statewide didn't have codes in crosstab--reading them from script docx

codes <- officer::read_docx("data-raw/misc_input/DataHaven0720_Prn2.docx") |>
  officer::docx_summary() |>
  # drop later
  tibble::as_tibble() |>
  dplyr::filter(style_name %in% c("Alias", "Long Label", "Short Label")) |>
  dplyr::mutate(
    id = cumsum(style_name == "Alias"),
    style_name = gsub("(?:^[\\w\\s]*?)(\\b\\w+\\b$)", "\\L\\1", style_name, perl = TRUE)
  ) |>
  dplyr::group_by(id, style_name) |>
  dplyr::summarise(text = paste(text, collapse = " ")) |>
  dplyr::ungroup() |>
  tidyr::pivot_wider(id_cols = id,
                     names_from = style_name,
                     values_from = text) |>
  dplyr::mutate(
    alias = stringr::str_remove(alias, "\\:\\s$"),
    label = label |>
      stringr::str_remove_all("(\\[|INTERVIEWER).+$") |>
      stringr::str_remove_all("\\(.+\\)") |>
      stringr::str_replace_all("\\?(?=\\w)", " ") |>
      stringr::str_squish() |>
      stringr::str_replace_all(c("\\<sel_alcohol\\>" = "4 or 5")) |>
      stringr::str_remove_all("[:punct:]") |>
      tolower() |>
      stringr::str_squish()
  ) |>
  dplyr::filter(!is.na(label))

cws20 <- dcws:::read_xtabs(
  "data-raw/crosstabs/DataHaven2020 Connecticut Crosstabs.xlsx",
  year = 2020,
  process = TRUE,
  code_pattern = "^$"
) |>
  dplyr::distinct(q_number, question) |>
  dplyr::mutate(
    label = question |>
      stringr::str_remove("\\[.+$") |>
      stringr::str_remove_all("\\(.+\\)") |>
      stringr::str_replace_all(c("\\<4 if female/5 if male\\>" = "4 or 5")) |>
      stringr::str_remove_all("[:punct:]") |>
      tolower() |>
      stringr::str_squish()
  )

cws20_lookup <- cws20 |>
  dplyr::select(-question) |>
  fuzzyjoin::stringdist_left_join(codes, by = "label", method = "qgram") |>
  dplyr::select(q_number, code = alias)

usethis::use_data(cws20_lookup, overwrite = TRUE)
