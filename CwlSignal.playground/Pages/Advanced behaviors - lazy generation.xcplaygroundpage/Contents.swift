/*:
# Advanced behaviors 2

> **This playground requires the CwlSignal.framework built by the CwlSignal_macOS scheme.** If you're seeing the error: "no such module 'CwlSignal'" follow the Build Instructions on the [Introduction](Introduction) page.

## Lazy generation

In many cases, we want to defer the actual generation of values until *after* a subscriber is ready to receive them. In CwlSignal, we can use the `generate` function, which invokes its closure every time the "activation" state changes, to start after the signal graph becomes active.

The `generate` function's closure will also be invoke with a `nil` value when the signal graph *deactives* so you can clean up resources.

---
*/
import CwlSignal

// Create an output immediately but only start creating data to feed into the pipeline after a listener connects.
let output = Signal<Int>.generate { input in
   if let i = input {
		print("Signal has activated")
      i.send(values: 1, 2, 3)
   } else {
		print("Signal has deactivated")
	}
}

print("We're just about to subscribe.")

// Subscribe to listen to the values output by the channel
let endpoint = output.subscribe { result in
	switch result {
	case .success(let value): print("Value: \(value)")
	case .failure(let error): print("End of signal: \(error)")
	}
}

print("We're just about to cancel the endpoint")

// The signal will already be cancelled before we reach this point because we didn't hold onto the `input` in the `generate` function and it cancelled itself when it reached the end of the scope.
// SOMETHING TO TRY: replace the `generate` with `retainedGenerate` and the `input` will be automatically held until all endpoints are cancelled.
endpoint.cancel()

print("Done")

/*:
---

*This example writes to the "Debug Area". If it is not visible, show it from the menubar: "View" → "Debug Area" → "Show Debug Area".*

[Next page: Advanced behaviors - capturing](@next)

[Previous page: Advanced behaviors - continuous](@previous)
*/
