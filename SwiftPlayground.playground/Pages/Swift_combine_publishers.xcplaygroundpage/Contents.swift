//: [Previous](@previous)
/*:
 ## Publisher
 - **Publisher Protocol** The Publisher protocol is a fundamental protocol in Combine that defines types that can deliver a sequence of values over time. Publisher is a protocol that defines the contract for publishing values
 */
import Foundation
import Combine
protocol Publisher {
    associatedtype Output      // The type of value published
    associatedtype Failure: Error  // The type of error that can occur
    
    func receive<S>(subscriber: S) where S: Subscriber,
                                         Self.Failure == S.Failure,
                                         Self.Output == S.Input
}
/*:
 - **AnyPublisher** AnyPublisher is a type-erased wrapper for the Publisher protocol.
    - Hide the complex implementation details of a publisher
    - Allow different publisher types to be used interchangeably
    - AnyPublisher is a concrete type that implements Publisher
    - Use AnyPublisher when:
        - Returning publishers from functions
        - Storing publishers as properties
        - Hiding complex implementation details
        - Making APIs cleaner and more maintainable
    - Always use eraseToAnyPublisher() to convert a publisher chain to AnyPublisher
    - AnyPublisher maintains the same Output and Failure types as the original publisher
 */
// Example 1: Basic Usage
func createPublisher() -> AnyPublisher<String, Never> {
    return Just("Hello")
        .eraseToAnyPublisher()  // Converts to AnyPublisher
}
createPublisher()
    .sink(receiveValue: { print($0) })

// Example 2: Network Request
func fetchData(from url: URL) -> AnyPublisher<Data, URLError> {
    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .eraseToAnyPublisher()
}

/*:
 - **Differences and Relationship between Publisher and AnyPublisher**
 */
// Example 3
// Publisher example (concrete type)
let justPublisher = Just(5) // Type: Just<Int>
// AnyPublisher example (type-erased)
let anyPublisher = Just(5).eraseToAnyPublisher() // Type: AnyPublisher<Int, Never>

// Why type erasure is useful:
class DataService {
    // Without type erasure - complex return type
    func fetchDataRaw() -> Publishers.Map<Publishers.SetFailureType<Just<String>, Error>, Data> {
        return Just("data")
            .setFailureType(to: Error.self)
            .map { $0.data(using: .utf8)! }
    }
    
    // With type erasure - clean return type
    func fetchData() -> AnyPublisher<Data, Error> {
        return Just("data")
            .setFailureType(to: Error.self)
            .map { $0.data(using: .utf8)! }
            .eraseToAnyPublisher()
    }
}
/*:
 ## Future
 - A publisher that eventually produces a single value and then finishes or fails.
 - Use a future to perform some work and then asynchronously publish a single element.
 - The closure calls the promise with a Result that indicates either success or failure.
 - In the success case, the future’s downstream subscriber receives the element prior to the publishing stream finishing normally.
 - If the result is an error, publishing terminates with that error.
 - final class Future<Output, Failure> where Failure : Error
 */

func generateAsyncRandomNumberFromFuture() -> Future <Int, Never> {
    return Future() { promise in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let number = Int.random(in: 1...10)
            promise(Result.success(number))
        }
    }
}
let cancellable: AnyCancellable?

//cancellable = generateAsyncRandomNumberFromFuture()
//    .sink { number in print("Got random number \(number).") }
/*:
 - Integrating with Swift Concurrency
 */
//Task {
//    let number = await generateAsyncRandomNumberFromFuture().value
//    print("Got random number \(number).")
//}

/*:
 **Alternatives to Futures**
 - The async-await syntax in Swift can also replace the use of a future entirely, for the case where you want to perform some operation after an asynchronous task completes.
 */
func generateAsyncRandomNumberFromContinuation() async -> Int {
    return await withCheckedContinuation { continuation in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let number = Int.random(in: 1...10)
            continuation.resume(returning: number)
        }
    }
}
//Task {
//    let asyncRandom = await generateAsyncRandomNumberFromContinuation()
//}

/*:
 ## Just
 - A publisher that emits an output to each subscriber just once, and then finishes.
 */
class RandomGenerator {
    
    var cancellables: Set<AnyCancellable> = []
    
    func generateRandomNumber() -> AnyPublisher<Int, Never> {
        Just(Int.random(in: 1...100))
            .print()
            .eraseToAnyPublisher()
    }
    
    func useRandomNumber() {
        // Each subscription gets a new random number
        generateRandomNumber()
            .sink { value in
                print("First subscription: \(value)")
            }
            .store(in: &cancellables)
//        
//        generateRandomNumber()
//            .sink { value in
//                print("Second subscription: \(value)")
//            }
//            .store(in: &cancellables)
    }
}
//let obj = RandomGenerator()
//obj.useRandomNumber()
/*:
 ## Deferred
 - A publisher that awaits subscription before running the supplied closure to create a publisher for the new subscriber.
 */
