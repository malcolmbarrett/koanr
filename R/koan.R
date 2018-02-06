title <- function(collection = NULL) {
  if (!is.null(collection)) {
    .df <- collection
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- collect_koans()
  }

  # randomly select koan

}

main_case <- function(collection = NULL) {
  if (!is.null(collection)) {
    .df <- collection
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- collect_koans()
  }

  # randomly select koan

}

commentary <- function(collection = NULL) {
  if (!is.null(collection)) {
    .df <- collection
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- collect_koans()
  }

  # randomly select koan

}

capping_verse <- function(collection = NULL) {
  if (!is.null(collection)) {
    .df <- collection
    if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
  } else {
    .df <- koan_collections
  }

  # randomly select koan

}

koan <- function(collection = NULL) {
 if (!is.null(collection)) {
   .df <- collection
   if (!is.data.frame(.df)) stop("`collection` must be of class data.frame")
 } else {
   .df <- koan_collections
 }

  # randomly select koan

}
