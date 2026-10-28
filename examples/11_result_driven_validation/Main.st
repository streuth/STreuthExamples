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
            inputType: ProfileInput;
            initialState: Editing activateOnStart: false

            state: Editing do: [
                on: ProfileInput SetOperator do: [
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

let app := FsmHtmlApp new
app inputView: operatorInputView
app pane: [
    section: [
        class: "summary";
        title: "Accepted profile";
        paragraph: "Operator: \[machine operatorName]"
    ]
]
app follow: machine

"Rendered tutorial 11; try a blank, short, spaced, then valid name in the HTML pane." println
