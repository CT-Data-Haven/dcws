# METADATA ----
codes20 <- dcws:::clean_cws_2020()

paths <- list.files("data-raw/crosstabs", pattern = "\\.xlsx?", full.names = TRUE) %>%
  clean_paths() %>%
  tibble::enframe(value = "path") %>%
  dplyr::mutate(year = as.numeric(stringr::str_extract(path, "\\d{4}")))

# use empty code for 2020
full_meta <- paths %>%
  dplyr::mutate(code_patt = ifelse(year == 2020, "^$", formals(cwi::xtab2df)$code_pattern)) %>%
  dplyr::mutate(data = purrr::pmap(list(path, year, code_patt), function(path, year, code_patt) {
    suppressMessages(cwi::read_xtabs(path, year = year, process = TRUE, code_pattern = code_patt))
  }) %>%
    purrr::map(dplyr::mutate,
               dplyr::across(c(category, group), clean_lvls),
               category = forcats::as_factor(ifelse(group %in% stringr::str_to_title(levels(cwi::ct5_clusters$cluster)),
                                                    "Five Connecticuts",
                                                    as.character(category))),
               category = forcats::as_factor(ifelse(category %in% c("Connecticut", name), "Total", as.character(category))),
               question = stringr::str_replace_all(question, "\\´", "'"))) %>%
  dplyr::arrange(year, name) %>%
  dplyr::select(-code_patt) %>%
  split(.$year) %>%
  purrr::modify_at("2020", function(df) {
    df %>%
      dplyr::mutate(data = purrr::map(data, ~dplyr::left_join(., codes20, by = "q_number"))) %>%
      dplyr::mutate(data = purrr::map(data, dplyr::select, code, dplyr::everything(), -q_number))
  }) %>%
  dplyr::bind_rows()

group_meta <- full_meta %>%
  dplyr::mutate(groups = purrr::map(data, dplyr::distinct, category, group)) %>%
  dplyr::select(year, name, groups)

response_meta <- full_meta %>%
  dplyr::filter(name == "Connecticut") %>%
  tidyr::unnest(data) %>%
  dplyr::distinct(year, code, question, response) %>%
  dplyr::group_by(year) %>%
  dplyr::mutate(row = rleid(question)) %>%
  dplyr::group_by(year, row, code, question) %>%
  dplyr::summarise(response = paste(response, collapse = " / ")) %>%
  dplyr::ungroup()

usethis::use_data(group_meta, overwrite = TRUE, version = 3)
# is response_meta really that useful?
# usethis::use_data(response_meta, overwrite = TRUE, version = 3)
usethis::use_data(full_meta, internal = TRUE, overwrite = TRUE, version = 3)



# SURVEY DATA ----
cws_full_data <- full_meta %>%
  dplyr::select(year, name, data) %>%
  dplyr::filter(name %in% unique(cwi::xwalk$town) |
                  stringr::str_detect(name, "(Greater|Ring|County)") |
                  name %in% c("Connecticut", "5CT", "Valley")) %>%
  tidyr::unnest(data) %>%
  tidyr::nest(data = category:value) %>%
  tidyr::nest(survey = c(-year, -name))

usethis::use_data(cws_full_data, overwrite = TRUE, version = 3)
