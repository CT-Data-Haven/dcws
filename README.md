

<!-- README.md is generated from README.qmd. Please edit that file -->

# dcws

<!-- badges: start -->

![GitHub Actions Workflow Status:
check-release](https://img.shields.io/github/actions/workflow/status/CT-Data-Haven/dcws/check-release.yaml?style=flat-square&label=check-release)
![GitHub Actions Workflow Status:
pkgdown](https://img.shields.io/github/actions/workflow/status/CT-Data-Haven/dcws/pkgdown.yaml?style=flat-square&label=pkgdown)
![Codecov](https://img.shields.io/codecov/c/github/CT-Data-Haven/dcws?style=flat-square.png)

[![Hippocratic License
HL3-LAW-SV](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-LAW-SV&labelColor=5e2751&color=bc8c3d.png)](https://firstdonoharm.dev/version/3/0/law-sv.html)
<!-- badges: end -->

This is a small data-focused package to make easier use of the DataHaven
Community Wellbeing Survey. It contains the data extracted from
crosstabs from the survey waves. 2020 and 2022 are statewide only.

## Installation

You can install the development version of dcws from
[GitHub](https://github.com/CT-Data-Haven/dcws) with:
[GitHub](https://github.com/CT-Data-Haven/dcws) with:

``` r
# install.packages("devtools")
devtools::install_github("CT-Data-Haven/dcws")
```

## About the survey

The data in these crosstabs represent question-by-question weighted
estimates, disaggregated by selected demographic and socioeconomic
characteristics. Each estimate represents how a group of
respondents—weighted to be representative of the population within the
specified geographic area—answered the question shown. Please use
caution in interpreting the information in this repo. We recommend
contacting DataHaven with any questions, at info AT ctdatahaven.org.
DataHaven staff can help confirm whether the information in this repo is
being interpreted in a correct way, and we can recommend further
analysis that might be useful to your work.

In particular, when reading the data, be aware of “skip patterns” in the
survey, such as Q49, “During this time, has your job been full time or
part time?” Only the subset of adults who indicated in the previous
question that they had a paid job would have been eligible to receive
this question. Therefore, the estimates in that section of the crosstab
show the percentages of adults with paid jobs who have full time jobs,
not the percentages of all adults who have full time jobs.

Generally, columns with demographic breakdowns are included only when
the number of respondents completing that specific survey item was
sufficiently large for reporting. Additionally, please note that some
questions were not asked to all respondents, due to branching. For
example, respondents were randomly-assigned to one of three statewide
“ballots” at the outset of the survey. This approach allows for a larger
number of questions to be included in the survey.

The demographic categories shown in the crosstab are determined based on
responses to detailed survey questions on age, sex, race/ethnicity,
place of birth, presence of children in the household, sexual
orientation, gender identity, income, education, town of residence, and
other characteristics or experiences. Where available, a disability
categorization is based on respondents who answered yes to any of the
standard 6-item screener question for having a disability. The
incarceration experience questions are only asked to men who are ages 18
to 64. Sexual orientation and gender identity are broken down in several
ways: as an umbrella term, LGBTQ denotes any adults who identify
themselves as lesbian, gay, bisexual, some other orientation besides
straight, or transgender, while “straight and cisgender” refers to
adults who identify as none of these. Where possible, we disaggregate
these groups further by sexual orientation alone (lesbian, gay, or
bisexual vs straight) or gender identity alone (transgender vs
cisgender). As sample sizes permit, results for smaller demographic
groups may be shown in the Connecticut statewide data, but not in the
data for smaller geographic regions. Not all of the demographic
questions are included in every year of the survey.

Please contact DataHaven or visit the DataHaven website’s [DataHaven
Community Wellbeing Survey
page](https://ctdatahaven.org/reports/datahaven-community-wellbeing-survey)
for additional information about these data.

## About the survey

The data in these crosstabs represent question-by-question weighted
estimates, disaggregated by selected demographic and socioeconomic
characteristics. Each estimate represents how a group of
respondents—weighted to be representative of the population within the
specified geographic area—answered the question shown. Please use
caution in interpreting the information in this repo. We recommend
contacting DataHaven with any questions, at info AT ctdatahaven.org.
DataHaven staff can help confirm whether the information in this repo is
being interpreted in a correct way, and we can recommend further
analysis that might be useful to your work.

In particular, when reading the data, be aware of “skip patterns” in the
survey, such as Q49, “During this time, has your job been full time or
part time?” Only the subset of adults who indicated in the previous
question that they had a paid job would have been eligible to receive
this question. Therefore, the estimates in that section of the crosstab
show the percentages of adults with paid jobs who have full time jobs,
not the percentages of all adults who have full time jobs.

Generally, columns with demographic breakdowns are included only when
the number of respondents completing that specific survey item was
sufficiently large for reporting. Additionally, please note that some
questions were not asked to all respondents, due to branching. For
example, respondents were randomly-assigned to one of three statewide
“ballots” at the outset of the survey. This approach allows for a larger
number of questions to be included in the survey.

The demographic categories shown in the crosstab are determined based on
responses to detailed survey questions on age, sex, race/ethnicity,
place of birth, presence of children in the household, sexual
orientation, gender identity, income, education, town of residence, and
other characteristics or experiences. Where available, a disability
categorization is based on respondents who answered yes to any of the
standard 6-item screener question for having a disability. The
incarceration experience questions are only asked to men who are ages 18
to 64. Sexual orientation and gender identity are broken down in several
ways: as an umbrella term, LGBTQ denotes any adults who identify
themselves as lesbian, gay, bisexual, some other orientation besides
straight, or transgender, while “straight and cisgender” refers to
adults who identify as none of these. Where possible, we disaggregate
these groups further by sexual orientation alone (lesbian, gay, or
bisexual vs straight) or gender identity alone (transgender vs
cisgender). As sample sizes permit, results for smaller demographic
groups may be shown in the Connecticut statewide data, but not in the
data for smaller geographic regions. Not all of the demographic
questions are included in every year of the survey.

Please contact DataHaven or visit the DataHaven website’s [DataHaven
Community Wellbeing Survey
page](https://ctdatahaven.org/reports/datahaven-community-wellbeing-survey)
for additional information about these data.

## Included data

As of 2025-04-02, the data included here are:

| name | 2015 | 2018 | 2020 | 2021 | 2022 | 2015_2024 | 2024 |
|:---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **TOTAL** | **23** | **52** | **1** | **35** | **1** | **150** | **123** |
| 5CT | x | x |  |  |  |  |  |
| 6 Wealthiest Fairfield County |  |  |  |  |  | x | x |
| Ansonia |  |  |  |  |  | x |  |
| Aspetuck Health District |  |  |  |  |  | x | x |
| Backus Hospital |  |  |  |  |  | x | x |
| Bloomfield |  |  |  |  |  | x |  |
| Branford |  |  |  |  |  | x |  |
| Bridgeport | x | x |  | x |  | x | x |
| Bridgeport Hospital |  |  |  |  |  | x | x |
| Bristol | x | x |  | x |  | x | x |
| Bristol Burlington Health District |  |  |  |  |  | x | x |
| Bristol Health |  |  |  |  |  | x | x |
| CCHD |  | x |  |  |  |  |  |
| Capitol COG |  |  |  |  |  | x | x |
| Central Connecticut Health District |  |  |  |  |  | x | x |
| Charlotte Hungerford Hospital |  |  |  |  |  | x | x |
| Chatham Health District |  |  |  |  |  | x | x |
| Cheshire |  |  |  |  |  | x |  |
| Chesprocott |  | x |  |  |  |  |  |
| Chesprocott Health District |  |  |  |  |  | x | x |
| Connecticut | x | x | x | x | x | x | x |
| Connecticut Children’s |  |  |  |  |  | x | x |
| Connecticut River Area Health District |  |  |  |  |  | x |  |
| DMHAS Region 1 |  |  |  |  |  | x | x |
| DMHAS Region 2 |  |  |  |  |  | x | x |
| DMHAS Region 3 |  |  |  |  |  | x | x |
| DMHAS Region 4 |  |  |  |  |  | x | x |
| DMHAS Region 5 |  |  |  |  |  | x | x |
| Danbury | x | x |  | x |  | x | x |
| Danbury Hospital |  |  |  |  |  | x | x |
| Darien |  | x |  | x |  | x | x |
| Day Kimball Healthcare |  |  |  |  |  | x | x |
| Derby |  |  |  |  |  | x |  |
| EHHD |  | x |  | x |  |  |  |
| East Hartford |  | x |  |  |  | x |  |
| East Haven |  | x |  |  |  | x |  |
| East Lyme |  |  |  |  |  | x |  |
| East Shore District Health Department |  |  |  |  |  | x | x |
| Eastern Highlands Health District |  |  |  |  |  | x | x |
| Easton |  |  |  |  |  | x |  |
| FCHT |  | x |  |  |  |  |  |
| Fairfield |  | x |  | x |  | x | x |
| Fairfield County | x | x |  | x |  | x | x |
| Farmington Valley Health District |  |  |  |  |  | x | x |
| Greater Bridgeport | x | x |  |  |  | x | x |
| Greater Bridgeport COG |  |  |  |  |  | x | x |
| Greater Greenwich |  | x |  |  |  |  |  |
| Greater Hartford | x | x |  | x |  | x | x |
| Greater New Haven | x | x |  | x |  | x | x |
| Greater New London | x | x |  |  |  |  |  |
| Greater Waterbury | x | x |  | x |  | x | x |
| Greenwich | x | x |  | x |  | x | x |
| Greenwich Hospital |  |  |  |  |  | x | x |
| Griffin Health |  |  |  |  |  | x | x |
| Groton |  |  |  | x |  | x | x |
| HIA Area |  |  |  | x |  |  |  |
| Hamden |  | x |  | x |  | x | x |
| Hartford | x | x |  | x |  | x | x |
| Hartford County |  |  |  |  |  | x | x |
| Hartford Healthcare |  |  |  |  |  | x | x |
| Hartford Hospital |  |  |  |  |  | x | x |
| Hartford Inner Ring |  | x |  |  |  | x | x |
| Hartford Outer Ring |  | x |  |  |  | x | x |
| Hospital of Central Connecticut |  |  |  |  |  | x | x |
| Housatonic Valley Health District |  |  |  |  |  | x | x |
| Johnson Memorial Hospital |  |  |  |  |  | x | x |
| Lawrence + Memorial Hospital |  |  |  |  |  | x | x |
| Ledge Light Health District |  |  |  |  |  | x | x |
| Ledyard |  |  |  |  |  | x |  |
| Litchfield County |  |  |  |  |  | x | x |
| Lower Connecticut River Valley COG |  |  |  |  |  | x | x |
| Lower Naugatuck Valley | x | x |  | x |  |  |  |
| Manchester |  | x |  |  |  | x |  |
| Manchester Memorial Rockville General Hospital |  |  |  |  |  | x | x |
| Meriden | x | x |  |  |  | x | x |
| Mid State Medical Center |  |  |  |  |  | x | x |
| Middlesex County | x | x |  | x |  | x | x |
| Middlesex Health |  |  |  |  |  | x | x |
| Middlesex United Way |  |  |  |  |  | x | x |
| Middletown |  | x |  |  |  | x | x |
| Milford |  | x |  | x |  | x | x |
| Monroe |  | x |  | x |  | x | x |
| NCDHD |  | x |  | x |  |  |  |
| NDDH |  | x |  | x |  |  |  |
| NY Border Towns |  | x |  |  |  |  |  |
| Naugatuck |  |  |  |  |  | x | x |
| Naugatuck Valley COG |  |  |  |  |  | x | x |
| Naugatuck Valley Health District |  |  |  |  |  | x | x |
| New Britain | x | x |  |  |  | x | x |
| New Haven | x | x |  | x |  | x | x |
| New Haven County |  |  |  |  |  | x | x |
| New Haven Inner Ring |  | x |  |  |  | x | x |
| New Haven Outer Ring |  | x |  |  |  | x | x |
| New London | x | x |  | x |  | x | x |
| New London County |  |  |  |  |  | x | x |
| New Milford |  | x |  | x |  | x |  |
| Newtown |  | x |  |  |  | x |  |
| Newtown Health District |  |  |  |  |  | x | x |
| North Central District Health Department |  |  |  |  |  | x | x |
| North Haven |  |  |  |  |  | x |  |
| Northeast District Department of Health |  |  |  |  |  | x | x |
| Northeastern Connecticut COG |  |  |  |  |  | x | x |
| Northwest Hills COG |  |  |  |  |  | x | x |
| Norwalk | x | x |  | x |  | x | x |
| Norwalk Hospital |  |  |  |  |  | x | x |
| Norwich |  |  |  |  |  | x |  |
| Nuvance Health |  |  |  |  |  | x | x |
| Oxford |  |  |  |  |  | x |  |
| Plainville |  |  |  |  |  | x |  |
| Pomperaug |  | x |  |  |  |  |  |
| Port Chester NY |  | x |  | x |  |  |  |
| Prospect ECHN |  |  |  |  |  | x | x |
| Prospect Hospitals |  |  |  |  |  | x | x |
| Quinnipiack Valley Health District |  |  |  |  |  | x | x |
| Saint Francis Hospital |  |  |  |  |  | x | x |
| Saint Mary’s Hospital |  |  |  |  |  | x | x |
| Seymour |  |  |  |  |  | x |  |
| Sharon Hospital |  |  |  |  |  | x | x |
| Shelton |  |  |  |  |  | x | x |
| South Central Connecticut COG |  |  |  |  |  | x | x |
| South Central Health District |  |  |  |  |  | x | x |
| Southeastern CTHIC Area |  |  |  | x |  |  |  |
| Southeastern Connecticut COG |  |  |  |  |  | x | x |
| Southington |  |  |  |  |  | x |  |
| St Vincent’s Medical Center |  |  |  |  |  | x | x |
| Stamford | x | x |  | x |  | x | x |
| Stamford Health |  |  |  |  |  | x | x |
| Stratford |  | x |  | x |  | x | x |
| Tolland County |  |  |  |  |  | x | x |
| Torrington |  |  |  | x |  | x | x |
| Torrington Area Health District |  |  |  |  |  | x | x |
| Trinity Health of New England |  |  |  |  |  | x | x |
| Trumbull |  | x |  | x |  | x | x |
| UConn John Dempsey Hospital |  |  |  |  |  | x | x |
| Uncas Health District |  |  |  |  |  | x | x |
| United Way of Central and Northeastern Connecticut |  |  |  |  |  | x | x |
| United Way of Coastal and Western Connecticut |  |  |  |  |  | x | x |
| United Way of Greater New Haven |  |  |  |  |  | x | x |
| United Way of Greater Waterbury |  |  |  |  |  | x | x |
| United Way of Greenwich |  |  |  |  |  | x | x |
| United Way of Meriden Wallingford |  |  |  |  |  | x | x |
| United Way of Milford |  |  |  |  |  | x | x |
| United Way of Naugatuck Beacon Falls |  |  |  |  |  | x | x |
| United Way of Northwest Connecticut |  |  |  |  |  | x | x |
| United Way of Southeastern Connecticut |  |  |  |  |  | x | x |
| United Way of Southington |  |  |  |  |  | x | x |
| United Way of West Central Connecticut |  |  |  |  |  | x | x |
| Valley United Way |  |  |  |  |  | x | x |
| Wallingford |  | x |  |  |  | x |  |
| Waterbury | x | x |  | x |  | x | x |
| Waterbury Health |  |  |  |  |  | x | x |
| Waterford |  |  |  |  |  | x |  |
| Watertown |  |  |  |  |  | x |  |
| West Hartford | x | x |  |  |  | x |  |
| West Hartford Bloomfield Health District |  |  |  |  |  | x | x |
| West Haven |  | x |  | x |  | x | x |
| Western Connecticut COG |  |  |  |  |  | x | x |
| Winchester |  |  |  |  |  | x |  |
| Windham |  |  |  |  |  | x |  |
| Windham County |  |  |  |  |  | x | x |
| Windham Hospital |  |  |  |  |  | x | x |
| Windsor |  |  |  | x |  | x |  |
| Yale New Haven Health |  |  |  |  |  | x | x |
| Yale New Haven Hospital |  |  |  |  |  | x | x |
| ZIP 10573 |  |  |  |  |  | x | x |
