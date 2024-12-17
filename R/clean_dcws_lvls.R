# regex
to_replace <- c(
  "\\bNH\\b" = "New Haven",
  "(Inner Ring|Outer Ring)([\\w\\s]+$)" = "\\2 \\1",
  "Etnicity" = "Ethnicity",
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
  "(?<=Bachelor's)( degree)",
  "\\*$",
  "\\stotal$"
), collapse = "|")

# full strings
to_recode <- list(
  "Greater Waterbury" = "CCF",
  "Greater Waterbury" = "CCF Area",
  "Greater Hartford" = "CRCOG",
  "Port Chester NY" = "Port Chester",
  # "5CT" = "Five Connecticuts",
  "Connecticut" = "Connecticut Cities/Towns",
  "Connecticut" = "CT",
  "With children" = "Children in HH",
  "Male" = "M",
  "Female" = "F",
  "Kids in home" = "Yes",
  "No kids" = "No",
  "High school" = "High school or GED",
  "$75K-$100K" = "$75K-100K",
  "Other race" = "Other",
  "Lower Naugatuck Valley" = "Valley"
)

# full strings
to_collapse <- list(
  "Not white" = c("Not White", "Non-White", "Not-White"),
  "Black" = c("Black/Afr Amer", "Black/ Afr Amer", "African American/Black"),
  "Indigenous" = c("Native Amer", "American Indian", "Native American")
)

# full xwalk
grp2cat <- list(
  "Five Connecticuts" = c("Wealthy", "Suburban", "Rural", "Urban Periphery", "Urban Core"),
  "Gender" = c("Male", "Female", "Nonbinary"),
  "Age" = c("Ages 18-34", "Ages 18-49", "Ages 35-49", "Ages 35-54", "Ages 50-64", "Ages 50+", "Under age 55", "Ages 55+", "Ages 65+"),
  "Race/Ethnicity" = c("White", "Black", "Latino", "Asian", "Indigenous", "Not white", "Other race"),
  "Education" = c("Less than high school", "High school or less", "High school", "Some college or less", "Some college or Associate's", "Some college or higher", "Less than Bachelor's", "Bachelor's or higher"),
  "Income" = c("<$15K", "$15K-$30K", "<$30K", "$30K-$50K", "$30K-$75K", "$30K-$100K", "$50K-$75K", "<$75K", "$75K-$100K", "$75K+", "<$100K", "$100K-$200K", ">$100K", "$100K+", ">$200K", "$200K+"),
  "With children" = c("No kids", "Kids in home"),
  "Sexual orientation & gender identity" = c("Cisgender and straight", "Identifies as LGBTQ"),
  "Sexual orientation" = c("Lesbian, gay, or bisexual", "Straight"),
  "Place of birth" = c("Born in the US", "Born outside the US"),
  "Latino origin" = c("Mexican", "Puerto Rican", "Puerto Rican, born in Puerto Rico", "Puerto Rican, mainland born", "Other Latino"),
  "Disability" = c("Disabled", "Not disabled"),
  "Incarceration history" = c("Never incarcerated", "Incarcerated once", "Incarcerated two or more times"),
  "Gender identity" = c("Cisgender", "Transgender")
)

#' @title Clean up categories and groups from crosstabs
#' @description This is a bunch of string cleaning to standardize the categories (Gender, Age, etc) and groups (Male, Ages 65+, etc) across all available crosstabs. This does the same operation on both categories and groups because there is some overlap. The lists of regex and other replacements aren't exported, but they aren't hidden either: access them at `dcws:::to_replace`, `dcws:::to_remove`, `dcws:::to_recode`, or `dcws:::to_collapse` if you need them.
#' @param x A vector. If not a factor already, will be coerced to one.
#' @examples
#' # vector of strings as read in from crosstabs
#' categories <- c("Connecticut", "NH Inner Ring", "Gender", "Age",
#'                 "Race/Ethnicity", "Education", "Income", "Children in HH")
#' levels(clean_dcws_lvls(categories))
#'
#' groups <- c("M", "F", "18-34", "35 to 49", "65 and older",
#'             "Black/Afr Amer", "African American/Black", "High School",
#'             "Less than $15,000", "$15,000 to $30,000", "No")
#' levels(clean_dcws_lvls(groups))
#' @return A factor
#' @export
clean_dcws_lvls <- function(x) {
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

add_cats <- function(x, return_table) {
  x <- clean_dcws_lvls(x)
  cats <- suppressWarnings(forcats::fct_collapse(x, !!!grp2cat))
  cats <- ifelse(grepl(" total", cats), "Total", as.character(cats))
  # cats <- forcats::as_factor(cats)
  # cats <- suppressWarnings(forcats::fct_relevel(cats, names(grp2cat)))
  if (return_table) {
    data.frame(category = cats, group = x)
  } else {
    cats
  }
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
