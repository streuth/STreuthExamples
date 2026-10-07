# 14 — Keymap and chord DSL

The earlier tutorials built receiver-aware blocks, FSMs, payload handlers, and
protocol guards separately. This lesson composes them into a small source DSL
that builds a chord and binds it to a semantic editor command.

Run it from the repository root:

```sh
./bin/run-example 14_keymap_chord_dsl
```

Expected output:

```text
Cmd+k
Built chord: Cmd+k
Bound command: CursorForward
Installation row: Cmd+k | Editor | editor.move-right
```

The first line comes from the canonical `ChordBuilderFSM` entering its `Done`
state. `ChordRecipe build:on:` runs its block with a `ChordInputBuilder` as
`self`. Each `input:value:` statement is guarded by `ChordBuilderInput` and the
corresponding payload union, then forwards one typed event to the machine:

```streuth
build: [
    input: ChordBuilderInput Modifier value: ModifierKey Cmd;
    input: ChordBuilderInput Char value: ("k" charAt: 1)
]
```

The semicolon ends the first keyword statement; without it, the following
`input:` would continue the same selector instead of starting a second event.

The FSM remains responsible for sequencing those inputs and the reusable
`ChordBuilder` remains responsible for producing `Cmd+k`. The DSL is only a
thin, typed source layer; it does not duplicate the state machine.

The completed chord then enters a second receiver-aware DSL:

```streuth
tutorialKeymap cursor: [
    bind: chord to: CursorForward
]
```

`cursor:` supplies a `CursorKeymapBuilder`, whose `bind:to:` accepts only cursor
commands and installs them in the editor context. The resulting row uses the
normalized chord, context, and stable semantic command identity expected by the
keymap host.

This tutorial deliberately does not call `activate`, so running it cannot
replace the IDE's current keymap. Human-authored STreuth source remains the
executable source of truth; there is no intermediate JSON representation.

Try adding `ModifierKey Shift` before the character. The FSM should build
`Shift+Cmd+k`, and the keymap should resolve either modifier order to the same
normalized chord.

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.
