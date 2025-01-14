#TODO: rewrite to hard-code messy labels
# otherwise this should be a check of the data itself
test_that("clean_cws_lvls returns expected levels", {
    # paths <- sample_paths()
    # paths$path <- file.path("data-raw", "crosstabs", sample_paths()$path)
    # xtabs <- purrr::pmap(paths, function(path, year) {
    #     suppressMessages(read_xtabs(path = path, year = year, verbose = FALSE, process = TRUE))
    # })
    # xtabs <- dplyr::bind_rows(xtabs, .id = "id") # dummy number
    # xtabs <- dplyr::distinct(xtabs, id, category, group)
    # xtabs <- dplyr::filter(xtabs, category != "Total", as.character(category) != as.character(group))
    # xtabs <- dplyr::mutate(xtabs, dplyr::across(category:group, list(clean = clean_cws_lvls)))
    # xtabs <- dplyr::mutate(xtabs, dplyr::across(dplyr::where(is.factor), forcats::fct_drop))
    # expect_setequal(
    #     !!levels(xtabs$category_clean),
    #     c(
    #         "Five Connecticuts",
    #         "Gender", "Age", "Race/Ethnicity", "Education", "Income", "With children",
    #         # statewide / large regions
    #         "Sexual orientation", "Gender identity", "Sexual orientation & gender identity",
    #         # statewide
    #         "Place of birth", "Latino origin", "Disability", "Incarceration history"
    #     )
    # )
})
