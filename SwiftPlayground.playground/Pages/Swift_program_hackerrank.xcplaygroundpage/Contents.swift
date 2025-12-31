//: [Previous](@previous)
import Foundation

/*:
 * Complete the 'timeConversion' function below.
 *
 * The function is expected to return a STRING.
 * The function accepts STRING s as parameter.
 */

func timeConversion(s: String) -> String {
    // Write your code here
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.dateFormat = "hh:mm:ssa"

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "HH:mm:ss" // 'HH' is for 24-hour format

    if let date = inputFormatter.date(from: s) {
        return outputFormatter.string(from: date)
    } else {
        return ""
    }
}

//let stdout = ProcessInfo.processInfo.environment["OUTPUT_PATH"]!
//FileManager.default.createFile(atPath: stdout, contents: nil, attributes: nil)
//let fileHandle = FileHandle(forWritingAtPath: stdout)!
//
//guard let s = readLine() else { fatalError("Bad input") }

//let result = timeConversion(s: "07:05:45PM")
//
//print(result)


/*:
 * Complete the 'morganAndString' function below.
 *
 * The function is expected to return a STRING.
 * The function accepts following parameters:
 *  1. STRING a
 *  2. STRING b
 */

func morganAndString(a: String, b: String) -> String {
    // Write your code here
    // 1. Append sentinel 'z' to handle the end of strings correctly
    var s1 = Array(a + "z")
    var s2 = Array(b + "z")
    
    var result = ""
    var i = 0
    var j = 0
    
    // Total characters to process (excluding the two 'z's we added)
    let totalLength = s1.count + s2.count - 2
    result.reserveCapacity(totalLength)
    
    while i < s1.count - 1 && j < s2.count - 1 {
        // Simple comparison
        if s1[i] < s2[j] {
            result.append(s1[i])
            i += 1
        } else if s1[i] > s2[j] {
            result.append(s2[j])
            j += 1
        } else {
            // TIE BREAKER: Compare the suffixes
            // Swift's array slice comparison is highly optimized
            if compareSuffixes(s1, i, s2, j) {
                result.append(s1[i])
                i += 1
            } else {
                result.append(s2[j])
                j += 1
            }
        }
    }
    
    func compareSuffixes(_ s1: [Character], _ i: Int, _ s2: [Character], _ j: Int) -> Bool {
        var p1 = i
        var p2 = j
        
        while p1 < s1.count && p2 < s2.count {
            if s1[p1] < s2[p2] { return true }
            if s1[p1] > s2[p2] { return false }
            p1 += 1
            p2 += 1
        }
        return true
    }
    
    // Append remaining characters from whichever string isn't finished
    if i < s1.count - 1 {
        result.append(contentsOf: s1[i..<s1.count-1])
    }
    if j < s2.count - 1 {
        result.append(contentsOf: s2[j..<s2.count-1])
    }
    
    return result
}


//let result = morganAndString(a: "JACK", b: "DANIEL")
//
//print(result)




//: [Next](@next)
