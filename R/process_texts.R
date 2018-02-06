library(pdftools)
library(stringr)
library(purrr)
library(dplyr)

download.file("http://www.thezensite.com/ZenTeachings/KoanStudies/Shoyoroku.pdf", "Shoyoroku.pdf", mode = "wb")
boe_txt <- pdf_text("Shoyoroku.pdf")

boe_cases <- boe_txt[5:27] %>%
  str_split("\\n[:digit:]") %>%
  modify_depth(1, ~pluck(., 1)) %>%
  str_replace_all("\"", "'") %>%
  str_replace_all("[:blank:]+", " ") %>%
  str_replace(" \\(last revision: 20 July 2004\\)", "") %>%
  str_replace("CASE 38: Rinzai's 'True Person'", "CASE 38: Rinzai's 'True Person'\n") %>%
  str_replace("CASE 68: Kassan Brandishes the Sword", "CASE 68: Kassan Brandishes the Sword\n") %>%
  str_c(collapse = " ") %>%
  str_split("CASE ") %>%
  pluck(1) %>% .[-1] %>%
  str_split("\n")

book_of_equanimity <- boe_cases %>% map_df(function(.x) {
  title <- .x[1]
  main_case <- .x[-1] %>%
    paste(collapse = " ")
  tibble(collection = "Book of Equanimity", title, main_case) %>%
    tidyr::separate(title, c("case", "title"), sep = "\\: ", extra = "merge")
})

spluck <- function(str_var, pattern) {
  str_var %>% str_split(pattern) %>% map_chr(~.x[1])
}

book_of_equanimity$title <- book_of_equanimity$title %>%
  spluck("\\— ") %>%
  spluck("– ") %>%
  spluck("--") %>%
  str_replace_all("_", "") %>%
  str_trim()
book_of_equanimity$main_case <- book_of_equanimity$main_case %>%
  str_replace_all("[0-9]{1,2}(?![0-9])", "") %>%
  str_replace("5", "500") %>%
  str_trim()

book_of_equanimity <- book_of_equanimity %>%
  tidyr::gather(key = type, value = text, title, main_case) %>%
  mutate(case = as.integer(case)) %>%
  arrange(case)

denk_txt1 <- pdf_text("https://shastaabbey.org/pdf/bookDenk02.pdf")
denk_txt2 <- pdf_text("https://shastaabbey.org/pdf/bookDenk03.pdf")
denk_txt3 <- pdf_text("https://shastaabbey.org/pdf/bookDenk04.pdf")

record_of_light <- list(denk_txt1, denk_txt2, denk_txt3[1:78]) %>% map_df(function(.chunk) {
  .chunk %>%
  str_split("\n") %>%
  map(~paste(.x[-1], collapse = "\n ")) %>%
  paste(collapse = " ") %>%
  str_split("CHAPTER") %>%
  modify_at(1, ~.x[-1]) %>%
  map(~str_split(.x, "\n")) %>%
  pluck(1) %>%
  map_df(function(.x){
    title <- paste(.x[1:3], collapse = "") %>%
      str_to_title()
    main_case <- .x[4:length(.x)]
    if (main_case[1] == " EKA." ) {
      title <- paste(title, "Eka.")
      main_case <- main_case[-1]
    }
    last_ten_lines <- main_case[(length(main_case) - 15):length(main_case)]
    main_case_end <- str_detect(main_case, "\\s{5}") %>% which() %>% pluck(2)

    commentary <- main_case[main_case_end:length(main_case)]
    main_case <- main_case[seq_len(main_case_end - 1)] %>%
      paste(collapse = "") %>%
      str_replace_all("- ", "") %>%
      str_trim()

    end_line <- last_ten_lines %>%
      paste(collapse = "") %>%
      str_split("\\s{5}") %>% pluck(1) %>% pluck(2)

    commentary_end <- map_lgl(str_trim(commentary), ~str_detect(end_line, fixed(.x))) %>%
      which() %>%
      pluck(1)

    commentary <- commentary[seq_len(commentary_end - 1)] %>%
      paste(collapse = "") %>%
      str_replace_all("- ", "") %>%
      str_trim()

    capping_verse <- last_ten_lines %>%
      paste(collapse = "") %>%
      str_split("\\s{5}") %>%
      map(~str_trim(.x[-1])) %>%
      map_chr(function(.x) {
        intro <- .x[1]
        verse <- .x[-1] %>% keep(~.x != "")
        paste(intro, paste(verse, collapse = ", "))
      })

    tibble(collection = "Record of the Transmission of the Light", title, main_case, commentary, capping_verse) %>%
      mutate(title = str_trim(title)) %>%
      tidyr::separate(title, c("case", "title"), sep = "\\. ", extra = "merge") %>%
      mutate(case = as.integer(case))
  })
})

record_of_light <- record_of_light %>%
  mutate_if(is.character, funs(str_replace_all(.," //.", "") %>%
                                 str_replace_all("á", "o") %>%
                                 str_replace_all("\\s{5}", " \n ") %>%
                                 str_replace_all("\\s{4}", " \n "))) %>%
  tidyr::gather(key = type, value = text, title, main_case, commentary, capping_verse) %>%
  arrange(case)

