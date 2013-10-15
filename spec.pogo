require 'chai'.should ()

(c) or default continuation =
    c @or @(error, result)
        if (error)
            throw (error)
        else
            result
    
make (fn) asynchronous when (has continuation) =
    if (has continuation)
        @(args, ..., cont)
            fn (args, ..., cont)
    else
        @(args, ..., cont)
            try
                cont (nil, fn (args, ...))
            catch (e)
                cont (e)

describe 'sync async'
    describe 'calling functions that call other functions'
        f (cont) =
            has continuation = cont
            cont := (cont) or default continuation

            (make (g) asynchronous when (has continuation)) (cont)

        g (continuation) =
            if (continuation)
                continuation (nil, "g called with continuation")
            else
                "g called without continuation"

        context 'when called asynchronously'
            it 'calls the other function asynchronously'
                f!.should.equal 'g called with continuation'

        context 'when called synchronously'
            it 'calls the other function synchronously'
                f().should.equal 'g called without continuation'

    describe 'calling functions that take blocks'
        f (block, cont) =
            has continuation = cont
            cont := (cont) or default continuation

            (make (block) asynchronous when (has continuation)) (cont)

        block called with continuation (c) =
            "block called with continuation: #(@not @not c)"

        context 'when the function is called asynchronously'
            it 'calls the block asynchronously'
                f!
                    continuation (nil, block called with continuation (continuation))
                .should.equal 'block called with continuation: true'

        context 'when the function is called synchronously'
            it 'calls the block synchronously'
                f @(cont)
                    block called with continuation (cont)
                .should.equal 'block called with continuation: false'
