// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let readings := {17, 21, 24, 31}

let comfortable := readings filter: [ temperature |
    (temperature >= 20) && [temperature <= 25]
]
let freezing := readings detect: [ temperature | temperature <= 0 ]
let hot := readings detect: [ temperature | temperature > 30 ]

"Comfortable result is many: \[comfortable isMany]" println
"Comfortable readings:" println
comfortable each: [ temperature |
    "- \[temperature asIntegerString]" println
]
freezing each: [ temperature |
    "Unexpected freezing reading: \[temperature asIntegerString]" println
]
"No freezing reading: \[freezing isNone]" println
"Exactly one hot reading: \[hot isOne]" println
"Hot reading: \[hot one asIntegerString]" println
