# elm-image-collection [![][badge-doc]][doc]  [![][badge-license]][license]

[badge-doc]: https://img.shields.io/badge/documentation-latest-yellow.svg?style=flat-square
[doc]: http://package.elm-lang.org/packages/mpizenberg/elm-image-collection/latest
[badge-license]: https://img.shields.io/badge/license-MPL%202.0-blue.svg?style=flat-square
[license]: https://www.mozilla.org/en-US/MPL/2.0/

This package aims at easing the manipulation and display of a collection of images.

## Installation

```bash
elm-package install mpizenberg/elm-image-collection
```

## Basic Usage

To initialize an image collection, you may provide a default viewing size (320x240 here)

```elm
(imColl, imCollMsg) = ImageCollection.init <| Just (320, 240)
```

In the view, you may use the very basic default viewer
(see `defaultView` example below) or the more advance viewer (`view`).

```elm
App.map ImColl <| ImageCollection.defaultView model.collection
```

To see a running basic example, you can just try the one in
`examples/basic`.

## Documentation

You can find the package documentation on the [elm package website][doc]

## License

This Source Code Form is subject to the terms of the Mozilla Public License,v. 2.0.
If a copy of the MPL was not distributed with this file,
You can obtain one at https://mozilla.org/MPL/2.0/.

## Contact

Feel free to contact me at matthieu.pizenberg@gmail.com for any question.

## Credits

Great thanks to Matthias [KtorZ](https://github.com/KtorZ) who introduced me to elm.
