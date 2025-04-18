% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch_cws.R
\name{fetch_cws}
\alias{fetch_cws}
\title{Fetch and subset DCWS data}
\usage{
fetch_cws(
  ...,
  .year = NULL,
  .name = NULL,
  .category = NULL,
  .unnest = FALSE,
  .add_wts = FALSE,
  .drop_ct = TRUE,
  .incl_questions = TRUE
)
}
\arguments{
\item{...}{Any number of conditions to filter by, which will be passed to \code{dplyr::filter}. These don't override the named options, so if you filter by \code{year > 2020} but then set \code{.year = 2015} you're not going to get any data.}

\item{.year}{A vector of one or more year(s) to subset by. If this is a character that contains a separator (\code{"_"}, \code{"-"}, or a space character), it will be assumed to be a span of years, such as for multi-year pooled crosstabs (e.g. \code{"2015_2024"}). Otherwise it's assumed this is a single year of the survey. If \code{NULL}, no filtering is done by year.}

\item{.name}{A vector of one or more strings giving the name(s) to subset by. If \code{NULL}, no filtering is done by name.}

\item{.category}{A vector of one or more strings giving the category(ies) to subset by. If \code{NULL}, no filtering is done by category.}

\item{.unnest}{Boolean: should data be returned nested into a column called \code{data}? Defaults to \code{FALSE}.}

\item{.add_wts}{Boolean: should groups' survey weights be attached, via a left-join with \code{dcws::cws_full_wts}? This is useful if you need to collapse groups later; otherwise you might get stuck in annoying \code{tidyr::unnest} messes.}

\item{.drop_ct}{Boolean: should statewide totals be included for each crosstab extract? This can be useful for a single location in order to have Connecticut values to compare against, but becomes redundant with multiple locations. The default \code{TRUE} means statewide averages will not be included.}

\item{.incl_questions}{Boolean: should the full text of each question be included? If \code{FALSE}, questions will be demarcated by just their codes, which take up less space but can change year to year. Defaults \code{TRUE}.}
}
\value{
A data frame, with between 5 and 10 columns, depending on arguments:
\itemize{
\item Columns \code{year}, \code{span}, \code{name}, and \code{code} are always included
\item If \code{.incl_questions = TRUE}, column \code{question} is included
\item If \code{.unnest = TRUE}, the crosstab data will be in columns \code{category}, \code{group}, \code{response}, and \code{value}
\item If \code{.unnest = FALSE}, crosstab data columns will be nested in a list-column called \code{data}
\item If \code{.add_wts = TRUE}, column \code{weight} is included
Note that the \code{span} column, a new addition, is a string giving the span of years included in that set of survey data. For single years, this will be the same as \code{year}; in the case of a pooled dataset 2015-2024, \code{year} will be \code{2024} and \code{span} will be \code{"2015_2024"}.
}
}
\description{
This function returns the split data from \code{cws_full_data} in a nicer format, with options for subsetting. Filtering by year, location name, and category are named options, any of which take a vector of one or more values, but any valid conditions can be passed to \code{...} for more flexible filtering. For any named options, \code{NULL}, the default, will mean no filtering is done by that column.
}
\examples{
# no filtering
fetch_cws()

# filter by year, name, and/or category
fetch_cws(.name = c("Greater New Haven", "New Haven")) # all years
fetch_cws(.year = 2024, .name = c("Greater New Haven", "New Haven"))
fetch_cws(.year = "2015_2024", .name = "New Haven", .category = c("Total", "Age", "Gender"))

# filter by conditions
fetch_cws(code == "Q4E", .year = 2018, .name = c("Greater New Haven", "New Haven"), .unnest = TRUE)
fetch_cws(grepl("Q4[A-Z]", code), .year = 2018, .name = c("Greater New Haven", "New Haven"))
fetch_cws(grepl("health insurance", question), year > 2015, .name = "New Haven")
fetch_cws(question \%in\% c("Diabetes", "Asthma"), .name = "Bridgeport")

# how you might use this to make a beautiful table
fetch_cws(code == "Q1", .year = 2021, .category = c("Income", "Gender"), .unnest = TRUE) |>
    dplyr::group_by(name, category, group) |>
    # might want to remove refused, don't know responses
    sub_nonanswers() |>
    dplyr::filter(response == "Yes") |>
    tidyr::pivot_wider(id_cols = name, names_from = group, values_from = value)

# adding weights to collapse groups (e.g. combining income brackets)
fetch_cws(code == "Q1", .year = 2021, .add_wts = TRUE)
fetch_cws(
    .year = 2021, .name = "New Haven", .category = c("Total", "Age", "Income"),
    .add_wts = TRUE, .unnest = TRUE
)
}
\seealso{
\code{\link[=fetch_wts]{fetch_wts()}} \link{cws_full_data}

Other accessing: 
\code{\link{fetch_wts}()},
\code{\link{read_xtabs}()},
\code{\link{xtab2df}()}
}
\concept{accessing}
