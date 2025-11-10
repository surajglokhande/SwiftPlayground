//: [Previous](@previous)
/*:
 In Combine, a Publisher produces elements, and a Subscriber acts on the elements it receives. However, a publisher can’t send elements until the subscriber attaches and asks for them. The subscriber also controls the rate at which the publisher delivers elements, by using the Subscribers.Demand type to indicate how many elements it can receive. A subscriber can indicate demand in either of two ways:
 By calling request(_:) on the Subscription instance that the publisher provided when the subscriber first subscribed.
 By returning a new demand when the publisher calls the subscriber’s receive(_:) method to deliver an element.
 Demand is additive: If a subscriber has demanded two elements, and then requests Subscribers.Demand(.max(3)), the publisher’s unsatisfied demand is now five elements. If the publisher then sends an element, the unsatisfied demand decreases to four. Publishing elements is the only way to reduce unsatisfied demand; subscribers can’t request negative demand.
 Many apps just use the operators sink(receiveValue:) and assign(to:on:) to create the convenience subscriber types Subscribers.Sink and Subscribers.Assign, respectively. These two subscribers issue a demand for unlimited when they first attach to the publisher. Once a publisher has unlimited demand, there can be no further negotiation of demand between subscriber and publisher.
 */
import Foundation
import Combine
class ImperativeEventHandler {
    private var anySubscriber: AnySubscriber<String, Never>?

    func attach(subscriber: AnySubscriber<String, Never>) {
        anySubscriber = subscriber
    }

    func newEvent(_ event: String) {
        _ = anySubscriber?.receive(event)
    }
}

let publisher = PassthroughSubject<String, Never>()
let sink = Subscribers.Sink<String, Never>(receiveCompletion: { _ in }, receiveValue: { print("Received:", $0) })
let anySubs = AnySubscriber(sink)

let handler = ImperativeEventHandler()
handler.attach(subscriber: anySubs)
handler.newEvent("Hello from Imperative!")

//: [Next](@next)
