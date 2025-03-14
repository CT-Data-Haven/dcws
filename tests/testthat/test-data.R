test_that("full dataset has correct categories & groups", {
    # no running functions---just check that data was correctly standardized already
    all_grps <- cws_full_data |>
        dplyr::bind_rows(.id = "id") |>
        dplyr::filter(category != "Total") |>
        dplyr::filter(as.character(category) != as.character(group)) |>
        dplyr::distinct(category, group) |>
        dplyr::mutate(dplyr::across(dplyr::where(is.factor), forcats::fct_drop))

    # added_cats <- add_cats(levels(all_grps$group), return_table = FALSE)
    # expect_equal(as.character(added_cats), all_grps$category)
    all_cats <- c(
        "Five Connecticuts", "Gender", "Age", "Race/Ethnicity", "Education",
        "Income", "With children", "Sexual orientation", "Gender identity",
        "Sexual orientation & gender identity", "Place of birth",
        "Latino origin", "Disability", "Incarceration history"
    )
    expect_setequal(levels(all_grps$category), all_cats)
    grp_lvls <- levels(all_grps$group)
    expect_true(any(grepl("[Kk]ids", grp_lvls)))
    expect_false(any(grepl("[Cc]hildren", grp_lvls)))
    expect_false(any(grepl(" total$", grp_lvls)))
    expect_false(any(grepl("^Income ", grp_lvls)))
    expect_false(any(grp_lvls == "No kids in home"))
})
