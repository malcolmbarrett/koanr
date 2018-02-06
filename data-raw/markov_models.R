library(koanr)
library(dplyr)
library(markovifyR)

koan_collections <- dplyr::bind_rows(koanr::blue_cliff_record,
                                     koanr::book_of_equanimity,
                                     koanr::gateless_gate,
                                     koanr::record_of_light)
`%>%` <- dplyr::`%>%`
titles <- koan_collections %>% dplyr::filter(type == "title")
main_cases <- koan_collections %>% dplyr::filter(type == "main_case")
commentaries <- koan_collections %>% dplyr::filter(type == "commentary")
capping_verses <- koan_collections %>% dplyr::filter(type == "capping_verse")

markovify_model_title <-
  markovifyR::generate_markovify_model(
    input_text = titles$text,
    markov_state_size = 2L,
    max_overlap_total = 25,
    max_overlap_ratio = .85
  )

markovify_model_main_case <-
  markovifyR::generate_markovify_model(
    input_text = commentaries$text,
    markov_state_size = 2L,
    max_overlap_total = 25,
    max_overlap_ratio = .85
  )

markovify_model_commentary <-
  markovifyR::generate_markovify_model(
    input_text = main_cases$text,
    markov_state_size = 2L,
    max_overlap_total = 25,
    max_overlap_ratio = .85
  )

markovify_model_capping_verse <-
  markovifyR::generate_markovify_model(
    input_text = capping_verses$text,
    markov_state_size = 2L,
    max_overlap_total = 25,
    max_overlap_ratio = .85
  )

usethis::use_data(markovify_model_title, markovify_model_main_case,
                  markovify_model_commentary, markovify_model_capping_verse,
                  internal = TRUE, overwrite = TRUE)
# usethis::use_data(markovify_model_main_case, internal = TRUE, overwrite = TRUE)
# usethis::use_data(markovify_model_commentary, internal = TRUE, overwrite = TRUE)
# usethis::use_data(markovify_model_capping_verse, internal = TRUE, overwrite = TRUE)
