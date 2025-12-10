//: [Previous](@previous)
/*:
 ## Subscribers
 In Combine, a Publisher produces elements, and a Subscriber acts on the elements it receives. However, a publisher can’t send elements until the subscriber attaches and asks for them.
 
 The subscriber also controls the rate at which the publisher delivers elements, by using the Subscribers.Demand type to indicate how many elements it can receive. A subscriber can indicate demand in either of two ways:
 
 By calling request(_:) on the Subscription instance that the publisher provided when the subscriber first subscribed.
 
 By returning a new demand when the publisher calls the subscriber’s receive(_:) method to deliver an element.
 
 Demand is additive: If a subscriber has demanded two elements, and then requests Subscribers.Demand(.max(3)), the publisher’s unsatisfied demand is now five elements. If the publisher then sends an element, the unsatisfied demand decreases to four. Publishing elements is the only way to reduce unsatisfied demand; subscribers can’t request negative demand.
 
 Many apps just use the operators sink(receiveValue:) and assign(to:on:) to create the convenience subscriber types Subscribers.Sink and Subscribers.Assign, respectively. These two subscribers issue a demand for unlimited when they first attach to the publisher. Once a publisher has unlimited demand, there can be no further negotiation of demand between subscriber and publisher.
 
 the Subscriber is an important protocol in the Combine framework. It represents a type that can receive and react to values and completion events from Publishers. In Combine, data flows from a Publisher to a Subscriber. The Subscriber receives the values emitted by the Publisher and processes them accordingly.
 
 **Key Points:**
 
 - A Subscriber subscribes to a Publisher.
 - It receives input values and handles completion events (finished or error).
 - You usually use provided subscribers like .sink, .assign, but you can create your own by conforming to the Subscriber protocol.
 - receive(subscription:): Called when the subscriber subscribes to a publisher.
 - receive(_:): Called whenever the publisher emits a value.
 - receive(completion:): Called when the publisher finishes or fails.
 */
/*:
 **What is Subscribers.Demand?**
 
 - It's a way for Subscribers to tell Publishers how many values they want to receive, supporting backpressure.
 - It's used both when the subscription starts, and each time the subscriber receives a value.

 **Purpose**
 
 When a Publisher pushes data to a Subscriber, the Subscriber decides how many items it wants, using Subscribers.Demand. This goes hand-in-hand with the receive(subscription:) and receive(_:) methods of the Subscriber protocol.
 
 **Why Use Demand?**
 
 - Efficient resource usage: Prevents memory and thread overload.
 - Custom flow control: You can adjust your demand as you process values.
 
 **Common Demand Values**
 
 - .none — The subscriber doesn’t want any more values right now.
 - .unlimited — The subscriber can handle all values, with no limit.
 - .max(Int) — The subscriber wants a specific number of values (e.g., .max(3) means "give me three more values")
 
 **How It Works in Practice**
 
 - **In receive(subscription:)**
 
    - The subscriber tells the publisher how many values it wants initially:
 */
import Foundation
import Combine
func receive(subscription: Subscription) {
    // Request 5 values
    subscription.request(.max(5))
}
/*:
 - **In receive(_:)**
 
    - After receiving each value, the subscriber can return another demand to continue—or .none to stop:
 */
func receive(_ input: String) -> Subscribers.Demand {
    print(input)
    // Ask for one more value each time
    return .max(1)
}
/*:
    Example
 */
final class PrintSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        print("Received subscription")
        //        subscription.request(.unlimited) // Request unlimited values
        subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Received input: \(input)")
        return .max(1)
        /*
        if return .none output will be
            Received subscription
            Received input: A
            Received input: B
        */
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion: \(completion)")
    }
}

let publisher = ["A", "B", "C", "D", "E"].publisher
let subscriber = PrintSubscriber()
//publisher.subscribe(subscriber)

class DynamicDemandSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never
    var count = 0
    
    func receive(subscription: Subscription) {
        print("Received subscription")
        subscription.request(.max(1)) // Start with one value
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Received input: \(input)")
        count += 1
        if count < 3 {
            return .max(3) // keep requesting one at a time
        } else {
            return .none // stop after 5
        }
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
}
let publisherTwo = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"].publisher
publisherTwo.subscribe(DynamicDemandSubscriber())
/*:
 
 **What is Backpressure?**
 
 Backpressure is a concept in reactive programming and system design that refers to the ability to regulate the flow of data between a producer (source of data) and a consumer (receiver of data) so that the consumer is not overwhelmed with more data than it can process.
 
 **In the context of Apple's Combine framework:**
 
 **Publisher:** Emits values (data/events) as fast as it can.
 **Subscriber:** Receives and processes those values.
 
 **If the publisher emits values faster than the subscriber can handle, it can lead to issues such as:**
 
 - Memory overload
 - Increased latency
 - App crashes
 
 Backpressure mechanisms allow the subscriber to control how much data it receives, preventing these problems.
 
 **How is Backpressure Handled in Combine?**
 
 Combine uses the Subscribers.Demand type to implement backpressure:
 
 When a subscriber subscribes, it requests a certain number of values from the publisher.
 After processing an item, the subscriber can request more values, or signal that it can't handle more right now.
 The publisher will only send as many values as requested, giving the subscriber time to process.
 */
/*:
 ## What is the diffrence between .sink vs Subscriber.Sink with example?
 **1. .sink Operator**
 
 ### **What is it?**
 - .sink is a convenience operator (extension method) provided on the Publisher protocol. It internally creates a subscriber of type Subscriber.Sink, attaches it to the publisher, and returns an AnyCancellable so you can manage (and cancel) the subscription. It’s the easiest way to subscribe to a publisher for most cases.
 */
let publisherThree = [1, 2, 3].publisher
var cancellable: AnyCancellable?

cancellable = publisherThree.sink(
    receiveCompletion: { completion in
        print("Completed: \(completion)")
    },
    receiveValue: { value in
        print("Received: \(value)")
    }
)
// Output:
// Received: 1
// Received: 2
// Received: 3
// Completed: finished
/*:
 **2. Subscriber.Sink**
 
 ### **What is it?**
 
 - Subscriber.Sink is an actual subscriber type (sometimes called SinkSubscriber) that implements the Subscriber protocol. You can manually create this type and attach it to a publisher using .subscribe(_:).
 */
let publisherFour = [1, 2, 3].publisher

let sinkSubscriber = Subscribers.Sink<Int, Never>(
    receiveCompletion: { completion in
        print("SinkSubscriber completed: \(completion)")
    },
    receiveValue: { value in
        print("SinkSubscriber received: \(value)")
    }
)

// Attach the SinkSubscriber to the publisher
publisherFour.subscribe(sinkSubscriber)

// Output:
// SinkSubscriber received: 1
// SinkSubscriber received: 2
// SinkSubscriber received: 3
// SinkSubscriber completed: finished
//: [Next](@next)
