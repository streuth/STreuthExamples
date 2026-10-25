// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let machine := ChordBuilderFSM new: "Guided chord builder"
machine configure

let view := ChordBuilderHtmlView for: machine
view follow: machine

"State: \[machine currentState name]" println
"Rendered an interactive chord builder in the HTML pane." println
