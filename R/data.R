#' Contents of DataHaven Community Wellbeing Crosstabs
#'
#' This is a nested data frame where each row corresponds to a year and location of the survey. The `data` column contains the full set of data extracted from the respective crosstabs; this, in turn, is nested by question and question code. This is a bit of a strange format, but it balances ease of subsetting by year and location with saving space and avoiding repeated values (e.g. listing out full question text dozens of times).
#'
#' On its own, the structure is probably annoying. Easier extraction is available using `fetch_cws`.
#'
#' @format A data frame of `r nrow(cws_full_data)` rows and 3 columns.
#'
#' ### Outer structure:
#' \describe{
#'   \item{year}{Numeric, year of survey}
#'   \item{name}{Text of location}
#'   \item{survey}{List-column of data frames of survey response data. The number of rows varies based on the questions and participant groups available, but the 3 columns are the same.}
#' }
#'
#' ### For the `survey` list-column:
#' \describe{
#'   \item{code}{Question code, e.g. "Q2", "Q4E", "RENTEVICT"}
#'   \item{question}{Full text of survey question}
#'   \item{data}{List-column of more data frames, providing the actual response values per question. Again, number of rows varies, but the 4 columns are the same.}
#' }
#'
#' ### For the `data` list-column:
#' \describe{
#'   \item{category}{Factor: participant group categories, e.g. "Gender", "Age"}
#'   \item{group}{Factor: participant group, e.g. "Male", "Ages 65+"}
#'   \item{response}{Text of responses, depending on question}
#'   \item{value}{Share of participants giving each response}
#' }
#' @source Compiled DCWS crosstabs
#' @seealso [fetch_cws()]
#' @examples
#' # bunch of different ways to work with this
#' # specific question for one location and one year
#' cws_full_data %>%
#'   dplyr::filter(year == 2018, name == "Greater New Haven") %>%
#'   tidyr::unnest(survey) %>%
#'   dplyr::filter(grepl("suitable employment", question)) %>%
#'   tidyr::unnest(data)
#'
#' # simpler but a bit slower--has to unnest to full 600k rows
#' cws_full_data %>%
#'   tidyr::unnest(survey) %>%
#'   tidyr::unnest(data) %>%
#'   dplyr::filter(year == 2018,
#'                 name == "Greater New Haven",
#'                 grepl("suitable employment", question))
#'
#' # specific question, one location, multiple years
#' cws_full_data %>%
#'   dplyr::mutate(survey = purrr::map(survey, dplyr::filter, question == "Diabetes")) %>%
#'   dplyr::filter(name == "New Haven") %>%
#'   tidyr::unnest(survey) %>%
#'   tidyr::unnest(data)
#'
#' # make things easier with fetch_cws: flexibly grab by location, year, and/or
#' # filter conditions
#' fetch_cws(grepl("Have there been times .+ food", question), .year = 2018,
#'           .name = c("Connecticut", "Greater New Haven", "New Haven"))
"cws_full_data"

#' DCWS weights
#'
#' This is a nested data frame containing each survey's weights, used for combining groups to calculate average values. These can be joined to DCWS data with `fetch_cws`, or manually. Note that in some larger areas for 2018 (maybe also 2015), groups might not all line up between data and weights--check for NAs in your weights column if need be.
#'
#' @format A data frame with `r nrow(cws_full_wts)` rows and 3 variables:
#' \describe{
#'   \item{\code{year}}{Numeric, year of survey}
#'   \item{\code{name}}{Text of location}
#'   \item{\code{weights}}{A list of nested data frames, each of which has 2 columns for group and weight.}
#'}
#' @source Compiled DCWS crosstabs
#' @seealso [fetch_cws()], [fetch_wts()]
#' @examples
#' cws_full_wts
#'
#' cws_full_wts |>
#'   dplyr::filter(name == "Greater New Haven") |>
#'   tidyr::unnest(weights)
#'
"cws_full_wts"

#' DCWS group metadata
#'
#' This is a reference dataset listing what categories and groups are available for each survey by year and location. Not all questions are available for all groups, and not all groups are available every year or for every location.
#'
#' @format A data frame with `r nrow(cws_group_meta)` rows and 3 variables:
#' \describe{
#'   \item{\code{year}}{Numeric, year of survey}
#'   \item{\code{name}}{Text of location}
#'   \item{\code{groups}}{A list of nested data frames, each of which has 2 columns for category and group.}
#'}
#' @source Compiled DCWS crosstabs
#' @examples
#' # larger areas have more groups available each year (see number of rows per nested tibble)
#' cws_group_meta
#'
#' cws_group_meta |>
#'   dplyr::filter(name == "Greater New Haven") |>
#'   tidyr::unnest(groups)
#'
#' # this is useful if you want to know what locations have data for a certain
#' # set of conditions, e.g. 2021 values by income
#' cws_group_meta |>
#'   tidyr::unnest(groups) |>
#'   dplyr::filter(year == 2021, category == "Income")
#'
"cws_group_meta"

#' DCWS maximum margins of error
#'
#' This is a data frame listing the maximum margin of error for estimates for each location and year. The values are extracted from the headers of the crosstab spreadsheets, but many are missing, especially for 2015. It's unlikely anyone will need this often beyond the community profiles on our website, so they're not filtered for the same subset of locations as the main data and weights datasets.
#'
#' @format A data frame with `r nrow(cws_max_moe)` rows and 3 variables:
#' \describe{
#'   \item{\code{year}}{Numeric, year of survey}
#'   \item{\code{name}}{Text of location}
#'   \item{\code{moe}}{Numeric, value of maximum MOE}
#' }
#' @source Compiled DCWS crosstabs
#' @examples
#' cws_max_moe
#'
"cws_max_moe"

# #' DCWS indicator definitions
# #'
# #' This data frame is a reference of how indicators are defined, such as Likert questions that get collapsed into a single number (e.g. strongly agree & somewhat agree --> percent agree). It also has more complicated indicators, such as smoking rate and underemployment, and notes on the calculations of each. Other than depression, which starting in 2018 moved to the standardized PHQ-2 phrasing, definitions are consistent across years.
# #'
# #' @format A data frame with `r nrow(cws_defs)` rows and 5 variables:
# #' \describe{
# #'   \item{\code{indicator}}{Text of abbreviated indicator name, e.g. "safe biking"}
# #'   \item{\code{question}}{Text of question as given on the survey with punctuation and capital letters removed, e.g. "there are places to bicycle in or near my neighborhood that are safe from traffic such as on the street or on special lanes separate paths or trails"}
# #'   \item{\code{collapsed_responses}}{Comma-separated text of responses that are collapsed into the indicator, e.g. "Strongly agree, Somewhat agree". In a few cases may not *exactly* match the real response choice}
# #'   \item{\code{universe}}{Text describing the universe over which the indicator should be calculated, e.g. percent who have smoked 100 cigarettes is the universe for percent currently smoking. If missing, no need to do anything special.}
# #'   \item{\code{calculation}}{Text describing the calculation if there's anything unusual to be done.}
# #' }
# #' @source Handwritten by Camille
# #' @examples
# #' cws_defs
# #'
# "cws_defs"
