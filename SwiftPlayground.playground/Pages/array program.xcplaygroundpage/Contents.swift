
/*:
 //removed dublicate element
 */
import Foundation
func arrayFunc() {
    var array = [5,9,7,11,9,11]
    //don't use any predefined function like contains
    //keep the order of the elements same
    //removed dublicate element
    //output:
    // [5,9,7,11]
    
    //    1st approch
    //    for i in 0..<array.count {
    //        var isDuplicate = false
    //        for j in 0..<uniqueArray.count {
    //            if array[i] == uniqueArray[j] {
    //                isDuplicate = true
    //                break
    //            }
    //        }
    //        if !isDuplicate {
    //            uniqueArray.append(array[i])
    //        }
    //    }
    
    //  2nd approch
    var uniqueArray: [Int] = []
    var seenElements: [Int: Bool] = [:] // Using a dictionary/hash map for efficient lookup
    for element in array {
        // Check if the element has already been seen
        if seenElements[element] == nil { // If it's nil, the element hasn't been added yet
            uniqueArray.append(element)
            seenElements[element] = true // Mark the element as seen
        }
    }
    
    print(uniqueArray) // Output: [5, 9, 7, 11]
}
//arrayFunc()
//higher order functions
func sortFunction() {
    let arr = [1, 2, 3]
    print(arr.map { [$0, $0] })
    print(arr.compactMap { [$0, $0] })
    print(arr.flatMap { [$0, $0] })
}
//sortFunction()

//Second Largest Element in an Array
func secoundLargest() {
    var array = [100, 35, 10, 10, 34, 1, 79]
    //    Output: 34
    //    Explanation: The largest element of the array is 35 and the second largest element is 34.
    
    var largestNumber = 0
    var secoundLargestNumber = 0
    for item in array {
        if item > largestNumber {
            secoundLargestNumber = largestNumber
            largestNumber = item
        } else if item > secoundLargestNumber && item < largestNumber {
            secoundLargestNumber = item
        }
        //        if item != largestNumber{
        //            if item > secoundLargestNumber {
        //                secoundLargestNumber = item
        //            }
        //        }
    }
    print(largestNumber)
    print(secoundLargestNumber)
}
//secoundLargest()

//3rd largest element in array
func thirdLargest() {
    var array = [36, 1, 10, 34, 10, 79, 100]
    //    Output: 34
    //    Explanation: The largest element of the array is 35 and the second largest element is 34.
    
    var largestNumber = 0
    var secoundLargestNumber = 0
    var thirdLargestNumber = 0
    for item in array {
        if item > largestNumber {
            thirdLargestNumber = secoundLargestNumber
            secoundLargestNumber = largestNumber
            largestNumber = item
        } else if item > thirdLargestNumber && item < largestNumber {
            if item > secoundLargestNumber {
                thirdLargestNumber = secoundLargestNumber
                secoundLargestNumber = item
            }
        }
    }
    print(largestNumber)
    print(secoundLargestNumber)
    print(thirdLargestNumber)
    //Multiplication of 10, 6 and 20
    print(largestNumber * secoundLargestNumber * thirdLargestNumber)
}
//thirdLargest()

//Maximum consecutive one’s (or zeros) in a binary array
func consecutiveOnes() {
    var array = [0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0]
    //    Output: 4
    //    Explanation: The maximum number of consecutive 1’s in the array is 4 from index 3-6.
    //    var outputArray: [Int: Int] = [:]
    var maxCount = 0
    var currentCount = 0
    for i in 1..<array.count {
        if array[i] == array[i - 1] {
            currentCount += 1
            maxCount = maxCount > currentCount ? maxCount : currentCount
        } else {
            currentCount = 1
        }
    }
    print(maxCount)
}
func AnotherConsecutiveOnes() {
    var array = [0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0]
    //    Output: 4
    //    Explanation: The maximum number of consecutive 1’s in the array is 4 from index 3-6.
    var newArray: [Int:Int] = [:]
    for (index,item) in array.enumerated() {
        
        if newArray[item] == nil {
            newArray[item] = 1
        }else if var count = newArray[item] {
            newArray[item] = count + 1
        }
    }
    print(newArray.values.max() ?? 0)
}
//consecutiveOnes()
//AnotherConsecutiveOnes()

//Move all zeros to end of array
func moveZeroToEnd() {
    var array = [1, 2, 0, 4, 3, 0, 5, 0]
    //    Output: arr[] = [1, 2, 4, 3, 5, 0, 0, 0]
    //    Explanation: There are three 0s that are moved to the end.
    var outputArray: [Int] = []
    var zeroArray: [Int] = []
    for i in 0..<array.count {
        if array[i] != 0 {
            outputArray.append(array[i])
        }else{
            zeroArray.append(array[i])
        }
    }
    outputArray.append(contentsOf: zeroArray)
    print(outputArray)
}
//moveZeroToEnd()

