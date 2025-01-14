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
})

test_that("cws_check_yr fails for arguments outside reasonable bounds", {
    expect_error(cws_check_yr("fake_path.txt", year = NULL, verbose = FALSE))
    expect_error(cws_check_yr("fake_path.txt", year = 25, verbose = FALSE))
})
