module Main exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Dict exposing (Dict)
import ImageCollection as ImColl exposing (Key, ImageCollection)
import Image exposing (Image)


main =
    H.beginnerProgram
        { model = init
        , view = view
        , update = update
        }



-- MODEL #############################################################


type alias Model =
    { collection : ImageCollection
    , imageUrl : String
    }


init : Model
init =
    Model Dict.empty ""



-- UPDATE ############################################################


type Msg
    = ChangeUrl String
    | AddImage


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeUrl url ->
            { model | imageUrl = url }

        AddImage ->
            let
                url =
                    model.imageUrl
            in
                { model
                    | collection =
                        Dict.insert url (Image url 320 320) model.collection
                }



-- VIEW ##############################################################


view : Model -> H.Html Msg
view model =
    H.div []
        [ urlForm
          -- , H.br [] []
        , ImColl.defaultView model.collection
        ]


urlForm : Html Msg
urlForm =
    H.div []
        [ H.input
            [ HA.type_ "text"
            , HA.placeholder "Image url"
            , HE.onInput ChangeUrl
            ]
            []
        , H.input
            [ HA.type_ "submit"
            , HA.value "Add Image"
            , HE.onClick AddImage
            ]
            []
        ]
