// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let Visitor := Object derive: "Visitor"

Visitor define: [
    method visit: of: Number [ number |
        "Number: \[number asIntegerString]" println
    ]

    method visit: of: String [ string |
        "String: \[string]" println
    ]
]

let hexColour := Regex from: "^#[0-9A-Fa-f]{6}$"

// Candidates on one object are tried newest first. Install the broad String
// fallback before the narrower Regex guard so the narrow case gets priority.
Visitor method: "visit:" of: {hexColour} [ colour |
    "Hex colour: \[colour]" println
]

let visitor := Visitor new
visitor visit: 10
visitor visit: "hello"
visitor visit: "#3366CC"

// Reversing those declarations is legal, but changes precedence. Both guards
// accept the colour String, so this later broad method is selected first.
let ReversedVisitor := Object derive: "ReversedVisitor"

ReversedVisitor method: "visit:" of: {hexColour} [ colour |
    "Reversed hex colour: \[colour]" println
]

ReversedVisitor method: "visit:" of: String [ string |
    "Reversed String fallback: \[string]" println
]

let reversedVisitor := ReversedVisitor new
reversedVisitor visit: "#3366CC"
