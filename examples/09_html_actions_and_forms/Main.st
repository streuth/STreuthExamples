// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let GreetingApp := Object derive

GreetingApp define: [
    field visitorName of: String := ""

    method document of: { ^HTML } [
        let app := self
        let document := HTML new: "tutorial-nine"

        document
            head: [
                title: "A live greeting";
                charset: "utf-8";
                viewport: "width=device-width, initial-scale=1";
                stylesheet: "Style.css"
            ]
            body: [
                header: [
                    title: "A live greeting";
                    paragraph: "Submit the form to update this application."
                ];
                main: [
                    section: [
                        app visitorName isEmpty ifFalse: [
                            paragraph: ("Hello, " + app visitorName + "!")
                        ];
                        form: [
                            action: "save-name";
                            label: [
                                forId: "visitor-name";
                                text: "Your name"
                            ];
                            input: [
                                id: "visitor-name";
                                type: "text";
                                name: "visitor-name";
                                value: app visitorName
                            ];
                            button: [ text: "Say hello" ]
                        ]
                    ]
                ]
            ]

        document
    ]

    method render of: { ^String } [
        self document render
    ]

    method show of: { ^Self } [
        let app := self
        HTMLViewer show: (self render) onAction: [ action |
            app handleAction: action
        ]
        self
    ]

    method handleAction: of: { ^Self, HTMLAction } [ action |
        ((action name == "save-name")
            && [ action fields containsKey: "visitor-name" ]) ifTrue: [
            self visitorName: (action fields at: "visitor-name")
            self show
        ]
        self
    ]
]

let greeting := GreetingApp new

// A synthetic action checks the same handler used by the live HTML form.
greeting handleAction: (HTMLAction named: "save-name" fields: {
    "visitor-name" -> "Ada"
} asMap)

Object assert: (greeting visitorName == "Ada")
    message: "the named form field should update the model"
Object assert: ((greeting render) contains: "Hello, Ada!")
    message: "rerendering should display the updated model"
Object assert: ((greeting render) contains: "<link rel=\"stylesheet\" href=\"Style.css\">")
    message: "the rendered document should link its ordinary stylesheet"

// Start the interactive lesson with an empty form.
greeting visitorName: ""
greeting show

"Rendered tutorial 09; submit the form in the HTML pane." println
