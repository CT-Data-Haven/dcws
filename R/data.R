#' Contents of DataHaven Community Wellbeing Crosstabs
#'
#' This is a list of data frames; previously it was one data frame with 2 levels of nesting. Each data frame in the list represents a combination of survey endyear, timespan, and location, delimited with periods. For example, `cws_full_data[["2024.2015_2024.Greater New Haven"]]` holds the 2015-2024 pooled data for Greater New Haven. The switch from a nested data frame to a list of data frames was needed to speed things up as the extent of the survey and number of crosstabs has ballooned. This also used to include full text of every question, but those are now in the `cws_codebook` data frame.
#'
#' The recommended way of accessing this data is using `fetch_cws`, which filters and combines it for you.
#'
#' @format A list of `r length(cws_full_data)` data frames, each with `r ncol(cws_full_data[[1]])` columns and varying numbers of rows:
#' \describe{
#'   \item{year}{Numeric, endyear of survey (e.g. 2024)}
#'   \item{span}{Character, span of years of the survey (e.g. "2015_2024")}
#'   \item{name}{Text of location}
#'   \item{code}{Question code, e.g. "Q2", "Q4E", "RENTEVICT"}
#'   \item{category}{Factor: participant group categories, e.g. "Gender", "Age"}
#'   \item{group}{Factor: participant group, e.g. "Male", "Ages 65+"}
#'   \item{response}{Factor: text of responses, depending on question}
#'   \item{value}{Share of participants giving each response}
#' }
#' @source Compiled DCWS crosstabs
#' @seealso [fetch_cws()], [cws_codebook]
#' @examples
#' # get specific question based on code
#' cws_full_data[["2024.2015_2024.Greater New Haven"]] |>
#'     dplyr::filter(code == "Q64")
#'
#' # bind, then join with codebook to find question by text
#' cws_full_data[["2024.2015_2024.Greater New Haven"]] |>
#'     dplyr::left_join(cws_codebook, by = c("year", "code")) |>
#'     dplyr::filter(grepl("adequate shelter", question))
#'
#' # make things easier with fetch_cws: flexibly grab by location, year, and/or
#' # filter conditions
#' fetch_cws(grepl("adequate shelter", question),
#'     .year = "2015_2024",
#'     .name = c("Connecticut", "Greater New Haven", "New Haven")
#' )
"cws_full_data"

#' DCWS weights
#'
#' This is a nested data frame containing each survey's weights, used for combining groups to calculate average values. These can be joined to DCWS data with `fetch_cws`, or manually. Note that in some larger areas for 2018 (maybe also 2015), groups might not all line up between data and weights--check for NAs in your weights column if need be.
#'
#' @format A data frame with `r nrow(cws_full_wts)` rows and `r ncol(cws_full_wts)` variables:
#' \describe{
#'   \item{year}{Numeric, year of survey}
#'   \item{span}{Character, span of years of the survey (e.g. "2015_2024")}
#'   \item{name}{Text of location}
#'   \item{weights}{A list of nested data frames, each of which has 2 columns for group and weight.}
#' }
#' @source Compiled DCWS crosstabs
#' @seealso [fetch_cws()], [fetch_wts()]
#' @examples
#' cws_full_wts
#'
#' cws_full_wts |>
#'     dplyr::filter(name == "Greater New Haven") |>
#'     tidyr::unnest(weights)
#'
"cws_full_wts"

#' DCWS group metadata
#'
#' This is a reference dataset listing what categories and groups are available for each survey by year and location. Not all questions are available for all groups, and not all groups are available every year or for every location.
#'
#' @format A data frame with `r nrow(cws_group_meta)` rows and `r ncol(cws_group_meta)` variables:
#' \describe{
#'   \item{year}{Numeric, year of survey}
#'   \item{span}{Character, span of years of the survey (e.g. "2015_2024")}
#'   \item{name}{Text of location}
#'   \item{groups}{A list of nested data frames, each of which has 2 columns for category and group.}
#' }
#' @source Compiled DCWS crosstabs
#' @examples
#' # larger areas have more groups available each year (see number of rows per nested tibble)
#' cws_group_meta
#'
#' cws_group_meta |>
#'     dplyr::filter(name == "Greater New Haven") |>
#'     tidyr::unnest(groups)
#'
#' # this is useful if you want to know what locations have data for a certain
#' # set of conditions, e.g. 2021 values by income
#' cws_group_meta |>
#'     tidyr::unnest(groups) |>
#'     dplyr::filter(year == 2021, category == "Income")
#'
"cws_group_meta"

