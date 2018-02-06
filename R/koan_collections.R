data(blue_cliff_record, envir = environment())
data(book_of_equanimity, envir = environment())
data(gateless_gate, envir = environment())
data(record_of_light, envir = environment())

collect_koans <- function() {
  dplyr::bind_rows(koanr:::blue_cliff_record, koanr:::book_of_equanimity,
                   koanr:::gateless_gate, koanr:::record_of_light)
}
