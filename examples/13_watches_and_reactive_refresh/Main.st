// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let ToggleInput := Enum named: "ToggleInput" values: {
    "Toggle"
}

let ToggleFSM := FSM derive: "ToggleFSM"
ToggleFSM define: [
    method configure of: {^Self} [
        let machine := self
        let Off := machine stateNamed: "off"
        let On := machine stateNamed: "on"

        machine fsm: [
            self inputType: ToggleInput
            self initialState: Off activateOnStart: false

            self state: Off do: [
                self on: ToggleInput Toggle next: On
            ]

            self state: On do: [
                self on: ToggleInput Toggle next: Off
            ]
        ]

        self
    ]

    self exposes: FSMPublic + {"configure"}
    self
]

let machine := ToggleFSM new: "Reactive switch"
machine configure

let app := FsmHtmlApp new
app pane: [
    section: [
        class: "summary";
        title: "Reactive output";
        paragraph: "Choose Toggle below. The current-state highlight updates after every input.";
        paragraph: "The view watches inputRevision, not every field on the model."
    ]
]
app follow: machine

"State: \[machine currentState name]" println
"Rendered tutorial 13; use Toggle in the HTML pane to watch the state refresh." println