#' DCWS maximum margins of error
#'
#' This is a data frame listing the maximum margin of error for estimates for each location and year. The values are extracted from the headers of the crosstab spreadsheets, but many are missing, especially for 2015. It's unlikely anyone will need this often beyond the community profiles on our website, so they're not filtered for the same subset of locations as the main data and weights datasets.
#'
#' @format A data frame with `r nrow(cws_max_moe)` rows and `r ncol(cws_max_moe)` variables:
#' \describe{
#'   \item{year}{Numeric, year of survey}
#'   \item{span}{Character, span of years of the survey (e.g. "2015_2024")}
#'   \item{name}{Text of location}
#'   \item{moe}{Numeric, value of maximum MOE}
#' }
#' @source Compiled DCWS crosstabs
#' @examples
#' cws_max_moe
#'
"cws_max_moe"

#' DCWS indicator definitions
#'
#' This data frame is a reference of how indicators are defined, such as Likert questions that get collapsed into a single number (e.g. strongly agree & somewhat agree --> percent agree). It also has more complicated indicators, such as smoking rate and underemployment, and responses used to calculate each. Responses should be consistent across years.
#'
#' @format A data frame with `r nrow(cws_defs)` rows and `r ncol(cws_defs)` variables:
#' \describe{
#'   \item{indicator}{Text of abbreviated indicator name, e.g. "safe biking"}
#'   \item{question}{Text of question as given on the survey with punctuation and capital letters removed, e.g. "there are places to bicycle in or near my neighborhood that are safe from traffic such as on the street or on special lanes separate paths or trails"}
#'   \item{\code{collapsed_responses}}{Comma-separated text of responses that are collapsed into the indicator, e.g. "Strongly agree, Somewhat agree".}
#' }
#' @source Handwritten by Camille for the upcoming glossary project
#' @examples
#' cws_defs
#'
"cws_defs"

#' DCWS codebook
#'
#' This is a data frame of all the codes and questions, and corresponding possible responses, for each year of the survey. Previously this was part of the `cws_full_data` data frame, but is now split out on its own to reduce redundancy and save space. Note that surveys are identified only by year, not span; pooled data use codes following their endyears.
#'
#' @format A data frame with `r nrow(cws_codebook)` rows and `r ncol(cws_codebook)` variables:
#' \describe{
#'   \item{year}{Numeric, year of survey}
#'   \item{code}{Character, question code}
#'   \item{question}{Character, full text of survey question}
#'   \item{responses}{List of character vectors, of all possible responses for each question}
#' }
#' @source Compiled DCWS crosstabs
#' @examples
#' cws_codebook |>
#'     dplyr::filter(grepl("adequate shelter", question))
#'
#' cws_codebook |>
#'     dplyr::filter(grepl("adequate shelter", question), year == 2024) |>
#'     tidyr::unnest(responses)
#'
"cws_codebook"

#' DCWS demo data
#' 
#' This is a small sample of 2018 DataHaven Community Wellbeing Survey data for Greater New Haven with weights attached, saved here for use in examples and testing. It was created with the `fetch_cws` function.
#' 
#' @format A data frame with `r nrow(cws_demo)` rows and `r ncol(cws_demo)` variables:
#' \describe{
#'   \item{year}{Numeric, endyear of survey (e.g. 2024)}
#'   \item{span}{Character, span of years of the survey (e.g. "2015_2024")}
#'   \item{name}{Text of location}
#'   \item{code}{Question code, e.g. "Q2", "Q4E", "RENTEVICT"}
#'   \item{category}{Factor: participant group categories, e.g. "Gender", "Age"}
#'   \item{group}{Factor: participant group, e.g. "Male", "Ages 65+"}
#'   \item{response}{Factor: text of responses, depending on question}
#'   \item{value}{Share of participants giving each response}
#'   \item{weight}{Weights per group for aggregating}
#' }
#' @source Sample of DCWS crosstabs
#' @examples 
#' cws_demo
#' @seealso [fetch_cws()]
"cws_demo"