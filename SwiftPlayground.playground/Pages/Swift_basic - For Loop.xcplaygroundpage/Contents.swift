//: [Previous](@previous)

import Foundation

func demo() {
    var str = ["1","2","3","4","5","6","7","8","9"]
//    for item in stride(from: 8, through: 0, by: -1) {
//        print(str[item])
//    }
//    print("\n")
//    for item in stride(from: 0, through: 8, by: 1) {
//        print(str[item])
//    }
//    print("\n")
//    for item in stride(from: 1, to: 8, by: 1) {
//        print(str[item])
//    }
//    print("\n")
//    for index in stride(from: str.count - 1, through: 0, by: -1) {
//        print(str[index])
//    }
    
//    for i in str.indices {
//        print(str[i])
//    }
    
//    for item in str {
//        print(item)
//    }
//    
//    for (index, item) in str.enumerated() {
//        print(index, item)
//    }
//    
//    str.forEach { char in
//        print(char)
//    }
}
func strLoops() {
    var str = "suraj"
    
    for i in str.indices {
        print(str[i])
    }
    
    for item in str {
        print(item)
    }
    
    for (index, item) in str.enumerated() {
        print(index, item)
    }
    
    str.forEach { char in
        print(char)
    }
}
//strLoops()
demo()

//: [Next](@next)
