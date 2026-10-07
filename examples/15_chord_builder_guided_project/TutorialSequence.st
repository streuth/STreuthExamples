// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let TutorialStep := Object derive

TutorialStep define: [
    field number of: Number := 0
    field title of: String := ""
    field detail of: String := ""
    field fill of: String := "white"
    field position of: Pair := (0 -> 0)

    method number:title:detail:fill:position:
        of: {^TutorialStep, Number, String, String, String, Pair} [ number title detail fill position |
            let step := self new
            step number: number
            step title: title
            step detail: detail
            step fill: fill
            step position: position
            step
        ]

    method drawOn: of: {Svg} [ canvas |
        let left := position x
        let top := position y

        canvas rect: position
            size: (200 -> 120)
            fill: fill
            stroke: "#334155"
            width: 2
            attrs: {("rx" -> 14)}

        canvas circle: ((left + 28) -> (top + 30))
            radius: 18
            fill: "#0f172a"
            stroke: "#0f172a"
            width: 1

        canvas text: number asIntegerString
            at: ((left + 28) -> (top + 30))
            size: 15
            fill: "white"
            anchor: "middle"
            baseline: "middle"

        canvas text: title
            at: ((left + 54) -> (top + 30))
            size: 16
            fill: "#0f172a"
            anchor: "start"
            baseline: "middle"

        canvas text: detail
            at: ((left + 18) -> (top + 78))
            size: 13
            fill: "#475569"
            anchor: "start"
            baseline: "middle"
    ]
]

let foundations := "#dbeafe"
let composition := "#ede9fe"
let interaction := "#dcfce7"
let integration := "#fef3c7"

let steps := {
    TutorialStep number: 1 title: "Messages" detail: "visible values" fill: foundations position: (40 -> 170),
    TutorialStep number: 2 title: "Objects + blocks" detail: "guarded behavior" fill: foundations position: (270 -> 170),
    TutorialStep number: 3 title: "Guarded visitor" detail: "value as guard" fill: foundations position: (500 -> 170),
    TutorialStep number: 4 title: "Collection Result" detail: "none / one / many" fill: composition position: (730 -> 170),
    TutorialStep number: 5 title: "Match + Dispatcher" detail: "ordered rules" fill: composition position: (960 -> 170),

    TutorialStep number: 6 title: "Receiver builder" detail: "rebound self" fill: composition position: (960 -> 400),
    TutorialStep number: 7 title: "HTML DSL" detail: "rendered document" fill: composition position: (730 -> 400),
    TutorialStep number: 8 title: "Finite state machine" detail: "typed transitions" fill: interaction position: (500 -> 400),
    TutorialStep number: 9 title: "HTML actions" detail: "Browser form input" fill: interaction position: (270 -> 400),
    TutorialStep number: 10 title: "Reusable input views" detail: "payload controls" fill: interaction position: (40 -> 400),

    TutorialStep number: 11 title: "Result validation" detail: "structured problems" fill: interaction position: (40 -> 630),
    TutorialStep number: 12 title: "Protocol capability" detail: "generic input:value:" fill: interaction position: (270 -> 630),
    TutorialStep number: 13 title: "Watch refresh" detail: "explicit revision" fill: interaction position: (500 -> 630),
    TutorialStep number: 14 title: "Keymap chord DSL" detail: "semantic binding" fill: integration position: (730 -> 630),
    TutorialStep number: 15 title: "Guided project" detail: "everything integrated" fill: integration position: (960 -> 630)
}

let diagram := Svg width: 1200
    height: 800
    viewBox: {0, 0, 1200, 800}
    draw: [
        self background: "#f8fafc"

        self text: "The STreuth tutorial sequence"
            at: (40 -> 52)
            size: 30
            fill: "#0f172a"
            anchor: "start"
            baseline: "middle"

        self text: "Each slice adds one idea; Tutorial 15 composes them into a live project."
            at: (40 -> 88)
            size: 16
            fill: "#475569"
            anchor: "start"
            baseline: "middle"

        self rect: (40 -> 118) size: (18 -> 18) fill: foundations stroke: "#334155" width: 1 attrs: {("rx" -> 4)}
        self text: "Foundations 1–3" at: (68 -> 127) size: 13 fill: "#334155" anchor: "start" baseline: "middle"
        self rect: (245 -> 118) size: (18 -> 18) fill: composition stroke: "#334155" width: 1 attrs: {("rx" -> 4)}
        self text: "Composition 4–7" at: (273 -> 127) size: 13 fill: "#334155" anchor: "start" baseline: "middle"
        self rect: (465 -> 118) size: (18 -> 18) fill: interaction stroke: "#334155" width: 1 attrs: {("rx" -> 4)}
        self text: "State + interaction 8–13" at: (493 -> 127) size: 13 fill: "#334155" anchor: "start" baseline: "middle"
        self rect: (750 -> 118) size: (18 -> 18) fill: integration stroke: "#334155" width: 1 attrs: {("rx" -> 4)}
        self text: "Integration 14–15" at: (778 -> 127) size: 13 fill: "#334155" anchor: "start" baseline: "middle"

        self raw: "<defs><marker id=\"sequence-arrow\" viewBox=\"0 0 10 10\" refX=\"9\" refY=\"5\" markerWidth=\"7\" markerHeight=\"7\" orient=\"auto-start-reverse\"><path d=\"M 0 0 L 10 5 L 0 10 z\" fill=\"#64748b\"/></marker></defs>"

        // The cards follow a snake so the complete story remains legible in
        // the half-width SVG pane used by Presentation Layout.
        self line: (240 -> 230) to: (270 -> 230) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (470 -> 230) to: (500 -> 230) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (700 -> 230) to: (730 -> 230) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (930 -> 230) to: (960 -> 230) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (1060 -> 290) to: (1060 -> 400) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (960 -> 460) to: (930 -> 460) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (730 -> 460) to: (700 -> 460) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (500 -> 460) to: (470 -> 460) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (270 -> 460) to: (240 -> 460) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (140 -> 520) to: (140 -> 630) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (240 -> 690) to: (270 -> 690) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (470 -> 690) to: (500 -> 690) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (700 -> 690) to: (730 -> 690) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}
        self line: (930 -> 690) to: (960 -> 690) stroke: "#64748b" width: 3 attrs: {("marker-end" -> "url(#sequence-arrow)")}

        steps each: [ step | step drawOn: self ]
    ]

// Keep the checked-in image and the live SVG pane driven by the same source.
(File relativeToCurrentSource: "TutorialSequence.svg") write: diagram render
SvgViewer size: (1200 -> 800)
SvgViewer render: diagram

"Rendered the 15-slice tutorial map in the SVG pane." println
