clean_paths <- function(x) {
  paths <- x
  x <- xfun::sans_ext(basename(x))
  x <- stringr::str_remove(x, "^DataHaven\\d{4}[\\s_]")
  x <- stringr::str_remove_all(x, "[\\s_](Crosstabs|Pub)")
  x <- stringr::str_replace_all(x, c("^CCF$" = "Greater Waterbury",
                                  "^CRCOG$" = "Greater Hartford",
                                  "Cty" = "County"))
  x <- stringr::str_replace_all(x, "(?<=[a-z])\\B(?=[A-Z])", " ")
  x <- stringr::str_remove_all(x, "\\s{2,}")
  x <- stringr::str_replace(x, "(Inner Ring|Outer Ring)([\\w\\s]+$)", "\\2 \\1")
  x <- stringr::str_remove(x, "Greater (?=[\\w\\s]+Ring)")
  x <- stringr::str_remove_all(x, "((?<!Border )Towns|Statewide|Region|Central CT Health District|CCF|CRCOG)")
  x <- stringr::str_replace(x, "(?<=NY)([A-Z])", " \\1")
  x <- stringr::str_replace_all(x, "([A-Z]{2,})([A-Z])(?=[a-z])", "\\1 \\2")
  x <- stringr::str_trim(x)
  x <- dplyr::recode(x, Valley = "Lower Naugatuck Valley", "Port Chester" = "Port Chester NY")
  stats::setNames(paths, x)
}
