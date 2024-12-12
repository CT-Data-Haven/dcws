

<!-- README.md is generated from README.Rmd. Please edit that file -->

# dcws

<!-- badges: start -->

[![R-CMD-check](https://github.com/CT-Data-Haven/dcws/actions/workflows/check-release.yaml/badge.svg)](https://github.com/CT-Data-Haven/dcws/actions/workflows/check-release.yaml)
[![pkgdown](https://github.com/CT-Data-Haven/dcws/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/CT-Data-Haven/dcws/actions/workflows/pkgdown.yaml)
[![Codecov test
coverage](https://codecov.io/gh/CT-Data-Haven/dcws/branch/main/graph/badge.svg)](https://app.codecov.io/gh/CT-Data-Haven/dcws?branch=main)
<!-- badges: end -->

This is a small data-focused package to make easier use of the DataHaven
Community Wellbeing Survey. It contains the data extracted from
crosstabs from the 2015, 2018, 2020, 2021, and 2022 survey waves. 2020
and 2022 are statewide only.

## Installation

You can install the development version of dcws from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("CT-Data-Haven/dcws")
```

## Included data

As of 2024-12-11, the data included here are:

| name | 2015 | 2018 | 2020 | 2021 | 2022 | 2024 |
|:---|:--:|:--:|:--:|:--:|:--:|:---|
| 5CT | x | x |  |  |  |  |
| Bridgeport | x | x |  | x |  |  |
| Bristol | x | x |  | x |  |  |
| CCHD |  | x |  |  |  |  |
| Chesprocott |  | x |  |  |  |  |
| Connecticut | x | x | x | x | x |  |
| Danbury | x | x |  | x |  |  |
| Darien |  | x |  | x |  |  |
| EHHD |  | x |  | x |  |  |
| East Hartford |  | x |  |  |  |  |
| East Haven |  | x |  |  |  |  |
| FCHT |  | x |  |  |  |  |
| Fairfield |  | x |  | x |  |  |
| Fairfield County | x | x |  | x |  |  |
| Greater Bridgeport | x | x |  |  |  |  |
| Greater Greenwich |  | x |  |  |  |  |
| Greater Hartford | x | x |  | x |  |  |
| Greater New Haven | x | x |  | x |  |  |
| Greater New London | x | x |  |  |  |  |
| Greater Waterbury | x | x |  | x |  |  |
| Greenwich | x | x |  | x |  |  |
| Groton |  |  |  | x |  |  |
| HIA Area |  |  |  | x |  |  |
| Hamden |  | x |  | x |  |  |
| Hartford | x | x |  | x |  |  |
| Hartford Inner Ring |  | x |  |  |  |  |
| Hartford Outer Ring |  | x |  |  |  |  |
| Lower Naugatuck Valley | x | x |  | x |  |  |
| Manchester |  | x |  |  |  |  |
| Meriden | x | x |  |  |  |  |
| Middlesex County | x | x |  | x |  |  |
| Middletown |  | x |  |  |  |  |
| Milford |  | x |  | x |  |  |
| Monroe |  | x |  | x |  |  |
| NCDHD |  | x |  | x |  |  |
| NDDH |  | x |  | x |  |  |
| NY Border Towns |  | x |  |  |  |  |
| New Britain | x | x |  |  |  |  |
| New Haven | x | x |  | x |  |  |
| New Haven Inner Ring |  | x |  |  |  |  |
| New Haven Outer Ring |  | x |  |  |  |  |
| New London | x | x |  | x |  |  |
| New Milford |  | x |  | x |  |  |
| Newtown |  | x |  |  |  |  |
| Norwalk | x | x |  | x |  |  |
| Pomperaug |  | x |  |  |  |  |
| Port Chester NY |  | x |  | x |  |  |
| Southeastern CTHIC Area |  |  |  | x |  |  |
| Stamford | x | x |  | x |  |  |
| Stratford |  | x |  | x |  |  |
| Torrington |  |  |  | x |  |  |
| Trumbull |  | x |  | x |  |  |
| Wallingford |  | x |  |  |  |  |
| Waterbury | x | x |  | x |  |  |
| West Hartford | x | x |  |  |  |  |
| West Haven |  | x |  | x |  |  |
| Windsor |  |  |  | x |  |  |
| dcws_ansonia_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_backus_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_backus_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bloomfield_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_branford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bridgeport_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bridgeport_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bridgeport_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bridgeport_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bristol_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bristol_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bristol_health_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_bristol_health_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_capitol_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_capitol_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_charlotte_hungerford_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_charlotte_hungerford_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_cheshire_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_connecticut_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_connecticut_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_connecticut_childrens_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_connecticut_childrens_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_danbury_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_danbury_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_danbury_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_danbury_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_darien_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_darien_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_day_kimball_healthcare_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_day_kimball_healthcare_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_derby_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_east_hartford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_east_haven_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_east_lyme_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_easton_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_fairfield_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_fairfield_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_fairfield_county_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_fairfield_county_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_bridgeport_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_bridgeport_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_bridgeport_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_bridgeport_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_hartford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_hartford_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_new_haven_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_new_haven_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_waterbury_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greater_waterbury_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greenwich_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greenwich_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greenwich_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_greenwich_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_griffin_health_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_griffin_health_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_groton_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_groton_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hamden_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hamden_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hartford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hartford_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hartford_county_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hartford_county_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hartford_healthcare_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hartford_healthcare_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hartford_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hartford_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hospital_of_central_connecticut_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_hospital_of_central_connecticut_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_johnson_memorial_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_johnson_memorial_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_lawrence_memorial_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_lawrence_memorial_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_ledyard_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_litchfield_county_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_litchfield_county_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_lower_connecticut_river_valley_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_lower_connecticut_river_valley_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_manchester_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_manchester_memorial_rockville_general_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_manchester_memorial_rockville_general_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_meriden_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_meriden_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_mid_state_medical_center_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_mid_state_medical_center_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_middlesex_county_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_middlesex_county_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_middlesex_health_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_middlesex_health_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_middletown_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_middletown_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_milford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_milford_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_monroe_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_monroe_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_naugatuck_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_naugatuck_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_naugatuck_valley_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_naugatuck_valley_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_britain_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_britain_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_haven_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_haven_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_haven_county_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_haven_county_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_london_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_london_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_london_county_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_london_county_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_new_milford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_newtown_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_north_haven_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_northeastern_connecticut_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_northeastern_connecticut_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_northwest_hills_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_northwest_hills_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_norwalk_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_norwalk_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_norwalk_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_norwalk_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_norwich_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_nuvance_health_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_nuvance_health_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_oxford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_plainville_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_prospect_echn_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_prospect_echn_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_prospect_hospitals_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_prospect_hospitals_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_saint_francis_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_saint_francis_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_saint_marys_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_saint_marys_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_seymour_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_sharon_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_sharon_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_shelton_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_shelton_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_south_central_connecticut_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_south_central_connecticut_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_southeastern_connecticut_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_southeastern_connecticut_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_southington_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_st_vincents_medical_center_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_st_vincents_medical_center_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_stamford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_stamford_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_stamford_health_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_stamford_health_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_stratford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_stratford_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_tolland_county_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_tolland_county_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_torrington_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_torrington_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_trinity_health_of_new_england_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_trinity_health_of_new_england_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_trumbull_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_trumbull_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_uconn_john_dempsey_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_uconn_john_dempsey_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_wallingford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_waterbury_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_waterbury_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_waterbury_health_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_waterbury_health_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_waterford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_watertown_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_west_hartford_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_west_haven_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_west_haven_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_western_connecticut_cog_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_western_connecticut_cog_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_winchester_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_windham_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_windham_county_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_windham_county_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_windham_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_windham_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_windsor_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_yale_new_haven_health_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_yale_new_haven_health_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_yale_new_haven_hospital_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_yale_new_haven_hospital_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_zip_10573_2015_2024-v0.2.0 |  |  |  |  |  | x |
| dcws_zip_10573_2024-v0.2.0 |  |  |  |  |  | x |
| **TOTAL** | **23** | **52** | **1** | **35** | **1** | **186** |
