cws_lvl_patts_ <- function(is_category) {
    # whether it's category or group changes children labels
    # i.e. category = with children, group = kids in home, no kids
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
        "(?<=0K) or more" = "+",
        "(?<=\\d) or more" = "+",
        # "Under age " = "Ages 18-",
        "^\\b(\\d{2,})" = "Ages \\1",
        "hich school" = "high school",
        ",000" = "K",
        "Age\\b(?=.)" = "Ages",
        # "Kids" = "Children",
        # "kids" = "children",
        "\\bHH" = "home",
        "^\\>(\\$[\\d\\w]+$)" = "\\1+"
    )
    if (is_category) {

    } else {
        to_replace <- c(to_replace, c(
            Children = "Kids",
            children = "kids"
        ))
    }

    # regex
    to_remove <- paste(c(
        "\\s((?<!Border )Towns|Statewide|Region)",
        "(\\s[Tt]otal|[Tt]otal\\s)",
        "(?<=(/|\\<))\\s",
        "(?<=Associate's)( degree)",
        "(?<=Bachelor's)( degree)",
        "^Income ",
        "\\*$"
    ), collapse = "|")

    # full strings
    to_recode <- list(
        "Greater Waterbury" = "CCF",
        "Greater Waterbury" = "CCF Area",
        "Greater Waterbury" = "CCF Towns",
        "Greater Hartford" = "CRCOG",
        "Port Chester NY" = "Port Chester",
        # "5CT" = "Five Connecticuts",
        "Five Connecticuts" = "Connecticut Cities/Towns",
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
    if (is_category) {
        to_recode <- c(to_recode, list("With children" = "Children in home"))
    } else {
        to_recode <- c(to_recode, list("No kids" = "No kids in home"))
    }

    # full strings
    to_collapse <- list(
        "Not white" = c("Not White", "Non-White", "Not-White"),
        "Black" = c("Black/Afr Amer", "Black/ Afr Amer", "African American/Black"),
        "Indigenous" = c("Native Amer", "American Indian", "Native American")
    )

    list(
        to_remove = to_remove,
        to_replace = to_replace,
        to_recode = to_recode,
        to_collapse = to_collapse
    )
}

under_endpt <- function(x) {
    bound <- as.numeric(stringr::str_extract(x, "\\d+"))
    max <- bound - 1
    repl <- paste("Ages 18", max, sep = "-")
    stringr::str_replace(x, "(?:Under age )(\\d+)", repl)
}

#' @title Clean up categories and groups from crosstabs
#' @description This is a bunch of string cleaning to standardize the categories (Gender, Age, etc) and groups (Male, Ages 65+, etc) across all available crosstabs. This does the same operation on both categories and groups because there is some overlap. The lists of regex and other replacements aren't exported, but they aren't hidden either: access them at `dcws:::to_replace`, `dcws:::to_remove`, `dcws:::to_recode`, or `dcws:::to_collapse` if you need them.
#' @param x A vector. If not a factor already, will be coerced to one.
#' @param is_category Boolean: if `FALSE`, assume these are groups (e.g. "High school or less", "Some college or Associate's") rather than categories (e.g. "Education").
#' @param order Boolean: if `TRUE`, groups will be put into logical order (e.g. <$30K, $30K-$100K). This only applies to groups (i.e. `is_category = FALSE`), and only really affects ages and income groups. If `FALSE` (default), levels will be kept in the same order as they were received.
#' @examples
#' # vector of strings as read in from crosstabs
#' categories <- c(
#'     "Connecticut", "NH Inner Ring", "Gender", "Age",
#'     "Race/Ethnicity", "Education", "Income", "Children in HH"
#' )
#' levels(clean_cws_lvls(categories, is_category = TRUE))
#'
#' groups <- c(
#'     "M", "F", "18-34", "35 to 49", "65 and older",
#'     "Black/Afr Amer", "African American/Black", "High School",
#'     "Less than $15,000", "$15,000 to $30,000", "No"
#' )
#' levels(clean_cws_lvls(groups))
#' @return A factor of the same length as `x`
#' @family cleaning
#' @export
clean_cws_lvls <- function(x, is_category = FALSE, order = FALSE) {
    if (!class(x) %in% c("factor", "character") | all(is.na(x))) {
        cli::cli_abort("{.var x} should be a non-empty character vector or a factor")
    }
    if (!is.factor(x)) x <- forcats::as_factor(x)
    patts <- cws_lvl_patts_(is_category = is_category)
    suppressWarnings({
        # weird but might work best to do twice
        x <- forcats::fct_relabel(x, stringr::str_remove_all, patts[["to_remove"]])
        x <- forcats::fct_relabel(x, stringr::str_replace_all, patts[["to_replace"]])
        x <- forcats::fct_recode(x, !!!patts[["to_recode"]])
        x <- forcats::fct_collapse(x, !!!patts[["to_collapse"]])
        x <- forcats::fct_relabel(x, \(s) ifelse(grepl("Under age ", s), under_endpt(s), s))
        x <- forcats::fct_relabel(x, stringr::str_squish)
    })
    if (order && !is_category) {
        x <- order_lvls(x)
    }
    x
}

add_cats <- function(x, return_table) {
    # full xwalk
    grp2cat <- list(
        "Five Connecticuts" = c("Wealthy", "Suburban", "Rural", "Urban Periphery", "Urban Core"),
        "Gender" = c("Male", "Female", "Nonbinary"),
        "Age" = c("Ages 18-34", "Ages 18-49", "Ages 35-49", "Ages 35-54", "Ages 50-64", "Ages 50+", "Under age 55", "Ages 55+", "Ages 65+"),
        "Race/Ethnicity" = c("White", "Black", "Latino", "Asian", "Indigenous", "Not white", "Other race"),
        "Education" = c("Less than high school", "High school or less", "High school", "Some college or less", "Some college or Associate's", "Some college or higher", "Less than Bachelor's", "Bachelor's or higher"),
        "Income" = c("<$15K", "$15K-$30K", "<$30K", "$30K-$50K", "$30K-$75K", "$30K-$100K", "$50K-$75K", "<$75K", "$75K-$100K", "$75K+", "<$100K", "$100K-$200K", ">$100K", "$100K+", ">$200K", "$200K+"),
        "With children" = c("No kids", "Kids in home", "No kids in home"),
        "Sexual orientation & gender identity" = c("Cisgender and straight", "Identifies as LGBTQ"),
        "Sexual orientation" = c("Lesbian, gay, or bisexual", "Straight"),
        "Place of birth" = c("Born in the US", "Born outside the US"),
        "Latino origin" = c("Mexican", "Puerto Rican", "Puerto Rican, born in Puerto Rico", "Puerto Rican, mainland born", "Other Latino"),
        "Disability" = c("Disabled", "Not disabled"),
        "Incarceration history" = c("Never incarcerated", "Incarcerated once", "Incarcerated two or more times"),
        "Gender identity" = c("Cisgender", "Transgender")
    )

    x <- clean_cws_lvls(x, is_category = FALSE)
    cats <- suppressWarnings(forcats::fct_collapse(x, !!!grp2cat))
    cats <- ifelse(grepl(" total", cats), "Total", as.character(cats))
    cats <- forcats::as_factor(cats)
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
    # handle if all groups only give a single number, e.g. 65+
    if (!"nums2" %in% names(df)) {
        df$nums2 <- NA_character_
    }
    df <- dplyr::arrange(df, nums1, under, over, nums2)
    df$x <- forcats::fct_inorder(df$x)
    df$x
}
