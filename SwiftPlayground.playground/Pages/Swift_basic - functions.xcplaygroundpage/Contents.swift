//: [Previous](@previous)
/*:
# Function Argument Labels and Parameter Names in Swift

## Argument Labels
- **Purpose:** Argument labels make function calls more readable and expressive.
Syntax: The argument label is written before the parameter name, separated by a space.
```
 func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)! Glad you could visit from \(hometown)."
}
print(greet(person: "Anna", from: "Boston"))
```
## Omitting Argument Labels
- **Underscore (_):** Use an underscore to omit the argument label when calling the function.
```
 func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
    // Function body goes here
}
someFunction(1, secondParameterName: 2)
```
## Default Parameter Values
- **Default Values:** Parameters can have default values, making them optional when calling the function.
```
 func greet(person: String, from hometown: String = "Unknown") -> String {
    return "Hello \(person)! Glad you could visit from \(hometown)."
}
print(greet(person: "Anna")) // Uses default value for hometown
```
## Variadic Parameters
- **Definition:** Variadic parameters accept zero or more values of a specified type.
Syntax: Use three dots (...) after the parameter's type.
```
 func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5) // Returns 3.0
```
## In-Out Parameters
- **Definition:** In-out parameters allow a function to modify the value of a parameter.
Syntax: Use the inout keyword before the parameter type.
```
 func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var firstInt = 3
var secondInt = 107
swapTwoInts(&firstInt, &secondInt)
```
*/
//: [Next](@next)
