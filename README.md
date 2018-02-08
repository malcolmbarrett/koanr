
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/malcolmbarrett/koanr.svg?branch=master)](https://travis-ci.org/malcolmbarrett/koanr) [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/myfqx9fpr4fqcgom?svg=true)](https://ci.appveyor.com/project/malcolmbarrett/koanr)

koanr
=====

`koanr` is (mostly) a data package containing the text for several of the more important Zen koan texts: The Gateless Gate (`gateless_gate`), The Blue Cliff Record (`blue_cliff_record`), The Record of the Transmission of the Light(`record_of_light`), and The Book of Equanimity(`book_of_equanimity`). `koanr` also includes functions for sampling koans.

Quickly access a koan:
----------------------

``` r
library(koanr)
koan(collection = gateless_gate, case = 1)
```

Collection: The Gateless Gate

Case \#1: Joshu's Dog

Main Case: A monk asked Joshu, "Has the dog the Buddha nature?"

Joshu replied, "Mu (nothing)!"

Commentary: Mumon's Comment:

For the pursuit of Zen, you must pass through the barriers (gates) set up by the Zen masters. To attain his mysterious awareness one must completely uproot all the normal workings of one's mind. If you do not pass through the barriers, nor uproot the normal workings of your mind, whatever you do and whatever you think is a tangle of ghost. Now what are the barriers? This one word "Mu" is the sole barrier. This is why it is called the Gateless Gate of Zen. The one who passes through this barrier shall meet with Joshu face to face and also see with the same eyes, hear with the same ears and walk together in the long train of the patriarchs. Wouldn't that be pleasant?

Would you like to pass through this barrier? Then concentrate your whole body, with its 360 bones and joints, and 84,000 hair follicles, into this question of what "Mu" is; day and night, without ceasing, hold it before you. It is neither nothingness, nor its relative "not" of "is" and "is not." It must be like gulping a hot iron ball that you can neither swallow nor spit out.

Then, all the useless knowledge you have diligently learned till now is thrown away. As a fruit ripening in season, your internality and externality spontaneously become one. As with a mute man who had had a dream, you know it for sure and yet cannot say it. Indeed your ego-shell suddenly is crushed, you can shake heaven and earth. Just as with getting ahold of a great sword of a general, when you meet Buddha you will kill Buddha. A master of Zen? You will kill him, too. As you stand on the brink of life and death, you are absolutely free. You can enter any world as if it were your own playground. How do you concentrate on this Mu? Pour every ounce of your entire energy into it and do not give up, then a torch of truth will illuminate the entire universe.

Capping Verse: Has a dog the Buddha nature? This is a matter of life and death. If you wonder whether a dog has it or not, You certainly lose your body and life!

Pick a random koan
------------------

``` r
koan()
```

Collection: The Gateless Gate

Case \#22: Kashapa's Flag Pole

Main Case: Ananda asked Maha Kashapa, "Buddha gave you the golden woven robe of successorship. What else did he give you?"

Kashapa said, "Ananda!"

"Yes!" answered Ananda.

"Knock down the flagpole at the gate!" said Kashapa.

Commentary: Mumon's Comments:

If you can give a "turning word" (a momentous word for awakening), you will see the meeting at Mount Grdhrahuta? still in session. If not, no matter how much you make struggles to study from the age of Vipasyin, you cannot attain enlightenment.

Capping Verse: How is Ananda's question, compared to Kashapa's answer of heart. How many people have since then opened their eyes. Elder brother calls and younger brother answers--the family disgrace. This spring does not belong to Yin and Yang.

Quickly bind all four collections
---------------------------------

``` r
collect_koans()
#> # A tibble: 819 x 4
#>    collection         case type       text                                
#>    <chr>             <int> <chr>      <chr>                               
#>  1 Blue Cliff Record     1 title      "Bodhidharma's \"Clear and Void\""  
#>  2 Blue Cliff Record     1 main_case  "Emperor Bu of Ryô asked Great Mast…
#>  3 Blue Cliff Record     2 title      "Jôshû's \"Supreme Way\""           
#>  4 Blue Cliff Record     2 main_case  "Jôshû, instructing the assembly, s…
#>  5 Blue Cliff Record     3 title      Master Ba Is Ill                    
#>  6 Blue Cliff Record     3 main_case  "Great Master Ba was seriously ill.…
#>  7 Blue Cliff Record     4 title      Tokusan with His Bundle             
#>  8 Blue Cliff Record     4 main_case  "Tokusan arrived at Isan. Carrying …
#>  9 Blue Cliff Record     4 commentary "(Setchô commented: \"Seen through!…
#> 10 Blue Cliff Record     5 title      "Seppô's \"Grain of Rice\""         
#> # ... with 809 more rows
```
