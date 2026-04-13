#' @title Combine multiple response categories into one indicator-style one
#' @description This is a function to speed up a common task of combining multiple responses (e.g. "Excellent", "Good") into a single one (e.g. "Excellent / Good"). It's useful for converting questions in their original format into one where we can use a single number to show the percentage of people who rated something excellent or good. Two additional steps are optional but done by default: non-answers are dropped with [sub_nonanswers()], and the data is filtered for _only_ the named aggregated responses. Both of these steps can be disabled independently.
#' @details
#' A few gotchas are possible with this function:
#'
#' * Unless you're using a data frame with only one location, category, and group, you'll likely want to use this on a grouped data frame. This function _maintains_ all groups of the data frame passed in, but it is outside the purview of this function to _create_ any groups. You should do that in advance yourself (see examples).
#' * Removing non-answers and filtering happen independently but are informed by each other. If you decide to filter the data but not drop non-answers, the values of `nons` will be included as response categories to keep. This is to avoid a situation where more data is dropped than you might intend.
#'
#' @param data A data frame with groups maintained.
#' @param categories A named list of vectors. Each list item should be a character vector of response categories to lump together, and each vector's name should be the new name for the aggregated response. This follows the `...` argument of [forcats::fct_collapse()], as that is where it is passed directly.
#' @param filter_responses Logical: if `TRUE` (the default), only responses matching the names of the `categories` argument will be kept.
#' @param drop_nonanswers Logical: if `TRUE` (the default), will drop nonanswers with [sub_nonanswers()] after aggregating.
#' @return A data frame with groups maintained. It will have fewer rows, depending on arguments passed for filtering and dropping nonanswers.
#' @inheritParams sub_nonanswers
#' @examples
#'   xt <- system.file("extdata/test_xtab2021.xlsx", package = "dcws") |>
#'       read_xtabs(process = TRUE, year = 2021)
#' # how responsive is local govt?
#'   local_govt <- dplyr::filter(xt, code == "Q4A", category == "Age")
#'   unique(local_govt$response)
#' # combine excellent & good, drop non-answers, filter
#' # note that this question has different wording for "Don't know" response
#'   local_govt |>
#'      dplyr::group_by(category, group) |>
#'      combine_response(
#'          list(excellent_good = c("Excellent", "Good")),
#'          nons = c("Don't know enough about it in order to say", "Refused")
#'      )
#' # combine but no filtering or dropping
#' local_govt |>
#'      dplyr::group_by(category, group) |>
#'      combine_response(
#'          list(excellent_good = c("Excellent", "Good")),
#'          nons = c("Don't know enough about it in order to say", "Refused"),
#'          filter_responses = FALSE,
#'          drop_nonanswers = FALSE
#'      )
#'
#' # multiple combined categories--useful for Likert questions
#' area_change <- dplyr::filter(xt, code == "Q2", category == "Gender")
#' unique(area_change$response)
#' # using default filtering, this drops middle category ("About the same")
#' area_change |>
#'   dplyr::group_by(category, group) |>
#'   combine_response(
#'      list(
#'          `Getting better` = c("Much better", "Somewhat better"),
#'          `Getting worse` = c("Much worse", "Somewhat worse")
#'      ))
#' # instead turn off filtering but keep non-answer dropping
#' # unfortunately now responses are out of order...
#' area_change |>
#'   dplyr::group_by(category, group) |>
#'   combine_response(
#'      list(
#'          `Getting better` = c("Much better", "Somewhat better"),
#'          `Getting worse` = c("Much worse", "Somewhat worse")
#'      ), filter_responses = FALSE)
#' # ...unless response is already a factor, in which case levels stick
#' area_change |>
#'   dplyr::group_by(category, group) |>
#'   dplyr::mutate(response = forcats::as_factor(response)) |>
#'   combine_response(
#'      list(
#'          `Getting better` = c("Much better", "Somewhat better"),
#'          `Getting worse` = c("Much worse", "Somewhat worse")
#'      ), filter_responses = FALSE)
#'
#' @inheritDotParams sub_nonanswers
#' @export
#' @family data manipulation functions
#' @seealso [sub_nonanswers()] [forcats::fct_collapse()]
combine_response <- function(
    data,
    categories,
    response = response,
    value = value,
    filter_responses = TRUE,
    drop_nonanswers = TRUE,
    nons = c("Don't know", "Refused"),
    ...
) {
    if (
        !inherits(categories, "list") |
            length(names(categories)) == 0 |
            !all(purrr::map_lgl(categories, is.character))
    ) {
        cli::cli_abort(
            "{.var categories} should be a named list of character vectors"
        )
    }
    if (drop_nonanswers & is.null(nons)) {
        cli::cli_abort(
            "If passing along to {.fn sub_nonanswers}, {.arg nons} is required."
        )
    }
    check_cols(data, c({{ response }}, {{ value }}))
    # modeling after sub_nonanswers
    response_vals <- unique(dplyr::pull(data, {{ response }}))
    to_collapse <- purrr::flatten_chr(categories)
    xtra_resps <- setdiff(to_collapse, response_vals)

    if (length(xtra_resps) > 0) {
        cli::cli_warn(c(
            "!" = "Your list of categories contains responses not found in the data: {.val {xtra_resps}} not found."
        ))
    }

    grps <- dplyr::groups(data)
    data <- suppressWarnings(dplyr::mutate(
        data,
        {{ response }} := forcats::fct_collapse({{ response }}, !!!categories)
    ))
    data <- dplyr::group_by(data, !!!grps, {{ response }})
    data <- dplyr::summarise(data, dplyr::across({{ value }}, sum))

    if (drop_nonanswers) {
        data <- sub_nonanswers(
            data,
            response = response,
            value = value,
            nons = nons,
            ...
        )
    }
    # expected responses come from whether nons are dropped, whether filtering
    if (filter_responses) {
        if (drop_nonanswers) {
            resp_out <- names(categories)
        } else {
            resp_out <- c(names(categories), nons)
        }
        data <- dplyr::filter(data, {{ response }} %in% resp_out)
    }
    data <- dplyr::mutate(
        data,
        {{ response }} := forcats::fct_drop({{ response }})
    )
    data
}
