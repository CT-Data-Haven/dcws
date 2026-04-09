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
    data <- dplyr::mutate(
        data,
        {{ response }} := forcats::fct_collapse({{ response }}, !!!categories)
    )
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