// Without Deferred (executes immediately)
let immediatePublisher = Future<String, Never> { promise in
    print("Work started immediately")
    promise(.success("Result"))
}
// With Deferred (executes only when subscribed)
let deferredPublisher = Deferred {
    Future<String, Never> { promise in
        print("Work started only after subscription")
        promise(.success("Result"))
    }
}
//deferredPublisher.sink { result in
//    print("called after subscription: \(result)")
//}
/*:
 ## Record
 - A publisher that allows for recording a series of inputs and a completion, for later playback to each subscriber.
 */
class MultipleSubscribersExample {
    var cancellables = Set<AnyCancellable>()
    
    func demonstrateMultipleSubscribers() {
        let record = Record<Int, Never>(
            output: [1, 2, 3],
            completion: .finished
        )
        
        // First subscriber
        record
            .sink(
                receiveCompletion: { print("First completed: \($0)") },
                receiveValue: { print("First received: \($0)") }
            )
            .store(in: &cancellables)
        
        // Second subscriber (gets same sequence)
        record
            .sink(
                receiveCompletion: { print("Second completed: \($0)") },
                receiveValue: { print("Second received: \($0)") }
            )
            .store(in: &cancellables)
    }
}
//MultipleSubscribersExample().demonstrateMultipleSubscribers()
/*:
 ## ConnectablePublisher
 **1. What is autoconnect() in combine and why is important?**
 - The autoconnect() method in the Combine framework is used with connectable publishers, like TimerPublisher or publishers returned by the multicast operator, to automate the connection process as soon as the first subscriber attaches. By default, a ConnectablePublisher holds off emitting events until you manually call its connect() method, giving you more control over when the stream starts.
 
 **Importance of autoconnect()**
 - autoconnect() makes the publisher start sending values immediately upon subscription, without needing a separate call to connect().
 - It simplifies code in scenarios where you want a publisher to begin emitting as soon as someone subscribes, such as updating your UI with the latest data or starting a timer right away.
 */

Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .sink { date in print(date) }

/*:
 **2. I want to see the diffrence with autoconnect and with it. i'm not able to understand the concept? give me both example?**
 - **2.1 Without autoconnect()** When you create a connectable publisher like Timer.publish(), it won't start emitting events until you explicitly call connect().
 - If you do need multiple subscribers to be synchronized before starting, you would avoid autoconnect() and manage the timing of connect() manually.
 - **Example:**
  */
let timer = Timer.publish(every: 1, on: .main, in: .common)
let cancellableOne = timer
    .sink { date in
        print("Timer fired: \(date)")
    }

// Timer is NOT running yet because connect() wasn't called
let connection = timer.connect()  // Now the timer starts
/*:
    - You manually call connect() to start the timer.
    - If you don't call connect(), subscribers won't receive any events.
    - Useful if you want to control exactly when the timer starts, perhaps after multiple subscribers are set up.
 
 - **2.2 With autoconnect()** Using autoconnect() will automatically call connect() on behalf of you once the first subscriber attaches.
 - **Example:**
 */
let cancellableTwo = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .sink { date in
        print("Timer fired: \(date)")
    }

// The timer starts immediately upon subscription, no manual connect needed
/*:
    - The timer starts as soon as the .sink subscriber attaches.
    - Cleaner and simpler syntax for cases where you want immediate start.
    - You lose the fine control of manual connection but gain simplicity.
 */
//: ![](combine.png)
/*:
 **3. List all the publisher which required .autoconnect to connect its subscriber?**
 - **3.1 Main Publishers Requiring .autoconnect()**
    - **Timer.TimerPublisher:** Emitting values at specific time intervals. Without .autoconnect(), you must manually call connect() to start the timer.

    - **Publishers.Multicast:** This returns a connectable publisher that shares a single upstream subscription. You use .autoconnect() to automatically connect on subscription instead of calling connect() manually.

    - **Publishers.MakeConnectable:** Any publisher converted to a connectable publisher using makeConnectable(); .autoconnect() can be used to simplify connection.
 */
//: ![](combine_with_autoconnect.png)
/*:
 - **3.2 Publishers That Don’t Require .autoconnect()**
    - **Just Publisher (Just):** Emits a single value immediately upon subscription.
    - **Future Publisher (Future):** Emits a single asynchronous result once it becomes available.
    - **PassthroughSubject and CurrentValueSubject:** Subjects that start emitting values upon subscription or when their value changes.
    - **URLSession.DataTaskPublisher:** Publishes the result of a network data task immediately on subscription.
    - **NotificationCenter.Publisher:** Emits notifications as they occur.
    - **Sequence Publishers (Publishers.Sequence):** Emit values from a collection immediately upon subscription.
    - **Map, Filter, FlatMap, etc. (Operator Publishers):** These transform or filter values from upstream publishers and start emitting as soon as upstream emits.
 */
//: ![](combine_without_autoconnect.png)
//: [Next](@next)
