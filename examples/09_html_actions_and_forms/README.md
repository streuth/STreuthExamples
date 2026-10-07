# 09 — HTML actions and forms

Tutorial 07 rendered an HTML object tree. This tutorial makes one small step:
the page can send a named action back to STreuth.

Run it from the repository root:

```sh
./bin/run-example 09_html_actions_and_forms
```

Expected console output:

```text
Rendered tutorial 09; submit the form in the HTML pane.
```

In STreuthBrowser, enter a name and press **Say hello**. The browser translates
the native form submission into an `HTMLAction`. Its `name` is `save-name`, and
its `fields` map contains the input under `visitor-name`. No JavaScript is
required.

`handleAction:` reads that named field, updates the `GreetingApp` model, and
calls `show` again. The new document displays the greeting. The synthetic
`HTMLAction` near the bottom of `Main.st` checks the same handler without needing
a person to submit the form, which keeps the example runnable from the command
line.

`Style.css` is an ordinary linked stylesheet. `Main.st` uses
`stylesheet: "Style.css"`, so the generated document contains the same relative
`<link>` a hand-written HTML page would use. Keep the stylesheet beside `Main.st`;
the Browser preview resolves that relative path from the tutorial directory.

Notice `let app := self` in `document` and `show`. HTML builder blocks temporarily
use the current HTML node as `self`, while the captured `app` still names the
application model. The action callback captures it for the same reason.

Try adding a second input called `favourite-language`. Read both values from
`action fields`, store them in the model, and include them in the rerendered
message.

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.
