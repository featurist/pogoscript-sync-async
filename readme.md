# Sync/Async Semantics

The basic idea is this. You have an API that takes a block:

    do (n) times (block) =
        for (i = 0, i < n, ++i)
            block ()

So you can call it like this:

    do 2 times
        console.log 'hi'

But what happens when you want have an asynchronous task in the block? Say you want to write to a file or something?

    do 2 times!
        fs.write file! 'some.txt' 'hi'

Well this isn't ordinarily going to work. The function wasn't written to be asynchronous, and even if it was, how does it know to call the block asynchronously? You can write `do times` to do the right thing in both cases, but it's hard. So hard in fact that I'm not going to bother doing it here.

Instead, I propose some semantics like this:

Let's define a function `f` that makes two other function calls, one of them asynchronous:

    f () = g!() + h()

When `f` is called asynchronously, `g` is also called asynchronously.

When `f` is called synchronously, `g` is also called synchronously.

In effect, non-blocking or blocking semantics are chosen by the caller, not the function definition.
