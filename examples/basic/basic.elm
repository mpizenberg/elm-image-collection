import Html as H
import Html.App as App
import Html.Attributes as HA
import Html.Events as HE
import Task

import ImageCollection
import Image




main =
    App.program
        { init = init
        , update = update
        , subscriptions = (\_ -> Sub.none)
        , view = view
        }


{-| Transform a message to a Cmd message -}
msgToCmd : msg -> Cmd msg
msgToCmd message =
    Task.perform identity identity (Task.succeed message)




-- MODEL #############################################################




type alias Model =
    { collection : ImageCollection.Model
    , url : String
    }


init : (Model, Cmd Msg)
init =
    let
        (imColl, imCollMsg) = ImageCollection.init <| Just (320, 240)
    in
        ( Model imColl "", Cmd.map ImColl imCollMsg )




-- UPDATE ############################################################




type Msg
    = Url String
    | Validate
    | AddImage String
    | ImColl ImageCollection.Msg


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
                (model, Cmd.map ImColl <| msgToCmd <| ImageCollection.Add url im)
        ImColl imCollMsg ->
            let
                (imColl, imCollMsg') =
                    ImageCollection.update imCollMsg model.collection
            in
                ({model | collection = imColl}, Cmd.map ImColl imCollMsg')




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
        , App.map ImColl <| ImageCollection.defaultView model.collection
        ]

