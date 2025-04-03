# dcws v1.3.0 (2025-04-03)

This is the first release of {dcws} that is intended to go public. A few changes in recent versions toward that goal:

- Separation of concerns: Many of the functions that were previously in the [cwi package](https://www.github.com/ct-data-haven/cwi) were more geared toward working with our survey data. Those have now been moved here. For the next few months, use of those functions under the `cwi` namespace will throw deprecation warnings; they'll be removed once we start work on the next Community Wellbeing Index (its namesake) later this year.
- License: {dcws} is now released under the [Hippocratic License](https://firstdonoharm.dev/), which takes an explicit stance on how open source software can and should be used for the public good. This includes restrictions on the use of this software and the data it contains by government and law enforcement actors.
- More robust testing and better test coverage: I've tried to preempt edge cases that might occur, especially for users outside of DataHaven, but please file issues for any bugs.

## Feat

- clean up dependencies, rebuild in preparation for public release

# dcws v1.2.0 (2025-04-02)

## Feat

- clean up dependencies, rebuild in preparation for public release

## Fix

- **clean_cws_lvls**: add argument to make sure group levels are in semantic order

# dcws v1.1.0 (2025-03-24)

## Feat

- next set of migrations from {cwi}:
  - **cws_demo**: sample dataset for examples and testing
  - **collapse_n_wt** & **sub_nonanswers**: moved to {dcws} with testing

## Fix

- Functions that use default bare column names now use a helper utility to give informative error messages if any columns are missing

# dcws v1.0.1 (2025-03-22)

## Fix

- **filter_down**: fix minor bug in how filter_after handled streaks

# dcws v1.0.0 (2025-03-14)

- **BREAKING CHANGE** (potentially): in order to handle the number and complexity of the crosstab tables with all the 2024 additions, I switched the object `cws_full_data` that `fetch_cws` relies on from a data frame with deeply nested list-columns of more data frames, to a list of individual data frames. Each crosstab now has an ID that can be used to directly subset, such as "2021.2021.New Haven" for New Haven's 2021 data, or "2024.2015*2024.Capitol Region COG" for the Capitol Region COG's 2015-2024 pooled data. For the most part, this is a behind-the-scenes change handled by `fetch_cws`, but this method is \_much* faster.
- Formatting fixes should all be done, with respect to category & group labels, region names, etc.
- First round of crosstab-related functions from {cwi} have been moved here, and are documented and tested. Those are in the process of being deprecated from {cwi}.

## Feat

- cleanup before version bump

## Fix

- **clean_cws_lvls**: fix "greater than" signs in clean_cws_lvls; closes #2

## Refactor

- switch cws_full_data from nested data frame to list of data frames

# dcws v0.1.6 (2025-02-26)

## Fix

- **clean_cws_lvls**: yet another set of regex changes for cleaning levels

# dcws v0.1.5.9000 (2025-01-27)

## Fix

- better pattern matching for clean_cws_lvls

# dcws 0.1.5

- Add indicator definitions --> `cws_defs`

# dcws 0.1.4

- Add 2022 statewide crosstabs

# dcws 0.1.3

- Add a few 2021 crosstabs
- Switch to `cli` package for messaging

# dcws 0.1.2

- Update several 2021 crosstabs
- Add vignette on which locations are left out of `cws_full_data`

# dcws 0.1.1

- Better ordering of group levels
- Add `.drop_ct` argument to `fetch_cws`
- Update vignette

# dcws 0.1.0

- First full build with a vignette :tada:

# dcws 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
