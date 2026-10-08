// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let tourGreeting := TourGreeting for: "PolyGlot"
let tourPage := TourPage new
let tourMessage := tourGreeting text

Object
    assert: (tourMessage == "Hello, PolyGlot!")
    message: "the included library should provide the greeting"

tourMessage println
HTMLViewer show: (tourPage htmlFor: tourGreeting)
"Rendered the guided IDE tour in the HTML pane." println
