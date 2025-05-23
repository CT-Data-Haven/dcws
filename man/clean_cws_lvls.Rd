% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_cws_lvls.R
\name{clean_cws_lvls}
\alias{clean_cws_lvls}
\title{Clean up categories and groups from crosstabs}
\usage{
clean_cws_lvls(x, is_category = FALSE, order = FALSE)
}
\arguments{
\item{x}{A vector. If not a factor already, will be coerced to one.}

\item{is_category}{Boolean: if \code{FALSE}, assume these are groups (e.g. "High school or less", "Some college or Associate's") rather than categories (e.g. "Education").}

\item{order}{Boolean: if \code{TRUE}, groups will be put into logical order (e.g. <$30K, $30K-$100K). This only applies to groups (i.e. \code{is_category = FALSE}), and only really affects ages and income groups. If \code{FALSE} (default), levels will be kept in the same order as they were received.}
}
\value{
A factor of the same length as \code{x}
}
\description{
This is a bunch of string cleaning to standardize the categories (Gender, Age, etc) and groups (Male, Ages 65+, etc) across all available crosstabs. This does the same operation on both categories and groups because there is some overlap. The lists of regex and other replacements aren't exported, but they aren't hidden either: access them at \code{dcws:::to_replace}, \code{dcws:::to_remove}, \code{dcws:::to_recode}, or \code{dcws:::to_collapse} if you need them.
}
\examples{
# vector of strings as read in from crosstabs
categories <- c(
    "Connecticut", "NH Inner Ring", "Gender", "Age",
    "Race/Ethnicity", "Education", "Income", "Children in HH"
)
levels(clean_cws_lvls(categories, is_category = TRUE))

groups <- c(
    "M", "F", "18-34", "35 to 49", "65 and older",
    "Black/Afr Amer", "African American/Black", "High School",
    "Less than $15,000", "$15,000 to $30,000", "No"
)
levels(clean_cws_lvls(groups))
}
\concept{cleaning}
