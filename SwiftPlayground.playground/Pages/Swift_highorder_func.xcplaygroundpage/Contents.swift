//: [Previous](@previous)
/*:
 ## Write a Program where Filter the Man class where addressLine != nil && addressType == "permanent" in Address class
 */
import Foundation

func StringOperation() {
    var str = ["suraj", "Dhiraj", "shweta", "ruchika", "sumedh"]
    
    func forLoop() {
        for item in str {
            print(item)
        }
        
        for (index,item) in str.enumerated() {
            print(index, item)
        }
        
        for i in 0..<str.count {
            print(i, str[i])
        }
        
        for i in 0...str.count - 1 {
            print(i, str[i])
        }
        
        for i in 1...10 {
            print(i)
        }
    }
    func strOp() {
        
    }
    //forLoop()
    //string operation
    
}

//StringOperation()

func arrayOperation() {
    var str = ["suraj", "Dhiraj", "shweta", "ruchika", "sumedh"]
    
    //
    print(str[0..<4])
    print(str[0].sorted())
    print(str[0].sorted(by: >))
    print(str[0].sorted(by: <))
}

arrayOperation()

struct Address {
    var addressLine: String?
    var addressType: String
}

struct Man {
    var name: String
    var address: [Address]?
}

var arrayAdd = [
    Address(addressLine: nil, addressType: "permanent"),
    Address(addressLine: "african", addressType: "permanent"),
    Address(addressLine: "american", addressType: "temp"),
]

var arrayPer = [
    Man(name: "suraj", address: [arrayAdd[0], arrayAdd[1]]),
    Man(name: "parag", address: [arrayAdd[1], arrayAdd[2]]),
    Man(name: "vaibhav", address: [arrayAdd[0]]),
]

var newArray = arrayPer.filter({
    $0.address?.filter({ $0.addressLine != nil && $0.addressType == "permanent" }).count ?? 0 > 0
}).map({ $0.name })

//print(newArray)

func giveOutput() {
    var array = [1, 4, 3, nil, 4, 10]
    print(array.map { $0 })  //  = [1,1])
    print(array.compactMap { [$0, $0] })  // = [[Optional(1), Optional(1)], [Optional(2), Optional(2)], [Optional(3), Optional(3)], [nil, nil], [Optional(4), Optional(4)], [Optional(5), Optional(5)]]
    print(array.compactMap { $0 })  // = [1, 2, 3, 4, 5]
    print(array.flatMap { $0 })  // = [1, 2, 3, 4, 5]
    print(array.flatMap { [$0] })  // = [1, 2, 3, 4, 5]
    print(array.flatMap { [$0, $0] })  // = [Optional(1), Optional(1), Optional(2), Optional(2), Optional(3), Optional(3), nil, nil, Optional(4), Optional(4), Optional(5), Optional(5)]
    print(
        array.reduce(
            1,
            { partialResult, count in
                return partialResult * (count ?? 1)
            }
        )
    )
//    var newarray = array.sort { num1, num2 in
//        return num1 > num2
//    }
}
giveOutput()
//: [Next](@next)
