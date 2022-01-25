#' Contents of DataHaven Community Wellbeing Crosstabs
#'
#' This is a nested data frame where each row corresponds to a year and location of the survey. The `data` column contains the full set of data extracted from the respective crosstabs; this, in turn, is nested by question and question code. This is a bit of a strange format, but it balances ease of subsetting by year and location with saving space and avoiding repeated values (e.g. listing out full question text dozens of times).
#'
#' On its own, the structure is probably annoying. Easier extraction is available using `fetch_cws`.
#'
#' @format A data frame of 73 rows and 3 columns.
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
#' @format A data frame with 87 rows and 3 variables:
#' \describe{
#'   \item{\code{year}}{Numeric, year of survey}
#'   \item{\code{name}}{Text of location}
#'   \item{\code{weights}}{A list of nested data frames, each of which has 2 columns for group and weight.}
#'}
#' @source Compiled DCWS crosstabs
#' @seealso [fetch_cws()], [fetch_wts()]
"cws_full_wts"

#' DCWS group metadata
#'
#' This is a reference dataset listing what categories and groups are available for each survey by year and location. Not all questions are available for all groups.
#'
#' @format A data frame with 82 rows and 3 variables:
#' \describe{
#'   \item{\code{year}}{Numeric, year of survey}
#'   \item{\code{name}}{Text of location}
#'   \item{\code{groups}}{A list of nested data frames, each of which has 2 columns for category and group.}
#'}
#' @source Compiled DCWS crosstabs
"group_meta"
