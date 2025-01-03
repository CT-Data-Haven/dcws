#' @title Fetch and subset DCWS data
#' @description This function returns the doubly-nested data from `cws_full_data` in a nicer format, with options for subsetting. Filtering by year, location name, and category are named options, any of which take a vector of one or more values, but any valid conditions can be passed to `...` for more flexible filtering. For any named options, `NULL`, the default, will mean no filtering is done by that column.
#' @param ... Any number of conditions to filter by, which will be passed to `dplyr::filter`. These don't override the named options, so if you filter by `year > 2020` but then set `.year = 2015` you're not going to get any data.
#' @param .year A vector of one or more year(s) to subset by. If this is a character that contains a separator (`"_"`, `"-"`, or a space character), it will be assumed to be a span of years, such as for multi-year pooled crosstabs (e.g. `"2015_2024"`). Otherwise it's assumed this is a single year of the survey. If `NULL`, no filtering is done by year.
#' @param .name A vector of one or more strings giving the name(s) to subset by. If `NULL`, no filtering is done by name.
#' @param .category A vector of one or more strings giving the category(ies) to subset by. If `NULL`, no filtering is done by category.
#' @param .unnest Logical: should the `data` column be unnested? This just saves a step of calling `tidyr::unnest` but defaults to false.
#' @param .add_wts Logical: should groups' survey weights be attached, via a left-join with `dcws::cws_full_wts`? This is useful if you need to collapse groups later; otherwise you might get stuck in annoying `tidyr::unnest` messes.
#' @param .drop_ct Logical: should statewide totals be included for each crosstab extract? This can be useful for a single location in order to have Connecticut values to compare against, but becomes redundant with multiple locations. The default `TRUE` means statewide averages will not be included.
#' @return A data frame, with between 5 and 9 columns, depending on arguments. Columns `year`, `name`, `code`, and `question` are always included. Additional columns:
#'
#' |arguments                 |columns                                                          |
#' |:-------------------------|:----------------------------------------------------------------|
#' |.unnest = F, .add_wts = F |data (nested df of category, group, response, and value)         |
#' |.unnest = F, .add_wts = T |data (nested df of category, group, response, value, and weight) |
#' |.unnest = T, .add_wts = F |category, group, response, value                                 |
#' |.unnest = T, .add_wts = T |category, group, response, value, weight                         |
#'
#' @examples
#' # no filtering
#' fetch_cws()
#'
#' # filter by year, name, and/or category
#' fetch_cws(.name = c("Greater New Haven", "New Haven")) # all years
#' fetch_cws(.year = 2018, .name = c("Greater New Haven", "New Haven"))
#' fetch_cws(.year = 2021, .name = "New Haven", .category = c("Total", "Age", "Gender"))
#'
#' # filter by conditions
#' fetch_cws(code == "Q4E", .year = 2018, .name = c("Greater New Haven", "New Haven"), .unnest = TRUE)
#' fetch_cws(grepl("Q4[A-Z]", code), .year = 2018, .name = c("Greater New Haven", "New Haven"))
#' fetch_cws(grepl("health insurance", question), year > 2015, .name = "New Haven")
#' fetch_cws(question %in% c("Diabetes", "Asthma"), .name = "Bridgeport")
#'
#' # how you might use this to make a beautiful table
#' fetch_cws(code == "Q1", .year = 2021, .category = c("Income", "Gender"), .unnest = TRUE) |>
#'   dplyr::group_by(name, category, group) |>
#'   # might want to remove refused, don't know responses
#'   # cwi::sub_nonanswers() |>
#'   dplyr::filter(response == "Yes") |>
#'   tidyr::pivot_wider(id_cols = name, names_from = group, values_from = value)
#'
#' # adding weights to collapse groups (e.g. combining income brackets)
#' fetch_cws(code == "Q1", .year = 2021, .add_wts = TRUE)
#' fetch_cws(.year = 2021, .name = "New Haven", .category = c("Total", "Age", "Income"),
#'           .add_wts = TRUE, .unnest = TRUE)
#' @seealso cws_full_data, cws_full_wts
#' @import tidyselect
#' @export
fetch_cws <- function(..., .year = NULL, .name = NULL, .category = NULL, .unnest = FALSE, .add_wts = FALSE, .drop_ct = TRUE) {
  # warn if code is used anywhere--not stable year to year
  q <- purrr::map_chr(rlang::enquos(...), rlang::as_label)
  if (any(grepl("\\bcode\\b", q)) & (is.null(.year) | length(.year) > 1)) {
    cli::cli_alert_warning("Keep in mind that codes might change between years--double check before using {.var code} as a filter.")
  }

  out <- tidyr::unnest(dcws::cws_full_data, survey)
  out <- dplyr::filter(out, !!!rlang::quos(...))

  # unnest first--filtering is 15x faster if unnested than by mapping
  # if filtering categories
  # if dropping ct
  # if adding wts
  # if not unnesting, re-nest
  out <- tidyr::unnest(out, data)
  out <- filter_cws_(out, .year = .year, .name = .name, .category = .category)

  if (nrow(out) == 0) {
    # used to be a warning, but that creates errors further down.
    cli::cli_abort("No data were found for this combination of years, locations, and/or categories.")
  }

  if (.drop_ct) {
    out <- dplyr::filter(out, !(name != "Connecticut" & group == "Connecticut"))
  }

  if (.add_wts) {
    out <- dplyr::left_join(out,
                            tidyr::unnest(dcws::cws_full_wts, weights),
                            by = c("year", "name", "group"))
  }

  #TODO: write replacement for where
  out <- dplyr::mutate(out, dplyr::across(where(is.factor), forcats::fct_drop))

  if (!.unnest) {
    out <- tidyr::nest(out, data = -year:-question)
  }

  out
}


