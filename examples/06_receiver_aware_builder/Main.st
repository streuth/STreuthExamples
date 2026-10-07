// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

let Article := Object derive: "Article"

Article define: [
    field title of: String
    field paragraphs of: (List of: String)
]

let ArticleBuilder := Object derive: "ArticleBuilder"

ArticleBuilder define: [
    field article of: Article

    method title: of: {^Self, String} [ text |
        article title: text
        self
    ]

    method paragraph: of: {^Self, String} [ text |
        article paragraphs add: text
        self
    ]

    method build of: {^Article} [
        article title isEmpty ifTrue: [
            self error: "An article requires a title"
        ]
        article
    ]

    method compose: of: {
        ^Article,
        Block on: ArticleBuilder
    } [ specification |
        let builder := self new
        let draft := Article new
        draft paragraphs: (List of: String)
        builder article: draft

        specification callOn: builder
        builder build
    ]
]

let subject := "Blocks"

let article := ArticleBuilder compose: [
    title: "Learning \[subject]";
    paragraph: "Values receive messages.";
    paragraph: "A block can run on a builder."
]

Object assert: (article title == "Learning Blocks")
Object assert: (article paragraphs size == 2)

article title println
article paragraphs each: [ paragraph |
    "- \[paragraph]" println
]
