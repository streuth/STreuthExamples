// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let lessonTitle := "Messages & builders"
let document := HTML new: "tutorial-seven"

document
    head: [
        title: lessonTitle;
        charset: "utf-8";
        viewport: "width=device-width, initial-scale=1";
        self styleName: "body" list: {
            "font-family: system-ui, sans-serif",
            "margin: 2rem",
            "color: #243047"
        }
    ]
    body: [
        header: [
            title: lessonTitle;
            paragraph: "STreuth blocks can build structured output."
        ];
        main: [
            section: [
                title: "A typed document tree";
                paragraph: "Each nested message adds a typed HTML node.";
                text: "The writer escapes <markup> before the IDE displays it."
            ]
        ];
        footer: [
            paragraph: "Built with the canonical Workspace HTML DSL."
        ]
    ]

let rendered := document render

Object
    assert: (rendered contains: "Messages &amp; builders")
    message: "HTML text is escaped"
Object
    assert: (rendered contains: "&lt;markup&gt;")
    message: "body text is escaped"

HTMLViewer show: rendered
"Rendered tutorial 07 in the HTML pane." println
