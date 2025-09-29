//: [Previous](@previous)
import Foundation

class Node {
    
    var next: Node?
    var data: Int
    
    init(data: Int) {
        self.data = data
    }
}

class LinkedList {
    var head: Node?
    var tail: Node?
    
    func create(_ data: Int) -> Node? {
        var newNode = Node(data: data)
        return newNode
    }
    
    func push_front(_ data: Int) {
        var node = create(data)
        if head == nil {
            head = node
            tail = node
        }else{
            node?.next = head
            head = node
        }
    }
    
    func pop_front() {
        var curr = head
        if head != nil {
            head = head?.next
            curr?.next = nil
            curr = nil
        }
    }
    
    func pop_back() {
        var curr = head
        if head != nil && tail != nil {
            var curr = head
            
            while curr?.next?.next != nil {
                curr = curr?.next
            }
            curr?.next = nil
            tail = nil
            tail = curr
            
        }
    }
    
    func push_back(_ data: Int) {
        var node = create(data)
        if head == nil {
            head = node
            tail = node
        }else{
            tail?.next = node
            tail = node
        }
    }
    
    func insertMiddle(_ data: Int, _ pos: Int) {
        if pos < 0 {
            return
        }
        if pos == 0 {
            push_front(data)
            return
        }
        var node = create(data)
        if head != nil && tail != nil {
            
            var curr = head
            for i in 0..<pos-1 {
                curr = curr?.next
            }
            node?.next = curr?.next
            curr?.next = node
        }
        
    }
    
    func reverseLinkedList() {
        if head != nil && tail != nil {
            var prev: Node?
            var curr = head
            var next: Node?
            
            while curr != nil {
                next = curr?.next
                curr?.next = prev
                prev = curr
                curr = next
            }
            head = prev
        }
    }
    
    func printNode() {
        var curr = head
        while curr != nil {
            print("\(curr?.data ?? 0) ->")
            curr = curr?.next
        }
    }
}

var ll = LinkedList()
ll.push_front(3)
ll.push_front(2)
ll.push_front(1)
//ll.printNode()
ll.push_back(4)
ll.push_back(5)
//ll.printNode()
//ll.pop_front()
//ll.printNode()
//ll.pop_back()
ll.printNode()
print("=================")
//ll.insertMiddle(3, 2)
ll.reverseLinkedList()
ll.printNode()
//ll.printHeadAndTails()

//: [Next](@next)
