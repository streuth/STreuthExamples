// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let ConsoleInput := Enum named: "ConsoleInput" values: {
    "SetLevel"
}

let LevelConsoleFSM := FSM derive: "LevelConsoleFSM"
LevelConsoleFSM define: [
    field pendingLevel of: String := ""
    field appliedLevel of: String := "unset"

    method input:value: of: {
        ^Self,
        ConsoleInput,
        String
    } [ input value |
        self pendingLevel: value
        self input: input
        self
    ]

    method configure of: {^Self} [
        let machine := self
        let Ready := machine stateNamed: "ready"

        machine fsm: [
            inputType: ConsoleInput;
            initialState: Ready activateOnStart: false

            state: Ready do: [
                on: ConsoleInput SetLevel do: [
                    machine appliedLevel: machine pendingLevel
                ]
            ]
        ]

        self
    ]

    // Publication makes these selectors callable on this FSM family. It does
    // not change the separate guard used by generic code.
    self exposes: FSMPublic + {
        "configure", "input:value:", "appliedLevel"
    }
    self
]

let PayloadDispatcher := Object derive: "PayloadDispatcher"
PayloadDispatcher define: [
    method send:value:to: of: {
        ^Self,
        EnumValue,
        String,
        FSMValueInputProtocol
    } [ input value target |
        target input: input value: value
        self
    ]
]

let machine := LevelConsoleFSM new: "Level console"
machine configure

let ordinaryMachine := FSM new: "Ordinary FSM"

// Defining a method and publishing it are separate decisions. Protocol matching
// follows the receiver's public surface, so this private implementation does
// not satisfy the public capability contract.
let HiddenPayloadTarget := Object derive: "HiddenPayloadTarget"
HiddenPayloadTarget define: [
    method input:value: [ input value | self ]
]
HiddenPayloadTarget exposes: {"new"}

let hiddenTarget := HiddenPayloadTarget new

let dispatcher := PayloadDispatcher new
dispatcher
    send: ConsoleInput SetLevel
    value: "quiet"
    to: machine

"Public selector: \[machine respondsTo: "input:value:"]" println
"Payload contract: \[FSMValueInputProtocol matches: machine]" println
"Ordinary FSM payload contract: \[FSMValueInputProtocol matches: ordinaryMachine]" println
"Hidden method is public: \[hiddenTarget respondsTo: "input:value:"]" println
"Applied level: \[machine appliedLevel]" println
