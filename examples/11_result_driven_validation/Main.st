// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let OperatorNameValidator := Object derive: "OperatorNameValidator"
OperatorNameValidator define: [
    method problemsFor: of: {^Result, String} [ candidate |
        let problems := Result none
        problems of: String

        candidate isEmpty ifTrue: [
            problems add: "Name is required."
        ]
        (candidate size < 3) ifTrue: [
            problems add: "Name must contain at least 3 characters."
        ]
        (candidate contains: " ") ifTrue: [
            problems add: "Name cannot contain spaces."
        ]

        problems
    ]
]

let ProfileInput := Enum named: "ProfileInput" values: {
    "SetOperator"
}

let ProfileFSM := FSM derive: "ProfileFSM"
ProfileFSM define: [
    field pendingOperatorName of: String := ""
    field operatorName of: String := "unassigned"
    field validationMessage of: String := ""

    method input:value: of: {
        ^Self,
        ProfileInput,
        String
    } [ input value |
        self pendingOperatorName: value
        self input: input
        self
    ]

    method configure of: {^Self} [
        let machine := self
        let Editing := machine stateNamed: "editing"

        machine fsm: [
            self inputType: ProfileInput
            self initialState: Editing activateOnStart: false

            self state: Editing do: [
                self on: ProfileInput SetOperator do: [
                    machine operatorName: machine pendingOperatorName
                ]
            ]
        ]

        self
    ]

    self exposes: FSMPublic + {
        "configure", "input:value:",
        "operatorName", "validationMessage", "validationMessage:"
    }
    self
]

let machine := ProfileFSM new: "Operator profile"
machine configure

let validator := OperatorNameValidator new
let operatorInputView := FSMInputView
    named: ProfileInput SetOperator name
    displayBlock: [ inputName |
        form: [
            action: (HTMLAction named: "fsm-input" value: inputName);
            label: [
                forId: "operatorName";
                text: "Operator name"
            ];
            input: [
                id: "operatorName";
                name: "operatorName";
                type: "text"
            ];
            button: [ text: "Save operator" ];
            machine validationMessage isEmpty ifFalse: [
                div: [
                    class: "validation-error";
                    text: machine validationMessage
                ]
            ]
        ]
    ]
    handlerBlock: [ action target |
        let candidate := action fields at: "operatorName"
        let problems := validator problemsFor: candidate

        problems isNone
            then: [
                target validationMessage: ""
                target
                    input: ProfileInput SetOperator
                    value: candidate
            ]
            else: [
                target validationMessage: (problems join: " ")
            ]
    ]

// Keep the production input rendering and routing, but count refreshes instead
// of requiring a live Browser pane during the command-line lesson.
let LessonValidationApp := FsmHtmlApp derive: "LessonValidationApp"
LessonValidationApp define: [
    field refreshCount of: Number := 0

    method show: of: {^Self, FSM} [ target |
        self refreshCount: refreshCount + 1
        self
    ]
]
LessonValidationApp inputView: operatorInputView

let app := LessonValidationApp new
let blankProblems := validator problemsFor: ""
Object assert: blankProblems isMany
    message: "a blank name should retain every useful validation problem"
Object assert: ((validator problemsFor: "Ada") isNone)
    message: "a valid name should be represented by no problems"

let invalidAction := HTMLAction
    named: "fsm-input?value=SetOperator"
    fields: {"operatorName" -> ""} asMap
app handleAction: invalidAction for: machine

Object assert: (machine operatorName == "unassigned")
    message: "invalid input must not reach the FSM transition"
Object assert: (machine inputRevision == 0)
    message: "invalid input must not be dispatched"
Object assert: (machine validationMessage contains: "Name is required.")
    message: "the model should retain a useful required-name failure"
Object assert: (machine validationMessage contains: "at least 3 characters")
    message: "the model should retain every relevant failure"

let rejectedDocument := (app
    documentFor: machine
    description: machine description) render
Object assert: (rejectedDocument contains: machine validationMessage)
    message: "the next render should present the validation failures"

let validAction := HTMLAction
    named: "fsm-input?value=SetOperator"
    fields: {"operatorName" -> "Ada"} asMap
app handleAction: validAction for: machine

Object assert: (machine operatorName == "Ada")
    message: "valid input should reach the typed FSM transition"
Object assert: (machine validationMessage isEmpty)
    message: "accepting a value should clear the previous failures"
Object assert: (machine inputRevision == 1)
    message: "only the valid input should be dispatched"
Object assert: (app refreshCount == 2)
    message: "both rejected and accepted actions should refresh once"

"Rejected: \[blankProblems join: " "]" println
"Accepted: \[machine operatorName]" println
