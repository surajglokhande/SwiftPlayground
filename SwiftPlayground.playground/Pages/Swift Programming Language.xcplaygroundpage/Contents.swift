/*:
[Previous](@previous)
# Swift Programming Language

## Control Transfer Statements
Control transfer statements change the order in which your code is executed, by transferring control from one piece of code to another. Swift
has five control transfer statements:

	continue
 
 - Action: Immediately stops the current iteration of a loop and moves to the next iteration.
 - Use Case: To skip the remaining code in the current pass of the loop if a condition is met, but you want the loop to keep running.
 */

let puzzleInput = "great minds think alike"
var puzzleOutput = ""
let charactersToRemove: [Character] = ["a", "e", "i", "o", "u", " "]
for character in puzzleInput {
	if charactersToRemove.contains(character) {
		continue
	}
	puzzleOutput.append(character)
}
print(puzzleOutput)

// Print only even numbers
//outerloop: for i in 0..<10 {
    innerloop: for i in 0..<10 {
        if i % 2 != 0 { // If i is odd
            continue innerloop // Skip the rest of the current iteration and go to the next
        }
        print("\(i) is an even number.")
    }
//}

/*:
	break
 
 - Action: Immediately exits the entire control structure (e.g., a for-in loop, a while loop, or a switch statement).
 - Use Case: To stop iterating or evaluating once a specific condition is met and you don't need to check the rest.
 */
// Stop searching for a number once found
let numbers = [1, 5, 8, 12, 15]
let target = 8
for num in numbers {
    if num == target {
        print("\(target) found!")
        break // Exit the loop immediately
    }
    print("Checking \(num)...")
}

// Breaking out of an outer loop using a labeled statement
outerLoop: for row in 1...3 {
    for column in 1...3 {
        print("(\(row), \(column))")
        if row == 2 && column == 2 {
            break outerLoop // Breaks out of the 'outerLoop'
        }
    }
}

/*:
	fallthrough
 
 - Action: Allows execution to continue into the next case in a switch block, even if the case pattern doesn't match.
 - Use Case: Rarely used, but occasionally necessary when you want to execute the logic of multiple sequential cases.
 */

let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
	case 2, 3, 5, 7:
		description += " a prime number, and also"
		fallthrough
//	case 11, 13, 17, 19:
//		description += " again a prime number"
//		break
	default:
		description += " an integer."
}
print(description)
/*:
	return
 
 - Action: Immediately exits the current function or method and returns control (and potentially a value) to the point where the function was called.
 - Use Case: To finish a function's execution.
 */

/*:
	throw
 */
enum DataError: Error {
    case emptyData(String)
    case invalidData(String)
    case falseData
}

func throwsError(str: String) throws -> Bool {
    if str.isEmpty {
        throw DataError.emptyData("empty")
    }else if str.contains("suraj"){
        throw DataError.invalidData("invalid")
    }else {
        return true
    }
}
do {
    var recived = try throwsError(str: "")
    print("successs:\(recived)")
}catch DataError.invalidData(let msg) {
    print(msg)
}catch DataError.emptyData(let msg) {
    print(msg)
}
//: [Next](@next)