#' @title Fetch and subset weights for DCWS data
#' @description This function returns the nested `cws_full_wts` data, meant as a counterpart to `fetch_cws`.
#' @return A data frame, with either 3 columns (if `.unnest = FALSE`) or 4 columns (if `.unnest = TRUE`).
#' * For `.unnest = FALSE`: columns are `year`, `name`, and a list of nested data frames `weights`
#' * For `.unnest = TRUE`: `year`, `name`, `group`, and `weight`
#' @inheritParams fetch_cws
#' @examples
#' # no filtering
#' fetch_wts()
#'
#' # weights are generally useful in combination with actual data
#' # but unless you unnest in advance, this is messy
#' fetch_cws(code == "Q4E", .year = 2021,
#'           .name = c("Greater New Haven", "New Haven"), .unnest = TRUE) |>
#'   dplyr::left_join(fetch_wts(.unnest = TRUE), by = c("year", "name", "group"))
#' @export
#' @seealso fetch_cws
fetch_wts <- function(..., .year = NULL, .name = NULL, .unnest = FALSE) {
  out <- dplyr::filter(dcws::cws_full_wts, !!!rlang::quos(...))
  out <- filter_cws_(out, .year = .year, .name = .name, .category = NULL)

  if (nrow(out) == 0) {
    cli::cli_abort("No weights were found for this combination of years and locations.")
  }

  if (.unnest) {
    out <- tidyr::unnest(out, weights)
  }

  out
}

filter_cws_ <- function(df, .year, .name, .category) {
  if (!is.null(.year)) {
    # coerce to string and filter by span
    yr_chr <- as.character(.year)
    df <- df[df[["span"]] %in% yr_chr, ]
    # if (is.character(.year) && grepl("[_\\-\\s]", .year)) {
    #   df <- dplyr::filter(df, span %in% .year)
    # } else {
    #   df <- dplyr::filter(df, year %in% .year)
    # }
  }
  if (!is.null(.name)) {
    df <- df[df[["name"]] %in% .name, ]
  }
  if (!is.null(.category)) {
    df <- df[df[["category"]] %in% .category, ]
  }
  df
}

# filter_cws_ <- function(df, .year, .name, .category) {
#   if (!is.null(.year)) {
#     if (is.character(.year)) .year <- as.numeric(.year)
#     df <- dplyr::filter(df, year %in% .year)
#   }
#   if (!is.null(.name)) {
#     df <- dplyr::filter(df, name %in% .name)
#   }
#   if (!is.null(.category)) {
#     df <- dplyr::filter(df, category %in% .category)
#   }
#   df
# }

utils::globalVariables("where")
