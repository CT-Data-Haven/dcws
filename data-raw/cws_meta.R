devtools::load_all()
# METADATA ----
codes20 <- dcws:::clean_cws_2020()

paths <- list.files("data-raw/crosstabs", pattern = "\\.xlsx?", full.names = TRUE) %>%
  dcws:::clean_paths() %>%
  tibble::enframe(value = "path") %>%
  dplyr::mutate(year = as.numeric(stringr::str_extract(path, "\\d{4}")),
                name = dplyr::recode(name, Valley = "Lower Naugatuck Valley"))

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
               group = forcats::fct_recode(group, Connecticut = "Total"),
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

# order group levels within categories
lvls <- full_meta %>%
  tidyr::unnest(data) %>%
  dplyr::filter(category != "Total") %>%
  dplyr::distinct(category, group) %>%
  split(.$category, drop = TRUE) %>%
  purrr::map(~forcats::fct_drop(.$group))

lvls[["Age"]] <- dcws:::order_lvls(lvls[["Age"]])
lvls[["Race/Ethnicity"]] <- forcats::fct_relevel(lvls[["Race/Ethnicity"]], "Not white", "Other race", after = Inf)
lvls[["Income"]] <- dcws:::order_lvls(lvls[["Income"]])
lvls[["Education"]] <- forcats::fct_relevel(lvls[["Education"]], "Less than high school", "High school or less", "High school", "Some college or less", "Some college or Associate's", "Some college or higher", "Less than Bachelor's", "Bachelor's or higher")

# assign levels back into full_meta to carry over to other datasets
full_meta <- full_meta %>%
  tidyr::unnest(data) %>%
  dplyr::mutate(group = forcats::fct_relevel(group, levels(purrr::reduce(lvls, c)))) %>%
  tidyr::nest(data = code:value)


group_meta <- full_meta %>%
  dplyr::mutate(groups = purrr::map(data, dplyr::distinct, category, group)) %>%
  dplyr::select(year, name, groups)

response_meta <- full_meta %>%
  dplyr::filter(name == "Connecticut") %>%
  tidyr::unnest(data) %>%
  dplyr::distinct(year, code, question, response) %>%
  dplyr::group_by(year) %>%
  dplyr::mutate(row = dcws:::rleid(question)) %>%
  dplyr::group_by(year, row, code, question) %>%
  dplyr::summarise(response = paste(response, collapse = " / ")) %>%
  dplyr::ungroup()


################## CHECK ABOVE BEFORE SAVING ###################################
usethis::use_data(group_meta, overwrite = TRUE, version = 3)
# is response_meta really that useful?
# usethis::use_data(response_meta, overwrite = TRUE, version = 3)
usethis::use_data(full_meta, internal = TRUE, overwrite = TRUE, version = 3)



# SURVEY DATA ----
cws_full_data <- full_meta %>%
  dplyr::select(year, name, data) %>%
  dplyr::filter(name %in% unique(cwi::xwalk$town) |
                  stringr::str_detect(name, "(Greater|Ring|County)") |
                  name %in% c("Connecticut", "5CT", "Lower Naugatuck Valley")) %>%
  tidyr::unnest(data) %>%
  tidyr::nest(data = category:value) %>%
  tidyr::nest(survey = c(-year, -name))

usethis::use_data(cws_full_data, overwrite = TRUE, version = 3)


# WEIGHTS -----
# 5cts doesn't get weights, although they're in the 2018 file
# monroe 2021 doesn't have breakdowns so no weights
safe_wts <- purrr::possibly(
  cwi::read_weights,
  tibble::tibble(group = character(), weight = numeric())
)

add_wt1 <- function(data, name) {
  data %>%
    tibble::add_row(group = unique(c("Connecticut", name)), weight = 1, .before = 1) %>%
    dplyr::mutate(group = forcats::as_factor(group))
}

# filter to keep just locations & years that have data
# tack on 1.0 weights to top
cws_full_wts <- paths %>%
  dplyr::mutate(weights = path %>%
                  purrr::map(safe_wts) %>%
                  purrr::map(dplyr::mutate, group = clean_lvls(group)) %>%
                  purrr::map2(name, add_wt1)) %>%
  dplyr::select(year, name, weights) %>%
  dplyr::semi_join(cws_full_data, by = c("year", "name"))

usethis::use_data(cws_full_wts, overwrite = TRUE, version = 3)
