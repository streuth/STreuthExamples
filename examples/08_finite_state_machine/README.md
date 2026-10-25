# 08 — Finite-state machine

A finite-state machine makes valid changes explicit. This document workflow has
three named states and a typed `DocumentInput` enum. Sending `submit` is valid
only in `draft`; `approve` and `revise` are valid only in `review`.

Run it from the repository root:

```sh
./bin/run-example 08_finite_state_machine
```

Expected output:

```text
State: draft
State: review
State: published
```

The outer `fsm:` block configures the machine. Each `state:do:` block then runs
with that `State` as `self`, so `self on:next:` declares a transition on the
current state. `input:` looks for a transition belonging to the current state
and moves to its declared successor.

The workset uses the canonical core FSM sources provided by the STreuth standard
library. This lesson uses only the model layer; it does not create an HTML or
SVG view.

Try replacing `approve` with `revise`. The machine returns to `draft`. Then add
an `enter:` block to `Review` or use `on:do:next:` to attach an action to the
transition.
