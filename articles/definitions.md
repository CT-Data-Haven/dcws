# Indicator definitions

This is an overview of standardized definitions of many of the
indicators we use. For example, the question about the condition of
local parks is a Likert-style question with answers of strongly agree,
somewhat agree, somewhat disagree, strongly disagree. When we report
this indicator, however, we do it as the percentage that says either
strongly or somewhat agree. The data frame `cws_defs` has definitions of
each indicator of this type, how the question was phrased, and the
definition of what responses get collapsed into the summary indicator.
The data frame is part of a larger [data dictionary
project](https://github.com/CT-Data-Haven/dictionary-build) still in
progress.

``` r
library(dcws)
library(dplyr)
```

Here’s how one of these Likert questions is defined, nothing special.

``` r
cws_defs |>
    filter(indicator == "safe_biking") |>
    knitr::kable()
```

| indicator   | question                                                                                                                                               | collapsed_responses    |
|:------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------|
| safe_biking | There are places to bicycle in or near my neighborhood that are safe from traffic, such as on the street or on special lanes, separate paths or trails | strongly agree / agree |

A few questions are more complicated, and have different universes to
use. For example, current smoking rate is calculated based on the
percentage of people who say they’ve smoked 100 cigarettes in their
life; that becomes the universe for the share of people who say they
currently smoke every day or some days:

``` r
cws_defs |>
    filter(grepl("smok", indicator)) |>
    knitr::kable()
```

| indicator       | question                                                             | collapsed_responses   |
|:----------------|:---------------------------------------------------------------------|:----------------------|
| smoked_100_cigs | Have you smoked at least 100 cigarettes in your entire life          | yes                   |
| currently_smoke | Do you currently smoke cigarettes every day, some days or not at all | every day / some days |

As of right now, those universes aren’t included in the dataset, but
they can be if it’s at all confusing.

Here’s the whole data frame as reference:

``` r
knitr::kable(cws_defs)
```

| indicator                           | question                                                                                                                                               | collapsed_responses                                                |
|:------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------|
| financial_insecurity                | How well would you say you are managing financially these days?                                                                                        | just getting by / finding it difficult / finding it very difficult |
| food_insecurity                     | Have there been times in the past 12 months when you did not have enough money to buy food that you or your family needed?                             | yes / no                                                           |
| housing_insecurity                  | In the last 12 months, have you not had enough money to provide adequate shelter or housing for you or your family?                                    | yes / no                                                           |
| transport_insecurity                | In the past 12 months, did you stay home when you needed or wanted to go someplace because you had no access to reliable transportation?               | yes / no                                                           |
| car_access                          | Do you have access to a car when you need it?                                                                                                          | very often / fairly often                                          |
| locations_in_walking_dist           | Many stores, banks, markets or places to go are within easy walking distance of my home                                                                | strongly agree / agree                                             |
| safe_biking                         | There are places to bicycle in or near my neighborhood that are safe from traffic, such as on the street or on special lanes, separate paths or trails | strongly agree / agree                                             |
| local_rec_facilities                | My neighborhood has several free or low cost recreation facilities such as parks, playgrounds, public swimming pools, etc                              | strongly agree / agree                                             |
| safe_to_walk_at_night               | I do not feel safe to go on walks in my neighborhood at night                                                                                          | strongly disagree / disagree                                       |
| trust_neighbors                     | People in this neighborhood can be trusted                                                                                                             | strongly agree / agree                                             |
| youth_have_positive_role_models     | Children and youth in my town generally have the positive role models they need around here                                                            | strongly agree / agree                                             |
| have_some_influence_over_local_govt | How would you describe your ability to influence local-government decision making?                                                                     | great influence / moderate influence / a little influence          |
| self_rated_health                   | How would you rate your overall health?                                                                                                                | excellent / very good                                              |
| satisfied_with_life                 | How satisfied are you with your life nowadays?                                                                                                         | mostly / completely                                                |
| happy                               | How happy did you feel yesterday?                                                                                                                      | mostly / completely                                                |
| anxious                             | How anxious did you feel yesterday?                                                                                                                    | mostly / completely                                                |
| social_support                      | How often do you get the social and emotional support you need?                                                                                        | always / usually                                                   |
| satisfied_with_area                 | Are you satisfied with the city or area where you live?                                                                                                | yes / no                                                           |
| local_govt_is_responsive            | How responsive local government is to the needs of residents                                                                                           | excellent / good                                                   |
| police_approval                     | The job done by the police to keep residents safe                                                                                                      | excellent / good                                                   |
| work_opportunities                  | The ability of residents to obtain suitable employment                                                                                                 | excellent / good                                                   |
| good_place_to_raise_kids            | As a place to raise children                                                                                                                           | excellent / good                                                   |
| parks_in_good_condition             | The condition of public parks and other public recreational facilities                                                                                 | excellent / good                                                   |
| produce_available                   | The availability of affordable, high-quality fruits and vegetables                                                                                     | excellent / good                                                   |
| labor_force_cws                     | Have you had a paid job in the last 30 days                                                                                                            | yes / no, but would like to work                                   |
| unemployed_cws                      | Have you had a paid job in the last 30 days                                                                                                            | no, but would like to work                                         |
| employed_cws                        | Have you had a paid job in the last 30 days                                                                                                            | yes                                                                |
| working_part_time                   | During this time, has your job been full time or part time                                                                                             | part time                                                          |
| prefer_full_time                    | Are you working part-time by choice, or would you rather have a full-time job                                                                          | rather have a full time job                                        |
| no_one_personal_doc                 | Do you have one person or place you think of as your personal doctor or health care provider                                                           | no                                                                 |
| no_doctor                           | Is that because you have more than one personal doctor, or none at all                                                                                 | none at all                                                        |
| smoked_100_cigs                     | Have you smoked at least 100 cigarettes in your entire life                                                                                            | yes                                                                |
| currently_smoke                     | Do you currently smoke cigarettes every day, some days or not at all                                                                                   | every day / some days                                              |
