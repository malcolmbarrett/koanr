utils::globalVariables(c(".", "%>%", "case", "ditch", "id", "koan_collections", "n", "text", "type"))

`%>%` <- dplyr::`%>%`

#' Sample a koan
#'
#' @param collection a \code{data.frame}, the koan collection to sample from.
#'   Default is \code{NULL}, which randomly selects a collection to pick from.
#' @param case the case number. Default is \code{NULL}, which randomly selects a
#'   case.
#' @param verbose logical. Should koan be printed to console?
#'
#' @return verboses a koan (or part of it) and invisibly returns either a \code{tbl}
#'   containing the text (\code{koan()}) or a character vector.
#' @export
#'
#' @examples
#' koan(gateless_gate, 1)
#'
#' @rdname koan
#' @name Sample a koan
koan <- function(collection = NULL, case = NULL, verbose = TRUE) {
  if (!is.null(collection)) {
    .df <- collection
    collection_name <- unique(.df$collection)
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- collect_koans()
    collection_name <- sample(unique(.df$collection), 1)
  }

  if (!is.null(case)) {
    case_num <- case
  } else {
    case_num <- dplyr::filter(.df, collection == collection_name) %>%
      dplyr::pull(case) %>%
      unique() %>%
      sample(1)
  }

  collection_df <- dplyr::filter(.df, collection == collection_name)

  if (verbose) cat("Collection:", collection_name, "\n\n")
  title(collection = collection_df, case = case_num, verbose = verbose)
  if (verbose) cat("\n\n")
  main_case(collection = collection_df, case = case_num, verbose = verbose)
  if (verbose) cat("\n\n")
  comment <- commentary(collection = collection_df, case = case_num, verbose = verbose)
  if (!purrr::is_empty(comment)) cat("\n\n")
  capping_verse(collection = collection_df, case = case_num, verbose = verbose)
}

#' @export
#' @rdname koan
title <- function(collection = NULL, case = NULL, verbose = TRUE) {
  if (!is.null(collection)) {
    .df <- collection
    collection_name <- unique(.df$collection)
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- collect_koans()
    collection_name <- sample(unique(.df$collection), 1)
  }

  if (!is.null(case)) {
    case_num <- case
  } else {
    case_num <- dplyr::filter(.df, collection == collection_name) %>%
      dplyr::pull(case) %>%
      unique() %>%
      sample(1)
  }
  title <- .df %>%
    dplyr::filter(collection == collection_name, type == "title", case == case_num) %>%
    dplyr::pull(text)

  if (verbose) cat(paste0("Case #", case_num, ": ", title))
  invisible(title)
}

#' @export
#' @rdname koan
main_case <- function(collection = NULL, case = NULL, verbose = TRUE) {
  if (!is.null(collection)) {
    .df <- collection
    collection_name <- unique(.df$collection)
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- collect_koans()
    collection_name <- sample(unique(.df$collection), 1)
  }

  if (!is.null(case)) {
    case_num <- case
  } else {
    case_num <- dplyr::filter(.df, collection == collection_name) %>%
      dplyr::pull(case) %>%
      unique() %>%
      sample(1)
  }
  main_case <- .df %>%
    dplyr::filter(collection == collection_name, type == "main_case", case == case_num) %>%
    dplyr::pull(text)

  if (verbose) cat(paste0("Main Case: ", main_case))
  invisible(main_case)
}

#' @export
#' @rdname koan
commentary <- function(collection = NULL, case = NULL, verbose = TRUE)  {
  if (!is.null(collection)) {
    .df <- collection
    collection_name <- unique(.df$collection)
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- collect_koans()
    collection_name <- sample(unique(.df$collection), 1)
  }

  if (!is.null(case)) {
    case_num <- case
  } else {
    case_num <- dplyr::filter(.df, collection == collection_name) %>%
      dplyr::pull(case) %>%
      unique() %>%
      sample(1)
  }
  commentary <- .df %>%
    dplyr::filter(collection == collection_name, type == "commentary", case == case_num) %>%
    dplyr::pull(text)

  if (!purrr::is_empty(commentary)) {
    if (verbose) cat(paste0("Commentary: ", commentary))
    }
  invisible(commentary)
}

#' @export
#' @rdname koan
capping_verse <- function(collection = NULL, case = NULL, verbose = TRUE)  {
  if (!is.null(collection)) {
    .df <- collection
    collection_name <- unique(.df$collection)
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- collect_koans()
    collection_name <- sample(unique(.df$collection), 1)
  }

  if (!is.null(case)) {
    case_num <- case
  } else {
    case_num <- dplyr::filter(.df, collection == collection_name) %>%
      dplyr::pull(case) %>%
      unique() %>%
      sample(1)
  }
  capping_verse <- .df %>%
    dplyr::filter(collection == collection_name, type == "capping_verse", case == case_num) %>%
    dplyr::pull(text)

  if (!purrr::is_empty(capping_verse)) {
    if (verbose) cat(paste0("Capping Verse: ", capping_verse))
    }
  invisible(capping_verse)
}

data(blue_cliff_record, envir = environment())
data(book_of_equanimity, envir = environment())
data(gateless_gate, envir = environment())
data(record_of_light, envir = environment())

#' Bind koan collections together
#'
#' This is a convenience function that binds the koan data together into a
#' single \code{tbl.}
#'
#' @return a \code{tbl.} containing all 4 koan collections
#' @export
#'
#' @examples
#' library(dplyr)
#'
#' collect_koans() %>% filter(type == "main_case")
collect_koans <- function() {
  dplyr::bind_rows(blue_cliff_record, book_of_equanimity,
                   gateless_gate, record_of_light)
}
