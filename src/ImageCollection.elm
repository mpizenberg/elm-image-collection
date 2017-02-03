-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/


module ImageCollection exposing (..)

{-| The ImageCollection module helps dealing with collections of images.

@docs Key, ImageCollection
@docs ItemViewer, defaultItemViewer
@docs view, defaultView
-}

import Html as H exposing (Html)
import Dict exposing (Dict)
import Image exposing (Image)


-- MODEL #############################################################


{-| The key type to access images in the collection.
-}
type alias Key =
    String


{-| A collection of images.
-}
type alias ImageCollection =
    Dict Key Image



-- VIEW ##############################################################


{-| A type alias describing a view function for an item (key,images) of the collection.
-}
type alias ItemViewer msg =
    List (H.Attribute msg) -> Maybe ( Int, Int ) -> Key -> Image -> Html msg


{-| The default itemViewer, just a simple Image viewer, not taking care of the key.
-}
defaultItemViewer : ItemViewer msg
defaultItemViewer attributes maybeSize key image =
    Image.viewImg attributes maybeSize image


{-| View a collection of images with a specific item viewer.

For example, with the following code:

    collection =
        Dict.fromList
            [ ("1", Image "1.jpg" 320 240)
            , ("2", Image "2.jpg" 640 480)
            ]

    html =
        view
            defaultItemViewer
            [ HA.class "image" ]
            Nothing
            [ HA.class "collection" ]
            collection

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
view :
    ItemViewer msg
    -> List (H.Attribute msg)
    -> Maybe ( Int, Int )
    -> List (H.Attribute msg)
    -> ImageCollection
    -> Html msg
view itemViewer imgAttributes maybeSize collAttributes collection =
    collection
        |> Dict.map (itemViewer imgAttributes maybeSize)
        |> Dict.values
        |> H.div collAttributes


{-| The default view, just all the images in a div.
-}
defaultView : ImageCollection -> Html msg
defaultView =
    view defaultItemViewer [] Nothing []
