# 06 — Receiver-aware builder

This example turns a block into a small configuration language. `compose:`
creates an `ArticleBuilder`, then `callOn:` runs the supplied block with that
builder as `self`.

Run it from the repository root:

```sh
./bin/run-example 06_receiver_aware_builder
```

Expected output:

```text
Learning Blocks
- Values receive messages.
- A block can run on a builder.
```

Inside the builder block, receiverless `title:` and `paragraph:` messages reach
the temporary `ArticleBuilder`. The outer `subject` variable remains lexically
captured even though `self` has changed. The `Block on: ArticleBuilder` contract
documents and checks the receiver expected by `compose:`.

Semicolons explicitly separate adjacent receiverless keyword messages. Without
them, neighbouring lines could be parsed as parts of one longer keyword
selector.

Try adding another `paragraph:`. Then remove the `title:` line and observe the
builder's validation error. For comparison, replace the builder block with
ordinary explicit sends to an `ArticleBuilder` instance—the resulting object
can be the same, but `callOn:` supplies the concise DSL surface.
