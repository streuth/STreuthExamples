// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

// This small receiver-aware builder is the bridge between source syntax and
// the reusable FSM. Every DSL statement becomes one typed payload input.
let ChordInputBuilder := Object derive: "ChordInputBuilder"
ChordInputBuilder define: [
    field machine of: FSMValueInputProtocol

    method for: of: {^ChordInputBuilder, FSMValueInputProtocol} [ machine |
        let builder := ChordInputBuilder new
        builder machine: machine
        builder
    ]

    method input:value: of: {
        ^Self,
        ChordBuilderInput,
        ChordInputValue or: nil
    } [ input value |
        machine input: input value: value
        self
    ]

    method api of: {^List} [
        {"input:value:"}
    ]

    self exposes: (Object suggestedExposures) + {
        "for:", "input:value:"
    }
    self
]

let ChordRecipe := Object derive: "ChordRecipe"
ChordRecipe define: [
    method build:on: of: {
        ^String,
        Block on: ChordInputBuilder,
        ChordBuilderFSM
    } [ buildChord machine |
        buildChord callOn: (ChordInputBuilder for: machine)
        machine chordText
    ]
]

let machine := ChordBuilderFSM new: "Tutorial chord"
machine configure

let chord := ChordRecipe
    build: [
        input: ChordBuilderInput Modifier value: ModifierKey Cmd;
        input: ChordBuilderInput Char value: ("k" charAt: 1)
    ]
    on: machine

Object assert: (machine currentState name == "Done")
    message: "the typed recipe should complete the chord FSM"
Object assert: (machine inputRevision == 2)
    message: "each DSL statement should become one FSM input"
Object assert: (chord == "Cmd+k")
    message: "the FSM-backed builder should produce the canonical chord"

let tutorialKeymap := Keymap
    named: "Tutorial"
    extending: nil
    registry: Commands
    policy: KeymapPolicy new
    platform: KeyPlatform Mac

// cursor: supplies a typed CursorKeymapBuilder as self. Its bind:to: method
// accepts only commands from the cursor command group.
tutorialKeymap cursor: [
    bind: chord to: CursorForward
]

let boundCommand := tutorialKeymap commandAt: "Command+K"
Object assert: (boundCommand == CursorForward)
    message: "the keymap should resolve the normalized generated chord"
Object assert: (boundCommand group == CommandGroup Cursor)
    message: "the typed keymap section should retain the command group"

let installationRow := tutorialKeymap installationRows first
Object assert: (installationRow first == "Cmd+k")
    message: "installation output should retain the canonical chord"
Object assert: (installationRow second == "Editor")
    message: "cursor bindings should default to the editor context"
Object assert: (installationRow last == "editor.move-right")
    message: "installation output should use the stable command identity"

"Built chord: \[chord]" println
"Bound command: \[boundCommand name]" println
"Installation row: \[installationRow join: " | "]" println
