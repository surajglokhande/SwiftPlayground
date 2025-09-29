//: [Previous](@previous)
import Foundation

func bubbleSort(array: [Int]) {
    
    var newArray = array
    for i in 0..<newArray.count - 1 {
        var isSwap = false
        for j in 0..<newArray.count - 1 - i {
            if newArray[j] > newArray[j + 1] {
                var temp = newArray[j]
                newArray[j] = newArray[j+1]
                newArray[j+1] = temp
                isSwap = true
            }
        }
        if !isSwap {
            return
        }
    }
    print(newArray)
}

bubbleSort(array: [4,1,5,2,3])
//: [Next](@next)
