expect_all_value <- function(x, expected) {
    actual <- quasi_label(rlang::enquo(x), arg = "x")
    actual$matches <- actual$val == expected
    expect(
        all(actual$matches),
        stringr::str_glue("Not all values match {expected}: {toString(actual$matches)}")
    )
    invisible(actual$val)
}
