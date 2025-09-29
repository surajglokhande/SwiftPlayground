//: [Previous](@previous)
import Foundation

func binarySearch(array: [Int], k: Int) {
    
    var start = 0
    var end = array.count
    while start < end {
        var mid = start + (end - start) / 2
        if array[mid] == k {
            print(mid)
            return
        }else if k > array[mid] {
            start = mid + 1
        }else {
            end = mid
        }
    }
}


binarySearch(array: [-1,0,3,4,5,9,12], k: 12)



//: [Next](@next)