gg_text <- pdf_text("http://info.stiltij.nl/publiek/meditatie/koan/mumonkan-shimomisse.pdf")
gg_text <- gg_text[4:57]
gateless_gate <- gg_text %>%
  str_split("\n") %>%
  map(~paste(.x[-1], collapse = "\n ")) %>%
  paste(collapse = " ") %>%
  str_split("CASE ") %>%
  modify_at(1, ~.x[-1]) %>%
  map(~str_split(.x, "\n")) %>%
  pluck(1) %>%
  map_df(function(.x){
    title <- paste(str_trim(.x[1:2]), collapse = " ") %>%
      str_to_title()
    main_case <- .x[3:length(.x)]
    if (str_trim(main_case[1]) == "OF THE 100 FOOT HIGH POLE" ) {
      title <- paste(title, "OF THE 100 FOOT HIGH POLE") %>% str_to_title()
      main_case <- main_case[-1]
    }

    last_few_lines <- main_case[(length(main_case) - 7):length(main_case)]
    main_case_end <- str_detect(str_trim(main_case), "Mumon") %>% which() %>% pluck(1)

    commentary <- main_case[main_case_end:length(main_case)]
    main_case <- main_case[seq_len(main_case_end - 1)] %>%
      paste(collapse = "") %>%
      str_replace_all("- ", "") %>%
      str_trim()

    end_line <- last_few_lines %>%
      paste(collapse = "") %>%
      str_split("\\s{3}") %>% pluck(1) %>% pluck(2)

    commentary_end <- map_lgl(str_trim(commentary), ~str_detect(end_line, fixed(.x))) %>%
      which() %>%
      pluck(1)

    comm_lines <- ifelse(commentary_end == 1, seq_len(3), seq_len(commentary_end - 1))
    if (commentary_end == 1) comm_lines <- 1:3 else comm_lines <- seq_len(commentary_end - 1)
    commentary <- commentary[comm_lines] %>%
      paste(collapse = "") %>%
      str_replace_all("- ", "") %>%
      str_trim()

    capping_verse <- last_few_lines %>%
      paste(collapse = "") %>%
      str_split("\\s{3}") %>%
      map(~str_trim(.x[-1])) %>%
      map_chr(function(.x) {
        intro <- .x[1]
        if (str_detect(intro, "Mumon")) intro <- ""
        verse <- .x[-1] %>% keep(~.x != "")
        paste(intro, paste(verse, collapse = " ")) %>% str_trim()
      })

    tibble(collection = "The Gateless Gate", title, main_case, commentary, capping_verse) %>%
      mutate(title = str_trim(title)) %>%
      tidyr::separate(title, c("case", "title"), sep = "\\. ", extra = "merge") %>%
      mutate(case = as.integer(case))
  })



gateless_gate <- gateless_gate %>%
  mutate_if(is.character, funs(str_replace_all(., "\"", "'") %>%
                                               str_replace_all("\\s{4}", " \n ") %>%
                                              str_replace_all("\\s{3}", " \n "))) %>%
  tidyr::gather(key = type, value = text, title, main_case, commentary, capping_verse) %>%
  arrange(case)

bcr_txt <- pdf_text("http://4x13.net/buddhism/koan_bluecliff.pdf")

bcr_cases <- bcr_txt[5:31] %>%
  str_split("\\n[:digit:]") %>%
  modify_depth(1, ~pluck(., 1)) %>%
  str_replace_all("\"", "'") %>%
  str_replace_all("[:blank:]+", " ") %>%
  str_replace("CASE 75: Ukyû's Blind Stick", "CASE 75: Ukyû's Blind Stick\n") %>%
  str_c(collapse = " ") %>%
  str_split("CASE ") %>%
  pluck(1) %>% .[-1] %>%
  str_split("\n")

blue_cliff_record <- bcr_cases %>% map_df(function(.x) {
  title <- .x[1]
  main_case <- .x[-1] %>% str_trim()
  commentary_index <- str_detect(main_case, "Setchô said")
  commentary <-  paste(main_case[commentary_index], collapse = " \n ")
  main_case <- paste(main_case[!commentary_index], collapse = " ")
  tibble(collection = "Blue Cliff Record", title, main_case, commentary) %>%
    tidyr::separate(title, c("case", "title"), sep = "\\: ", extra = "merge")
})

spluck <- function(str_var, pattern) {
  str_var %>% str_split(pattern) %>% map_chr(~.x[1])
}

blue_cliff_record$title <- blue_cliff_record$title %>%
  spluck("\\— ") %>%
  spluck("– ") %>%
  spluck("--") %>%
  str_replace_all("_", "") %>%
  str_replace_all("[0-9]{1,2}(?![0-9])", "") %>%
  str_trim()
blue_cliff_record$main_case <- blue_cliff_record$main_case %>%
  str_replace_all("[0-9]{1,2}(?![0-9])", "") %>%
  str_replace("5", "500") %>%
  str_trim()

blue_cliff_record <- blue_cliff_record %>%
  tidyr::gather(key = type, value = text, title, main_case, commentary) %>%
  mutate(case = as.integer(case)) %>%
  filter(text != "") %>%
  arrange(case)
