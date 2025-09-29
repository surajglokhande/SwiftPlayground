//: [Previous](@previous)
import Foundation

struct Queue<Element> {
    var queue: [Element] = []
    
    
    mutating func enqueue(_ data: Element) {
        queue.append(data)
    }
    
    mutating func dequeue() -> Element {
        queue.removeFirst()
    }
    
    mutating func clear() {
        queue.removeAll()
    }
    
    func printQueue() {
        print(queue)
    }
}

var q = Queue<Int>()
q.enqueue(1)
q.enqueue(2)
q.enqueue(3)
q.dequeue()
q.printQueue()
//: [Next](@next)
