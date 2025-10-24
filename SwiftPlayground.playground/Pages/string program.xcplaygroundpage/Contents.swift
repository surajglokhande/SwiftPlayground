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

//
// Anagram.swift
// Group anagrams from an array of strings
//
// Usage:
//   let result = anagram(array: ["eat","tea","tan","ate","nat","bat"])
//   print(result) // grouped anagrams
//

func anagram(array: [String]) -> [[String]] {
    var groups = [String: [String]]()
    for word in array {
        // use the sorted characters as the key
        let key = String(word.sorted())
        groups[key, default: []].append(word)
        print(groups)
    }
    // Return the groups as an array of arrays
    return Array(groups.values)
}

// Example usage
let input = ["eat", "tea", "tan", "ate", "nat", "bat"]
let grouped = anagram(array: input)

// Optionally sort groups and their contents for deterministic output when printing
let sortedOutput = grouped.map { $0.sorted() }.sorted { $0.joined() < $1.joined() }
//print(sortedOutput)


//: [Next](@next)
