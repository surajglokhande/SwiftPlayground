//: [Previous](@previous)
import Foundation
let array = ["suraj", 1, true, "dhiraj"] as [Any]


for item in array {
    if item is String {
        print(item)
    }
}

for case let item as String in array {
    print(item)
}

struct Person {
    var name: String? = .none
    var age: Optional<String> = .none
    
    func demo(){
        print(name == age)
        print(type(of: name))
        print(type(of: age))
    }
}

let person: Person = Person()
person.demo()

//: [Next](@next)
