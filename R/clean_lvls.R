# regex
to_replace <- c(
  "\\bNH\\b" = "New Haven",
  "(Inner Ring|Outer Ring)([\\w\\s]+$)" = "\\2 \\1",
  Etnicity = "Ethnicity",
  "Hispanic" = "Latino",
  "(?<=\\-)(\\d+)(?=K)" = "$\\1",
  "\\s(and|or) older" = "+",
  "(?<=.)High" = "high",
  "School" = "school",
  " (\\-|to) " = "-",
  "Less than (?=\\$)" = "<",
  "(?<=,000) or more" = "+",
  "^\\b(\\d+)" = "Ages \\1",
  "hich school" = "high school",
  ",000" = "K",
  "Age\\b(?=.)" = "Ages"
)

# regex
to_remove <- paste(c(
  "\\s((?<!Border )Towns|Statewide|Region)",
  "(\\sTotal|Total\\s)",
  "(?<=(/|\\<))\\s",
  "(?<=Associate's)( degree)",
  "(?<=Bachelor's)( degree)"
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


#' @title Clean up categories and groups from crosstabs
#' @description This is a bunch of string cleaning to standardize the categories (Gender, Age, etc) and groups (Male, Ages 65+, etc) across all available crosstabs. This does the same operation on both categories and groups because there is some overlap. The lists of regex and other replacements aren't exported, but they aren't hidden either: access them at `dcws:::to_replace`, `dcws:::to_remove`, `dcws:::to_recode`, or `dcws:::to_collapse` if you need them.
#' @param x A vector. If not a factor already, will be coerced to one.
#' @examples
#' # vector of strings as read in from crosstabs
#' categories <- c("Connecticut", "NH Inner Ring", "Gender", "Age",
#'                 "Race/Ethnicity", "Education", "Income", "Children in HH")
#' levels(clean_lvls(categories))
#'
#' groups <- c("M", "F", "18-34", "35 to 49", "65 and older",
#'             "Black/Afr Amer", "African American/Black", "High School",
#'             "Less than $15,000", "$15,000 to $30,000", "No")
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


order_lvls <- function(x) {
  if (!is.factor(x)) x <- forcats::as_factor(x)
  df <- data.frame(x = x)
  df$nums <- purrr::map(stringr::str_extract_all(df$x, "\\d+"), as.numeric)
  df$under <- +!stringr::str_detect(df$x, "^(Under |Less |\\<)") # 0 if detected
  df$over <- +stringr::str_detect(df$x, "(\\+| more| higher)") # 1 if detected
  df <- tidyr::unnest_wider(df, nums, names_sep = "")
  df <- dplyr::arrange(df, nums1, under, over, nums2)
  df$x <- forcats::fct_inorder(df$x)
  df$x
}
