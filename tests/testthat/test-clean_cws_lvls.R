# TODO: rewrite to hard-code messy labels
# otherwise this should be a check of the data itself
test_that("clean_cws_lvls checks data types", {
    xt_grps <- readRDS(testthat::test_path("test_data/grp_test_cases.rds"))
    as_num <- as.numeric(levels(xt_grps$category))
    expect_error(clean_cws_lvls(as_num, is_category = TRUE))
    # error for all NA, but some NA fine
    expect_error(clean_cws_lvls(c(NA_character_)))
    expect_silent(dummy <- clean_cws_lvls(c(NA_character_, ">$30K")))

    # columns are currently character, not factor
    as_char <- clean_cws_lvls(xt_grps$category, is_category = TRUE)
    as_fct <- clean_cws_lvls(as.factor(xt_grps$category), is_category = TRUE)
    expect_setequal(as_char, as_fct)
    expect_s3_class(as_char, "factor")
    expect_s3_class(as_fct, "factor")
})

test_that("clean_cws_lvls returns expected levels", {
    xt_grps <- readRDS(testthat::test_path("test_data/grp_test_cases.rds"))
    # xt_grps <- dplyr::mutate(xt_grps, dplyr::across(category:group, list(clean = clean_cws_lvls)))
    xt_grps$category <- clean_cws_lvls(xt_grps$category, is_category = TRUE)
    xt_grps$group <- clean_cws_lvls(xt_grps$group, is_category = FALSE)
    xt_grps <- dplyr::mutate(xt_grps, dplyr::across(dplyr::where(is.factor), forcats::fct_drop))
    # sample might not include all groups & cats, but shouldn't include ones outside expected
    all_cats <- c(
        "Five Connecticuts",
        "Gender", "Age", "Race/Ethnicity", "Education", "Income", "With children",
        # statewide / large regions
        "Sexual orientation", "Gender identity", "Sexual orientation & gender identity",
        # statewide
        "Place of birth", "Latino origin", "Disability", "Incarceration history"
    )
    # every element of xt_grps$category should be in all_cats
    expect_in(levels(xt_grps$category), all_cats)
    expect_false(any(c("Kids in home", "Children in HH") %in% levels(xt_grps$category)))
    expect_false(any(grepl("(,000|Less than \\$| or more|^Income|Towns| [Tt]otal|School|Under age|or older)", levels(xt_grps$group))))
})

test_that("clean_cws_lvls calls order_lvls", {
    age <- c("Age 55 or older", "Under age 55", "18-34", "65+", "Ages 65+")
    order <- clean_cws_lvls(age, is_category = FALSE, order = TRUE)
    unorder <- clean_cws_lvls(age, is_category = FALSE, order = FALSE)
    expect_equal(
        levels(order),
        c("Ages 18-34", "Ages 18-54", "Ages 55+", "Ages 65+")
    )
    expect_equal(
        levels(unorder),
        c("Ages 55+", "Ages 18-54", "Ages 18-34", "Ages 65+")
    )
})

test_that("add_cats returns correct data types", {
    grps <- c(
        readRDS(testthat::test_path("test_data/grp_test_cases.rds"))$group,
        "New Haven total"
    )
    cat_vec <- add_cats(grps, return_table = FALSE)
    cat_tbl <- add_cats(grps, return_table = TRUE)
    expect_s3_class(cat_vec, "factor")
    expect_s3_class(cat_tbl, "data.frame")
})

test_that("add_cats fixes 'total' groups", {
    grps <- c(
        readRDS(testthat::test_path("test_data/grp_test_cases.rds"))$group,
        "New Haven total"
    )
    expect_false(
        c("New Haven total") %in% add_cats(grps, return_table = FALSE)
    )
})

test_that("order_lvls gets numbers in correct order", {
    age <- c("35-49", "35-64", "Under age 35")
    inc <- c("$30K+", "$30K or more", "Under $30K")
    expect_equal(
        levels(order_lvls(age)),
        # just check ordering, not string cleanup
        c("Under age 35", "35-49", "35-64")
    )
    expect_equal(
        levels(order_lvls(inc)),
        c("Under $30K", "$30K+", "$30K or more")
    )
})

test_that("order_lvls handles single numbers", {
    # adds dummy column nums2
    single_age <- c("65+", "Age 65 or more", "Age 65 and older")
    single_inc <- c("$100K or more", ">$100K", "$100K+", "Income >$100K")
    expect_equal(levels(clean_cws_lvls(single_age)), "Ages 65+")
    expect_equal(levels(clean_cws_lvls(single_inc)), "$100K+")
})
