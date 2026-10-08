# 16 — Guided STreuthBrowser IDE tour

This project is an orientation lap around STreuthBrowser. Its program is
deliberately small: a greeting library, an application object that renders one
HTML page, and a main file that joins them. The lesson is the IDE workflow, not
new language syntax.

The workset is self-contained, so the same tour works from a neighbouring
development checkout and from the `tutorial/` directory in a packaged
STreuthBrowser distribution.

## Run it from the command line

From the STreuthExamples repository root:

```sh
./bin/run-example 16_guided_ide_tour
```

Expected output:

```text
Hello, PolyGlot!
Rendered the guided IDE tour in the HTML pane.
```

## The four-minute IDE tour

Open `tutorial/16_guided_ide_tour/.streuth-workset.st` in STreuthBrowser. The
tour is phrased as questions so each pane has a reason to be on screen.

### 1. What source participates in this run?

In the File Browser, expand `tutorial`, then `16_guided_ide_tour`. The Tutorial
tree contains curated, read-only lessons. The `src` tree is the writable
Workspace; **Copy to Workspace** makes an editable copy under `src/tutorial`
when a learner wants to experiment.

Open the workset. The editor should open related tabs for:

1. `lib/TourGreeting.st`
2. `app/TourPage.st`
3. `Main.st`

The manifest lists them in that order because the greeting must exist before
`TourPage` can use it, and both must exist before `Main.st` runs. A workset says
which sources participate and in which order; it does not create a namespace.

### 2. What structure is in the selected source?

Select `TourGreeting.st`. The editor shows the source, while its **Structure**
tab should show `TourGreeting`, the `audience` field, and the `for:` and `text`
methods. Select `TourPage.st` and the same pane should change to `TourPage` and
`htmlFor:`. Selecting a structure row moves to that declaration without
running anything.

### 3. What executed, and what did it produce?

Select `Main.st` and choose **Run Current File** or press Cmd+R. Because the file
belongs to this workset, the IDE evaluates the workset in manifest order.

- **Program Output** shows the two expected lines above.
- **HTML** shows a page headed `Hello, PolyGlot!`.
- **Console** remains available for REPL commands, diagnostics, and navigation;
  ordinary `println` output belongs in Program Output.
- The **status bar** first reports that `Main.st` is running and then that the
  run completed. Its file state should be saved, not dirty.

This is the edit-run-inspect loop: source in the editor, textual effects in
Program Output, a visual projection in HTML, and run state at the bottom.

### 4. What live objects now exist?

Show Object Browser and keep its scope on **Workset**. Its tabs answer different
questions about the loaded program:

- **Objects** includes `TourGreeting`, `TourPage`, and the top-level bindings
  `tourGreeting`, `tourPage`, and `tourMessage`.
- **Definitions** can show where the selected object or method was declared.
- **Usages** can show where the workset refers to that declaration.
- **ST Methods** shows the selected object's STreuth behavior.
- **Java Methods** exposes underlying host behavior when it is relevant.

Select `tourGreeting`, choose **Select For Input**, and evaluate `text` in the
Object Console. The result should be `Hello, PolyGlot!`; this sends a message to
the live object created by the run rather than starting another program.

### 5. What evidence connects these files?

In `Main.st`, place the caret on `TourGreeting` and press Cmd+B. The IDE should
navigate to its definition in `lib/TourGreeting.st`, an already-open workset
tab. Use Back to return.

Place the caret on the `text` declaration in `TourGreeting.st` and choose
**Find Usages**. Object Browser should select **Usages** and include the sends in
`Main.st` and `TourPage.st`. Single-click previews a result and double-click
navigates to it.

Completion, definitions, and usages combine source structure with the loaded
runtime. In dynamic code the IDE labels the strength of its evidence rather
than claiming every possible receiver is statically certain.

### 6. Where do problems appear?

Copy the tutorial to the Workspace before making this temporary edit. In its
`Main.st`, change `tourGreeting text` to `tourGreeting txet`, then open
**Tools → Lint Results…** (or refresh analysis if the pane is already open).
The lint window should report the unknown selector and make it available to
navigation. Undo the edit; the warning should disappear after analysis
refreshes.

This deliberate typo is not part of the checked-in source. The clean tutorial
runs without lint findings.

### 7. What changes in Presentation Layout?

Select the HTML tab, then enable **Presentation Layout**. The File Browser and
Object Browser are hidden so the editor and current HTML projection share the
window. Leave Presentation Layout to restore the working panes. This is the
layout used for the live portions of the PolyGlot talk, not a separate runtime
mode.

## One experiment to keep

In the copied Workspace version, change `"PolyGlot"` to your own audience name
and run again. Program Output, the HTML heading, the live `tourGreeting`, and
the completed-run status should all agree on the new run.

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.
