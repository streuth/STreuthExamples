// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let DocumentInput := Enum named: "DocumentInput" values: {
    "submit", "approve", "revise"
}

let workflow := FSM new: "Document workflow"
let Draft := workflow stateNamed: "draft"
let Review := workflow stateNamed: "review"
let Published := workflow stateNamed: "published"

workflow fsm: [
    self inputType: DocumentInput
    self initialState: Draft activateOnStart: false

    self state: Draft do: [
        self on: DocumentInput submit next: Review
    ]

    self state: Review do: [
        self on: DocumentInput approve next: Published;
        self on: DocumentInput revise next: Draft
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

Object assert: (workflow currentState == Published)
    message: "the approved document should be published"
