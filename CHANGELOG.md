# dcws v1.5.0 (2026-04-13)

## Feat

- **combine_response**: wip add combine_response function and tests

# dcws v1.4.0 (2026-01-21)

## Feat

- **data**: add 2025 statewide data

# dcws v1.3.0 (2025-04-03)

## Feat

- clean up dependencies, rebuild in preparation for public release

# dcws v1.2.0 (2025-04-02)

## Feat

- clean up dependencies, rebuild in preparation for public release
- next set of migrations from cwi

## Fix

- **clean_cws_lvls**: add argument to make sure group levels are in semantic order

# dcws v1.0.1 (2025-03-22)

## Fix

- **filter_down**: fix minor bug in how filter_after handled streaks

# dcws v1.0.0 (2025-03-14)

## Feat

- cleanup before version bump

## Fix

- **clean_cws_lvls**: fix "greater than" signs in clean_cws_lvls; closes #2

## Refactor

- switch cws_full_data from nested data frame to list of data frames

# dcws v0.1.6 (2025-02-26)

## Fix

- **clean_cws_lvls**: yet another set of regex changes for cleaning levels
- clean_cws_lvls still missing a pattern
- better pattern matching for clean_cws_lvls
