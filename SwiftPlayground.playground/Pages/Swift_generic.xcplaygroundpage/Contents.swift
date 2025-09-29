import Foundation
/*:
 # Generic

Generic code enables you to write flexible , usable functions and types that can work with any type, subject to requirementsm that you define.

	Generic One
 */
var fristNumber = "suraj"//1.2//5
var secoundNumber = "dhiraj"//5.2//10

func swapTwoValue<T>(_ a: inout T, _ b: inout T) {
	let temp = a
	a = b
	b = temp
}

swapTwoValue(&fristNumber, &secoundNumber)
debugPrint(fristNumber)
debugPrint(secoundNumber)
/*:
	Generic Two
 */
struct Stack<T> {
	var array: [T] = []

	mutating func push(_ item: T) {
		array.append(item)
		debugPrint("push :\(array)")
	}
	mutating func pop() {
		array.removeLast()
		debugPrint("pop :\(array)")
	}
}
var obj = Stack(array: [1,2,3,4,5.1]) //OR var obj = Stack<Double>(array: [1.5,2.5,3.5,4.5,5.5]) //OR var obj = Stack(array: [1.5,2.5,3.5,4.5,5.5])
obj.push(6)
obj.pop()
/*:
 ## Generic Constraints

It's sometimes useful to enforce certain type constraint on the types that can be used with generic functions and generic types. Type constraints specifiy that a type parameter must inherit from a specific class or conform to a perticular protocol composition.

	Generic Constraints One
*/
/*
 protocol ContainerType {
	associatedtype Item
	var items: [Item] { get }
	var count: Int { get }
	mutating func append(_ item: Item)
}
struct Container<T>: ContainerType {
	typealias Item = T
	var count: Int {
		return items.count
	}
	var items: [T]

	mutating func append(_ item: T) {
		items.append(item)
	}
//	func findTheIndex( valueToFind: T) -> Int? where T: Equatable {
//		for (index, value) in items.enumerated() {
//			if value == valueToFind {
//				return index
//			}
//		}
//		return nil
//	}
 }
/*:
 Instead of extension you can also write "findTheIndex" function inside "Container" struct like above commented code.
 */
extension Container /*where T: Equatable*/ { //"T: Equatable" protocol apply for all extension
	func findTheIndex( valueToFind: T) -> Int? where T: Equatable { //"Equatable" protocol apply only for this func
		for (index, value) in items.enumerated() {
			if value == valueToFind { //"Equatable" protocol bacause we have to check value T type
				return index
			}
		}
		return nil
	}
}
extension Container where T: Comparable { //"T: Comparable" protocol apply for all extension
	func max() -> T? /*where T: Comparable*/ { //you can apply here also if you want
		guard items.count > 0 else {
			return nil
		}
		var largest = items[0]
		for item in self.items {
			if largest < item { //"Comparable" protocol bacause we have to compare value T type
				largest = item
			}
		}
		return largest
	}
}
let containerObj = Container(items: [1,2,3,4,5])
debugPrint(containerObj.findTheIndex(valueToFind: 2) ?? 0)
debugPrint(containerObj.max() ?? 0)
 */
/*:
 ## Protocol Composition
 protocol composition is a powerful feature that allows you to combine multiple protocols into a single name. This can be very useful when you want to define a type that needs to adhere to multiple protocols simultaneously.
    
    let's consider above example
*/
typealias ConstraintType = Comparable & Equatable

protocol ContainerType {
	associatedtype Item: ConstraintType
	var items: [Item] { get }
	var count: Int { get }
	mutating func append(_ item: Item)
}
struct Container<T: ConstraintType>: ContainerType {
	typealias Item = T
	var count: Int {
		return items.count
	}
	var items: [T]

	mutating func append(_ item: T) {
		items.append(item)
	}
}

extension Container {
	func findTheIndex( valueToFind: T) -> Int? {
		for (index, value) in items.enumerated() {
			if value == valueToFind {
				return index
			}
		}
		return nil
	}
	func max() -> T? {
		guard items.count > 0 else {
			return nil
		}
		var largest = items[0]
		for item in self.items {
			if largest < item {
				largest = item
			}
		}
		return largest
	}

}
let containerObj = Container(items: [1,2,3,4,5])
let containerObj2 = Container(items: [6,7,8,9,10])
debugPrint(containerObj.findTheIndex(valueToFind: 2) ?? 0)
debugPrint(containerObj.max() ?? 0)
/*:
 ## Where clause
 You can restrict the type using put "where clause"
 */
//extension Container where T == Int {
//	func Avarage() -> T {
//		var sum = 0
//		sum = items.reduce(0, { x, y in
//			x+y
//		})
//		return sum/items.count
//	}
//}
//debugPrint(containerObj.Avarage())
//func merge<container1: ContainerType, container2: ContainerType>(c1: container1, c2: container2) -> any ContainerType where container1.Item == container2.Item {
//	var mergedArray: [container1.Item] = []
//	for item in c1.items {
//		mergedArray.append(item)
//	}
//	for item in c2.items {
//		mergedArray.append(item)
//	}
//	let container = Container(items: mergedArray)
//	return container
//}
//debugPrint(merge(c1: containerObj, c2: containerObj2))
//: [Next](@next)
