// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let ToggleInput := Enum named: "ToggleInput" values: {
    "Toggle"
}

let ToggleFSM := FSM derive: "ToggleFSM"
ToggleFSM define: [
    field label of: String := "switch"

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

    self exposes: FSMPublic + {
        "configure", "label", "label:"
    }
    self
]

// The production application would render HTML in show:. This lesson records
// redraw requests so reactive behavior stays executable at the command line.
let CountingFsmHtmlApp := FsmHtmlApp derive: "CountingFsmHtmlApp"
CountingFsmHtmlApp define: [
    field refreshCount of: Number := 0
    field renderedStates of: (List of: String) := List of: String

    method show: of: {^Self, FSM} [ machine |
        self refreshCount: refreshCount + 1
        renderedStates add: machine currentState name
        self
    ]
]

let firstMachine := ToggleFSM new: "First switch"
firstMachine configure
let secondMachine := ToggleFSM new: "Second switch"
secondMachine configure

let app := CountingFsmHtmlApp new
app follow: firstMachine

Object assert: (app refreshCount == 1)
    message: "following should render the current state immediately"
Object assert: (app inputWatch isActive)
    message: "following should install one active input-revision watch"

// label is useful model state, but it is not the dependency chosen by this
// view. Changing it should not request a redraw.
firstMachine label: "renamed switch"
Object assert: (app refreshCount == 1)
    message: "an unrelated field change should not redraw the FSM view"

firstMachine input: ToggleInput Toggle
Object assert: (firstMachine currentState name == "on")
    message: "the typed input should move the first machine"
Object assert: (app refreshCount == 2)
    message: "one inputRevision change should request one redraw"
Object assert: ((app renderedStates at: 2) == "on")
    message: "the reactive redraw should observe the new state"

// follow: stops the previous watch before attaching to a new machine, then
// renders the new current state once.
app follow: secondMachine
Object assert: (app refreshCount == 3)
    message: "switching machines should render the new machine immediately"

firstMachine input: ToggleInput Toggle
Object assert: (app refreshCount == 3)
    message: "the previously followed machine must not trigger stale redraws"

secondMachine input: ToggleInput Toggle
Object assert: (app refreshCount == 4)
    message: "the newly followed machine should trigger the active watch"

app inputWatch stop
secondMachine input: ToggleInput Toggle
Object assert: (app refreshCount == 4)
    message: "a stopped watch should no longer request redraws"

"Initial refreshes: 1" println
"After unrelated change: 1" println
"After first FSM input: 2" println
"After switching machines: \[app refreshCount asIntegerString]" println
