/*:

# Parallel composition 1

> **This playground requires the CwlSignal.framework built by the CwlSignal_macOS scheme.** If you're seeing the error: "no such module 'CwlSignal'" follow the Build Instructions on the [Introduction](Introduction) page.

## The `combine` function

One of the key strengths of reactive programming is the ability to integrate dependencies from different sources, potentially running in different execution contexts.

The underlying operator for these "multiple-input" operations is the `combine` operator. It offers an interface that closely resembles the `transform` operator, except that incoming `Result`s are wrapped in an `EitherResult`, reflecting an origin from "either" the first, the second or possibly third, fourth or fifth different input `Signal`.

---
 */
import CwlSignal

let semaphore = DispatchSemaphore(value: 0)

// Two signals compete, over time
let intSignal = Signal<Int>.timer(interval: .fromSeconds(1), value: 1)
let doubleSignal = Signal<Double>.timer(interval: .fromSeconds(0.5), value: 0.5)

// The signals are combined – first to send a value wins
let endpoint = intSignal.combine(second: doubleSignal) { (eitherResult: EitherResult2<Int, Double>, next: SignalNext<String>) in
   switch eitherResult {
   case .result1(.success(let intValue)): next.send(value: "\(intValue)")
   case .result2(.success(let doubleValue)): next.send(value: "\(doubleValue)")
	default: break
   }
	
	// Output always closes after the first value
	next.close()
}.subscribe { result in
	switch result {
	case .success(let v): print("The smaller value is: \(v)")
	case .failure: print("Signal complete"); semaphore.signal()
	}
}

// In reactive programming, blocking is normally "bad" but we need to block or the playground will finish before the background work.
semaphore.wait()

// You'd normally store the endpoint in a parent and let ARC control its lifetime.
endpoint.cancel()
/*:
---

*This example writes to the "Debug Area". If it is not visible, show it from the menubar: "View" → "Debug Area" → "Show Debug Area".*

[Next page: Parallel composition - operators](@next)

[Previous page: Serial pipelines - map](@previous)
*/
