rleid <- function(x) {
  if (is.factor(x)) x <- as.character(x)
  durations <- rle(x)$lengths
  unlist(purrr::imap(durations, function(d, i) rep(i, times = d)))
}
