// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let machine := ChordBuilderFSM new: "Guided chord builder"
machine configure

let view := ChordBuilderHtmlView for: machine
view follow: machine

Object assert: (machine currentState name == "Empty")
    message: "a fresh chord machine should begin empty"
Object assert: (view inputWatch isActive)
    message: "the HTML view should react to completed inputs"
Object assert: (FSMValueInputProtocol matches: machine)
    message: "the machine should satisfy the custom payload-input contract"

// Custom input views translate form fields into typed payload inputs.
let commandAction := HTMLAction
    named: "fsm-input?value=Modifier"
    fields: {"inputValue" -> "Cmd"} asMap
view handleAction: commandAction for: machine

Object assert: (machine currentState name == "Collecting")
    message: "the first modifier should begin chord collection"
Object assert: (machine chordText == "Cmd")
    message: "the modifier payload should reach the reusable builder"

let shiftAction := HTMLAction
    named: "fsm-input?value=Modifier"
    fields: {"inputValue" -> "Shift"} asMap
view handleAction: shiftAction for: machine

Object assert: (machine chordText == "Cmd+Shift")
    message: "a second modifier should accumulate in the Result"

// Delete has no payload and therefore uses FsmHtmlApp's default enum route.
view
    handleAction: (HTMLAction named: "fsm-input" value: "Delete")
    for: machine

Object assert: (machine currentState name == "Collecting")
    message: "deleting from many modifiers should remain collecting"
Object assert: (machine chordText == "Cmd")
    message: "the Result-aware transition should remove the latest modifier"

let characterAction := HTMLAction
    named: "fsm-input?value=Char"
    fields: {"inputValue" -> "k"} asMap
view handleAction: characterAction for: machine

Object assert: (machine currentState name == "Done")
    message: "a terminal character should complete the machine"
Object assert: (machine chordText == "Cmd+k")
    message: "the completed machine should expose the built chord"
Object assert: (machine inputRevision == 4)
    message: "each Browser-style action should become one FSM input"

let rendered := (view
    documentFor: machine
    description: machine description) render

Object assert: (rendered contains: "Send Modifier")
    message: "the modifier input should use its custom select view"
Object assert: (rendered contains: "Send Character")
    message: "the character input should use its custom text view"
Object assert: (rendered contains: ">Delete</a>")
    message: "the payload-free input should retain the default action view"
Object assert: (rendered contains: "State: Done")
    message: "the status pane should show the final FSM state"
Object assert: (rendered contains: "Chord: Cmd+k")
    message: "the status pane should show the completed chord"

"State: \[machine currentState name]" println
"Chord: \[machine chordText]" println
"Inputs processed: \[machine inputRevision asIntegerString]" println

// Leave a new machine open for the hands-on part of the lesson. In
// STreuthBrowser the last show becomes the visible interactive HTML pane.
let liveMachine := ChordBuilderFSM new: "Interactive chord builder"
liveMachine configure
let liveView := ChordBuilderHtmlView for: liveMachine
liveView follow: liveMachine

"Rendered a fresh interactive chord builder in the HTML pane." println
