library(pdftools)
library(stringr)
library(purrr)
library(dplyr)

boe_txt <- pdf_text("http://www.thezensite.com/ZenTeachings/KoanStudies/Shoyoroku.pdf")

boe_cases <- boe_txt[5:27] %>%
  str_split("\\n[:digit:]") %>%
  modify_depth(1, ~pluck(., 1)) %>%
  str_replace_all("[:blank:]+", " ") %>%
  str_replace(" \\(last revision: 20 July 2004\\)", "") %>%
  str_replace("CASE 38: Rinzai's \"True Person\"", "CASE 38: Rinzai's \"True Person\"\n") %>%
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
  str_replace_all("(?<!\\d)(([0-7]{1}[0-9]{0,1})|8{1}[0-6]{0,1})(?!\\d)", "") %>%
  str_trim()
book_of_equanimity$main_case <- book_of_equanimity$main_case %>%
  str_replace_all("(?<!\\d)(([0-7]{1}[0-9]{0,1})|8{1}[0-6]{0,1})(?!\\d)", "") %>%
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
    if (title == " 1. Shakyamuni Buddha, The Awakened One.") .x <- .x[-19]
    if (title == " 3. The Second Ancestor, The Sainted Ananda.") .x <- .x[1:227]
    main_case <- .x[4:length(.x)]
    if (main_case[1] == " EKA." ) {
      title <- paste(title, "Eka.")
      main_case <- main_case[-1]
    }
    last_ten_lines <- main_case[(length(main_case) - 15):length(main_case)]
    main_case_end <- str_detect(main_case, "\\s{5}") %>% which() %>% pluck(2)
    if (title == " 10. The Ninth Ancestor, The Sainted Fudamitta.") main_case_end <- 13
    if (title == " 18. The Seventeenth Ancestor, The Sainted Sügyanandai.") main_case_end <- 9

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

    commentary <- commentary[seq_len(commentary_end - 1)]

    likely_verse <- commentary %>% str_detect("\\s{7,}")
    likely_end_line <- map_lgl(1:length(likely_verse), function(i) {
      if (i == 1 || i == 2) return(FALSE)
      (likely_verse[i - 1] && likely_verse[i - 2] && !likely_verse[i])
    })

    commentary <- ifelse(likely_end_line, paste(" \n ", commentary), commentary)

    commentary <- commentary %>%
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
        paste(intro, "\n \n ", paste(verse, collapse = " \n "))
      })

    tibble(collection = "Record of the Transmission of the Light", title, main_case, commentary, capping_verse) %>%
      mutate(title = str_trim(title)) %>%
      tidyr::separate(title, c("case", "title"), sep = "\\. ", extra = "merge") %>%
      mutate(case = as.integer(case))
  })
})
likely_verse_main_case <- record_of_light$main_case %>%
  str_split("[:blank:]{3,}") %>%
  map(str_count, boundary("word")) %>%
  map(`<`, 20)

record_of_light$main_case <- record_of_light$main_case %>%
  str_split("[:blank:]{3,}") %>%
  map2(likely_verse_main_case, ~ifelse(.y, paste(.x, "VERSE"), .x)) %>%
  map(paste, collapse = " \n \n ") %>%
  str_replace_all("VERSE \n ", "")

likely_verse_commentary <- record_of_light$commentary %>%
  str_split("[:blank:]{3,}") %>%
  map(str_count, boundary("word")) %>%
  map(`<`, 20)

record_of_light$commentary <- record_of_light$commentary %>%
  str_split("[:blank:]{3,}") %>%
  map2(likely_verse_commentary, ~ifelse(.y, paste(.x, "VERSE"), .x)) %>%
  map(paste, collapse = " \n \n ") %>%
  str_replace_all("VERSE \n ", "") %>%
  str_replace_all("As \n \n a \n result \n of \n this \n you \n will \n not",
                  "As a result of this you will not")

