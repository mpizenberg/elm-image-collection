import Html as H
import Html.App as App
import Html.Attributes as HA
import Html.Events as HE

import ImageGallery
import Image
import Helpers as HP




main =
    App.program
        { init = init
        , update = update
        , subscriptions = (\_ -> Sub.none)
        , view = view
        }




-- MODEL #############################################################




type alias Model =
    { gallery : ImageGallery.Model
    , url : String
    }


init : (Model, Cmd Msg)
init =
    let
        (gallery, galleryCmd, _) = ImageGallery.init
    in
        ( Model gallery "", Cmd.map Gall galleryCmd )




-- UPDATE ############################################################




type Msg
    = Url String
    | Validate
    | AddImage String
    | Gall ImageGallery.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Url url ->
            ({model | url = url}, Cmd.none)
        Validate ->
            update (AddImage model.url) model
        AddImage url ->
            let
                (im, imMsg) = Image.init url 0 0
            in
                update (Gall <| ImageGallery.Add url Nothing im) model
        Gall galleryMsg ->
            let
                (gallery, galleryCmd, _) =
                    ImageGallery.update galleryMsg model.gallery
            in
                ({model | gallery = gallery}, Cmd.map Gall galleryCmd)




-- VIEW ##############################################################




view : Model -> H.Html Msg
view model =
    H.div []
        [ H.input
            [ HA.type' "text"
            , HA.placeholder "Image url"
            , HE.onInput Url ] []
        , H.input [ HA.type' "submit", HA.value "Add Image", HE.onClick Validate ] []
        ----------------------
        , H.br [] []
        , App.map Gall <| ImageGallery.defaultView
            (Just (640, 480))
            (Just (320, 240))
            model.gallery
        ]

