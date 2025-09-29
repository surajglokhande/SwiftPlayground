//: [Previous](@previous)
import Foundation
func removeAdjecentCharFrom(str: String) -> String {
    
    var stack: [Character] = []
    for item in str {

        if let last = stack.last, last == item {
            stack.removeLast()
        }else{
            stack.append(item)
        }
    }
    return String(stack)
}


//print(removeAdjecentCharFrom(str: "aabbccd"))
//print(removeAdjecentCharFrom(str: "aabbccdde"))
//print(removeAdjecentCharFrom(str: "aab"))
//print(removeAdjecentCharFrom(str: "aabddce"))

//palindromic string

func palindrome() {
    
    var str = "123454321"
    var array = Array(str)
    
    for (index, item) in array.enumerated() {
        if item != array[(str.count - 1) - index] {
            print("not")
            return
        }
    }
    print("yes")
}

//palindrome()

func palindromeTwo(str: String, i: Int, j: Int, isDelete: Bool) -> Bool {
    
    var start = i
    var end = j
    var array = Array(str)
    print(start, end)
    for item in array {
        print(start, end)
        if item != array[end] {
            if isDelete {
                return false
            }
            palindromeTwo(str: "abca", i: start, j: end - 1, isDelete: true)
        }else{
            start += 1
            end -= 1
        }
    }
    return true
}

print(palindromeTwo(str: "abca", i: 0, j: ("abca".count - 1), isDelete: false))

func uniqueChar(str: String) -> String {
    
    var array = Array(str)
    
    for (index,item) in str.enumerated() {
        var j = (index + 1)
        for char in array[(index + 1)..<array.count] {
            if j == (array.count - 1) && item != char {
                return String(item)
            }else if item == char {
                break
            }
            j+=1
        }
    }
    return ""
}

//print(uniqueChar(str: "intractive"))
//print(uniqueChar(str: "devtechie"))
//print(uniqueChar(str: "suhas"))

//: [Next](@next)