record_of_light <- record_of_light %>%
  mutate_if(is.character, funs(str_replace_all(.," //.", "") %>%
                                 str_replace_all("á", "o") %>%
                                 str_replace_all("â", "u") %>%
                                 str_replace_all("±", "s") %>%
                                 str_replace_all("œ", "n") %>%
                                 str_replace_all("Ø", "d") %>%
                                 str_replace_all("Å", "a") %>%
                                 str_replace_all("ü", "o") %>%
                                 str_replace_all("„", "s") %>%
                                 str_replace_all("≠", "i") %>%
                                 str_replace_all("Ÿ", "r") %>%
                                 str_replace_all("Ê", "t") %>%
                                 str_replace_all("÷", "S") %>%
                                 str_replace_all("Ä", "A") %>%
                                 str_replace_all("¨", "") %>%
                                 str_replace_all("- ", "") %>%
                                 str_replace_all("\\*", "") %>%
                                 str_replace_all("\\s+\\;", ";") %>%
                                 str_replace_all("\\s+\\,", ",") %>%
                                 str_replace_all("\\s+\\.", ".") %>%
                                 str_replace_all("\\s+\\?", "?") %>%
                                 str_replace_all("(?<!\\d)(([0-7]{1}[0-9]{0,1})|8{1}[0-6]{0,1})(?!\\d)", "")
                               )) %>%
  tidyr::gather(key = type, value = text, title, main_case, commentary, capping_verse) %>%
  arrange(case)

gg_text <- pdf_text("http://info.stiltij.nl/publiek/meditatie/koan/mumonkan-shimomisse.pdf")
gg_text <- gg_text[4:57]
gateless_gate <- gg_text %>%
  str_split("\n") %>%
  map(~paste(.x[-1], collapse = "\n ")) %>%
  paste(collapse = " ") %>%
  str_replace("CASE\\. 24", "CASE 24.") %>%
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

    short_comments <- c(
      " The question Joshu asked Nansen was dissolved by a stroke. After being enlightened, Joshu must further his pursuit 30 more years to exhaust that meaning.",
      "Tozan's Zen is like a clam. When the two halves of the shell open, you can see the whole inside. However, now tell me, \"What is Tozan's real insides?\"",
      " If you can answer Goso exactly, it will be extremely heartening. If you cannot answer properly yet, then you must do your best to watch out everything.",
      " Ananda was Buddha's disciple but his understanding was not like that pagan. Now tell me, \"How afar are the disciple and the non-disciple?\"",
      " Should you be able to clearly realize who he is, it would be as if you met your own father at the crossroads, as you do not have to ask your own father who he is."
    )

    short_replacements <- c(
      " Hundred flowers in Spring, the moon in Autumn,",
      "Just \"Three pounds of flax!\" pops up,",
      " Meeting the man of the Way on the road,",
      "    Treading on the sharp edge of a sword,",
      " Do not use another's bow and arrow."
    )

    if (any(short_comments %in% end_line)) end_line <- short_replacements[which(short_comments %in% end_line)]

    commentary_end <- map_lgl(str_trim(commentary), ~str_detect(end_line, fixed(.x))) %>%
      which()

    if (length(commentary_end) > 1) commentary_end <- min(commentary_end)
    if (commentary_end == 1) comm_lines <- 1:3 else comm_lines <- seq_len(commentary_end - 1)
    if (any(str_detect(commentary, "understands what Baso"))) {
      capping_verse <- commentary[3:6] %>%
        paste(collapse = " \n \n ") %>%
        str_replace_all("- ", "") %>%
        str_trim()
      commentary <- commentary[1:2] %>%
        paste(collapse = "") %>%
        str_replace_all("- ", "") %>%
        str_trim()

    } else {
    verse_lines <- commentary[-comm_lines] %>%
      str_replace_all("[:blank:]", " ") %>%
      str_replace_all("- ", "") %>%
      str_trim()
    commentary <- commentary[comm_lines] %>%
      paste(collapse = "") %>%
      str_replace_all("- ", "") %>%
      str_trim()

    # if (str_detect(last_few_lines[1], "Ananda was")) {
    #   commentary <- paste(commentary,
    #                       paste(last_few_lines[1:3], collapse = " "))
    #   verse_lines <- last_few_lines[4:7]
    # }

    capping_verse <- verse_lines %>%
      paste(collapse = " \n ") %>%
      str_trim()
      # paste(collapse = "") %>%
      # str_split("\\s{3}") %>%
      # map(~str_trim(.x[-1])) %>%
      # map_chr(function(.x) {
      #   intro <- .x[1]
      #   if (str_detect(intro, "Mumon")) intro <- ""
      #   verse <- .x[-1] %>% keep(~.x != "")
      #   paste(intro, " \n ", paste(verse, collapse = " \n ")) %>% str_trim()
      # })
  }
    tibble(collection = "The Gateless Gate", title, main_case, commentary, capping_verse) %>%
      mutate(title = str_trim(title)) %>%
      tidyr::separate(title, c("case", "title"), sep = "\\. ", extra = "merge") %>%
      mutate(case = as.integer(case))
  })



