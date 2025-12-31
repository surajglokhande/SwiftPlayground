//: [Previous](@previous)

import Foundation

func Fibonacci(upto: Int) {
    
    var f1 = 1
    var f2 = 0
    
    for i in 0...upto {
        var fibonacci = f1 + f2
        print(fibonacci)
        f1 = f2
        f2 = fibonacci
    }
}

var memo: [Int] = []
func FibonacciRecursive(upto: Int) -> Int {
    var n = upto
    
    if memo.contains(n) {
        return memo[n]
    }
    if n <= 2 {
        return 1
    }else{
        var result = FibonacciRecursive(upto: n - 1) + FibonacciRecursive(upto: n - 2)
        print(result)
        return result
    }
}

func fibonacciWithMemo(upto: Int) -> Int {
    
    var memo: [Int] = []
    var result = 0
    for i in 1..<upto + 1 {
        if i <= 2 {
            result = 1
        }else{
            result = memo[i - 1] + memo[i - 2]
            memo[i] = result
        }
    }
    return memo[upto]
}

//Fibonacci(upto: 10)
//FibonacciRecursive(upto: 7)
print(fibonacciWithMemo(upto: 7))

//: [Next](@next)
