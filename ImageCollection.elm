module ImageCollection exposing
    (..)




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


type Model =
    ImageCollection Model_




-- UPDATE ############################################################




type Msg
    = Clear
    | Add Key Image.Model
    | Remove Key
    | Update Key Image.Model




-- VIEW ##############################################################




view : Maybe Class -> ImageViewer msg -> Maybe Class -> Maybe (Int, Int) -> Model -> Node msg
view collectionClass viewer imageClass size (ImageCollection model) =
    H.div
        [ HA.class <| Maybe.withDefault "image-collection" collectionClass ]
        ( Dict.values <| Dict.map
            (viewer imageClass size)
            model.images
        )


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
