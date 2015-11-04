I am currently stuck on Dynamic Generating. Expect some delays

# Introduction

## Timeless and Netwire

`Timeless` is a rewrite on the [`netwire-5.0.1`](http://hub.darcs.net/ertes/netwire) library, intending to create a simpler interface for easy FRP(Functional Reactive Programming) construction. The core module, `FRP.Timeless.Signal`, `FRP.Timeless.Session`, and `FRP.Timeless.Run` are mostly taken from Netwire, except that the `Wire s e m a b` is simplified to `Signal s m a b`, and several instances (such as `Profuctor`) are stripped away (I have to admit that I don't understand them, so I don't add them until they are REALLY needed). Everything else will be rewritten from scratch, based on my other project, namely `timeless-RPG`, which tries to create a complete RPG game engine framework (For real, this time! Hopefully it will not be abandoned like... well, the python one, the SFML/C++ one, the Ruby one, the second SFML/C++ one, the python one again... you name it) based on SDL2.

The motivation to rewrite `netwire` as `timeless` is because `netwire` lacks proper documentation, and its `5.*` version is quite incomplete comparing to `4.*`. At the same time, it doesn't seem to be actively developed anymore, so I decide to write most if not all necessary things from scratch to gain a better understanding on, well, everything.

Please do not expect this library to finish before t → ∞. I can only hope that I will not abandon this project like the other ones that I did. I would really like to keep the repo private until I make it rock solid (so that I am less likely to lose motivation due to false satisfaction), but I fear that my hard drive may crash some time in the future (which it just did for my other computer), so I push the repo up now.

## What is Timeless? (do a `s/is/will be/g` in your head, for now)

`Timeless` is an Arrow based Functional Reactive Programming framework which supports continuous-time semantics. Discrete time events are simulated by "impulse functions". It supports dynamic switching and inhibition. Signals include pure, stateful, and Kleisli functions, which should give a wide range of applications.


# Tutorial

Read the `FRP.Timeless.Tutorial` module, which is written in Literate Haskell. It is a very detailed implementation example of a simple interactive program.

[1]:http://stackoverflow.com/questions/30905930/what-can-be-a-minimal-example-of-game-written-in-haskell
[2]:http://stackoverflow.com/questions/30992299/console-interactivity-in-netwire
[3]:http://stackoverflow.com/questions/32745934/kleisli-arrow-in-netwire-5
