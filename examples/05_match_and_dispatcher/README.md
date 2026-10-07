# 05 — Match and Dispatcher

This example introduces ordered decisions. `Match` applies rules to one subject
immediately. `Dispatcher` retains rules so the same decision can be applied to
many inputs.

Run it from the repository root:

```sh
./bin/run-example 05_match_and_dispatcher
```

Expected output:

```text
One score: solid
95 -> excellent
82 -> solid
61 -> developing
```

Rules are tried in the order they were added. The predicates overlap: `95`
satisfies both `score >= 90` and `score >= 70`, so `dispatchFirst:` deliberately
uses the first matching rule. `Always` supplies the final fallback. Giving each
predicate a `Block of: {Number}` guard documents and enforces the type of its
input while allowing both decision forms to share the same blocks.

Try reversing the first two Dispatcher rules and run the example again. Then
change `dispatchFirst:` to `dispatchOne:` and observe how the latter rejects an
input with more than one matching rule. Use `dispatchOne:` when overlap is an
error; use `dispatchFirst:` when rule order expresses precedence.
