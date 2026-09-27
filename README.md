# STreuthExamples

Small, runnable examples for learning STreuth one idea at a time.

This repository is the classroom and showroom. Experimental work belongs in
`STreuthWorkspace`; examples arrive here once they have a clear lesson, a clean
run path, and output a new reader can check.

## Start here

Requirements:

- Java 21 or newer.
- A current STreuth runtime. The runner finds a sibling `../STreuth` checkout
  automatically, or you can set `STREUTH_JAR` to a built `STreuth.jar`.

List and run the examples from this repository:

```sh
./bin/list-examples
./bin/run-example 01_hello_messages
./bin/check-examples
```

In STreuthBrowser, open the `.streuth-workset.st` inside an example directory.
Each example is an independent workset, so loading one does not execute the
others.

## Current learning path

1. [`01_hello_messages`](examples/01_hello_messages/README.md) — values,
   messages, variables, interpolation, and visible output.
2. [`02_objects_and_blocks`](examples/02_objects_and_blocks/README.md) — a named
   prototype, guarded fields and methods, instances, and a block passed a model
   object.
3. [`03_guarded_visitor`](examples/03_guarded_visitor/README.md) — ordinary
   type dispatch extended by a value that acts as a guard.

The intended next steps are collections, a small refactor-ready builder, the
HTML DSL, and finally the FSM DSL. The sequence should grow only when each new
example teaches one additional idea without requiring a tour of the whole
language.

## Example standard

Every curated example should have:

- One primary concept and only enough supporting syntax to demonstrate it.
- Its own `.streuth-workset.st`.
- A README with the expected output and a small experiment to try.
- No machine-specific absolute paths.
- An executable check through `./bin/check-examples`.

STreuth™ and STreuthBrowser™ are trademarks of Mark Kimberly Howe.
