// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let TourGreeting := Object derive: "TourGreeting"

TourGreeting define: [
    field audience of: String

    method for: of: {^TourGreeting, String} [ audience |
        let greeting := TourGreeting new
        greeting audience: audience
        greeting
    ]

    method text of: {^String} [
        "Hello, \[audience]!"
    ]
]
