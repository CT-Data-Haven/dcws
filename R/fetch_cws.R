#' @title Fetch and subset DCWS data
#' @description This function returns the split data from `cws_full_data` in a nicer format, with options for subsetting. Filtering by year, location name, and category are named options, any of which take a vector of one or more values, but any valid conditions can be passed to `...` for more flexible filtering. For any named options, `NULL`, the default, will mean no filtering is done by that column.
#' @param ... Any number of conditions to filter by, which will be passed to `dplyr::filter`. These don't override the named options, so if you filter by `year > 2020` but then set `.year = 2015` you're not going to get any data.
#' @param .year A vector of one or more year(s) to subset by. If this is a character that contains a separator (`"_"`, `"-"`, or a space character), it will be assumed to be a span of years, such as for multi-year pooled crosstabs (e.g. `"2015_2024"`). Otherwise it's assumed this is a single year of the survey. If `NULL`, no filtering is done by year.
#' @param .name A vector of one or more strings giving the name(s) to subset by. If `NULL`, no filtering is done by name.
#' @param .category A vector of one or more strings giving the category(ies) to subset by. If `NULL`, no filtering is done by category.
#' @param .unnest Boolean: should data be returned nested into a column called `data`? Defaults to `FALSE`.
#' @param .add_wts Boolean: should groups' survey weights be attached, via a left-join with `dcws::cws_full_wts`? This is useful if you need to collapse groups later; otherwise you might get stuck in annoying `tidyr::unnest` messes.
#' @param .drop_ct Boolean: should statewide totals be included for each crosstab extract? This can be useful for a single location in order to have Connecticut values to compare against, but becomes redundant with multiple locations. The default `TRUE` means statewide averages will not be included.
#' @param .incl_questions Boolean: should the full text of each question be included? If `FALSE`, questions will be demarcated by just their codes, which take up less space but can change year to year. Defaults `TRUE`.
#' @return A data frame, with between 5 and 10 columns, depending on arguments:
#' * Columns `year`, `span`, `name`, and `code` are always included
#' * If `.incl_questions = TRUE`, column `question` is included
#' * If `.unnest = TRUE`, the crosstab data will be in columns `category`, `group`, `response`, and `value`
#' * If `.unnest = FALSE`, crosstab data columns will be nested in a list-column called `data`
#' * If `.add_wts = TRUE`, column `weight` is included
#' Note that the `span` column, a new addition, is a string giving the span of years included in that set of survey data. For single years, this will be the same as `year`; in the case of a pooled dataset 2015-2024, `year` will be `2024` and `span` will be `"2015_2024"`.
#' @examples
#' # no filtering
#' fetch_cws()
#'
#' # filter by year, name, and/or category
#' fetch_cws(.name = c("Greater New Haven", "New Haven")) # all years
#' fetch_cws(.year = 2024, .name = c("Greater New Haven", "New Haven"))
#' fetch_cws(.year = "2015_2024", .name = "New Haven", .category = c("Total", "Age", "Gender"))
#'
#' # filter by conditions
#' fetch_cws(code == "Q4E", .year = 2018, .name = c("Greater New Haven", "New Haven"), .unnest = TRUE)
#' fetch_cws(grepl("Q4[A-Z]", code), .year = 2018, .name = c("Greater New Haven", "New Haven"))
#' fetch_cws(grepl("health insurance", question), year > 2015, .name = "New Haven")
#' fetch_cws(question %in% c("Diabetes", "Asthma"), .name = "Bridgeport")
#'
#' # how you might use this to make a beautiful table
#' fetch_cws(code == "Q1", .year = 2021, .category = c("Income", "Gender"), .unnest = TRUE) |>
#'     dplyr::group_by(name, category, group) |>
#'     # might want to remove refused, don't know responses
#'     sub_nonanswers() |>
#'     dplyr::filter(response == "Yes") |>
#'     tidyr::pivot_wider(id_cols = name, names_from = group, values_from = value)
#'
#' # adding weights to collapse groups (e.g. combining income brackets)
#' fetch_cws(code == "Q1", .year = 2021, .add_wts = TRUE)
#' fetch_cws(
#'     .year = 2021, .name = "New Haven", .category = c("Total", "Age", "Income"),
#'     .add_wts = TRUE, .unnest = TRUE
#' )
#' @seealso [fetch_wts()] [cws_full_data]
#' @family accessing
#' @export
fetch_cws <- function(...,
                      .year = NULL,
                      .name = NULL,
                      .category = NULL,
                      .unnest = FALSE,
                      .add_wts = FALSE,
                      .drop_ct = TRUE,
                      .incl_questions = TRUE) {
    # warn if code is used anywhere--not stable year to year
    q <- purrr::map_chr(rlang::enquos(...), rlang::as_label)
    if (any(grepl("\\bcode\\b", q)) && (is.null(.year) || length(.year) > 1)) {
        cli::cli_alert_warning("Keep in mind that codes might change between years--double check before using {.var code} as a filter.")
    }

    # will this have manual filtering?
    need_manual <- any(nchar(q) > 0)

    # will this need questions?
    need_questions <- any(grepl("\\bquestion\\b", q)) || .incl_questions

    need_pooled <- any(grepl("[_\\-\\s]", .year))

    # get extract as single df
    out <- extract_cws(.year, .name, .category, bind = TRUE)
    if (.drop_ct) {
        out <- dplyr::filter(out, !(name != "Connecticut" & group == "Connecticut"))
    }

    if (need_questions) {
        codebook <- dcws::cws_codebook[, c("year", "code", "question")]
        out <- dplyr::left_join(out, codebook, by = c("year", "code"))
    }
    # manual filter
    if (need_manual) {
        out <- dplyr::filter(out, !!!rlang::quos(...))
    }

    if (nrow(out) == 0) {
        # used to be a warning, but that creates errors further down.
        cli::cli_abort("No data were found for this combination of years, locations, and/or categories.")
    }

    # drop questions if there now but not keeping in final output
    if (need_questions & !.incl_questions) {
        out$question <- NULL
    }

    # add weights if using
    if (.add_wts) {
        wts <- tidyr::unnest(dcws::cws_full_wts, weights)
        out <- dplyr::left_join(out, wts, by = c("year", "span", "name", "group"))
    }

    if (.incl_questions) {
        out <- dplyr::relocate(out, question, .after = code)
    }

    out <- dplyr::mutate(out, dplyr::across(tidyselect::where(is.factor), forcats::fct_drop))

    # if .unnest, return with year, span, name, code, question, category, group, response, value, weight if asked
    # otherwise return with year, span, name, code, question, data list-col
    if (!.unnest) {
        out <- tidyr::nest(out, data = tidyselect::any_of(c("category", "group", "response", "value", "weight")))
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
#' fetch_cws(code == "Q4E",
#'     .year = 2021,
#'     .name = c("Greater New Haven", "New Haven"), .unnest = TRUE
#' ) |>
#'     dplyr::left_join(fetch_wts(.unnest = TRUE), by = c("year", "span", "name", "group"))
#'
#' # instead, use fetch_cws with .add_wts = TRUE to get these weights joined for you
#' fetch_cws(code == "Q4E",
#'     .year = 2021,
#'     .name = c("Greater New Haven", "New Haven"),
#'     .add_wts = TRUE
#' )
#' @export
#' @family accessing
#' @seealso [fetch_cws()] [cws_full_wts]
fetch_wts <- function(..., .year = NULL, .name = NULL, .unnest = FALSE) {
    out <- dplyr::filter(dcws::cws_full_wts, !!!rlang::quos(...))
    # filter by name first---most drastic cut in results (holdover from fetch_cws)
    if (!is.null(.name)) {
        out <- out[out$name %in% .name, ]
    }
    if (!is.null(.year)) {
        yr_chr <- as.character(.year)
        out <- out[out$span %in% yr_chr, ]
    }

    if (nrow(out) == 0) {
        cli::cli_abort("No weights were found for this combination of years and locations.")
    }

    if (.unnest) {
        out <- tidyr::unnest(out, weights)
    }

    out
}

################### HELPERS ################

make_cws_id <- function(span = NULL, name = NULL) {
    # for null year or name, assume all--generate from cws_group_meta
    if (is.null(span)) {
        span <- unique(dcws::cws_group_meta$span)
    }
    if (is.null(name)) {
        name <- unique(dcws::cws_group_meta$name)
    }
    ids <- expand.grid(span = span, name = name)
    ids$year <- stringr::str_extract(ids$span, "\\d{4}$")
    paste(ids$year, ids$span, ids$name, sep = ".")
}

#' @title Easy extraction of crosstabs by ID
#' @param span Character: one or more timespans, or `NULL` for all spans
#' @param name Character: one or more location names, or `NULL` for all locations
#' @param category Character: one or more categories, or `NULL` for all categories
#' @param bind Boolean: whether to bind into a single data frame. If `FALSE`, returns a list of data frames
#' @return Either a list of data frames, or a single data frame, of all combinations of span, name, and category.
#' @keywords internal
#' @noRd
extract_cws <- function(span = NULL, name = NULL, category = NULL, bind = FALSE) {
    id <- make_cws_id(span, name)
    out <- dcws::cws_full_data[id]
    out <- purrr::compact(out)
    if (!is.null(category)) {
        out <- purrr::map(out, \(x) x[x$category %in% category, ])
    }

    if (bind) {
        out <- dplyr::bind_rows(out)
    }
    out
}
