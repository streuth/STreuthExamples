# 07 — HTML DSL

An HTML document is an object tree built by ordinary STreuth messages. Each
builder block is typed for the node it configures, and `callOn:` inside the DSL
temporarily makes that node `self`. That is why receiverless messages such as
`title:`, `header:`, and `section:` describe the current part of the document.

The outer `lessonTitle` binding remains visible inside those receiver-aware
blocks. This combines the lexical capture from tutorial 06 with a practical
nested DSL.

Run it from the repository root:

```sh
./bin/run-example 07_html_dsl
```

Expected console output:

```text
Rendered tutorial 07 in the HTML pane.
```

In STreuthBrowser, run the workset and select the HTML tab to see the rendered
document. Presentation Layout can then show the source beside that HTML output.

This tutorial deliberately loads the canonical HTML DSL from the sibling
`STreuthWorkspace` checkout instead of copying it. Keep `STreuthExamples` and
`STreuthWorkspace` beside one another under the same parent directory.

Try adding another `section:` inside `main:`. Then put `<` or `&` in its text
and inspect the rendered result: `HTMLWriter` escapes content while preserving
the document structure.
