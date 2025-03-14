# if not including years, return single vector of names
# else return tibble
#' @title parse_cws_paths
#' @description Extract location names and years from DCWS crosstab paths
#' @param paths String: path
#' @param incl_year Boolean: whether to extract year(s)
#' @param incl_tag Boolean: whether to extract tag
#' @return Data frame
#' @noRd
parse_cws_paths <- function(paths, incl_year = TRUE, incl_tag = TRUE) {
    name <- xfun::sans_ext(basename(paths))
    # decide which function to use based on 2024 flags
    name <- ifelse(grepl("^dcws_.+\\-v", name),
        extract_name_r_(name),
        extract_name_spss_(name)
    )
    name <- path_regex_(name)
    if (incl_year) {
        span <- stringr::str_extract_all(paths, "(?<=\\D)(\\d{4})(?=[_\\s\\-])")
        span <- purrr::map_chr(span, paste, collapse = "_")
        year <- as.numeric(stringr::str_remove(span, "^\\d{4}_"))
    } else {
        span <- NULL
        year <- NULL
    }
    if (incl_tag) {
        tag <- extract_tag_(paths)
    } else {
        tag <- NULL
    }
    tibble::tibble(name, span, year, tag = tag, path = paths)
}

collapse_patt_ <- function(patt) {
    patt <- paste(patt, collapse = "|")
    sprintf("(%s)", patt)
}

path_regex_ <- function(x) {
    abbrevs <- collapse_patt_(c("\\bCog\\b", "Echn", "\\bZip\\b", "5ct", "Dmhas"))
    apost <- sprintf("\\b%s(s)\\b", collapse_patt_(c("Children", "Vincent", "Mary")))
    replace <- c("Uconn" = "UConn", "Lawrence Memorial" = "Lawrence + Memorial")

    x <- gsub(abbrevs, "\\U\\1", x, perl = TRUE)
    x <- stringr::str_replace_all(x, apost, "\\1'\\2")
    x <- stringr::str_replace_all(x, replace)
    x
}

extract_tag_ <- function(x, patt = "\\-v(\\d\\.){3,4}") {
    x <- stringr::str_extract(x, patt)
    # drop leading / trailing punct
    x <- stringr::str_remove_all(x, "(^[[:punct:]]|[[:punct:]]$)")
    x
}

extract_name_spss_ <- function(x) {
    x <- stringr::str_remove(x, "^DataHaven\\d{4}[\\s_]")
    x <- stringr::str_remove_all(x, "[\\s_](Crosstabs|Pub)")
    x <- stringr::str_replace_all(x, c(
        "^CCF$" = "Greater Waterbury",
        "^CRCOG$" = "Greater Hartford",
        "Cty" = "County"
    ))
    x <- stringr::str_replace_all(x, "(?<=[a-z])\\B(?=[A-Z])", " ")
    x <- stringr::str_remove_all(x, "\\s{2,}")
    x <- stringr::str_replace(x, "(Inner Ring|Outer Ring)([\\w\\s]+$)", "\\2 \\1")
    x <- stringr::str_remove(x, "Greater (?=[\\w\\s]+Ring)")
    x <- stringr::str_remove_all(x, "((?<!Border )Towns|Statewide|Region|Central CT Health District|CCF|CRCOG)")
    x <- stringr::str_replace(x, "(?<=NY)([A-Z])", " \\1")
    x <- stringr::str_replace_all(x, "([A-Z]{2,})([A-Z])(?=[a-z])", "\\1 \\2")
    x <- stringr::str_trim(x)
    x <- dplyr::recode(x, Valley = "Lower Naugatuck Valley", "Port Chester" = "Port Chester NY")
    x
}

extract_name_r_ <- function(x) {
    x <- stringr::str_remove(x, "^dcws_")
    x <- stringr::str_remove(x, "\\-.+$")
    x <- stringr::str_remove(x, "(_\\d{4})+$")
    # x <- stringr::str_replace_all(x, "_", " ")
    # x <- stringr::str_to_title(x)
    x <- snakecase::to_title_case(x)
    x
}
