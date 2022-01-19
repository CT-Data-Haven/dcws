#' @title Fetch and subset DCWS data
#' @description This function returns the doubly-nested data from `cws_full_data` in a nicer format, with options for subsetting. Filtering by year, location name, and category are named options, any of which take a vector of one or more values, but any valid conditions can be passed to `...` for more flexible filtering. For any named options, `NULL`, the default, will mean no filtering is done by that column.
#' @param ... Any number of conditions to filter by, which will be passed to `dplyr::filter`. These don't override the named options, so if you filter by `year > 2020` but then set `.year = 2015` you're not going to get any data.
#' @param .year A vector of one or more numbers giving the year(s) to subset by. If `NULL`, no filtering is done by year.
#' @param .name A vector of one or more strings giving the name(s) to subset by. If `NULL`, no filtering is done by name.
#' @param .category A vector of one or more strings giving the category(ies) to subset by. If `NULL`, no filtering is done by category.
#' @param .unnest Logical: should the `data` column be unnested? This just saves a step of calling `tidyr::unnest` but defaults to false.
#' @return A data frame, with either 5 columns (if `.unnest = FALSE`) or 8 columns (if `.unnest = TRUE`).
#' * For `.unnest = FALSE`: columns are `year`, `name`, `code`, `question`, and a list of nested data frames `data`
#' * For `.unnest = TRUE`: `year`, `name`, `code`, `question`, `category`, `group`, `response`, and `value`
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
#' fetch_cws(code == "Q1", .year = 2021, .category = c("Income", "Gender"), .unnest = TRUE) %>%
#'   dplyr::group_by(name, category, group) %>%
#'   cwi::sub_nonanswers() %>%
#'   dplyr::filter(response == "Yes") %>%
#'   tidyr::pivot_wider(id_cols = name, names_from = group, values_from = value)
#' @export
#' @seealso cws_full_data
fetch_cws <- function(..., .year = NULL, .name = NULL, .category = NULL, .unnest = FALSE) {
  # warn if code is used anywhere--not stable year to year
  q <- purrr::map_chr(rlang::enquos(...), rlang::as_label)
  if (any(grepl("\\bcode\\b", q)) & (is.null(.year) | length(.year) > 1)) {
    warning("Keep in mind that codes might change between years--double check before using code as a filter.")
  }

  out <- dcws::cws_full_data %>%
    tidyr::unnest(survey) %>%
    dplyr::filter(!!!rlang::quos(...))
  if (!is.null(.year)) {
    if (is.character(.year)) .year <- as.numeric(.year)
    out <- dplyr::filter(out, year %in% .year)
  }
  if (!is.null(.name)) {
    out <- dplyr::filter(out, name %in% .name)
  }
  if (!is.null(.category)) {
    out <- dplyr::mutate(out, data = purrr::map(data, dplyr::filter, category %in% .category))
  }
  if (nrow(dplyr::bind_rows(out$data)) == 0) {
    message("No results were found for this combination of years, locations, and/or categories.")
    return(out)
  }

  if (.unnest) {
    out <- tidyr::unnest(out, data)
  }

  out
}


