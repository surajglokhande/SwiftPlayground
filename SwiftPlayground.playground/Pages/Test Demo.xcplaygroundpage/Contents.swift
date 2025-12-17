//: [Previous](@previous)

//import UIKit
//import PlaygroundSupport
//
//class MyViewController : UIViewController {
//	override func loadView() {
//		let view = UIView()
//		view.backgroundColor = .white
//
//		let label = UILabel()
//		label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
//		label.text = "Hello World!"
//		label.textColor = .black
//
//		view.addSubview(label)
//		self.view = view
//	}
//}
//	// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = MyViewController()


import Foundation

let backgroundQueue1 = DispatchQueue(label: "com.example.backgroundQueue1", attributes: .concurrent)
let serialQueueForInnerWork = DispatchQueue(label: "com.example.serialInnerWork")

func runNestedSyncToDifferentQueue() {
    print("[\(Date())] Main Thread: Starting overall process.")

    // Outer Block: Submitted to backgroundQueue1 asynchronously
    backgroundQueue1.async {
        print("[\(Date())] 🔴 Task on backgroundQueue1: Started.")
        Thread.sleep(forTimeInterval: 0.5) // Simulate some work

        print("[\(Date())] 🔴 Task on backgroundQueue1: Submitting inner Task 🔵 synchronously to serialQueueForInnerWork.")

        // Inner Block: Submitted to serialQueueForInnerWork SYNCHRONOUSLY
        serialQueueForInnerWork.sync {
            print("[\(Date())] 🔵 Task on serialQueueForInnerWork: Started.")
            Thread.sleep(forTimeInterval: 1.0) // Simulate more work
            print("[\(Date())] 🔵 Task on serialQueueForInnerWork: Ended.")
        }

        print("[\(Date())] 🔴 Task on backgroundQueue1: Inner task completed. Continuing its own work.")
        Thread.sleep(forTimeInterval: 0.5) // More work on backgroundQueue1
        print("[\(Date())] 🔴 Task on backgroundQueue1: Ended.")
    }

    print("[\(Date())] Main Thread: Outer task submitted. Main thread is free.")

    // Keep the program alive to see all output
    Thread.sleep(forTimeInterval: 3.0)
    print("[\(Date())] Main Thread: Overall process finished.")
}

runNestedSyncToDifferentQueue()
/*:
 Output:
 [2025-11-17 04:43:50 +0000] Main Thread: Starting overall process.
 [2025-11-17 04:43:50 +0000] 🔴 Task on backgroundQueue1: Started.
 [2025-11-17 04:43:50 +0000] Main Thread: Outer task submitted. Main thread is free.
 [2025-11-17 04:43:50 +0000] 🔴 Task on backgroundQueue1: Submitting inner Task 🔵 synchronously to serialQueueForInnerWork.
 [2025-11-17 04:43:50 +0000] 🔵 Task on serialQueueForInnerWork: Started.
 [2025-11-17 04:43:51 +0000] 🔵 Task on serialQueueForInnerWork: Ended.
 [2025-11-17 04:43:51 +0000] 🔴 Task on backgroundQueue1: Inner task completed. Continuing its own work.
 [2025-11-17 04:43:52 +0000] 🔴 Task on backgroundQueue1: Ended.
 [2025-11-17 04:43:53 +0000] Main Thread: Overall process finished.
 */

struct MonetaryAmount: Equatable { // struct by default promotes value semantics
    let amount: Decimal
    let currencyCode: String

    // Custom initializer for validation or specific creation
    init?(amount: Decimal, currencyCode: String) {
        guard amount >= 0 else { return nil } // Example validation
        self.amount = amount
        self.currencyCode = currencyCode.uppercased()
    }

    // Example of behavior on the Value Object
    func add(_ other: MonetaryAmount) -> MonetaryAmount? {
        guard self.currencyCode == other.currencyCode else { return nil } // Must be same currency
        return MonetaryAmount(amount: self.amount + other.amount, currencyCode: self.currencyCode)
    }
}

// Usage
let priceA = MonetaryAmount(amount: 19.99, currencyCode: "USD")!
let priceB = MonetaryAmount(amount: 19.99, currencyCode: "USD")!
let tax = MonetaryAmount(amount: 1.50, currencyCode: "USD")!

print(priceA == priceB) // Output: true (they are equal by value)

if let total = priceA.add(tax) {
    print("Total price: \(total.amount) \(total.currencyCode)")
}
// Output: Total price: 21.49 USD
//: [Next](@next)
