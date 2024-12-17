devtools::load_all()
# METADATA ----
codes20 <- clean_cws_2020()

# spss-based xtabs come from excel sheets but r-based can come from single csv + codebook
paths <- list.files("data-raw/crosstabs", pattern = "\\.xlsx?", full.names = TRUE) |>
    clean_paths() |>
    tibble::enframe(value = "path") |>
    # get end year
    dplyr::mutate(yrs = stringr::str_extract_all(path, "(?<=\\D)(\\d{4})(?=[_\\s\\-])")) |>
    dplyr::mutate(span = purrr::map_chr(yrs, paste, collapse = "_")) |>
    dplyr::mutate(year = as.numeric(stringr::str_extract(span, "\\d{4}$"))) |>
    dplyr::mutate(name = dplyr::recode(name, Valley = "Lower Naugatuck Valley")) #|>
# dplyr::mutate(code_patt = ifelse(year == 2020, "^$", "^[A-Z\\d_]{2,20}$"))

# use empty code for 2020
ct5 <- c("Urban Core", "Urban Periphery", "Suburban", "Rural", "Wealthy")
safe_read_xtabs <- purrr::possibly(read_xtabs, otherwise = NULL)
full_meta <- paths |>
    dplyr::mutate(data = purrr::pmap(list(path, year), function(path, year) {
        safe_read_xtabs(path, year = year, process = TRUE, verbose = FALSE)
    }))
full_meta <- dplyr::mutate(full_meta, data = purrr::map(data, dplyr::mutate, dplyr::across(c(category, group), clean_dcws_lvls)))
full_meta <- dplyr::mutate(full_meta, data = purrr::map(data, dplyr::mutate, category = dplyr::case_when(
    group %in% ct5 ~ "Five Connecticuts",
    category %in% c("Connecticut", "HIC", name) ~ "Total",
    TRUE ~ as.character(category)
)))
full_meta <- dplyr::mutate(full_meta, data = purrr::map(data, dplyr::mutate,
    category = forcats::as_factor(category)
))
full_meta <- dplyr::mutate(full_meta, data = purrr::map(data, dplyr::mutate,
    group = suppressWarnings(forcats::fct_recode(group, Connecticut = "Total"))
))
full_meta <- dplyr::mutate(full_meta, data = purrr::map(data, dplyr::mutate,
    question = stringr::str_replace_all(question, "\\´", "'")
))
full_meta <- dplyr::arrange(full_meta, year, name)
# full_meta <- dplyr::select(full_meta, -code_patt)
full_meta <- split(full_meta, full_meta$year)
full_meta[["2020"]] <- dplyr::mutate(full_meta[["2020"]],
    data = purrr::map(data, \(x) dplyr::left_join(x, codes20, by = "q_number", relationship = "many-to-many"))
)
full_meta[["2020"]] <- dplyr::mutate(full_meta[["2020"]],
    data = purrr::map(data, dplyr::select, code, dplyr::everything(), -q_number)
)
full_meta <- dplyr::bind_rows(full_meta)


# order group levels within categories
lvls <- full_meta |>
    tidyr::unnest(data) |>
    dplyr::filter(category != "Total") |>
    dplyr::distinct(category, group) |>
    split(~category, drop = TRUE) |>
    purrr::map(\(x) forcats::fct_drop(x$group))

lvls[["Age"]] <- order_lvls(lvls[["Age"]])
lvls[["Race/Ethnicity"]] <- forcats::fct_relevel(lvls[["Race/Ethnicity"]], "Not white", "Other race", after = Inf)
lvls[["Income"]] <- order_lvls(lvls[["Income"]])
lvls[["Education"]] <- forcats::fct_relevel(lvls[["Education"]], "Less than high school", "High school or less", "High school", "Some college or less", "Some college or Associate's", "Some college or higher", "Less than Bachelor's", "Bachelor's or higher")

# assign levels back into full_meta to carry over to other datasets
full_meta <- full_meta |>
    tidyr::unnest(data) |>
    dplyr::mutate(group = forcats::fct_relevel(group, levels(purrr::reduce(lvls, c)))) |>
    dplyr::mutate(group = forcats::fct_relevel(group, "Connecticut")) |>
    dplyr::mutate(category = forcats::fct_relevel(category, "Total", "Five Connecticuts")) |>
    tidyr::nest(data = code:value)


cws_group_meta <- full_meta |>
    dplyr::mutate(groups = purrr::map(data, dplyr::distinct, category, group)) |>
    dplyr::select(year, name, groups)

response_meta <- full_meta |>
    dplyr::filter(name == "Connecticut") |>
    tidyr::unnest(data) |>
    dplyr::distinct(year, code, question, response) |>
    dplyr::group_by(year) |>
    dplyr::mutate(row = rleid(question)) |>
    dplyr::group_by(year, row, code, question) |>
    dplyr::summarise(response = paste(response, collapse = " / ")) |>
    dplyr::ungroup()





