# TODO: rewrite to hard-code messy labels
# otherwise this should be a check of the data itself
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
    expect_false(any(grepl("(,000|Less than \\$| or more|^Income|Towns| [Tt]otal|School)", levels(xt_grps$group))))
})
