streak <- function(x) {
    if (is.factor(x)) x <- as.character(x)
    durations <- rle(x)$lengths
    rep(seq_along(durations), times = durations)
}

cws_check_yr <- function(path, year, verbose) {
    if (length(path) > 1) {
        cli::cli_abort("Because of how it handles parsing years, `cws_check_yr` only takes 1 path at a time.")
    }
    if (is.null(year) & is.null(path)) {
        cli::cli_abort("Guessing the year is only available for functions that take a path argument. Please supply the year explicitly.")
    }
    # if not numeric, try:
    # * to coerce
    # * to guess before error
    if (!is.null(year)) {
        if (!is.numeric(year)) {
            year <- suppressWarnings(as.numeric(year))
        }
        if (is.na(year) | year < 1900 | year > 2100) {
            year <- NULL
        }
    }
    if (is.null(year)) {
        guessing <- TRUE
        # match year pattern, get last match
        # also need to handle test files
        if (grepl("test_xtab", path)) {
            patt <- "(\\d{4})"
        } else {
            patt <- "(?<=\\D)(\\d{4})(?=[\\b\\-_\\s])"
        }
        year <- stringr::str_extract_all(basename(path), patt)[[1]]
        year <- year[length(year)]
        year <- as.numeric(year)
        if (verbose) {
            cli::cli_inform(c("Guessing year from the path",
                "i" = "Based on the path {path}, assuming {.var year} = {year}."
            ))
        }
    } else {
        guessing <- FALSE
    }
    if (year < 2015) {
        cli::cli_warn("This function was designed for DCWS crosstabs starting with 2015. Other years might have unexpected results.")
    }
    year
}

# port from camiller
filter_after <- function(data, ..., .streak = TRUE) {
    q <- rlang::quos(...)
    out <- dplyr::mutate(data, .match = purrr::pmap_lgl(list(!!!q), all))
    out[[".occur"]] <- cumsum(out$.match) > 0

    if (.streak) {
        # streak needs to be calculated *after* filtering for occurrences
        out <- out[out$.occur, ]
        out <- out[streak(out$.match) > 1, ]
    } else {
        out <- out[out$.occur & dplyr::lag(out$.occur), ]
    }
    out$.match <- NULL
    out$.occur <- NULL
    out
}

filter_until <- function(data, ...) {
    q <- rlang::quos(...)
    dplyr::filter(data, cumsum(!!!q) == 0)
}

#' Check that all bare column names, included diffused ones, are in a data frame
#' If not, throws dplyr::select's error
#' @param data Data frame
#' @param ... Vector, etc giving tidyeval columns
#' @noRd
check_cols <- function(data, ...) {
    selected_cols <- tidyselect::eval_select(
        rlang::expr(c(...)),
        data,
        error_call = rlang::caller_env()
    )
    invisible(TRUE)
}
