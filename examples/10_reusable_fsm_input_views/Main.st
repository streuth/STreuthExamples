// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let ConsoleInput := Enum named: "ConsoleInput" values: {
    "Start", "SetMode"
}

let ConsoleFSM := FSM derive: "ConsoleFSM"

ConsoleFSM define: [
    field pendingMode of: (String or: nil) := nil
    field mode of: String := "unset"
    field payloadDispatches of: Number := 0

    method input:value: of: {
        ^Self,
        ConsoleInput,
        String
    } [ input value |
        self pendingMode: value
        self payloadDispatches: payloadDispatches + 1
        self input: input
        self
    ]

    method configure of: {^Self} [
        let machine := self
        let Waiting := machine stateNamed: "waiting"
        let Ready := machine stateNamed: "ready"

        machine fsm: [
            self inputType: ConsoleInput
            self initialState: Waiting activateOnStart: false

            self state: Waiting do: [
                self on: ConsoleInput Start next: Ready
            ]

            self state: Ready do: [
                self on: ConsoleInput SetMode do: [
                    machine mode: machine pendingMode
                ]
            ]
        ]

        self
    ]

    self exposes: FSMPublic + {
        "configure", "input:value:", "mode", "payloadDispatches"
    }
    self
]

let modeInputView := FSMInputView
    named: ConsoleInput SetMode name
    displayBlock: [ inputName |
        form: [
            action: (HTMLAction named: "fsm-input" value: inputName);
            label: [
                forId: "inputValue";
                text: "Mode"
            ];
            select: [
                id: "inputValue";
                name: "inputValue";
                option: [
                    value: "quiet";
                    label: "quiet"
                ];
                option: [
                    value: "loud";
                    label: "loud"
                ]
            ];
            button: [ text: "Set mode" ]
        ]
    ]
    handlerBlock: [ action machine |
        machine
            input: ConsoleInput SetMode
            value: (action fields at: "inputValue")
    ]

// The command-line lesson suppresses the live Browser refresh while preserving
// the same routing performed by FsmHtmlApp.
let LessonFsmHtmlApp := FsmHtmlApp derive: "LessonFsmHtmlApp"
LessonFsmHtmlApp define: [
    field refreshCount of: Number := 0

    method show: of: {^Self, FSM} [ machine |
        self refreshCount: refreshCount + 1
        self
    ]
]
LessonFsmHtmlApp inputView: modeInputView

let machine := ConsoleFSM new: "Sound console"
machine configure

let app := LessonFsmHtmlApp new
let rendered := (app
    documentFor: machine
    description: machine description) render

Object assert: (rendered contains: ">Start</a>")
    message: "an input without a custom view should render as the default action"
Object assert: (rendered contains: "name=\"inputValue\"")
    message: "the custom input view should render its payload field"
Object assert: (rendered contains: "Set mode")
    message: "the custom input view should render its own submit control"

// Start has no payload, so the default path sends the enum value directly.
app
    handleAction: (HTMLAction
        named: "fsm-input"
        value: ConsoleInput Start name)
    for: machine

Object assert: (machine currentState name == "ready")
    message: "the default input should move the machine to ready"
Object assert: (machine payloadDispatches == 0)
    message: "the default input should not use the payload-aware method"

// SetMode owns a payload view, so its handler translates form fields into the
// machine's typed input:value: protocol.
let modeAction := HTMLAction
    named: "fsm-input?value=SetMode"
    fields: {"inputValue" -> "quiet"} asMap
app handleAction: modeAction for: machine

Object assert: (machine mode == "quiet")
    message: "the custom handler should deliver the selected mode"
Object assert: (machine payloadDispatches == 1)
    message: "the payload-aware method should run exactly once"
Object assert: (app refreshCount == 2)
    message: "both input routes should request one refresh"

"State: \[machine currentState name]" println
"Mode: \[machine mode]" println
"Payload dispatches: \[machine payloadDispatches asIntegerString]" println
