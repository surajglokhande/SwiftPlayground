//: [Previous](@previous)
/*:
# Opaquetype
 - Opaque types allow you to describe the expected return type without defining a concrete type.
 - They hide the implementation details and expose only the behavior that complies with the protocol.
 - They help improve the type safety of your Swift code.
 - They allow you to use generic code and still return specific types.
 - **Some** keyword is used for opaque types, where the concrete type conforming to the protocol is hidden, prefer some for static dispatch and type safety.
 - **any** is used for existential types, which can hold any concrete type conforming to the protocol. Generally, any for dynamic, heterogeneous collections or when you need to erase type information.
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
//func getAddition() -> some AppendValue /*OR any AppendValue*/ {
//	return Addition()
//}
//func getAppend() -> some AppendValue /*OR any AppendValue*/ {
//	return Append()
//}
func setAddition( type: any AppendValue) {
	if let obj = type as? Addition {
		obj.updateValue(2)
	}
	debugPrint(type.startingValue)
}
setAddition(type: Addition())
func setAppend( type: some AppendValue) {
    if let obj = type as? Append {
        obj.updateValue([1,2])
    }
	debugPrint(type.startingValue)
}
setAppend(type: Append())
/*:
	Opaquetype
*/
protocol AnimalFeed { }
struct Grass: AnimalFeed { }
struct Meat: AnimalFeed { }
protocol Animal {
	associatedtype feedType: AnimalFeed

	var name: String { get set }
	func eat(_ food: feedType)
}
struct Lion: Animal {
	typealias feedType = Meat
	var name: String
	func eat(_ food: Meat) {
		debugPrint("\(String(describing: self.name)) eats")
	}
}
struct Chicken: Animal {
	typealias feedType = Grass
	var name: String
	func eat(_ food: Grass) {
		debugPrint("\(String(describing: self.name)) eats")
	}
}
struct Cow: Animal {
	typealias feedType = Grass
	var name: String
	func eat(_ food: Grass) {
		debugPrint("\(String(describing: self.name)) eats")
	}
}
func feedGeneric<T: Animal>(_ animal: T) { // Generic
	debugPrint(animal.name)
}
func feedWithSome(_ animal: some Animal) { // pass some as param
	debugPrint(animal.name)
}
func feedWithSome() -> some Animal { // return some
	return Chicken(name: "chicken")
}

let l = Lion(name: "lion")
l.eat(Meat())
feedGeneric(l)
feedWithSome(l)
feedWithSome()

var arrayOne: [any Animal] = [Chicken(name: ""), Lion(name: ""), Cow(name: "")]
var arrayTwo: [some Animal] = [Chicken(name: ""), Chicken(name: ""), Chicken(name: "")]
//var arrayThree: [some Animal] = [Chicken(name: ""), Lion(name: ""), Cow(name: "")]// error
/*:
	Showing no error in getAddition() and getAppend() because we dont used associatedtype type so no used of Opaquetype
 */
protocol AppendValueAnother {
	//associatedtype item
	var startingValue: Int { get set }
	func updateValue(_ value: Int)
}

class AdditionAnother: AppendValueAnother {
	//typealias item = Int
	var startingValue: Int = 1
	func updateValue(_ value: Int) {
		self.startingValue += value
		debugPrint(startingValue)
	}
}
class AppendAnother: AppendValueAnother {
	//typealias item = Int
	var startingValue: Int = 1
	func updateValue(_ value: Int) {
		self.startingValue += value
		debugPrint(startingValue)
	}
}

func getAddition() -> any/*optional*/ AppendValueAnother {
	return AdditionAnother()
}
func getAppend() -> some/*optional*/ AppendValueAnother {
	return AppendAnother()
}
getAddition().updateValue(2)
getAppend().updateValue(3)
func setAddition( type: any/*optional*/ AppendValueAnother) {
	debugPrint(type.updateValue(2))
	debugPrint(type.startingValue)
}
func setAppend( type: some/*optional*/ AppendValueAnother) {
	debugPrint(type.updateValue(2))
	debugPrint(type.startingValue)
}
setAddition(type: Addition())
setAppend(type: Append())
//: [Next](@next)
