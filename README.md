

<!-- README.md is generated from README.qmd. Please edit that file -->

# dcws

<!-- badges: start -->

[![R-CMD-check](https://github.com/CT-Data-Haven/dcws/actions/workflows/check-release.yaml/badge.svg)](https://github.com/CT-Data-Haven/dcws/actions/workflows/check-release.yaml)
[![pkgdown](https://github.com/CT-Data-Haven/dcws/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/CT-Data-Haven/dcws/actions/workflows/pkgdown.yaml)
[![Codecov test
coverage](https://codecov.io/gh/CT-Data-Haven/dcws/branch/main/graph/badge.svg)](https://app.codecov.io/gh/CT-Data-Haven/dcws?branch=main)
<!-- badges: end -->

This is a small data-focused package to make easier use of the DataHaven
Community Wellbeing Survey. It contains the data extracted from
crosstabs from the 2015, 2018, 2020, 2021, 2022, and 2024 survey waves.
2020 and 2022 are statewide only.

## Installation

You can install the development version of dcws from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("CT-Data-Haven/dcws")
```

## Included data

As of 2025-02-26, the data included here are:

| name | 2015 | 2018 | 2020 | 2021 | 2022 | 2024 |
|:---|:--:|:--:|:--:|:--:|:--:|:---|
| 5CT | x | x |  |  |  |  |
| 6 Wealthiest Fairfield County |  |  |  |  |  | x |
| Ansonia |  |  |  |  |  | x |
| Aspetuck Health District |  |  |  |  |  | x |
| Backus Hospital |  |  |  |  |  | x |
| Bloomfield |  |  |  |  |  | x |
| Branford |  |  |  |  |  | x |
| Bridgeport | x | x |  | x |  | x |
| Bridgeport Hospital |  |  |  |  |  | x |
| Bristol | x | x |  | x |  | x |
| Bristol Burlington Health District |  |  |  |  |  | x |
| Bristol Health |  |  |  |  |  | x |
| CCHD |  | x |  |  |  |  |
| Capitol COG |  |  |  |  |  | x |
| Central Connecticut Health District |  |  |  |  |  | x |
| Charlotte Hungerford Hospital |  |  |  |  |  | x |
| Chatham Health District |  |  |  |  |  | x |
| Cheshire |  |  |  |  |  | x |
| Chesprocott |  | x |  |  |  |  |
| Chesprocott Health District |  |  |  |  |  | x |
| Connecticut | x | x | x | x | x | x |
| Connecticut Children’s |  |  |  |  |  | x |
| Connecticut River Area Health District |  |  |  |  |  | x |
| Danbury | x | x |  | x |  | x |
| Danbury Hospital |  |  |  |  |  | x |
| Darien |  | x |  | x |  | x |
| Day Kimball Healthcare |  |  |  |  |  | x |
| Derby |  |  |  |  |  | x |
| Dmhas Region 1 |  |  |  |  |  | x |
| Dmhas Region 2 |  |  |  |  |  | x |
| Dmhas Region 3 |  |  |  |  |  | x |
| Dmhas Region 4 |  |  |  |  |  | x |
| Dmhas Region 5 |  |  |  |  |  | x |
| EHHD |  | x |  | x |  |  |
| East Hartford |  | x |  |  |  | x |
| East Haven |  | x |  |  |  | x |
| East Lyme |  |  |  |  |  | x |
| East Shore District Health Department |  |  |  |  |  | x |
| Eastern Highlands Health District |  |  |  |  |  | x |
| Easton |  |  |  |  |  | x |
| FCHT |  | x |  |  |  |  |
| Fairfield |  | x |  | x |  | x |
| Fairfield County | x | x |  | x |  | x |
| Farmington Valley Health District |  |  |  |  |  | x |
| Greater Bridgeport | x | x |  |  |  | x |
| Greater Bridgeport COG |  |  |  |  |  | x |
| Greater Greenwich |  | x |  |  |  |  |
| Greater Hartford | x | x |  | x |  | x |
| Greater New Haven | x | x |  | x |  | x |
| Greater New London | x | x |  |  |  |  |
| Greater Waterbury | x | x |  | x |  | x |
| Greenwich | x | x |  | x |  | x |
| Greenwich Hospital |  |  |  |  |  | x |
| Griffin Health |  |  |  |  |  | x |
| Groton |  |  |  | x |  | x |
| HIA Area |  |  |  | x |  |  |
| Hamden |  | x |  | x |  | x |
| Hartford | x | x |  | x |  | x |
| Hartford County |  |  |  |  |  | x |
| Hartford Healthcare |  |  |  |  |  | x |
| Hartford Hospital |  |  |  |  |  | x |
| Hartford Inner Ring |  | x |  |  |  | x |
| Hartford Outer Ring |  | x |  |  |  | x |
| Hospital of Central Connecticut |  |  |  |  |  | x |
| Housatonic Valley Health District |  |  |  |  |  | x |
| Johnson Memorial Hospital |  |  |  |  |  | x |
| Lawrence + Memorial Hospital |  |  |  |  |  | x |
| Ledge Light Health District |  |  |  |  |  | x |
| Ledyard |  |  |  |  |  | x |
| Litchfield County |  |  |  |  |  | x |
| Lower Connecticut River Valley COG |  |  |  |  |  | x |
| Lower Naugatuck Valley | x | x |  | x |  |  |
| Manchester |  | x |  |  |  | x |
| Manchester Memorial Rockville General Hospital |  |  |  |  |  | x |
| Meriden | x | x |  |  |  | x |
| Mid State Medical Center |  |  |  |  |  | x |
| Middlesex County | x | x |  | x |  | x |
| Middlesex Health |  |  |  |  |  | x |
| Middlesex United Way |  |  |  |  |  | x |
| Middletown |  | x |  |  |  | x |
| Milford |  | x |  | x |  | x |
| Monroe |  | x |  | x |  | x |
| NCDHD |  | x |  | x |  |  |
| NDDH |  | x |  | x |  |  |
| NY Border Towns |  | x |  |  |  |  |
| Naugatuck |  |  |  |  |  | x |
| Naugatuck Valley COG |  |  |  |  |  | x |
| Naugatuck Valley Health District |  |  |  |  |  | x |
| New Britain | x | x |  |  |  | x |
| New Haven | x | x |  | x |  | x |
| New Haven County |  |  |  |  |  | x |
| New Haven Inner Ring |  | x |  |  |  | x |
| New Haven Outer Ring |  | x |  |  |  | x |
| New London | x | x |  | x |  | x |
| New London County |  |  |  |  |  | x |
| New Milford |  | x |  | x |  | x |
| Newtown |  | x |  |  |  | x |
| Newtown Health District |  |  |  |  |  | x |
| North Central District Health Department |  |  |  |  |  | x |
| North Haven |  |  |  |  |  | x |
| Northeast District Department of Health |  |  |  |  |  | x |
| Northeastern Connecticut COG |  |  |  |  |  | x |
| Northwest Hills COG |  |  |  |  |  | x |
| Norwalk | x | x |  | x |  | x |
| Norwalk Hospital |  |  |  |  |  | x |
| Norwich |  |  |  |  |  | x |
| Nuvance Health |  |  |  |  |  | x |
| Oxford |  |  |  |  |  | x |
| Plainville |  |  |  |  |  | x |
| Pomperaug |  | x |  |  |  |  |
| Port Chester NY |  | x |  | x |  |  |
| Prospect ECHN |  |  |  |  |  | x |
| Prospect Hospitals |  |  |  |  |  | x |
| Quinnipiack Valley Health District |  |  |  |  |  | x |
| Saint Francis Hospital |  |  |  |  |  | x |
| Saint Mary’s Hospital |  |  |  |  |  | x |
| Seymour |  |  |  |  |  | x |
| Sharon Hospital |  |  |  |  |  | x |
| Shelton |  |  |  |  |  | x |
| South Central Connecticut COG |  |  |  |  |  | x |
| South Central Health District |  |  |  |  |  | x |
| Southeastern CTHIC Area |  |  |  | x |  |  |
| Southeastern Connecticut COG |  |  |  |  |  | x |
| Southington |  |  |  |  |  | x |
| St Vincent’s Medical Center |  |  |  |  |  | x |
| Stamford | x | x |  | x |  | x |
| Stamford Health |  |  |  |  |  | x |
| Stratford |  | x |  | x |  | x |
| Tolland County |  |  |  |  |  | x |
| Torrington |  |  |  | x |  | x |
| Torrington Area Health District |  |  |  |  |  | x |
| Trinity Health of New England |  |  |  |  |  | x |
| Trumbull |  | x |  | x |  | x |
| UConn John Dempsey Hospital |  |  |  |  |  | x |
| Uncas Health District |  |  |  |  |  | x |
| United Way of Central and Northeastern Connecticut |  |  |  |  |  | x |
| United Way of Coastal and Western Connecticut |  |  |  |  |  | x |
| United Way of Greater New Haven |  |  |  |  |  | x |
| United Way of Greater Waterbury |  |  |  |  |  | x |
| United Way of Greenwich |  |  |  |  |  | x |
| United Way of Meriden Wallingford |  |  |  |  |  | x |
| United Way of Milford |  |  |  |  |  | x |
| United Way of Naugatuck Beacon Falls |  |  |  |  |  | x |
| United Way of Northwest Connecticut |  |  |  |  |  | x |
| United Way of Southeastern Connecticut |  |  |  |  |  | x |
| United Way of Southington |  |  |  |  |  | x |
| United Way of West Central Connecticut |  |  |  |  |  | x |
| Valley United Way |  |  |  |  |  | x |
| Wallingford |  | x |  |  |  | x |
| Waterbury | x | x |  | x |  | x |
| Waterbury Health |  |  |  |  |  | x |
| Waterford |  |  |  |  |  | x |
| Watertown |  |  |  |  |  | x |
| West Hartford | x | x |  |  |  | x |
| West Hartford Bloomfield Health District |  |  |  |  |  | x |
| West Haven |  | x |  | x |  | x |
| Western Connecticut COG |  |  |  |  |  | x |
| Winchester |  |  |  |  |  | x |
| Windham |  |  |  |  |  | x |
| Windham County |  |  |  |  |  | x |
| Windham Hospital |  |  |  |  |  | x |
| Windsor |  |  |  | x |  | x |
| Yale New Haven Health |  |  |  |  |  | x |
| Yale New Haven Hospital |  |  |  |  |  | x |
| ZIP 10573 |  |  |  |  |  | x |
| **TOTAL** | **23** | **52** | **1** | **35** | **1** | **150** |
