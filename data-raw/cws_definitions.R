# definitions of moving questions from scales to indicators,
# e.g. trust neighbors as strongly agree thru strongly disagree --> single number
# qs <- list(
#   financial_insecurity = "managing financially these days",
#   food_insecurity = "^Have there been times .+ buy food",
#   housing_insecurity = "adequate shelter",
#   transport_insecurity = "^In the past 12 months, did you stay home",
#   car_access = "access to a car",
#   locations_in_walking_dist = "Many stores, banks, markets",
#   safe_biking = "places to bicycle",
#   local_rec_facilities = "free or low cost recreation",
#   safe_to_walk_at_night = "I do not feel safe to go on walks",
#   trust_neighbors = "People in this neighborhood can be trusted",
#   youth_have_positive_role_models = "positive role models",
#   have_some_influence_over_local_govt = "influence local.government",
#   self_rated_health = "rate your overall health",
#   satisfied_with_life = "satisfied are you with your life",
#   happy = "how happy did you feel",
#   anxious = "how anxious did you feel",
#   social_support = "social and emotional support you need",
#   satisfied_with_area = "Are you satisfied with the city",
#   local_govt_is_responsive = "responsive local government is",
#   police_approval = "job done by the police",
#   work_opportunities = "suitable employment",
#   good_place_to_raise_kids = "place to raise children",
#   parks_in_good_condition = "condition of public parks",
#   produce_available = "quality fruits and vegetables",
#   labor_force_cws = "had a paid job in the last 30 days",
#   unemployed_cws = "had a paid job in the last 30 days",
#   employed_cws = "had a paid job in the last 30 days",
#   working_part_time = "has your job been full time or part time",
#   prefer_full_time = "working part\\-time by choice",
#   no_one_personal_doc = "think of as your personal doctor",
#   no_doctor = "more than one personal doctor",
#   smoked_100_cigs = "smoked at least 100 cigarettes",
#   currently_smoke = "Do you currently smoke cigarettes"
# ) |>
#   tibble::enframe(name = "indicator", value = "patt") |>
#   tidyr::unnest(patt) |>
#   dplyr::mutate(indicator = forcats::as_factor(indicator))
#
# lookup <- cws_full_data |>
#   tidyr::unnest(survey) |>
#   tidyr::unnest(data) |>
#   dplyr::mutate(question = stringr::str_remove_all(question, "[\\[\\(].+[\\]\\)]\\:?")) |>
#   dplyr::mutate(question = stringr::str_remove_all(question, "[[:punct:]]+$")) |>
#   dplyr::mutate(question = stringr::str_squish(question)) |>
#   dplyr::filter(!grepl("^[A-Z]+\\:", question)) |>
#   dplyr::distinct(question, response) |>
#   dplyr::group_by(question) |>
#   dplyr::summarise(response = paste(tolower(response), collapse = " / "))
#
# lookup |>
#   fuzzyjoin::regex_right_join(qs, by = c("question" = "patt")) |>
#   dplyr::arrange(indicator) |>
#   dplyr::group_by(indicator) |>
#   dplyr::slice_head(n = 1) |>
#   dplyr::mutate(response = sprintf("(%s)", response)) |>
#   dplyr::mutate(question = paste(question, response)) |>
#   tibble::add_column(x1 = NA, x2 = NA, x3 = NA, x4 = NA) |>
#   dplyr::select(indicator, x1:x4, question) |>
#   readr::write_csv("cws_defs.csv", na = "")

# edited in airtable, built in dictionary_build repo
# need to get most recent tag from dictionary release
owner <- "ct-data-haven"
repo <- "dictionary-build"
file <- "gloss.duckdb"
path <- file.path("data-raw", file)

latest <- gh::gh("/repos/{owner}/{repo}/releases/latest",
    owner = owner, repo = repo
)
release_id <- latest[["id"]]

assets <- gh::gh("/repos/{owner}/{repo}/releases/{release_id}/assets",
    owner = owner, repo = repo, release_id = release_id, .per_page = 100
) |>
    purrr::map(\(x) x[c("name", "id")]) |>
    purrr::map(tibble::as_tibble) |>
    dplyr::bind_rows()
asset_id <- assets$id[assets$name == file]

# download, give mime type
db <- gh::gh("/repos/{owner}/{repo}/releases/assets/{asset_id}",
    owner = owner, repo = repo, asset_id = asset_id,
    .accept = "application/octet-stream",
    .destfile = path,
    .overwrite = TRUE
)

con <- DBI::dbConnect(duckdb::duckdb(path))
cws_defs <- DBI::dbGetQuery(con, "
                SELECT variable as indicator, question
                FROM variables
                WHERE dataset = 'cws';
                ")
cws_defs$collapsed_responses <- stringr::str_extract(cws_defs$question, "(?<=\\()(.+)(?=\\))")
cws_defs$question <- stringr::str_remove(cws_defs$question, "\\((.+)\\)$")
cws_defs <- dplyr::mutate(cws_defs, dplyr::across(c(question, collapsed_responses), stringr::str_squish))
cws_defs <- dplyr::as_tibble(cws_defs)

DBI::dbDisconnect(con)
usethis::use_data(cws_defs, overwrite = TRUE)
