# 11 — Result-driven validation

Tutorial 10 introduced a custom FSM input handler. This lesson keeps that
boundary and validates its submitted value before the input reaches the
machine.

Run it from the repository root:

```sh
./bin/run-example 11_result_driven_validation
```

Expected output:

```text
Rendered tutorial 11; try a blank, short, spaced, then valid name in the HTML pane.
```

`OperatorNameValidator problemsFor:` always returns a `Result` of messages. A
valid value produces `Result none`. An invalid value produces one or more
specific problems. The caller asks the result about its cardinality with
`isNone` and can join every retained message for display; it never uses `nil` as
a second, undocumented meaning.

The custom `FSMInputView` handler has two explicit branches:

- No problems: clear any earlier message and send the typed
  `ProfileInput SetOperator` plus its value to the FSM.
- One or more problems: keep the joined explanation on the model and do not
  dispatch the input.

The HTML pane makes both branches observable. Submit a blank or short name and
the form rerenders with every relevant problem while the accepted operator
remains `unassigned`. Submit `Ada` and the status changes to the accepted name
while the failure text disappears.

This is a useful Result convention for validators: the result contains
problems, so `isNone` means success and `isMany` preserves multiple independent
reasons. It also composes naturally with `each:`, `join:`, and `asList` when a
larger application needs richer presentation.

Try adding a maximum length rule. Then submit a value that violates both the
space rule and your new rule; both messages should survive in the `Result` and
appear in the next render.

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.
