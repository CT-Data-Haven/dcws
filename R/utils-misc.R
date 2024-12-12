rleid <- function(x) {
  if (is.factor(x)) x <- as.character(x)
  durations <- rle(x)$lengths
  unlist(purrr::imap(durations, function(d, i) rep(i, times = d)))
}

streak <- function(x) {
  durations <- rle(x)$lengths
  rep(seq_along(durations), times = durations)
}

cws_check_yr <- function(path, year) {
  if (is.null(year) & is.null(path)) {
    cli::cli_abort("Guessing the year is only available for functions that take a path argument. Please supply the year explicitly.")
  }
  if (is.null(year)) {
    # match year pattern, get last match
    year <- stringr::str_extract_all(path, "(?<=[\\ba-z_])(\\d{4})(?=[\\b\\-_\\s])")[[1]]
    year <- year[length(year)]
    year <- as.numeric(year)
    cli::cli_inform(c("Guessing year from the path",
                      "i" = "Based on the path {path}, assuming {.var year} = {year}."))
  }
  if (!is.numeric(year)) {
    cli::cli_abort("{.var year} should be a number for the year or end year of the survey.")
  }
  if (year < 2015) {
    cli::cli_warn("This function was designed for DCWS crosstabs starting with 2015. Other years might have unexpected results.")
  }
  year
}

# port from camiller
filter_after <- function(data, ..., .streak = TRUE) {
  q <- rlang::quos(...)
  matches <- data
  # matches <- dplyr::mutate(matches, .match = purrr::pmap_lgl(list(!!!q), all))
  # matches <- dplyr::mutate(matches, .occur = cumsum(.match) > 0)
  matches <- dplyr::mutate(matches, .match = purrr::pmap_lgl(list(!!!q), all))
  matches[[".occur"]] <- cumsum(matches$.match) > 0

  if (.streak) {
    out <- matches[matches$.occur & streak(matches$.match) > 1, ]
  } else {
    out <- matches[matches$.occur & dplyr::lag(matches$.occur), ]
  }
  out$.match <- NULL
  out$.occur <- NULL
  out
}

filter_until <- function(data, ...) {
  q <- rlang::quos(...)
  dplyr::filter(data, cumsum(!!!q) == 0)
}
