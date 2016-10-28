module Helpers exposing
    (..)




{-| Update again a tuple (model, cmd, data) with a new message -}
updateAgain
    : (msg -> model -> (model, Cmd msg, data))
    -> msg
    -> (model, Cmd msg, data)
    -> (model, Cmd msg, data)
updateAgain updateFunction msg (model, cmd, data) =
    let
        (model', cmd', data') = updateFunction msg model
    in
        (model', Cmd.batch [cmd, cmd'], data')


{-| Update with multiple messages in order -}
updateFull
    : (msg -> model -> (model, Cmd msg, data))
    -> (model, data)
    -> List msg
    -> (model, Cmd msg, data)
updateFull updateFunction (model, data) =
    List.foldl
        (updateAgain updateFunction)
        (model, Cmd.none, data)