//Reverse an Array in groups of given size
func reversedArrayInGroup() {
    var array = [1, 2, 3, 4, 5, 6, 7, 8] //k = 3
    //    Output: [3, 2, 1, 6, 5, 4, 8, 7]
    //    Explanation: Elements is reversed: [1, 2, 3] → [3, 2, 1], [4, 5, 6] → [6, 5, 4], and the last group [7, 8](size < 3) is reversed as [8, 7].
    
    //    var outputArray: [Int] = []
    var result = [Int]()
    let n = array.count
    let k = 3
    var i = 0
    while i < n {
        let end = min(i + k, n)
        let group = Array(array[i..<end].reversed())
        result.append(contentsOf: group)
        i += k
    }
    print(result)
}
//reversedArrayInGroup()

//Rotate an Array by d - Counterclockwise or Left
func rotateArray() {
    var array = [1, 2, 3, 4, 5, 6]
    //    Output: [3, 4, 5, 6, 1, 2] k = 2
    //    Explanation: After first left rotation, arr[] becomes [2, 3, 4, 5, 6, 1] and after the second   rotation, arr[] becomes [3, 4, 5, 6, 1, 2]
    var k = 2
    k %= array.count
    var middle = k - 1
    var last = array.count - 1
    
    reverse(array: &array, start: 0, end: middle)
    reverse(array: &array, start: k, end: last)
    reverse(array: &array, start: 0, end: last)
    
    print(array)
}
func reverse(array:inout [Int], start: Int, end: Int) {
    var start = start
    var end = end
    while start < end {
        var temp = array[start]
        array[start] = array[end]
        array[end] = temp
        start += 1
        end -= 1
    }
}
//rotateArray()

//Sort an array in wave form

func waveArray() {
    var arr: [Int] = [1, 2, 3, 4, 5]
    //Output: [2, 1, 4, 3, 5]
    //Explanation: Array elements after sorting it in the waveform are 2, 1, 4, 3, 5.
    
    for i in stride(from: 0, to: arr.count - 1, by: 2) {
        var temp = arr[i]
        arr[i] = arr[i+1]
        arr[i+1] = temp
    }
    print(arr)
}
//waveArray()

//Adding one to number represented as array of digits
func PlusOne() {
    var array: [Int] = [1, 2, 4]
    //    Output : 125
    //    Explanation: 124 + 1 = 125
    
    var total = ""
    for i in 0..<array.count {
        total += "\(array[i])"
    }
    print((Int(total) ?? 0)+1)
}
//PlusOne()

//Remove All Occurrences of an Element in an Array
func RemovedAllOccu() {
    var array: [Int] = [0, 1, 3, 0, 2, 2, 4, 2]
    //    ele = 2
    //    Output: 5
    
    var k = 2
    var count = 0
    for i in 0..<array.count {
        if array[i] != k {
            count += 1
        }
    }
    print(count)
}

//RemovedAllOccu()

//Finding sum of digits of a number until sum becomes single digit
func sumOfDigit() {
    var array = 5674
    //    Output: 1
    //    Explanation:
    //    Step 1: 1 + 2 + 3 + 4 = 10
    //    Step 2: 1 + 0 = 1
    
    print(singleReturn(total: array))
}
func singleReturn(total: Int) -> Int {
    var n = total
    var count = 0
    while (n > 0 || count > 9) {
        if n == 0 {
            n = count
            count = 0
        }
        count += n % 10
        n = Int(n/10)
    }
    return count
}
//sumOfDigit()

//Remove duplicates from Sorted Array
func removedDublicate() {
    var arr: [Int] = [1, 2, 2, 3, 4, 4, 4, 5, 5]
    //    Output: [1, 2, 3, 4, 5]
    
    var newArray: [Int: Int] = [:]
    var outputArray: [Int] = []
    var count = 0
    for i in 0..<arr.count {
        if newArray[arr[i]] == nil {
            newArray[arr[i]] = 1
            outputArray.append(arr[i])
        }else{
            newArray[arr[i]]! += 1
        }
    }
    print(outputArray)
}
// removedDublicate()

