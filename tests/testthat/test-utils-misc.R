## streak ----
test_that("streak handles factors", {
    expect_silent(dummy <- streak(factor(c("a", "a", "b"))))
})

test_that("streak returns correct groupings", {
    grps1 <- data.frame(grp = c("a", "a", "b", "c", "c"),
                        num = c(1, 1, 2, 3, 3))
    grps2 <- data.frame(grp = c("a", "a", "b", "a", "c"),
                        num = c(1, 1, 2, 3, 4))
    grps3 <- data.frame(grp = c(10, 10, 5, 5, 15),
                        num = c(1, 1, 2, 2, 3))
    ids1 <- streak(grps1$grp)
    ids2 <- streak(grps2$grp)
    ids3 <- streak(grps3$grp)
    expect_equal(ids1, grps1$num)
    expect_equal(ids2, grps2$num)
    expect_equal(ids3, grps3$num)
})

## cws_check_yr ----
test_that("cws_check_yr returns number", {
    expect_type(cws_check_yr(demo_xt(2015), NULL, FALSE), "double")
    expect_type(cws_check_yr(demo_xt("2015"), NULL, FALSE), "double")
    expect_type(cws_check_yr(demo_xt("2015_2024"), NULL, FALSE), "double")
    hyphen <- stringr::str_replace(demo_xt("2015_2024"), "2015_2024", "2015-2024")
    expect_type(cws_check_yr(hyphen, NULL, FALSE), "double")
})

test_that("cws_check_yr correctly guesses years", {
    expect_equal(cws_check_yr(demo_xt(2024), year = NULL, verbose = FALSE), 2024)
    expect_equal(cws_check_yr(demo_xt("2015_2024"), year = NULL, verbose = FALSE), 2024)
    expect_equal(cws_check_yr(demo_xt(2020), year = NULL, verbose = FALSE), 2020)
})

test_that("cws_check_yr converts year from valid character", {
    expect_equal(cws_check_yr("fake_path.txt", year = "2024", verbose = FALSE), 2024)
})

test_that("cws_check_yr tries to guess non-numeric year", {
    expect_equal(cws_check_yr(demo_xt(2024), year = 2024, verbose = FALSE), 2024)
    expect_equal(cws_check_yr(demo_xt("2015_2024"), year = "2015_2024", verbose = FALSE), 2024)
})

test_that("cws_check_yr doesn't accidentally match zip codes", {
    p1 <- "dcws_zip_10573_2015_2024-v0.2.0.xlsx"
    p2 <- "dcws_zip_10573_2024-v0.2.0.xlsx"
    expect_equal(cws_check_yr(p1, NULL, FALSE), 2024)
    expect_equal(cws_check_yr(p2, NULL, FALSE), 2024)
})

test_that("cws_check_yr only takes single path", {
    expect_no_error(cws_check_yr(demo_xt(2024), NULL, FALSE))
    expect_error(cws_check_yr(c(demo_xt(2020), demo_xt(2024)), NULL, FALSE))
})

test_that("cws_check_yr respects verbose argument", {
    expect_silent(dummy <- cws_check_yr(demo_xt(2024), NULL, verbose = FALSE))
    expect_message(dummy <- cws_check_yr(demo_xt(2024), NULL, verbose = TRUE), "2024")
})

test_that("cws_check_yr fails for arguments outside reasonable bounds", {
    expect_error(cws_check_yr("fake_path.txt", year = NULL, verbose = FALSE))
    expect_error(cws_check_yr("fake_path.txt", year = 25, verbose = FALSE))
})

test_that("cws_check_yr warns for years before 2015", {
    expect_warning(cws_check_yr("fake_path.txt", year = 2012, FALSE))
})

test_that("cws_check_yr requires path and/or year", {
    expect_error(cws_check_yr(NULL, NULL, FALSE))
})

## filter_before/_after ----
test_that("filter_down properly excludes rows", {
    messy_summary <- tibble::tribble(
        ~x1,        ~x2,
        "A",        1,
        "B",        5,
        "C",        9,
        "Weights",  NA,
        "A",        0.2,
        "B",        0.5
    )
    u1 <- filter_until(messy_summary, x1 == "Weights")
    a1 <- filter_after(messy_summary, x1 == "Weights")
    expect_equal(nrow(u1), 3)
    expect_equal(nrow(a1), 2)
})

test_that("filter_down handles multiple conditions", {
    messy_notes <- tibble::tribble(
        ~x1,       ~x2,        ~x3,
        "A",       "dog",      0,
        "B",       "cat",      1,
        "Source:", "xyz.com",  NA,
        "Date:",   "Jan",      2021
    )
    u1 <- filter_until(messy_notes, grepl("\\:", x1) & is.na(x3))
    a1 <- filter_after(messy_notes, grepl("\\:", x1) & is.na(x3))
    expect_equal(nrow(u1), 2)
    expect_equal(nrow(a1), 1)
})

test_that("filter_down handles commas", {
    # used to be an error but now I guess commas are okay in this type of quosure?
    messy_notes <- tibble::tribble(
        ~x1,       ~x2,        ~x3,
        "A",       "dog",      0,
        "B",       "cat",      1,
        "Source:", "xyz.com",  NA,
        "Date:",   "Jan",      2021
    )
    a1 <- filter_after(messy_notes, grepl("\\:", x1) & is.na(x3))
    a2 <- filter_after(messy_notes, grepl("\\:", x1), is.na(x3))
    expect_equal(nrow(a1), 1)
    expect_identical(a2, a1)
})

test_that("filter_after handles streaks", {
    messy_summary <- tibble::tribble(
        ~x1, ~x2,
        "A",   1,
        "B",   5,
        "C",   9,
        "Weights",  NA,
        "Weighted norm",   0,
        "A", 0.2,
        "B", 0.5,
        "Weights",   1
    )
    a1 <- filter_after(messy_summary, grepl("Weight", x1), .streak = TRUE)
    a2 <- filter_after(messy_summary, grepl("Weight", x1), .streak = FALSE)
    expect_equal(nrow(a1), 3)
    expect_equal(nrow(a2), 4)
})


