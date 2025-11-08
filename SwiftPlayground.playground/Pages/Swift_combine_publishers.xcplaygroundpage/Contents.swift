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
//        Deferred {
            Just(Int.random(in: 1...100))
                .print()
//        }
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
MultipleSubscribersExample().demonstrateMultipleSubscribers()
//: [Next](@next)
