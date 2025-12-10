//: [Previous](@previous)
/*:
 ## Write a Program where Filter the Man class where addressLine != nil && addressType == "permanent" in Address class
 */
import Foundation

/*:
 
 Below is the complete, organized, practical list of commonly used String methods, properties, operations, protocols, and higher-order functions in Swift.
 
 This is not an auto-generated dump — it’s curated so you can understand and use it in real projects.
 
 ⸻
 
 ✅ All Important String Operations in Swift (Complete List)
 
 ⸻
 
 🔵 1. Basic Properties
 
 Property    Description
 isEmpty    Checks if string is empty
 count    Number of characters
 first / last    First & last character
 startIndex / endIndex    Start/end positions
 indices    All indices
 */
var str = ["suraj", "Dhiraj", "shweta", "ruchika", "sumedh"]

func strBasicOp() {
    print(str.count)
    print(str.first ?? "")
    print(str.last ?? "")
    print(str.startIndex)
    let numbers = [10, 20, 30, 40, 50]
    if let i = numbers.firstIndex(of: 30) {
        print(i)
        print(numbers.endIndex)
        print(numbers[i ..< numbers.endIndex])
    }
    print(str.endIndex)
    print(str.indices)
}

//strBasicOp()
/*:
 ⸻
 
 🔵 2. Accessing Characters
 
 Operation    Example
 string[index]    single character
 string[string.startIndex]    get first
 string[string.index(after:)]    next index
 string[string.index(before:)]    previous index
 string[string.index(_:offsetBy:)]    index with offset
 */
 

/*:
 ⸻
 
 🔵 3. Substrings
 
 Method    Usage
 prefix(_:)    first N chars
 suffix(_:)    last N chars
 dropFirst(_:)    drop first N
 dropLast(_:)    drop last N
 prefix(while:)    keep until condition fails
 suffix(while:)    keep from end until condition fails
 
 
 ⸻
 
 🔵 4. Searching
 
 Method    Description
 contains(_:)    check substring/char
 range(of:)    find substring
 ranges(of:)    all ranges of substring
 hasPrefix(_:)    starts with
 hasSuffix(_:)    ends with
 
 
 ⸻
 
 🔵 5. Modifying Strings
 
 Method    Description
 append(_:)    add char/string
 insert(_:at:)    insert at index
 insert(contentsOf:at:)    insert multiple
 remove(at:)    remove at index
 removeFirst(_:)    remove first N
 removeLast(_:)    remove last N
 removeSubrange(_:)    remove range
 replacingOccurrences(of:with:)    replace substring
 
 
 ⸻
 
 🔵 6. Case Conversions
 
 Method    Description
 uppercased()    convert to uppercase
 lowercased()    convert to lowercase
 capitalized    First letter of each word capitalized
 
 
 ⸻
 
 🔵 7. Splitting & Joining
 
 Method    Description
 split(separator:)    split into array
 components(separatedBy:)    split using string
 joined(separator:)    join strings
 
 
 ⸻
 
 🔵 8. Trimming
 
 Method    Description
 trimmingCharacters(in:)    remove whitespace/newlines
 trimmed() (your own extension)    custom trimming
 
 Example:
 
 let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
 
 
 ⸻
 
 🔵 9. Conversions
 
 Method    Description
 Int(string)    string → Int
 Double(string)    string → Double
 Float(string)    string → Float
 Character(string)    string → Character
 
 
 ⸻
 
 🔵 10. Higher-Order Functions on String
 
 Strings are Collection of Characters, so these work:
 
 Method    Description
 map(_:)    transform each character
 compactMap(_:)    transform + remove nil
 filter(_:)    keep matching chars
 reduce(_:_:)    combine characters
 forEach(_:)    iterate
 
 Example:
 
 "Hello".map { $0.uppercased() }   // ["H","E","L","L","O"]
 "Hello".filter { $0 != "l" }      // "Heo"
 
 
 ⸻
 
 🔵 11. String Formatting
 
 Method    Description
 String(format:)    C-style formatting
 String(repeating:count:)    repeat string
 
 
 ⸻
 
 🔵 12. Encoding & Data
 
 Method    Description
 data(using:)    convert to Data
 utf8    UTF-8 bytes
 unicodeScalars    Unicode scalars
 
 
 ⸻
 
 🔵 13. Localized
 
 Method    Description
 localizedLowercase    locale aware lowercase
 localizedUppercase    locale aware uppercase
 
 
 ⸻
 
 🔵 14. Regular Expressions (iOS 16+)
 
 Method    Description
 contains(_ regex:)    regex match
 firstMatch(of:)    first match
 matches(of:)    all matches
 replacing(_:with:)    regex replace
 
 Example:
 
 "123abc".contains(/abc/)   // true
 
 
 ⸻
 
 ✅ If you want, I can also generate:
 
 ✔ Full cheat-sheet PDF
 
 ✔ Practice questions
 
 ✔ Interview-level string questions
 
 ✔ Code examples for each method
 
 ✔ A playground file you can run in Xcode
 
 Just tell me!
 */

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
    //forLoop()
}

StringOperation()

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
