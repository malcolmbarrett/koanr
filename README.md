
<!-- README.md is generated from README.Rmd. Please edit that file -->
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

Main Case: A monk asked Joshu, 'Has the dog the Buddha nature?' Joshu replied, 'Mu (nothing)!'

Commentary: Mumon's Comment: For the pursuit of Zen, you must pass through the barriers (gates) set up by the Zen masters. To attain his mysterious awareness one must completely uproot all the normal workings of one's mind. If you do not pass through the barriers, nor uproot the normal workings of your mind, whatever you do and whatever you think is a tangle of ghost. Now what are the barriers? This one word 'Mu' is the sole barrier. This is why it is called the Gateless Gate of Zen. The one who passes through this barrier shall meet with Joshu face to face and also see with the same eyes, hear with the same ears and walk together in the long train of the patriarchs. Wouldn't that be pleasant? Would you like to pass through this barrier? Then concentrate your whole body, with its 360 bones and joints, and 84,000 hair follicles, into this question of what 'Mu' is; day and night, without ceasing, hold it before you. It is neither nothingness, nor its relative 'not' of 'is' and 'is not.' It must be like gulping a hot iron ball that you can neither swallow nor spit out. Then, all the useless knowledge you have diligently learned till now is thrown away. As a fruit ripening in season, your internality and externality spontaneously become one. As with a mute man who had had a dream, you know it for sure and yet cannot say it. Indeed your ego-shell suddenly is crushed, you can shake heaven and earth. Just as with getting ahold of a great sword of a general, when you meet Buddha you will kill Buddha. A master of Zen? You will kill him, too. As you stand on the brink of life and death, you are absolutely free. You can enter any world as if it were your own playground. How do you concentrate on this Mu? Pour every ounce of your entire energy into it and do not give up, then a torch of truth will illuminate the entire universe.

Capping Verse: Has a dog the Buddha nature? This is a matter of life and death. If you wonder whether a dog has it or not, You certainly lose your body and life!

Or generate a fake one:

``` r
fake_koan()
```

Case \#44: The Thirty-Seventh Ancestor, Great Master Tüzan Ryükai.

Main Case: In a dream and was led to the rostrum. If you do not do so; there are all kinds of illusory thoughts, you do not shirk from talking to you did He pass on the other hand, the vessel is yours, it is complete darkness. Tozan said, “When you intentionally let thoughts arise, forthwith you will be the one who would demonstrate himself as the Buddhas. Ryûge brought one and gave it to Rinzai. Kyûhô would not acknowledge it, you are involved in exerting, there will be no merit or virtue; if you speak beautiful phrases.

Commentary: Because of this peak is a prediction that after six aeons I would say that you are like threads of gossamer or drifting dust; they gallop off hither and thither.

Capping verse: There is no need for rouge or powder, for any ugliness would be the principle in this story? His eye is a strange thing indeed! Here again are my humble words. By analogy IT is in detail, train thoroughly and probe deeply, then you will all be thoroughly undutiful beings.
