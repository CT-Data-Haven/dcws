# subset of data for testing combine_response
cws_exgood <- cws_full_data[["2024.2024.New Haven"]] |>
    dplyr::semi_join(
        dplyr::filter(
            cws_codebook,
            grepl(
                "(raise children|how happy did you feel|People in this neighborhood can be trusted)",
                question
            )
        ),
        by = c("year", "code")
    ) |>
    dplyr::filter(category == "Total") |>
    split(~code, drop = TRUE) |>
    purrr::map(\(x) {
        dplyr::mutate(
            x,
            dplyr::across(dplyr::where(is.factor), forcats::fct_drop)
        )
    })
# add one with multiple groups, then drop extra groups in first 3
cws_exgood[[4]] <- cws_exgood[[3]]
cws_exgood[1:3] <- purrr::map(
    cws_exgood[1:3],
    dplyr::filter,
    group == "New Haven"
)
