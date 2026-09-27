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
```

Try adding another Regex guard for a short colour such as `#abc`. This is the
first step toward the broader STreuth idea: useful values can become part of
the language's dispatch vocabulary without introducing special-case syntax.
