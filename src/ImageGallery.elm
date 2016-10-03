-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/

module ImageGallery exposing
    ( Model, init
    , Msg(..), update
    , defaultView, imageViewer, defaultViewThumbs, defaultViewSelected
    , selectedImage
    )

{-| The ImageGallery module helps displaying a gallery of images.

# Model
@docs Model, init

# Update
@docs Msg, update

# View
@docs defaultView, imageViewer, defaultViewThumbs, defaultViewSelected

# Outputs
@docs selectedImage

-}


import Html as H
import Html.App as App
import Html.Attributes as HA
import Html.Events as HE


import ImageCollection as ImColl exposing (Key, ImageViewer)
import Image exposing (TagType(..))
import Helpers as HP




-- MODEL #############################################################




type alias Model_ =
    { collection : ImColl.Model
    , thumbCollection : ImColl.Model
    , selected : Maybe Key
    }


{-| The model of an image gallery -}
type Model =
    ImageGallery Model_


{-| Initialize an empty model of an image gallery -}
init : (Model, Cmd Msg, Maybe Key)
init =
    let
        (coll, collMsg) = ImColl.init Nothing
        (thumbs, thumbsMsg) = ImColl.init Nothing
    in
        ( ImageGallery <| Model_ coll thumbs Nothing
        , Cmd.batch
            [ Cmd.map Coll collMsg
            , Cmd.map Thumb thumbsMsg
            ]
        , Nothing
        )




-- UPDATE ############################################################




{-| The type of messages to interact with an image gallery -}
type Msg
    = Clear
    -- Add key thumb image
    | Add Key (Maybe Image.Model) Image.Model
    | Update Key (Maybe Image.Model) Image.Model
    | Remove Key
    | Select (Maybe Key)
    | Coll ImColl.Msg
    | Thumb ImColl.Msg


{-| Update the gallery depending on the message -}
update : Msg -> Model -> (Model, Cmd Msg, Maybe Key)
update msg (ImageGallery model) =
    case msg of
        Clear ->
            init
        Add key maybeThumb image ->
            let
                thumb = Maybe.withDefault image maybeThumb
            in
                ( ImageGallery model
                , Cmd.batch
                    [ Cmd.map Coll <| HP.msgToCmd <| ImColl.Add key image
                    , Cmd.map Thumb <| HP.msgToCmd <| ImColl.Add key thumb
                    , HP.msgToCmd <| Select <| Just key
                    ]
                , model.selected
                )
        Update key maybeThumb image ->
            update (Add key maybeThumb image) (ImageGallery model)
        Remove key ->
            ( ImageGallery model
            , Cmd.batch
                [ Cmd.map Coll <| HP.msgToCmd <| ImColl.Remove key
                , Cmd.map Thumb <| HP.msgToCmd <| ImColl.Remove key
                ]
            , model.selected
            )
        Select maybeKey ->
            ( ImageGallery {model | selected = maybeKey}
            , Cmd.none
            , maybeKey
            )
        Coll collMsg ->
            let
                (coll, collCmd) =
                    ImColl.update
                        collMsg
                        model.collection
            in
                ( ImageGallery {model | collection = coll}
                , Cmd.map Coll collCmd
                , model.selected
                )
        Thumb thumbsMsg ->
            let
                (thumbs, thumbsCmd) =
                    ImColl.update
                        thumbsMsg
                        model.thumbCollection
            in
                ( ImageGallery {model | thumbCollection = thumbs}
                , Cmd.map Thumb thumbsCmd
                , model.selected
                )




-- VIEW ##############################################################




{-| Default view for an image gallery -}
defaultView : (Maybe (Int, Int)) -> (Maybe (Int, Int)) -> Model -> H.Html Msg
defaultView fullSize thumbSize model =
    H.div []
        [ defaultViewSelected fullSize model
        , H.br [] []
        , defaultViewThumbs thumbSize model
        ]


{-| Just a viewer for 1 image -}
imageViewer : ImageViewer Msg
imageViewer class size key imgModel =
    H.a
        [ HA.href "javascript:;", HE.onClick <| Select <| Just key]
        [ Image.view Image.ImgTag class size imgModel ]


{-| Default view of the thumbnails of an image gallery -}
defaultViewThumbs : (Maybe (Int, Int)) -> Model -> H.Html Msg
defaultViewThumbs size (ImageGallery model) =
    ImColl.view
        (Just "thumb-coll")
        imageViewer
        (Just "thumb")
        size
        model.thumbCollection


{-| Default view of the currently selected image of an image gallery -}
defaultViewSelected : (Maybe (Int, Int)) -> Model -> H.Html Msg
defaultViewSelected size (ImageGallery model) =
    case model.selected of
        Nothing ->
            H.text "No image Selected"
        Just key ->
            ImColl.viewOne
                ImgTag
                (Just "img-selected")
                size
                key
                model.collection




-- OUTPUTS ###########################################################




{-| Return currently selected image -}
selectedImage : Model -> Maybe Image.Model
selectedImage (ImageGallery model) =
    case model.selected of
        Nothing -> Nothing
        Just key ->
            ImColl.getImage key model.collection
