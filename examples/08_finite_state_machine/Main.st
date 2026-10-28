// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let DocumentInput := Enum named: "DocumentInput" values: {
    "submit", "approve", "revise"
}

let workflow := FSM new: "Document workflow"
let Draft := workflow stateNamed: "draft"
let Review := workflow stateNamed: "review"
let Published := workflow stateNamed: "published"

workflow fsm: [
    inputType: DocumentInput;
    initialState: Draft activateOnStart: false

    state: Draft do: [
        on: DocumentInput submit next: Review
    ]

    state: Review do: [
        on: DocumentInput approve next: Published;
        on: DocumentInput revise next: Draft
    ]
]

let showState := [ machine |
    "State: \[machine currentState name]" println
]

showState value: workflow
workflow input: DocumentInput submit
showState value: workflow
workflow input: DocumentInput approve
showState value: workflow
