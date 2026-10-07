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
4. [`04_collection_results`](examples/04_collection_results/README.md) —
   collection queries that preserve whether they found none, one, or many
   values.
5. [`05_match_and_dispatcher`](examples/05_match_and_dispatcher/README.md) —
   ordered decisions for one value with `Match`, then reusable rules with
   `Dispatcher`.
6. [`06_receiver_aware_builder`](examples/06_receiver_aware_builder/README.md) —
   a typed builder block whose `self` is rebound with `callOn:` while lexical
   values remain available.
7. [`07_html_dsl`](examples/07_html_dsl/README.md) — a receiver-aware builder
   that produces and displays a real HTML document.
8. [`08_finite_state_machine`](examples/08_finite_state_machine/README.md) —
   typed inputs move a model through explicitly declared states.
9. [`09_html_actions_and_forms`](examples/09_html_actions_and_forms/README.md) —
   a native HTML form becomes a typed action that updates a model and rerenders
   the page.
10. [`10_reusable_fsm_input_views`](examples/10_reusable_fsm_input_views/README.md)
    — payload-free FSM inputs keep the default action path, while reusable input
    views render and handle the inputs that need values.
11. [`11_result_driven_validation`](examples/11_result_driven_validation/README.md)
    — a `Result` carries zero, one, or many validation problems so custom input
    handlers can reject payloads with useful feedback and no `nil` convention.
12. [`12_protocols_and_exposed_capabilities`](examples/12_protocols_and_exposed_capabilities/README.md)
    — `exposes:` publishes one receiver's selectors, while a protocol declares
    the reusable capability contract generic code may require.
13. [`13_watches_and_reactive_refresh`](examples/13_watches_and_reactive_refresh/README.md)
    — a view watches one explicit FSM revision, redraws after inputs, and
    detaches stale subscriptions when it follows another machine.

The sequence should grow only when each new example teaches one additional idea
without requiring a tour of the whole language.

## Contributing

Start experimental work in your own `STreuthWorkspace`, then propose a focused,
runnable lesson here through a pull request. The
[four-repository, three-layer collaboration model](https://github.com/streuth/STreuth/blob/master/doc/COLLABORATION_MODEL.md)
describes the repository roles, promotion path, and core review boundary.

## Example standard

Every curated example should have:

- One primary concept and only enough supporting syntax to demonstrate it.
- Its own `.streuth-workset.st`.
- A README with the expected output and a small experiment to try.
- No machine-specific absolute paths.
- An executable check through `./bin/check-examples`.

STreuth™ and STreuthBrowser™ are trademarks of Mark Kimberly Howe.
