//: [Previous](@previous)
/*:
# Optionals in Swift

## What are Optionals?
- **Definition:** Optionals represent a value that may be absent. They can either contain a value or be nil (no value). Example: Converting a String to an Int might fail, so it returns an optional Int

```
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber) // convertedNumber is of type Int?
```
## Using nil
- **Setting to nil:** You can set an optional variable to nil to indicate it has no value.
var serverResponseCode: Int? = 404
serverResponseCode = nil // Now contains no value
- **Default nil:** If you define an optional without a default value, it is automatically set to nil.
```
var surveyAnswer: String? // Automatically set to nil
```
## Checking for a Value
- **Using if Statements:** Check if an optional contains a value by comparing it to nil.
```
if convertedNumber != nil {
    print("convertedNumber contains some integer value.")
}
```
## Optional Binding
- **Definition:** Optional binding checks if an optional contains a value and makes that value available as a temporary constant or variable.
Syntax:
```
if let actualNumber = Int(possibleNumber) {
    print("The string \"\(possibleNumber)\" has an integer value of \(actualNumber)")
} else {
    print("The string \"\(possibleNumber)\" couldn't be converted to an integer")
}
```
Shorter Syntax: You can use a shorter syntax to unwrap an optional value.
```
if let myNumber {
    print("My number is \(myNumber)")
}
```
## Multiple Optional Bindings
- **Combining Conditions:** You can include multiple optional bindings and Boolean conditions in a single if statement.
```
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
```


# Handling Optionals in Swift

## Providing a Fallback Value
- **Nil-Coalescing Operator (??):** Use this operator to provide a default value if an optional is nil.
```
let name: String? = nil
let greeting = "Hello, " + (name ?? "friend") + "!"
print(greeting) // Prints "Hello, friend!"
```

## Force Unwrapping
- **Force Unwrapping (!):** Use an exclamation mark to force unwrap an optional when you are sure it contains a value. This will trigger a runtime error if the optional is nil.
```
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
let number = convertedNumber! // Force unwrapping
```

## Implicitly Unwrapped Optionals
- **Definition:** These are optionals that are automatically unwrapped when accessed, assuming they always contain a value after being set.
Syntax: Use an exclamation mark after the type when declaring.
```
let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString // Unwrapped automatically
```
## Checking for nil
- **Using if Statements:** Check if an implicitly unwrapped optional is nil before accessing its value.
```
if assumedString != nil {
    print(assumedString!) // Safe to force unwrap
}
```
## Optional Binding with Implicitly Unwrapped Optionals
- **Optional Binding:** Use optional binding to safely unwrap and use the value of an implicitly unwrapped optional.
```
if let definiteString = assumedString {
    print(definiteString) // Safe to use
}
```
*/
//: [Next](@next)
