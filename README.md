
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/malcolmbarrett/koanr.svg?branch=master)](https://travis-ci.org/malcolmbarrett/koanr) [![AppVeyor Build Status](https://ci.appveyor.com/malcolmbarrett/koanr)](https://ci.appveyor.com/api/projects/status/github//malcolmbarrett/koanr/?branch=master&svg=true)

koanr
=====

`koanr` is (mostly) a data package containing the text for several of the more important Zen koan texts: The Gateless Gate (`gateless_gate`), The Blue Cliff Record (`blue_cliff_record`), The Record of the Transmission of the Light(`record_of_light`), and The Book of Equanimity(`book_of_equanimity`). `koanr` also includes functions for sampling (real) koans and generating (fake) koans.

Example
-------

Sample from an existing koan:

``` r
library(koanr)
koan(collection = gateless_gate, case = 1)
```

Collection: The Gateless Gate

Case \#1: Joshu's Dog

Main Case: A monk asked Joshu, "Has the dog the Buddha nature?" Joshu replied, "Mu (nothing)!"

Commentary: Mumon's Comment: For the pursuit of Zen, you must pass through the barriers (gates) set up by the Zen masters. To attain his mysterious awareness one must completely uproot all the normal workings of one's mind. If you do not pass through the barriers, nor uproot the normal workings of your mind, whatever you do and whatever you think is a tangle of ghost. Now what are the barriers? This one word "Mu" is the sole barrier. This is why it is called the Gateless Gate of Zen. The one who passes through this barrier shall meet with Joshu face to face and also see with the same eyes, hear with the same ears and walk together in the long train of the patriarchs. Wouldn't that be pleasant? Would you like to pass through this barrier? Then concentrate your whole body, with its 360 bones and joints, and 84,000 hair follicles, into this question of what "Mu" is; day and night, without ceasing, hold it before you. It is neither nothingness, nor its relative "not" of "is" and "is not." It must be like gulping a hot iron ball that you can neither swallow nor spit out. Then, all the useless knowledge you have diligently learned till now is thrown away. As a fruit ripening in season, your internality and externality spontaneously become one. As with a mute man who had had a dream, you know it for sure and yet cannot say it. Indeed your ego-shell suddenly is crushed, you can shake heaven and earth. Just as with getting ahold of a great sword of a general, when you meet Buddha you will kill Buddha. A master of Zen? You will kill him, too. As you stand on the brink of life and death, you are absolutely free. You can enter any world as if it were your own playground. How do you concentrate on this Mu? Pour every ounce of your entire energy into it and do not give up, then a torch of truth will illuminate the entire universe.

Capping Verse: Has a dog the Buddha nature? This is a matter of life and death. If you wonder whether a dog has it or not, You certainly lose your body and life!

Or generate a fake one:

``` r
fake_koan()
```

Case \#44: Suibi and the Memorial Service

Main Case: Nagyaarajuna said to him, Bashashita received, unseen, the SEAL. In that instant the boy what his master had preached about, the boy turned his head. The emperor pulled the straps of his Buddhist garment. In my heart there is a room with six windows. ORIGINAL MIND is naturally pure and unstained, IT is not stained or polluted.”

Commentary: He was imputed by the other, have emerged in the habit of first trying to devise an idea of self; you will reach IT, and you need not be the JEWEL when we invariably use the word or taken a wayward step.”

Capping verse: Now tell me, how am I ever to communicate this principle to you? Today I have realized! Indeed a possessed word, He is deceiving the entire crowd. Do not think that some bit of IT as though blind.