// Majority Element 1st variation
// mejority element and how many times it occured
func mejorityElement(array: [Int]) {
    
    var newArray: [Int: Int] = [:]
    var count = 0
    var end = array.count
    for i in 0..<end {
        //        print(i, (end - 1) - i)
        if array[i] == array[(end - 1) - i] {
            if newArray[array[i]] != nil {
                newArray[array[i]]! += 1
            }else{
                newArray[array[i]] = 1
            }
        }
    }
    print(newArray)
}
func mejorityElementTwo(array: [Int]) {
    var majorElement = array[0]
    var counter = 0
    
    for item in array {
        if item == majorElement {
            counter += 1
        }else{
            counter -= 1
        }
        if counter == 0 {
            majorElement = item
            counter = 1
        }
    }
    print(majorElement)
}


func mejorityElementThree(array: [Int]) {
    var newArray: [Int: Int] = [:]
    var count = 0
    var end = array.count
    for i in 0..<end {
        if newArray[array[i]] != nil {
            newArray[array[i]]! += 1
        }else{
            newArray[array[i]] = 1
        }
    }
    if let element = newArray.sorted(by: { $0.value > $1.value }).first, element.value > (end/2) {
        print(element.key, element.value)
    }else{
        print(0)
    }
    
}
//mejorityElement(array: [2,2,1,1,1,2,2,2])
//mejorityElementTwo(array: [2,2,1,1,1,1,1,2])
//mejorityElementThree(array: [2,2,3,3,3,3,3,2,2])

//Intersection Of two Array 1
// common element from both array
func intersectionOfArray(_ arrayOne: [Int], _ arrayTwo: [Int]) {
    
    var intersect: [Int] = []
    
    for i in 0..<arrayOne.count {
        for j in 0..<arrayTwo.count {
            if arrayOne[i] == arrayTwo[j] {
                if !(intersect.contains(arrayTwo[j])) {
                    intersect.append(arrayTwo[j])
                }
            }
        }
    }
    print(intersect)
}
func intersectionOfArrayUsingSet(_ arrayOne: [Int], _ arrayTwo: [Int]) {
    var set1: Set<Int> = []
    var set2: Set<Int> = []
    
    for item in arrayOne {
        set1.insert(item)
    }
    for item in arrayTwo {
        set2.insert(item)
    }
    print(Array(set1.intersection(set2)))
}
//intersectionOfArray([1,2,2,1,3], [3,2])
//intersectionOfArrayUsingSet([1,2,2,1,3], [3,2])

//Contains Duplicate With Distance
// var array = [1,2,3,1,2,3], k = 2
// output: false becuase min distance between dublicate array should be <= 2 if not return false
func dublicateWithDistance(array: [Int], k: Int) -> Bool {
    var map: [Int: Int] = [:]
    var minDis = Int.max
    for (index, item) in array.enumerated() {
        print("item: \(item)")
        if map[item] != nil {
            if let prevIndex = map[item] {
                print("prevIndex: \(prevIndex)")
                print("index: \(index)")
                let gap = index - prevIndex
                print("gap: \(gap)")
                minDis = min(gap, minDis)
                print("minDis: \(minDis)")
            }
        }
        map[item] = index
        print("dic: \(map)")
    }
    if minDis <= k {
        return true
    }
    return false
}

//print(dublicateWithDistance(array: [1,2,3,1], k: 3))
//print(dublicateWithDistance(array: [1,0,1,1], k: 1))
//print(dublicateWithDistance(array: [1,2,3,1,2,3], k: 2))

// Remove Element inPlace
// var array = [0,1,2,2,3,0,4,2], k = 2
// output: 5 and array [0,1,3,0,4]
func removeElementInPlace(_ array: [Int],_ k: Int) {
    
    
    var newAarry = array
    var index = 0
    for item in newAarry {
        if item != k {
            newAarry[index] = item
            index += 1
        }
    }
    print(index)
}

//removeElementInPlace([0,1,2,2,3,0,4,2], 2)


// FizzBuzz
// if element is multiple of 3 return "Fizz" if 5 return "Buzz" and both return FizzBuzz

func fizzBuzz() {
    var output: [String] = []
    for i in 1...15 {
        if (i%3) == 0 && i%5 == 0 {
            output.append("FizzBuzz")
        }else if (i%3) == 0 {
            output.append("Fizz")
        }else if i%5 == 0 {
            output.append("Buzz")
        }else{
            output.append("\(i)")
        }
    }
    print(output)
}
//fizzBuzz()

//product of array

func productOfArray(array: [Int]) {
    
    var output: [Int] = []
    for item in array {
        var count = 1
        for (index,i) in array.enumerated() {
            if item != i && (i != 0) {
                count *= i
            }
        }
        output.append(count)
    }
    print(output)
}

productOfArray(array: [1,2,3,4])
productOfArray(array: [1,2,0,4])
//: [Next](@next)