gateless_gate <- gateless_gate %>%
  mutate(main_case = str_replace_all(main_case, "\\s{3,}", " \n \n "),
         commentary = str_replace_all(commentary, "\\s{3,}", " \n \n ")) %>%
  tidyr::gather(key = type, value = text, title, main_case, commentary, capping_verse) %>%
  arrange(case)

bcr_txt <- pdf_text("http://4x13.net/buddhism/koan_bluecliff.pdf")

bcr_cases <- bcr_txt[5:31] %>%
  str_split("\\n[:digit:]") %>%
  modify_depth(1, ~pluck(., 1)) %>%
  str_replace_all("[:blank:]+", " ") %>%
  str_replace("CASE 75: Ukyû's Blind Stick", "CASE 75: Ukyû's Blind Stick\n") %>%
  str_c(collapse = " ") %>%
  str_split("CASE ") %>%
  pluck(1) %>% .[-1] %>%
  str_split("\n")

blue_cliff_record <- bcr_cases %>% map_df(function(.x) {
  title <- .x[1]
  main_case <- .x[-1] %>% str_trim()
  if (any(str_detect(main_case, "\\(Setchô comments, 'Wrong!'\\) Mayoku"))) {
    main_case <- main_case %>%
      str_replace("\\) M", ")@ M") %>%
      str_split("@") %>%
      unlist() %>%
      str_trim()
  }
  commentary_index <- str_detect(main_case, "Setchô")
  end_parenthesis <- str_detect(main_case[commentary_index], "\\)")
  if (is_empty(end_parenthesis)) end_parenthesis <- FALSE
  if (!any(end_parenthesis)) {
  commentary_index <- map(which(commentary_index), function(.comment){
      end_line <- str_detect(main_case[.comment:length(main_case)], "\\)") %>%
        which() %>%
        pluck(1)
      .comment:(.comment + end_line - 1)
    }) %>% unlist()
  total_index <- seq_len(length(main_case))
  not_commentary_index <- which(!(total_index %in% commentary_index))
  } else {
    not_commentary_index <- which(!commentary_index)
    commentary_index <- which(commentary_index)
  }
  # if (any(commentary_index)) browser()
  # if (is_empty(end_parenthesis)) end_parenthesis <- FALSE
  # if (!end_parenthesis) commentary_index[(which(commentary_index) + 1)] <- TRUE
  commentary <-  paste(main_case[commentary_index], collapse = " \n \n ")

  #try to guess where paragraph breaks are
  main_case <- main_case[not_commentary_index] %>% `[`(. != "")
  word_count <- main_case %>% str_count(boundary("word"))
  end_of_paragraph <- word_count <= 10 & main_case != main_case[length(main_case)]
  main_case[end_of_paragraph] <- paste(main_case[end_of_paragraph], "\n \n ")
  main_case <- paste(main_case, collapse = " ")
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
  str_replace_all("(?<!\\d)(([0-7]{1}[0-9]{0,1})|8{1}[0-6]{0,1})(?!\\d)", "") %>%
  str_replace_all("\\s+\\;", ";") %>%
  str_replace_all("\\s+\\,", ",") %>%
  str_replace_all("\\s+\\.", ".") %>%
  str_replace_all("\\s+\\?", "?") %>%
  str_trim()

blue_cliff_record$commentary <- blue_cliff_record$commentary %>%
  str_replace_all("(?<!\\d)(([0-7]{1}[0-9]{0,1})|8{1}[0-6]{0,1})(?!\\d)", "") %>%
  str_replace_all("\\s+\\,", ",") %>%
  str_replace_all("\\s+\\.", ".") %>%
  str_replace_all("\\s+\\?", "?") %>%
  str_trim()

blue_cliff_record <- blue_cliff_record %>%
  tidyr::gather(key = type, value = text, title, main_case, commentary) %>%
  mutate(case = as.integer(case)) %>%
  filter(text != "") %>%
  arrange(case)


usethis::use_data(blue_cliff_record, overwrite = TRUE)
usethis::use_data(book_of_equanimity, overwrite = TRUE)
usethis::use_data(gateless_gate, overwrite = TRUE)
usethis::use_data(record_of_light, overwrite = TRUE)
