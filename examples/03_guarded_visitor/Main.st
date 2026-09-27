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

Visitor method: "visit:" of: {hexColour} [ colour |
    "Hex colour: \[colour]" println
]

let visitor := Visitor new
visitor visit: 10
visitor visit: "hello"
visitor visit: "#3366CC"
