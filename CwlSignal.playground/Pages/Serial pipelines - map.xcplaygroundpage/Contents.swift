/*:

# Serial pipelines 2

> **This playground requires the CwlSignal.framework built by the CwlSignal_macOS scheme.** If you're seeing the error: "no such module 'CwlSignal'" follow the Build Instructions on the [Introduction](Introduction) page.

## The `map` function and transferring between contexts

*This example writes to the "Debug Area". If it is not visible, show it from the menubar: "View" → "Debug Area" → "Show Debug Area".*

As an example, the following code snippet uses `context` parameters in conjunction with the `map` function (a simplified one-to-one value transformer built on top of `transform`) to demonstrate sending a value in from the current context to the `.default` priority `Dispatch` global concurrent queue, before finally returning to the `.main` thread to report results.

---
 */
import CwlSignal

let semaphore = DispatchSemaphore(value: 0)

// Create an input/output pair
let (input, output) = Signal<Int>.createPair()

// Create the processor
let endpoint = output.map(context: .default) { value in
	// Perform the background work
	return sqrt(Double(value))
}.subscribe(context: .asyncQueue()) { result in
	// Deliver to a completion thread.
	switch result {
	case .success(let value): print(value)
	case .failure: semaphore.signal()
	}
}

// Send values to the input end
input.send(value: 1)
input.send(value: 2)
input.send(value: 3)
input.close()

// Wait until completion
semaphore.wait()

// You'd normally store the endpoint in a parent and let ARC automatically control its lifetime.
endpoint.cancel()
/*:
---

[Next page: Parallel composition - combine](@next)

[Previous page: Serial pipelines - transform](@previous)
*/