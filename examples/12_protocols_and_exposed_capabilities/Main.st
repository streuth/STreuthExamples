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
            self inputType: ConsoleInput
            self initialState: Ready activateOnStart: false

            self state: Ready do: [
                self on: ConsoleInput SetLevel do: [
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

Object assert: (machine respondsTo: "input:value:")
    message: "the concrete FSM should publish its payload selector"
Object assert: (FSMValueInputProtocol matches: machine)
    message: "the published selector should satisfy the payload contract"

let ordinaryMachine := FSM new: "Ordinary FSM"
Object assert: ((ordinaryMachine respondsTo: "input:value:") !)
    message: "the base FSM should not claim a payload selector"
Object assert: ((FSMValueInputProtocol matches: ordinaryMachine) !)
    message: "the base FSM should not satisfy the payload contract"

// Defining a method and publishing it are separate decisions. Protocol matching
// follows the receiver's public surface, so this private implementation does
// not satisfy the public capability contract.
let HiddenPayloadTarget := Object derive: "HiddenPayloadTarget"
HiddenPayloadTarget define: [
    method input:value: [ input value | self ]
]
HiddenPayloadTarget exposes: {"new"}

let hiddenTarget := HiddenPayloadTarget new
Object assert: ((hiddenTarget respondsTo: "input:value:") !)
    message: "an unexposed implementation should remain private"
Object assert: ((FSMValueInputProtocol matches: hiddenTarget) !)
    message: "a private method should not satisfy a public protocol"

let dispatcher := PayloadDispatcher new
dispatcher
    send: ConsoleInput SetLevel
    value: "quiet"
    to: machine

Object assert: (machine appliedLevel == "quiet")
    message: "protocol-guarded generic code should deliver the payload"
Object assert: (machine inputRevision == 1)
    message: "the payload dispatcher should use the normal FSM input path"

"Public selector: \[machine respondsTo: "input:value:"]" println
"Payload contract: \[FSMValueInputProtocol matches: machine]" println
"Applied level: \[machine appliedLevel]" println
