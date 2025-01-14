test_that("xtab2df properly matches categories & groups", {
    hdrs1 <- tibble::enframe(list(
        Connecticut = "Connecticut", Bridgeport = "Bridgeport",
        Gender = c("Male", "Female"),
        Age = paste("Ages", c("18-34", "35-49", "50-64", "65+")),
        "Race/Ethnicity" = c("White", "Black", "Latino"),
        Education = c("High school or less", "Some college or Associate's", "Bachelor's or higher"),
        Income = c("<$30K", "$30K-$75K", "$75K+"),
        "With children" = c("No kids", "Kids in home")
    ), name = "category", value = "group") |>
        tidyr::unnest(group) |>
        dplyr::mutate(dplyr::across(c(category, group), forcats::as_factor))
    hdrs2 <- read_xtabs(demo_xt(2018), year = 2018) |>
        xtab2df(year = 2018) |>
        dplyr::distinct(category, group)
    expect_equal(hdrs2, hdrs1)
})

test_that("xtab2df fills in categories for 2024+ crosstabs", {
    xtab <- read_xtabs(demo_xt(2024), year = 2024, process = TRUE)
    expect_equal(sum(is.na(xtab$category)), 0)
})

test_that("xtab2df handles crosstabs without codes e.g. 2020", {
    xt18 <- read_xtabs(demo_xt(2018), year = 2018, process = TRUE)
    xt20 <- read_xtabs(demo_xt(2020), year = 2020, process = TRUE)
    expect_s3_class(xt20, "data.frame")

    expect_true("code" %in% names(xt18))
    expect_false("code" %in% names(xt20))

    expect_false("q_number" %in% names(xt18))
    expect_true("q_number" %in% names(xt20))
})
