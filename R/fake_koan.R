`%>%` <- dplyr::`%>%`

#' Generate fake koans using a Markov model
#'
#' @param n_lines The amount of lines to create. Default randomly samples a
#' number.
#'
#' @return Prints a koan (or part of it) and invisibly returns a \code{tbl}
#'   containing the text.
#' @export
#'
#' @examples
#' fake_koan()
#' @rdname fake_koan
#' @name Fake Koans
fake_koan <- function() {
  title <- fake_title()
  cat("\n\nMain Case: \n")
  main_case <- fake_main_case()
  cat("\n\nCommentary: \n")
  commentary <- fake_commentary()
  cat("\n\nCapping verse: \n")
  capping_verse <- fake_capping_verse()

  koan_df <- tibble::tibble(
    title = title$title,
    main_case = paste(main_case$main_case, collapse = " "),
    commentary = paste(commentary$commentary, collapse = " "),
    capping_verse = paste(capping_verse$capping_verse, collapse = " ")
  ) %>%
    tidyr::separate(title, c("case", "title"), sep = "\\: ", extra = "merge") %>%
    tidyr::separate(case, c("ditch", "case"), sep = "#", extra = "merge") %>%
    dplyr::mutate(case = as.integer(case)) %>%
    dplyr::select(-ditch) %>%
    tidyr::gather(key = type,
                  value = text,
                  title, main_case, commentary, capping_verse)
  invisible(koan_df)
}

#' @export
#' @rdname fake_koan
fake_title <- function() {
  titles <- collect_koans() %>%
    dplyr::filter(type == "title")

  markovify_model_title <-
    markovifyR::generate_markovify_model(
      input_text = titles$text,
      markov_state_size = 2L,
      max_overlap_total = 25,
      max_overlap_ratio = .85
    )

  lines <- markovifyR::markovify_text(
    markov_model = markovify_model_title,
    output_column_name = 'title',
    count = 50,
    tries = 1000,
    only_distinct = TRUE,
    return_message = FALSE) %>%
    dplyr::slice(sample(1:n(), 1)) %>%
    dplyr::mutate(id = 1:n(),
                  title = paste0("Case #", sample(1:100, 1), ": ", title)) %>%
    dplyr::select(id, title)

  purrr::walk(lines$title, cat, "")
  invisible(lines)
}


#' @export
#' @rdname fake_koan
fake_main_case <- function(n_lines = sample(1:20, 1)) {
  main_cases <- collect_koans() %>%
    dplyr::filter(type == "main_case")

  markovify_model_main_case <-
    markovifyR::generate_markovify_model(
      input_text = main_cases$text,
      markov_state_size = 2L,
      max_overlap_total = 25,
      max_overlap_ratio = .85
    )

  lines <- purrr::rerun(n_lines, markovifyR::markovify_text(
    markov_model = markovify_model_main_case,
    output_column_name = 'main_case',
    count = 50,
    tries = 1000,
    only_distinct = TRUE,
    return_message = FALSE) %>%
      dplyr::slice(sample(1:n(), 1)) %>%
      dplyr::mutate(id = 1:n()) %>%
      dplyr::select(id, main_case)) %>%
    dplyr::bind_rows()

  purrr::walk(lines$main_case, cat, "")
  invisible(lines)
}

#' @export
#' @rdname fake_koan
fake_commentary <- function(n_lines = sample(1:20, 1)) {
  commentaries <- collect_koans() %>%
    dplyr::filter(type == "commentary")

  markovify_model_commentary <-
    markovifyR::generate_markovify_model(
      input_text = commentaries$text,
      markov_state_size = 2L,
      max_overlap_total = 25,
      max_overlap_ratio = .85
    )

  lines <- purrr::rerun(n_lines, markovifyR::markovify_text(
    markov_model = markovify_model_commentary,
    output_column_name = 'commentary',
    count = 50,
    tries = 1000,
    only_distinct = TRUE,
    return_message = FALSE) %>%
      dplyr::slice(sample(1:n(), 1)) %>%
      dplyr::mutate(id = 1:n()) %>%
      dplyr::select(id, commentary)) %>%
    dplyr::bind_rows()

  purrr::walk(lines$commentary, cat, "")
  invisible(lines)
}

#' @export
#' @rdname fake_koan
fake_capping_verse <- function(n_lines = sample(3:6, 1)) {
  capping_verses <- collect_koans() %>%
    dplyr::filter(type == "capping_verse")

  markovify_model_capping_verse <-
    markovifyR::generate_markovify_model(
      input_text = capping_verses$text,
      markov_state_size = 2L,
      max_overlap_total = 25,
      max_overlap_ratio = .85
    )

  lines <- purrr::rerun(n_lines, markovifyR::markovify_text(
    markov_model = markovify_model_capping_verse,
    output_column_name = 'capping_verse',
    count = 50,
    tries = 1000,
    only_distinct = TRUE,
    return_message = FALSE) %>%
      dplyr::slice(sample(1:n(), 1)) %>%
      dplyr::mutate(id = 1:n()) %>%
      dplyr::select(id, capping_verse)) %>%
    dplyr::bind_rows()

  purrr::walk(lines$capping_verse, cat, "")
  invisible(lines)
}


