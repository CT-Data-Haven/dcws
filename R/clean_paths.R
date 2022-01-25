clean_paths <- function(x) {
  nms <- x %>%
    basename() %>%
    xfun::sans_ext() %>%
    stringr::str_remove("^DataHaven\\d{4}[\\s_]") %>%
    stringr::str_remove_all("[\\s_](Crosstabs|Pub)") %>%
    stringr::str_replace_all(c("^CCF$" = "Greater Waterbury",
                               "^CRCOG$" = "Greater Hartford",
                               "Cty" = "County")) %>%
    stringr::str_replace_all("(?<=[a-z])\\B(?=[A-Z])", " ") %>%
    stringr::str_remove_all("\\s{2,}") %>%
    stringr::str_replace("(Inner Ring|Outer Ring)([\\w\\s]+$)", "\\2 \\1") %>%
    stringr::str_remove("Greater (?=[\\w\\s]+Ring)") %>%
    stringr::str_remove_all("((?<!Border )Towns|Statewide|Region|Central CT Health District|CCF|CRCOG)") %>%
    stringr::str_replace("(?<=NY)([A-Z])", " \\1") %>%
    stringr::str_trim() %>%
    dplyr::recode(Valley = "Lower Naugatuck Valley")
  stats::setNames(x, nms)
}
