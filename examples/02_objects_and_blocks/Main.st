// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let Reading := Object derive: "Reading"

Reading define: [
    field place of: String
    field temperature of: Number

    method place:temperature: of: {
        ^Reading,
        String,
        Number
    } [ place temperature |
        let reading := Reading new
        reading place: place
        reading temperature: temperature
        reading
    ]

    method isComfortable of: {^Boolean} [
        (temperature >= 18) && [temperature <= 24]
    ]

    method summary of: {^String} [
        "\[place]: \[temperature asIntegerString] C"
    ]
]

let kitchen := Reading place: "Kitchen" temperature: 21
let describe := [ reading |
    "\[reading summary] | comfortable: \[reading isComfortable]"
]

(describe value: kitchen) println
