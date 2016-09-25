-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/

module ImageGallery exposing
    ( ..
    )

{-| The ImageGallery module helps displaying a gallery of images.
-}


import Html as H
import Html.App as App
import Html.Attributes as HA
import Html.Events as HE


import ImageCollection exposing (Key, ImageViewer)
import Image exposing (TagType(..))
import Helpers as HP




-- MODEL #############################################################




type alias Model_ =
    { collection : ImageCollection.Model
    , thumbCollection : ImageCollection.Model
    , selected : Maybe Key
    }


{-| The model of an image gallery -}
type Model =
    ImageGallery Model_


{-| Initialize an empty model of an image gallery -}
init : (Model, Cmd Msg)
init =
    let
        (coll, collMsg) = ImageCollection.init Nothing
        (thumbs, thumbsMsg) = ImageCollection.init Nothing
    in
        ( ImageGallery <| Model_ coll thumbs Nothing ) !
        [ Cmd.map Coll collMsg
        , Cmd.map Thumb thumbsMsg
        ]




-- UPDATE ############################################################




type Msg
    = Clear
    -- Add key thumb image
    | Add Key (Maybe Image.Model) Image.Model
    | Update Key (Maybe Image.Model) Image.Model
    | Remove Key
    | Select (Maybe Key)
    | Coll ImageCollection.Msg
    | Thumb ImageCollection.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg (ImageGallery model) =
    case msg of
        Clear ->
            init
        Add key maybeThumb image ->
            let
                thumb = Maybe.withDefault image maybeThumb
            in
                ImageGallery model !
                [ Cmd.map Coll <| HP.msgToCmd <| ImageCollection.Add key image
                , Cmd.map Thumb <| HP.msgToCmd <| ImageCollection.Add key thumb
                ]
        Update key maybeThumb image ->
            update (Add key maybeThumb image) (ImageGallery model)
        Remove key ->
            ImageGallery model !
            [ Cmd.map Coll <| HP.msgToCmd <| ImageCollection.Remove key
            , Cmd.map Thumb <| HP.msgToCmd <| ImageCollection.Remove key
            ]
        Select maybeKey ->
            ( ImageGallery {model | selected = maybeKey}
            , Cmd.none
            )
        Coll collMsg ->
            let
                (coll, collMsg') =
                    ImageCollection.update
                        collMsg
                        model.collection
            in
                ( ImageGallery {model | collection = coll}
                , Cmd.map Coll collMsg'
                )
        Thumb thumbsMsg ->
            let
                (thumbs, thumbsMsg') =
                    ImageCollection.update
                        thumbsMsg
                        model.thumbCollection
            in
                ( ImageGallery {model | thumbCollection = thumbs}
                , Cmd.map Thumb thumbsMsg'
                )




-- VIEW ##############################################################




defaultView : (Maybe (Int, Int)) -> (Maybe (Int, Int)) -> Model -> H.Html Msg
defaultView fullSize thumbSize model =
    H.div []
        [ defaultViewSelected fullSize model
        , H.br [] []
        , defaultViewThumbs thumbSize model
        ]


imageViewer : ImageViewer Msg
imageViewer class size key imgModel =
    H.a
        [ HA.href "javascript:;", HE.onClick <| Select <| Just key]
        [ Image.view Image.ImgTag class size imgModel ]


defaultViewThumbs : (Maybe (Int, Int)) -> Model -> H.Html Msg
defaultViewThumbs size (ImageGallery model) =
    ImageCollection.view
        (Just "thumb-coll")
        imageViewer
        (Just "thumb")
        size
        model.thumbCollection


defaultViewSelected : (Maybe (Int, Int)) -> Model -> H.Html Msg
defaultViewSelected size (ImageGallery model) =
    case model.selected of
        Nothing ->
            H.text "No image Selected"
        Just key ->
            ImageCollection.viewOne
                ImgTag
                (Just "img-selected")
                size
                key
                model.collection
