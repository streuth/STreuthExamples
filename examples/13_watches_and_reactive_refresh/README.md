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
Initial refreshes: 1
After unrelated change: 1
After first FSM input: 2
After switching machines: 4
```

`FsmHtmlApp follow:` chooses one explicit dependency: the machine's
`inputRevision` field. It obtains the field through `getField:`, creates a
`Watch`, and calls `show:` whenever the revision changes. `FSM input:` advances
that revision after handling an input, so the view observes the completed state
transition rather than coupling itself to every model field.

The executable checks establish four parts of the lifecycle:

- Following performs one immediate render so the view is never initially
  blank.
- Changing the unrelated `label` field does not redraw.
- Sending an FSM input changes `inputRevision` and redraws exactly once with
  the new state.
- Following a second machine stops the previous watch before installing the
  replacement, preventing stale redraws from the old machine.

The final assertion stops the active watch and proves that later inputs remain
silent. `Watch` also supports `pause` and `resume` when a subscription should be
temporarily inactive without being discarded.

`CountingFsmHtmlApp show:` records refresh requests instead of opening a live
HTML pane. The subscription logic is still the production `follow:` method, so
the lesson can verify the reactive boundary from the command line.

Try watching `label` separately and recording its old and new values. A label
change should activate that watch while leaving the input-revision refresh
count unchanged.

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.
