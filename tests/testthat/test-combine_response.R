test_that("combine_response checks for missing cols", {
    ex_good <- list(excellent_good = c("Excellent", "Good"))
    expect_error(combine_response(
        cws_exgood[[1]],
        categories = ex_good,
        response = r
    ))
    expect_error(combine_response(
        cws_exgood[[1]],
        categories = ex_good,
        value = x
    ))
})

test_that("combine_response checks formatting of categories", {
    expect_error(combine_response(
        cws_exgood[[1]],
        categories = c("Excellent", "Good")
    ))
    expect_error(combine_response(
        cws_exgood[[1]],
        categories = list(c("Excellent", "Good"))
    ))
    expect_error(combine_response(
        cws_exgood[[1]],
        categories = list(ex_good = c(1, 2, 3))
    ))
    expect_error(combine_response(cws_exgood[[1]], categories = NULL))
})

test_that("combine_response checks for matching responses", {
    expect_warning(combine_response(
        cws_exgood[[1]],
        categories = list(ex_vgood = c("Excellent", "Very good")),
        drop_nonanswers = FALSE
    ))
})

test_that("combine_response returns correct responses", {
    ex_good_cats <- list(ex_good = c("Excellent", "Good"))
    happy_cats <- list(completely_mostly = c("Completely", "Mostly"))

    # defaults
    filter_drop <- combine_response(
        cws_exgood[[3]],
        categories = happy_cats,
        filter_responses = TRUE,
        drop_nonanswers = TRUE
    )
    expect_setequal(levels(filter_drop$response), "completely_mostly")

    no_filter_no_drop <- combine_response(
        cws_exgood[[3]],
        categories = happy_cats,
        filter_responses = FALSE,
        drop_nonanswers = FALSE
    )
    expect_setequal(
        levels(no_filter_no_drop$response),
        c(
            "completely_mostly",
            "Somewhat",
            "Only a little bit",
            "Not at all",
            "Don't know",
            "Refused"
        )
    )

    no_filter_drop <- combine_response(
        cws_exgood[[3]],
        categories = happy_cats,
        filter_responses = FALSE,
        drop_nonanswers = TRUE
    )
    expect_setequal(
        levels(no_filter_drop$response),
        c("completely_mostly", "Somewhat", "Only a little bit", "Not at all")
    )

    filter_no_drop <- combine_response(
        cws_exgood[[3]],
        categories = happy_cats,
        filter_responses = TRUE,
        drop_nonanswers = FALSE
    )
    expect_setequal(
        levels(filter_no_drop$response),
        c("completely_mostly", "Don't know", "Refused")
    )
})

# drop testing for passing args to sub_nonanswers---not really useful

test_that("combine_response handles multiple categories", {
    agree_cats <- list(
        agree = c("Strongly agree", "Somewhat agree"),
        disagree = c("Strongly disagree", "Somewhat disagree")
    )
    agree1 <- combine_response(
        cws_exgood[[2]],
        agree_cats,
        drop_nonanswers = TRUE
    )
    expect_setequal(levels(agree1$response), c("agree", "disagree"))
    agree2 <- combine_response(
        cws_exgood[[2]],
        agree_cats,
        drop_nonanswers = FALSE
    )
    expect_setequal(
        levels(agree2$response),
        c("agree", "disagree", "Don't know", "Refused")
    )
})

test_that("combine_response retains groups", {
    happy_cats <- list(completely_mostly = c("Completely", "Mostly"))
    happy_no_grps <- combine_response(cws_exgood[[3]], happy_cats)
    happy_grps <- cws_exgood[[4]] |>
        dplyr::group_by(category, group) |>
        combine_response(happy_cats)
    expect_length(dplyr::groups(happy_no_grps), 0)
    expect_length(dplyr::groups(happy_grps), 2)
})