# SURVEY DATA ----
# drop NY, health dists with abbreviated names
cws_full_data <- full_meta |>
    dplyr::select(year, span, name, data) |>
    tidyr::unnest(data) |>
    tidyr::nest(data = category:value) |>
    tidyr::nest(survey = c(-year, -span, -name))



# WEIGHTS -----
# 5cts doesn't get weights, although they're in the 2018 file
# monroe 2021 doesn't have breakdowns so no weights
safe_wts <- purrr::possibly(
    read_weights,
    tibble::tibble(group = character(), weight = numeric())
)

add_wt1 <- function(data, name) {
    data |>
        tibble::add_row(group = unique(c("Connecticut", name)), weight = 1, .before = 1) |>
        dplyr::mutate(group = forcats::as_factor(group))
}

# filter to keep just locations & years that have data
# tack on 1.0 weights to top
cws_full_wts <- paths |>
    dplyr::mutate(weights = path |>
        purrr::map(safe_wts) |>
        purrr::map(dplyr::mutate, group = clean_dcws_lvls(group)) |>
        purrr::map2(name, add_wt1)) |>
    dplyr::select(year, span, name, weights) |>
    dplyr::semi_join(cws_full_data, by = c("year", "span", "name"))



# MAXIMUM MARGIN OF ERROR ----
# maximum moe--probably won't need much except community profiles
# these are only in the headers of excel files (no idea why)
# 2015 in top row--extract for location
# for 2024-onward they're in sample size sheet (3)
read_moe_row_ <- function(path) {
    df <- suppressMessages(readxl::read_excel(path, col_names = FALSE, .name_repair = "universal"))
    # first row = name of location but stylized inconsistently
    # second row = moe
    # get moe from column that fuzzy matches name and doesn't have category header?
    df <- janitor::clean_names(df)
    sheet_name <- df$x1[1]
    df <- df[1:10, 1:3]
    moe <- dplyr::filter(df, grepl("margin of error", tolower(x1)) | is.na(x1))
    # drop secondary headers
    moe <- moe[, purrr::map_lgl(moe, \(x) !any(grepl("(Gender|Five Connecticuts)", x)))]
    moe <- janitor::remove_empty(moe, "rows")
    moe <- janitor::remove_empty(moe, "cols")
    # moe$hdr <- c("moe", "name")
    # moe$x1 <- NULL
    moe$x1 <- ifelse(grepl("margin of error", tolower(moe$x1)), "moe", "name")
    moe <- tidyr::pivot_longer(moe, -x1, names_to = "col")
    moe <- tidyr::pivot_wider(moe, names_from = x1, values_from = value)
    if (nrow(moe) > 1) {
        moe <- dplyr::filter(moe, name != "Connecticut")
    }
    if (nrow(moe) > 1) {
        cli::cli_abort("Too many rows in moe table")
    } else {
        readr::parse_number(moe$moe)
    }
}

read_moe_hdr_ <- function(path) {
    df <- openxlsx2::wb_load(path)
    hdr <- df[["worksheets"]][[1]][["headerFooter"]]
    if (!"oddHeader" %in% names(hdr)) {
        NA_real_
    } else {
        hdr <- hdr[["oddHeader"]]
        hdr <- unlist(hdr[nchar(hdr) > 0])
        hdr <- stringr::str_extract(hdr, "MOE.+\\%")
        hdr <- stringr::str_extract(hdr, "[\\d\\.]+")
        hdr <- readr::parse_number(hdr)
        hdr / 100
    }
}

read_moe_r_ <- function(path) {
    # for r-based xtabs, moe in 3rd sheet
    df <- readxl::read_excel(path, sheet = 3, skip = 1)
    df <- janitor::clean_names(df)
    moe <- df$max_margin_of_error[1]
    moe
}

cws_max_moe <- paths |>
    dplyr::mutate(moe = purrr::map2_dbl(path, year, function(p, y) {
        if (y == 2015) {
            read_moe_row_(p)
        } else if (y == 2024) {
            read_moe_r_(p)
        } else {
            read_moe_hdr_(p)
        }
    })) |>
    dplyr::select(year, span, name, moe)

# OUTPUT ----
################## CHECK ABOVE BEFORE SAVING ###################################
usethis::use_data(cws_group_meta, overwrite = TRUE)
# is response_meta really that useful?
# usethis::use_data(response_meta, overwrite = TRUE)
usethis::use_data(cws_full_data, overwrite = TRUE)

usethis::use_data(cws_full_wts, overwrite = TRUE)
usethis::use_data(cws_max_moe, overwrite = TRUE)

# internal datasets--need to do all together

# usethis::use_data(full_meta, internal = TRUE, overwrite = TRUE)
