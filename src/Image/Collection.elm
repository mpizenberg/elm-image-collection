-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/


module Image.Collection
    exposing
        ( Key
        , Collection
        , resize
        , ItemViewer
        , defaultItemViewer
        , view
        )

{-| This module helps you deal with collections of images.

@docs Key, Collection
@docs resize
@docs ItemViewer, defaultItemViewer, view
-}

import Html as H exposing (Html)
import Html.Attributes as HA
import Dict exposing (Dict)
import Image exposing (Image)


-- MODEL #############################################################


{-| The key type to access images in the collection.
-}
type alias Key =
    String


{-| A collection of images.
-}
type alias Collection =
    Dict Key Image



-- UPDATE ############################################################


{-| Resize all images of a collection.
-}
resize : ( Int, Int ) -> Collection -> Collection
resize size collection =
    collection
        |> Dict.map (\key image -> Image.resize size image)



-- VIEW ##############################################################


{-| A type alias describing a view function for an item (key,image) of the collection.
-}
type alias ItemViewer msg =
    Key -> Image -> Html msg


{-| The default itemViewer, just a simple Image viewer, not taking care of the key.
-}
defaultItemViewer : ItemViewer msg
defaultItemViewer key =
    Image.viewImg []


{-| View a collection of images with a specific item viewer.

For example, with the following code:

    collection =
        Dict.fromList
            [ ("1", Image "1.jpg" 320 240)
            , ("2", Image "2.jpg" 640 480)
            ]

    itemViewer key =
        Image.viewImg [ HA.class "image" ]

    html =
        collection
            |> view [ HA.class "collection" ] itemViewer

The html will look like:

    <div class="collection">
        <img class="image"
            src="1.jpg"
            style="width: auto; height: auto; max-width: 320px; max-height: 240px;">
        <img class="image"
            src="2.jpg"
            style="width: auto; height: auto; max-width: 640px; max-height: 480px;">
    </div>
-}
view : List (H.Attribute msg) -> ItemViewer msg -> Collection -> Html msg
view attributes itemViewer collection =
    collection
        |> Dict.map itemViewer
        |> Dict.values
        |> H.div attributes
