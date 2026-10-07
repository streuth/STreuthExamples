// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let excellentScore of: (Block of: {Number}) := [ score | score >= 90 ]
let solidScore of: (Block of: {Number}) := [ score | score >= 70 ]

// Match is convenient when one subject needs one ordered decision.
let oneScoreBand := 82 match
    .when: excellentScore do: [ "excellent" ]
    .when: solidScore do: [ "solid" ]
    .else: [ "developing" ]

"One score: \[oneScoreBand]" println

// Dispatcher keeps the rules so the same decision can be reused.
let scoreBand := Dispatcher new
scoreBand rules: {}

scoreBand
    .when: excellentScore do: [ "excellent" ]
    .when: solidScore do: [ "solid" ]
    .when: Always do: [ "developing" ]

{95, 82, 61} each: [ score |
    let band := scoreBand dispatchFirst: score
    "\[score asIntegerString] -> \[band]" println
]
