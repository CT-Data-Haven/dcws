# regex
to_replace <- c(
  "\\bNH\\b" = "New Haven",
  "(Inner Ring|Outer Ring)([\\w\\s]+$)" = "\\2 \\1",
  Etnicity = "Ethnicity",
  "(?<=\\-)(\\d+)(?=K)" = "$\\1",
  "\\s(and|or) older" = "+",
  "(?<=.)High" = "high",
  "School" = "school",
  " (\\-|to) " = "-",
  "Less than (?=\\$)" = "<",
  "(?<=,000) or more" = "+",
  "^\\b(\\d+)" = "Ages \\1",
  "hich school" = "high school",
  ",000" = "K"
)

# regex
to_remove <- paste(c(
  "\\s((?<!Border )Towns|Statewide|Region)",
  "(\\sTotal|Total\\s)",
  "(?<=(/|\\<))\\s",
  "(?<=Associate's) degree",
  "(?<=Bachelor's )(degree )(?=.)"
), collapse = "|")

# full strings
to_recode <- list(
  "Greater Waterbury" = "CCF",
  "Greater Hartford" = "CRCOG",
  "Port Chester NY" = "Port Chester",
  # "5CT" = "Five Connecticuts",
  "Connecticut" = "Connecticut Cities/Towns",
  "With children" = "Children in HH",
  Male = "M",
  Female = "F",
  "Kids in home" = "Yes",
  "No kids" = "No",
  "High school" = "High school or GED",
  "$75K-$100K" = "$75K-100K",
  Connecticut = "CT",
  "Other race" = "Other",
  "Lower Naugatuck Valley" = "Valley"
)

# full strings
to_collapse <- list(
  "Not white" = c("Not White", "Non-White", "Not-White"),
  Black = c("Black/Afr Amer", "Black/ Afr Amer", "African American/Black"),
  "Native American" = c("Native Amer", "American Indian")
)


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

#' @title Clean up categories and groups from crosstabs
#' @description This is a bunch of string cleaning to standardize the categories (Gender, Age, etc) and groups (Male, Ages 65+, etc) across all available crosstabs. This does the same operation on both categories and groups because there is some overlap; therefore, all warnings are suppressed because it would otherwise be very noisy.
#' @param x A vector. If not a factor already, will be coerced to one.
#' @examples
#' # vector of strings as read in from crosstabs
#' categories <- c("Connecticut", "NH Inner Ring", "Gender", "Age",
#'                 "Race/Ethnicity", "Education", "Income", "Children in HH")
#' levels(clean_lvls(categories))
#'
#' groups <- c("M", "F", "18-34", "Black/Afr Amer", "High School", "<$30K",
#'             "$75K-100K", "No")
#' levels(clean_lvls(groups))
#' @return A factor
#' @export
clean_lvls <- function(x) {
  if (!is.factor(x)) x <- forcats::as_factor(x)
  suppressWarnings({
    x <- forcats::fct_relabel(x, stringr::str_replace_all, to_replace)
    x <- forcats::fct_relabel(x, stringr::str_remove_all, to_remove)
    x <- forcats::fct_recode(x, !!!to_recode)
    x <- forcats::fct_collapse(x, !!!to_collapse)
    x <- forcats::fct_relabel(x, stringr::str_squish)
    x
  })
}


