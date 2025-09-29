//: [Previous](@previous)
/*:
 - When you want to use an existing class, but its interface doesn't match the one you need.
 - When you want to create a reusable class that cooperates with other unrelated classes, or classes that don't necessarily have compatible interfaces.
 - When interacting with external classes, such as third-party libraries, frameworks, or modules, we utilize the Adapter pattern in iOS Swift to ensure seamless integration and compatibility.
 - When you want to adapt an interface to multiple existing hierarchies.
 */
/*:
    Example One
 */
import Foundation
// famework code
class SDKClass {
    func shareSDK(analytics: String) {
        print(analytics)
    }
}

//your code
protocol AdaptorProtocol {
    func sendYour(analytics: String)
}
class YourClass: AdaptorProtocol {
    var sdkObject: SDKClass?
    
    init(sdkClass: SDKClass) {
        self.sdkObject = sdkClass
    }
    
    func sendYour(analytics: String) {
        self.sdkObject?.shareSDK(analytics: analytics)
    }
}

let yourObj: AdaptorProtocol = YourClass(sdkClass: SDKClass())
yourObj.sendYour(analytics: "launchedEvents")
/*:
    Example Two
 */
// MARK: - Target Interface

protocol PaymentGateway {
    func processPayment(amount: Double) -> Bool
    func refundPayment(transactionId: String) -> Bool
}
// MARK: - Adaptee (Incompatible Service)

class StripeService {
    func makeCharge(totalAmount: Double) -> Bool {
        print("Stripe: Initiating charge for $\(totalAmount)...")
        // Simulate complex Stripe API calls
        if totalAmount > 0 {
            print("Stripe: Charge successful!")
            return true
        } else {
            print("Stripe: Charge failed - invalid amount.")
            return false
        }
    }

    func processRefund(chargeId: String) -> Bool {
        print("Stripe: Processing refund for charge ID: \(chargeId)...")
        // Simulate complex Stripe API calls for refund
        if !chargeId.isEmpty {
            print("Stripe: Refund successful!")
            return true
        } else {
            print("Stripe: Refund failed - invalid charge ID.")
            return false
        }
    }
}
class PayPalService {
    func executePayment(price: Double) -> Bool {
        print("PayPal: Executing payment for $\(price)...")
        // Simulate complex PayPal API calls
        if price > 0 {
            print("PayPal: Payment successful!")
            return true
        } else {
            print("PayPal: Payment failed - invalid price.")
            return false
        }
    }

    func issueRefund(id: String) -> Bool {
        print("PayPal: Issuing refund for ID: \(id)...")
        // Simulate complex PayPal API calls for refund
        if !id.isEmpty {
            print("PayPal: Refund issued successfully!")
            return true
        } else {
            print("PayPal: Refund failed - invalid ID.")
            return false
        }
    }
}
// MARK: - Adapter

class StripeAdapter: PaymentGateway {
    private let stripeService: StripeService
    private var lastTransactionId: String = "" // For demonstration, Stripe might return an ID

    init(stripeService: StripeService) {
        self.stripeService = stripeService
    }

    func processPayment(amount: Double) -> Bool {
        let success = stripeService.makeCharge(totalAmount: amount)
        if success {
            // In a real scenario, Stripe would return a transaction ID
            self.lastTransactionId = UUID().uuidString
            print("StripeAdapter: Payment processed. Generated transaction ID: \(lastTransactionId)")
        }
        return success
    }

    func refundPayment(transactionId: String) -> Bool {
        return stripeService.processRefund(chargeId: transactionId)
    }
}

class PayPalAdapter: PaymentGateway {
    private let payPalService: PayPalService
    private var lastTransactionId: String = ""

    init(payPalService: PayPalService) {
        self.payPalService = payPalService
    }

    func processPayment(amount: Double) -> Bool {
        let success = payPalService.executePayment(price: amount)
        if success {
            self.lastTransactionId = UUID().uuidString
            print("PayPalAdapter: Payment processed. Generated transaction ID: \(lastTransactionId)")
        }
        return success
    }

    func refundPayment(transactionId: String) -> Bool {
        return payPalService.issueRefund(id: transactionId)
    }
}
// MARK: - Client Code

class ShoppingCart {
    private var paymentGateway: PaymentGateway

    init(paymentGateway: PaymentGateway) {
        self.paymentGateway = paymentGateway
    }

    func checkout(itemPrice: Double) {
        print("\nShoppingCart: Initiating checkout for $\(itemPrice)...")
        if paymentGateway.processPayment(amount: itemPrice) {
            print("ShoppingCart: Payment successful! Order placed.")
            // In a real app, you'd store the transaction ID for refunds
            // For simplicity, we'll just use a dummy ID for the next step if needed
            let dummyTransactionId = "TRN-\(UUID().uuidString.prefix(8))"
            print("ShoppingCart: Dummy transaction ID for potential refund: \(dummyTransactionId)")
            
            // Example of a refund (not tied to the exact payment, but demonstrates functionality)
            if Bool.random() { // Randomly attempt a refund for demonstration
                print("\nShoppingCart: Deciding to issue a test refund for \(dummyTransactionId)...")
                if paymentGateway.refundPayment(transactionId: dummyTransactionId) {
                    print("ShoppingCart: Test refund successful for \(dummyTransactionId).")
                } else {
                    print("ShoppingCart: Test refund failed for \(dummyTransactionId).")
                }
            }
        } else {
            print("ShoppingCart: Payment failed. Please try again.")
        }
    }
}

// --- Usage ---

print("--- Using Stripe ---")
let stripeService = StripeService()
let stripeAdapter = StripeAdapter(stripeService: stripeService)
let stripeCart = ShoppingCart(paymentGateway: stripeAdapter)
stripeCart.checkout(itemPrice: 99.99)
stripeCart.checkout(itemPrice: -10.00) // Test failure case

print("\n--- Using PayPal ---")
let payPalService = PayPalService()
let payPalAdapter = PayPalAdapter(payPalService: payPalService)
let payPalCart = ShoppingCart(paymentGateway: payPalAdapter)
payPalCart.checkout(itemPrice: 250.00)
//: [Next](@next)
