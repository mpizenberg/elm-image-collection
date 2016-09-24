-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/

module ImageCollection exposing
    ( Model, init
    , Msg(..), update
    , view, defaultView
    )

{-| The ImageCollection module helps dealing with collections of images.

# Model
@docs Model, init

# Update
@docs Msg, update

# View
@docs view, defaultView

-}


import VirtualDom exposing (Node)
import Html as H
import Html.Attributes as HA
import Dict


import Image exposing (Class, TagType)




-- For readability purpose in type definitions.
type alias Key = String
type alias ImageViewer msg =
    Maybe Class -> Maybe (Int, Int) -> Key -> Image.Model -> Node msg




-- MODEL #############################################################




type alias Model_ =
    { images : Dict.Dict Key Image.Model
    , defaultSize : Maybe (Int, Int)
    }


{-| The model for a collection of images.
-}
type Model =
    ImageCollection Model_


{-| Initialize the model of a collection of images
with the default size of image views.

    (model, msg) = init (Just (320, 240))
-}
init : Maybe (Int, Int) -> (Model, Cmd Msg)
init defaultSize =
    ( ImageCollection <| Model_ Dict.empty defaultSize
    , Cmd.none
    )



-- UPDATE ############################################################




{-| The type of messages to interact with image collections.
-}
type Msg
    = Clear
    | Remove Key
    | Add Key Image.Model
    | Update Key Image.Model
    | SetDefaultSize (Maybe (Int, Int))


{-| Update the image collection.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg (ImageCollection model) =
    case msg of
        Clear ->
            init Nothing
        Remove key ->
            ( ImageCollection {model | images = Dict.remove key model.images}
            , Cmd.none
            )
        Add key image ->
            ( ImageCollection {model | images = Dict.insert key image model.images}
            , Cmd.none
            )
        Update key image ->
            update (Add key image) (ImageCollection model)
        SetDefaultSize size ->
            ( ImageCollection {model | defaultSize = size}
            , Cmd.none
            )




-- VIEW ##############################################################




{-| The view of an image collection.
One can define a class for the <div> containing the collection,
a special function detailing the view of each image of the collection,
a class for each image tag,
and a default size for the images.

    viewer class size key imageModel =
        Image.view imageModel Image.ImgTag class size
    collectionNode = view (Just "my-collection") viewer Nothing (Just (320, 240)) model
-}
view : Maybe Class -> ImageViewer msg -> Maybe Class -> Maybe (Int, Int) -> Model -> Node msg
view collectionClass viewer imageClass size (ImageCollection model) =
    H.div
        [ HA.class <| Maybe.withDefault "image-collection" collectionClass ]
        ( Dict.values <| Dict.map
            (viewer imageClass size)
            model.images
        )


{-| A simple default viewer putting <img> tags one after the other.
-}
defaultView : Model -> Node msg
defaultView (ImageCollection model) =
    view
        Nothing
        defaultImageViewer
        Nothing
        model.defaultSize
        (ImageCollection model)


defaultImageViewer : ImageViewer msg
defaultImageViewer class size key imageModel =
    Image.view imageModel Image.ImgTag class size
