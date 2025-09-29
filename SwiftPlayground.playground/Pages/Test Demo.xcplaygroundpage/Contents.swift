////: [Previous](@previous)
//
//import Foundation
//
////class Vehicle {
////	func move() {
////		print("Moving")
////	}
////}
////
////class Car: Vehicle {
////	func honk() {
////		print("Honking")
////	}
////}
////
////class Bicycle: Vehicle {
////	func ringBell() {
////		print("Ringing bell")
////	}
////}
////
////	//USAGE
////let car = Car()
////let bike = Bicycle()
////var vehicle: Vehicle
////
////vehicle = car
////vehicle.move() // Output: "Moving"
////
////vehicle = bike
////vehicle.move() // Output: "Moving"
//
//class Rectangle {
//	var width: Int
//	var height: Int
//
//	init(width: Int, height: Int) {
//		self.width = width
//		self.height = height
//	}
//
//	func area() -> Int {
//		return width * height
//	}
//}
//
//class Square: Rectangle {
//	override var width: Int {
//		didSet {
//			print(self.width)
//			super.height = width
//			print(self.height)
//		}
//	}
//
//	override var height: Int {
//		didSet {
//			print(self.width)
//			super.width = height
//			print(self.height)
//		}
//	}
//}
//
//func main() {
//	let square = Square(width: 5, height: 5)
//
//	square.height
//	square.width
//
//	let rectangle: Rectangle = square
//
//	rectangle.height = 7
//	rectangle.width = 5
//
//	print(square.area())
//		// As a rectangle we should expect the area as 7 x 5 = 35, but we got 5 x 5 = 100
//}
//
//main()
//
////: [Next](@next)



//struct Demo1 {
//	var d1: Bool? = nil
//}
//
//struct Demo2 {
//	var d2: Demo1?
//}
//
//struct Demo3 {
//	var d3: Demo2?
//}
//
//var obj1 = Demo1()
////obj1.d1 = nil
//var obj2 = Demo2()
//obj2.d2 = obj1
//var obj3 = Demo3()
//obj3.d3 = obj2
//let consent_status = obj3.d3?.d2?.d1
//debugPrint(consent_status)

//protocol Test {
//	var str: Test? { get set }
//}
//
//protocol TestOne: Test {
//	var str: TestOne? { get set }
//}

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

//struct Demo: Codable {
//	let name: String?
//	let id: ID?
//}
//
//struct ID: Codable {
//	let number: String?
//}
//
//struct Practice {
//	func setData() {
//		let obj = Demo(name: "suraj", id: ID(number: "1"))
//		let jsonData = try? JSONEncoder().encode(obj)
//		let jsonString = String(data: jsonData!, encoding: .utf8)
//		UserDefaults.standard.set(jsonString, forKey: "Demo")
//		UserDefaults.standard.synchronize()
//	}
//
//	func getData() {
//		if let jsonString = UserDefaults.standard.value(forKey: "Demo") as? String {
//			let jsonData = Data(jsonString.utf8)
//			guard let payload = try? JSONDecoder().decode(Demo.self, from: jsonData) else { return }
//			debugPrint(payload)
//		}
//	}
//}
//
//let p = Practice()
//p.setData()
//p.getData()

//let flag = "REG"
//if (flag != "REG" || flag != "REG1") {
//	print("true")
//}else{
//	print("false")
//}
//
//let flag1 = "REG"
//if (flag1 != "REG" && flag1 != "REG1") {
//	print("true")
//}else{
//	print("false")
//}

//func demo() {
////	var x = 14
////	print(x)
////	var y = x
////	y = 5
////	print(x)
////	print(y)
//    let twoThousand: UInt16 = 2_000
//    let one: UInt8 = 1
//    let twoThousandAndOne = twoThousand + UInt16(one) // Explicit conversion
//    print(twoThousandAndOne)
//}
//
//demo()

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

//runNestedSyncToDifferentQueue()

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






