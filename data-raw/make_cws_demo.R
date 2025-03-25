# made using dcws functions that I've already tested, then dput
# fetch_cws(code == "Q1",
#     .year = 2018, .name = "Greater New Haven",
#     .category = c("Total", "Income"),
#     .unnest = TRUE, .add_wts = TRUE
# )
cws_demo <- structure(list(year = c(
    2018, 2018, 2018, 2018, 2018, 2018, 2018,
    2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018,
    2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018,
    2018, 2018, 2018
), span = c(
    "2018", "2018", "2018", "2018", "2018",
    "2018", "2018", "2018", "2018", "2018", "2018", "2018", "2018",
    "2018", "2018", "2018", "2018", "2018", "2018", "2018", "2018",
    "2018", "2018", "2018", "2018", "2018", "2018", "2018", "2018",
    "2018", "2018", "2018"
), name = c(
    "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven",
    "Greater New Haven", "Greater New Haven", "Greater New Haven"
), code = c(
    "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1",
    "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1",
    "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1", "Q1",
    "Q1"
), category = structure(c(
    1L,
    1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,
    2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L
), levels = c(
    "Total",
    "Income"
), class = "factor"), group = structure(c(
    8L, 8L, 8L,
    8L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 3L, 3L, 3L, 3L, 4L, 4L, 4L,
    4L, 5L, 5L, 5L, 5L, 6L, 6L, 6L, 6L, 7L, 7L, 7L, 7L
), levels = c(
    "<$15K",
    "$15K-$30K", "$30K-$50K", "$50K-$75K", "$75K-$100K", "$100K-$200K",
    "$200K+", "Greater New Haven"
), class = "factor"), response = structure(c(
    1L,
    2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L,
    2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L
), levels = c(
    "Yes",
    "No", "Don't know", "Refused"
), class = "factor"), value = c(
    0.81,
    0.18, 0.01, 0, 0.73, 0.26, 0, 0, 0.72, 0.27, 0.01, 0, 0.84, 0.16,
    0, 0, 0.84, 0.15, 0.01, 0, 0.83, 0.17, 0, 0, 0.85, 0.14, 0.01,
    0, 0.9, 0.09, 0.01, 0
), weight = c(
    1, 1, 1, 1, 0.09, 0.09, 0.09,
    0.09, 0.11, 0.11, 0.11, 0.11, 0.13, 0.13, 0.13, 0.13, 0.16, 0.16,
    0.16, 0.16, 0.13, 0.13, 0.13, 0.13, 0.18, 0.18, 0.18, 0.18, 0.05,
    0.05, 0.05, 0.05
)), row.names = c(NA, -32L), class = c(
    "tbl_df",
    "tbl", "data.frame"
))

usethis::use_data(cws_demo, overwrite = TRUE)
