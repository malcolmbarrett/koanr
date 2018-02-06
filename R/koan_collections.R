utils::globalVariables(c(".", "%>%", "case", "ditch", "id", "koan_collections", "n", "text", "type"))

data(blue_cliff_record, envir = environment())
data(book_of_equanimity, envir = environment())
data(gateless_gate, envir = environment())
data(record_of_light, envir = environment())

collect_koans <- function() {
  dplyr::bind_rows(blue_cliff_record, book_of_equanimity,
                   gateless_gate, record_of_light)
}
