//: [Previous](@previous)
import Foundation

struct Stack<Element> {
    var storage: [Element] = []
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        storage.popLast()
    }
    
    func printStack() {
        print(storage)
    }
    
}
var stack = Stack<Int>()
stack.push(1)
stack.printStack()
stack.push(2)
stack.printStack()
stack.push(3)
stack.printStack()
stack.push(4)
stack.printStack()
print(stack.pop() ?? 0)
stack.printStack()


//: [Next](@next)
