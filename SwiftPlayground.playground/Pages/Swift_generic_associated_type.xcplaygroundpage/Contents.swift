//: [Previous](@previous)
/*:
# associatedtype
- Associated types are used in swift protocols to define generic placeholders for the types used within the protocols.
- These placeholders enable protocols to declare requirements without specifying the concrete types themselves.
 */
protocol AppendValue {
	associatedtype item
	var startingValue: item { get set }

	func updateValue(_ value: item)
}

class Addition: AppendValue {
	typealias item = Int
	var startingValue: Int = 1

	func updateValue(_ value: Int) {
		self.startingValue += value
		debugPrint(startingValue)
	}
}
class Append: AppendValue {
	typealias item = [Int]
	var startingValue: [Int] = [1,2,3]

	func updateValue(_ value: [Int]) {
		self.startingValue.append(contentsOf: value)
		debugPrint(startingValue)
	}
}

Addition().updateValue(5) //pass int as param
Append().updateValue([4,5,6]) //pass [int] array as param
//: [Next](@next)
