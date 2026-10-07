# 12 — Protocols and exposed capabilities

Tutorial 10 used `input:value:` in a custom FSM handler. This lesson explains
why publishing that selector and declaring the handler's receiver contract are
two related but distinct decisions.

Run it from the repository root:

```sh
./bin/run-example 12_protocols_and_exposed_capabilities
```

Expected output:

```text
Public selector: true
Payload contract: true
Applied level: quiet
```

`LevelConsoleFSM exposes:` includes `input:value:`. That controls the concrete
receiver's public surface: an ordinary caller can send the message, and
`respondsTo:` reports it. Exposure answers “may this object receive this
message?”

`FSMValueInputProtocol` requires `input:value:`. `PayloadDispatcher` uses that
protocol as the guard on its `target` parameter, so generic code may rely on the
message without depending on `LevelConsoleFSM` or any inheritance relationship.
The protocol answers “what capability does this role require?”

The distinction matters at both boundaries:

- An ordinary `FSM` does not publish `input:value:` and therefore does not match
  the payload protocol.
- `HiddenPayloadTarget` defines the method but omits it from `exposes:`. Its
  implementation remains private, so it also does not match the public
  protocol.
- `LevelConsoleFSM` both implements and exposes the selector, so it satisfies
  the protocol and can pass through the dispatcher's guarded parameter.

An exposure list on one concrete object does not rewrite a method parameter
guard elsewhere. If generic code declares its target as `FSM`, it may use only
the base FSM contract. Declaring `FSMValueInputProtocol` makes the additional
capability explicit to readers, runtime guard checks, lint, and completion.

Try creating a non-FSM recorder that publicly implements `input:value:`. It can
satisfy `FSMValueInputProtocol` without deriving from `FSM`, demonstrating that
protocol compatibility is structural rather than an inheritance claim.

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.
