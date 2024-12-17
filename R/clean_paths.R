clean_paths <- function(x) {
    paths <- x
    x <- xfun::sans_ext(basename(x))
    # decide which function to use based on 2024 flags
    x <- ifelse(grepl("^dcws_.+\\-v", x),
        clean_paths_r_(x),
        clean_paths_spss_(x)
    )
    x <- path_regex_(x)
    stats::setNames(paths, x)
}

collapse_patt_ <- function(patt) {
    patt <- paste(patt, collapse = "|")
    sprintf("(%s)", patt)
}

path_regex_ <- function(x) {
    abbrevs <- collapse_patt_(c("\\bCog\\b", "Echn", "\\bZip\\b", "5ct"))
    apost <- sprintf("\\b%s(s)\\b", collapse_patt_(c("Children", "Vincent", "Mary")))
    replace <- c("Uconn" = "UConn", "Lawrence Memorial" = "Lawrence + Memorial")
    
    x <- gsub(abbrevs, "\\U\\1", x, perl = TRUE)
    x <- stringr::str_replace_all(x, apost, "\\1'\\2")
    x <- stringr::str_replace_all(x, replace)
    x
}


clean_paths_spss_ <- function(x) {
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

clean_paths_r_ <- function(x) {
    x <- stringr::str_remove(x, "^dcws_")
    x <- stringr::str_remove(x, "\\-.+$")
    x <- stringr::str_remove(x, "(_\\d{4})+$")
    # x <- stringr::str_replace_all(x, "_", " ")
    # x <- stringr::str_to_title(x)
    x <- snakecase::to_title_case(x)
    x
}
