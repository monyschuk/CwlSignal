/*:

# Serial pipelines 1

> **This playground requires the CwlSignal.framework built by the CwlSignal_macOS scheme.** If you're seeing the error: "no such module 'CwlSignal'" follow the Build Instructions on the [Introduction](Introduction) page.

## The `transform` function

Any number of `Signal` instances can be chained in series to form pipelines. This allows value transformations and other "stream processing" to be applied to values between the sender and the subscriber.

There are lots of different "operator" functions for chaining `Signal` instances together (including names like `map` and `flatMap` that you might recognize from `Sequence` and `Collection` processing in Swift) but most are implemented on top of the `transform` function which looks a little like this:

---
 */
import CwlSignal

let (i, o) = Signal<Int>.create()

// Transform into signal that emits the string "Beep", a number of times equal to the integer received
let endpoint = o.transform { (result: Result<Int>, next: SignalNext<String>) in
	switch result {
	case .success(let intValue): (0..<intValue).forEach { _ in next.send(value: "Beep") }
	case .failure(let error): next.send(error: error)
	}
}.subscribeValues { value in
	// In this example, we use `subscribeValues` which works like `subcribe` but unwraps the `Result<T>` automatically, ignoring errors (good if you don't need to know about end-of-stream conditions).
	print(value)
}

i.send(value: 3)
i.close()

// We normally store endpoints in a parent. Without a parent, this `cancel` lets Swift consider the variable "used".
endpoint.cancel()
/*:
---

*This example writes to the "Debug Area". If it is not visible, show it from the menubar: "View" → "Debug Area" → "Show Debug Area".*

[Next page: Serial pipelines - map](@next)

[Previous page: Basic channel](@previous)
*/
