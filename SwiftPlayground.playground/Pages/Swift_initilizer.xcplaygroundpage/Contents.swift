//: [Previous](@previous)
/*:
  **init: The Standard Initializer**
  
  Let’s Imagine you're opening a new savings account at a bank. The bank needs some basic information: your name and the initial deposit. *This is like the standard init in Swift—it’s the default way to set up an object with all the necessary details.*
  */
import Foundation
import UIKit
import PlaygroundSupport
class BankAccountOne {
    var name: String
    var balance: Double
    
    init(name: String, balance: Double) {
        self.name = name
        self.balance = balance
    }
}
var axisAccount = BankAccountOne(name: "Axis Bank", balance: 10000)
/*:
  **required init: The Must-Have Initializer**
 
  - By enforcing a required initializer, you prevent subclasses from potentially bypassing a critical setup step defined by the superclass. This is crucial for maintaining the integrity and expected behavior of objects within a class hierarchy.
  - Every subclass of a given class must implement that specific initializer
  - Enforcing Consistent Initialization Across Subclasses
  - When Using Protocols with Initializer Requirements
  - Preventing Inconsistent Object Creation
 
  Now, imagine every branch of this bank must have a specific process for opening an account, but it can be slightly different in each branch. However, there’s one rule they all must follow: they need to check your ID. *The required init in Swift is similar. If a class has a required init, any subclass must implement it, ensuring certain initialization steps are always followed.*
  */
/*:
    1st
 */
class Account {
    var id: String = ""
    
//    required init(id: String) {
//        self.id = id
//    }
}

class SavingsAccount: Account {
    var interestRate: Double
    
    init(id: String, interestRate: Double) {
        self.interestRate = interestRate
        super.init(id: id)
    }
    
    required init(id: String) {
        fatalError("init(id:) has not been implemented")
    }
}
var savingsAccount = SavingsAccount(id: "12345", interestRate: 0.05)
/*:
    2nd
 
 **Why setupView() in both?**

 - Custom view can be initialized in two fundamentally different ways:

 **Programmatically:** Using init(frame: CGRect). This happens when you create the view directly in code (e.g., let myView = MyCustomView(frame: .zero)).
 
 **Interface Builder (Storyboard/NIB):** Using required init?(coder: NSCoder). This happens when you drag a UIView onto a Storyboard and change its class to your custom class, or load a NIB file. The system then deserializes the view.
 */
class CustomClass: UIView {
    // 1. Designated Initializer for programmatic creation
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        print("designated init")
        self.backgroundColor = .red
    }
    init() {
        print("designated custom init")
        super.init(frame: CGRect.zero)
    }
    // 2. REQUIRED Initializer for Interface Builder / Deserialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("designated coder init")
        self.backgroundColor = .red
    }
}
PlaygroundPage.current.liveView = CustomClass(title: "my custom class", frame: CGRect(x: 50, y: 50, width: 200, height: 100))
PlaygroundPage.current.needsIndefiniteExecution = true
/*:
  **convenience init: The Shortcut Initializer**
  
  Imagine now that the bank offers a special service: if you don’t want to fill out all the forms, they can automatically fill them in based on your existing account. *This is what a convenience init does. It’s a secondary initializer that provides a shortcut, often filling in default values or calling another initializer to do most of the work.*
  */
class BankAccountTwo {
    var name: String
    var balance: Double
    
    init(name: String, balance: Double) {
        self.name = name
        self.balance = balance
    }
    
    convenience init(name: String) {
        self.init(name: name, balance: 0.0)
    }
}
var iciciAccount = BankAccountTwo(name: "ICICI Bank")
/*:
  **super init: The Inherited Initializer**
  
  Finally, let’s say you’re opening an account at a specific branch, and this branch needs to do everything the main bank does, plus a little extra, like offering you a welcome bonus. The super init is like making sure that the branch’s special steps come after the main bank’s steps.
  
  */
class SpecialAccount: BankAccountTwo {
    var bonus: Double
    
    init(name: String, balance: Double, bonus: Double) {
        self.bonus = bonus
        super.init(name: name, balance: balance + bonus)
    }
}
var hdfcAccount = SpecialAccount(name: "HDFC Bank", balance: 5000, bonus: 1000)
/*:
 **init?: The Failable initializer**
  
 You use a failable initializer (init?) when the initialization of an object might fail or return nil
 
 **Here are the primary scenarios and reasons to use a failable initializer:**
 
 1.Invalid Input or Data:
 a.Parsing External Data:
 b.Numerical Conversions:
 var str = Int("1")
 2.Validation of Initial State (Invariants)
 
 3.Resource Availability or Existence:
 failable initializers (init?) are used in built-in UI-related components in iOS Swift
 
 4.Enforcing Business Logic or Domain Rules:
  */
