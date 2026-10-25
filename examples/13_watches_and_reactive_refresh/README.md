# 13 — Watches and reactive refresh

Tutorial 12 established the capability used to deliver FSM inputs. This lesson
looks at the other direction: how a view notices that an input changed the
model without redrawing for every unrelated mutation.

Run it from the repository root:

```sh
./bin/run-example 13_watches_and_reactive_refresh
```

Expected output:

```text
State: off
Rendered tutorial 13; use Toggle in the HTML pane to watch the state refresh.
```

`FsmHtmlApp follow:` chooses one explicit dependency: the machine's
`inputRevision` field. It obtains the field through `getField:`, creates a
`Watch`, and calls `show:` whenever the revision changes. Following also renders
immediately, so the HTML pane starts with `off` highlighted rather than blank.

Choose **Toggle** in STreuthBrowser. `FSM input:` completes the state transition
and then advances `inputRevision`; the Watch therefore redraws the page with
`on` highlighted. Choose it again to see the same live view return to `off`.
The view is coupled to the input boundary rather than every field on the model.

`follow:` also stops its previous Watch before attaching to another machine.
`Watch` supports `pause`, `resume`, and `stop` when a larger application needs
explicit subscription lifecycle control.

Try adding a second field to `ToggleFSM` and displaying it in the custom pane.
Changing only that field will not redraw until an input advances
`inputRevision`.

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.
