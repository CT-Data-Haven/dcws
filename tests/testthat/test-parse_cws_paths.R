test_that("parse_cws_paths returns same name with multiple formats", {
    hamden <- c(
        "DataHaven2018 Hamden Crosstabs Pub.xlsx",
        "DataHaven2018 Hamden Crosstabs Pub.xls",
        "DataHaven2021_Hamden_Crosstabs.xlsx",
        "dcws_hamden_2015_2024-v0.2.0.xlsx",
        "dcws_hamden_2024-v0.2.0.xlsx"
    )
    gwb <- c(
        "DataHaven2015 CCF Crosstabs Pub.xlsx",
        "DataHaven2018 Greater Waterbury CCF Towns Crosstabs Pub.xlsx",
        "DataHaven2021_GreaterWaterburyCCF_Crosstabs.xlsx",
        "dcws_greater_waterbury_2015_2024-v0.2.0.xlsx"
    )
    hamden_clean <- parse_cws_paths(hamden, FALSE)
    gwb_clean <- parse_cws_paths(gwb, FALSE)
    expect_all_value(hamden_clean$name, "Hamden")
    expect_all_value(gwb_clean$name, "Greater Waterbury")
})

test_that("parse_cws_paths capitalizes acronyms", {
    abbrs <- c(
        "dcws_dmhas_region_2_2024-v0.3.2.xlsx",
        "dcws_5ct_2024-v0.1.0.xlsx",
        "DataHaven2015 5CT Crosstabs Pub.xlsx",
        "dcws_capitol_cog_2015_2024-v0.1.0.xlsx"
    )
    abbrs_clean <- parse_cws_paths(abbrs)
    expect_equal(
        abbrs_clean$name,
        c("DMHAS Region 2", "5CT", "5CT", "Capitol COG")
    )
})

test_that("parse_cws_paths returns correct set of columns", {
    # 4 columns with years, 2 without
    hamden <- c(
        "DataHaven2018 Hamden Crosstabs Pub.xlsx",
        "DataHaven2021_Hamden_Crosstabs.xlsx",
        "dcws_hamden_2015_2024-v0.2.0.xlsx",
        "dcws_hamden_2024-v0.2.0.xlsx"
    )
    with_yrs <- parse_cws_paths(hamden, incl_year = TRUE, incl_tag = FALSE)
    wo_yrs <- parse_cws_paths(hamden, incl_year = FALSE, incl_tag = FALSE)
    expect_named(with_yrs, c("name", "span", "year", "path"))
    expect_named(wo_yrs, c("name", "path"))

    with_tags <- parse_cws_paths(hamden, incl_year = FALSE, incl_tag = TRUE)
    wo_tags <- parse_cws_paths(hamden, incl_year = FALSE, incl_tag = FALSE)
    expect_named(with_tags, c("name", "tag", "path"))
    expect_named(wo_tags, c("name", "path"))

    with_both <- parse_cws_paths(hamden, incl_year = TRUE, incl_tag = TRUE)
    expect_named(with_both, c("name", "span", "year", "tag", "path"))
})

test_that("parse_cws_paths gets pooled and unpooled years", {
    paths1 <- c(
        "DataHaven2024 Hamden Crosstabs Pub.xlsx",
        "DataHaven2024_Hamden_Crosstabs.xlsx",
        "dcws_hamden_2024-v0.2.0.xlsx",
        "dcws_hamden_2015_2024-v0.2.0.xlsx"
    )
    paths2 <- c(
        "DataHaven2015_2024_Hamden_Crosstabs.xlsx",
        "DataHaven2015-2024_Hamden_Crosstabs.xlsx",
        "dcws_hamden_2015_2024-v0.2.0.xlsx"
    )
    parsed1 <- parse_cws_paths(paths1, TRUE)
    parsed2 <- parse_cws_paths(paths2, TRUE)
    expect_all_value(parsed1$year, 2024)
    expect_all_value(parsed2$year, 2024)
    expect_all_value(parsed2$span, "2015_2024")
})

test_that("parse_cws_paths gets correct tags", {
    paths1 <- c(
        "dcws_hamden_2024-v0.2.0.xlsx",
        "dcws_hamden_2015_2024-v0.2.5.xlsx",
        "DataHaven2024_Hamden_Crosstabs.xlsx"
    )
    parsed1 <- parse_cws_paths(paths1, incl_tag = TRUE)
    expect_equal(
        parsed1$tag,
        c("v0.2.0", "v0.2.5", NA_character_)
    )
})
