# 10 — Reusable FSM input views

Tutorial 08 sent enum inputs directly. This lesson keeps that simple default and
adds one reusable escape hatch for an input that needs a payload.

Run it from the repository root:

```sh
./bin/run-example 10_reusable_fsm_input_views
```

Expected output:

```text
Rendered tutorial 10; send Start, then choose a mode in the HTML pane.
```

`Start` needs no extra value. Because no input view is registered for it,
`FsmHtmlApp` renders its ordinary action link and later translates the action's
`value` back to `ConsoleInput Start`. The machine receives the enum through its
usual `input:` method.

`SetMode` is different: the machine cannot act until a person chooses `quiet` or
`loud`. Its `FSMInputView` pairs two reusable responsibilities under the exact
enum input name:

- `displayBlock:` builds the select field and submit button on the surrounding
  HTML element.
- `handlerBlock:` reads the submitted `inputValue` field and sends the typed
  `input:value:` message to any machine matching `FSMValueInputProtocol`.

`FsmHtmlApp` chooses between those paths by looking up the action value in its
registered input-view map. The custom handler owns payload interpretation; the
generic fallback stays small and correct for every payload-free enum input.

The lesson opens the production `FsmHtmlApp` directly. In STreuthBrowser, use
the ordinary **Start** action first, then choose a mode and press **Set mode**.
The state highlight, mode, and payload-dispatch count update in the HTML pane,
making both routing paths visible without a test-only application subclass.

Try adding a payload-free `Stop` input and transition. It should work without a
new `FSMInputView`. Then add a `SetTheme` input with its own select control and
handler, leaving the existing `SetMode` view unchanged.

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.
