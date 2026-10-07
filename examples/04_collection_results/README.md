# 04 — Collection results

Collection queries return a `Result`, making the number of matches explicit.
Use `isNone`, `isOne`, or `isMany` before asking for exactly one value with
`one`. `Result` is useful beyond collection queries whenever an operation may
produce zero, one, or several values.

When you only care about the values that exist, send `each:` directly to the
result. The block runs once for every value and zero times for `None`. In this
example the `freezing each:` block never runs, so it handles the optional value
without a `nil` check.

Run it from the repository root:

```sh
./bin/run-example 04_collection_results
```

Expected output:

```text
Comfortable result is many: true
Comfortable readings:
- 21
- 24
No freezing reading: true
Exactly one hot reading: true
Hot reading: 31
```

Try changing `31` to `19`, then inspect `hot isNone`. Next add a second value
above 30: `hot isMany` becomes true, and `hot one` deliberately rejects the
ambiguous result. Use `asList` when zero, one, and many are all acceptable.
