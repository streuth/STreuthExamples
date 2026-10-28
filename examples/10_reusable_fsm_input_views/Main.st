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
            inputType: ConsoleInput;
            initialState: Waiting activateOnStart: false

            state: Waiting do: [
                on: ConsoleInput Start next: Ready
            ]

            state: Ready do: [
                on: ConsoleInput SetMode do: [
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

let machine := ConsoleFSM new: "Sound console"
machine configure

let app := FsmHtmlApp new
app inputView: modeInputView
app pane: [
    section: [
        class: "summary";
        title: "Console output";
        paragraph: "Mode: \[machine mode]";
        paragraph: "Payload dispatches: \[machine payloadDispatches asIntegerString]"
    ]
]
app follow: machine

"Rendered tutorial 10; send Start, then choose a mode in the HTML pane." println
