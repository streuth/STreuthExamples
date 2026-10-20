# 03 — Guarded Visitor dispatch

This example begins with ordinary dispatch by type and then extends `visit:`
with a Regex value used directly as a guard. The call site remains unchanged;
the matching value determines which method applies.

Run it from the repository root:

```sh
./bin/run-example 03_guarded_visitor
```

Expected output:

```text
Number: 10
String: hello
Hex colour: #3366CC
Reversed String fallback: #3366CC
```

## Why installation order matters

Guarded overloads on the same object are considered **newest first**. STreuth
does not calculate that a Regex is more specific than `String`: for
`"#3366CC"`, both guards match.

The first visitor therefore installs the broad `String` fallback before the
narrow `hexColour` method. The narrower method is newer, so it gets the first
chance to accept the value and prints `Hex colour: #3366CC`.

`ReversedVisitor` deliberately installs the same guards in the other order.
Its later `String` method accepts the value before the Regex method is reached,
so it prints `Reversed String fallback: #3366CC`. This is expected dispatch
precedence, not a failed Regex or an intermittent dispatch bug.

As a rule, install broad fallbacks first and narrower guarded cases afterward.
When two narrow guards overlap, put the one that should win later. Try adding
another Regex guard for a short colour such as `#abc`, then add an overlapping
guard such as one accepting any String beginning with `#` and observe how
their installation order expresses precedence.

This is the first step toward the broader STreuth idea: useful values can
become part of the language's dispatch vocabulary without introducing
special-case syntax.
