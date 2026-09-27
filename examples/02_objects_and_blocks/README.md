# 02 — Objects and blocks

This example adds a named prototype, guarded fields and methods, an independent
instance, and a block that receives the model object.

Run it from the repository root:

```sh
./bin/run-example 02_objects_and_blocks
```

Expected output:

```text
Kitchen: 21 C | comfortable: true
```

Try creating a second `Reading` outside the comfortable range and pass it to
the same `describe` block. The block is an ordinary value; `value:` invokes it.
