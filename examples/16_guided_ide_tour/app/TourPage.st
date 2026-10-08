// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let TourPage := Object derive: "TourPage"

TourPage define: [
    method htmlFor: of: {^String, TourGreeting} [ greeting |
        "<main style=\"font-family: system-ui; margin: 3rem\">\n<h1>\[greeting text]</h1>\n<p>The workset loaded a library, an application object, and this live preview.</p>\n</main>"
    ]
]
