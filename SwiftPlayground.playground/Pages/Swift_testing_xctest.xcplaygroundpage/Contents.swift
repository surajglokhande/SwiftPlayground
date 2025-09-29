//: [Previous](@previous)
/*:
 ## XCTestCase
 
 **XCTestExpectation** is a crucial tool in XCTest for testing asynchronous code in iOS Swift. When your code performs operations that don't complete immediately (like network requests, animations, or long-running computations), XCTestExpectation allows your test to pause and wait for those asynchronous operations to finish before making assertions.

 **Here's a breakdown of how to use XCTestExpectation:**

 **1. When to use XCTestExpectation:**

 - **Asynchronous callbacks/closures:** When you have a method that takes a completion handler or a callback closure.
 - **Delegate methods:** When an object notifies its delegate asynchronously.
 - **Notification observers:** When your code listens for Notifications.
 - **Any code that doesn't return immediately:** If your function initiates an operation that completes at a later time.
 
 **2. Basic Usage Steps:**

    a. Create an XCTestExpectation:
 */
import XCTest
import Foundation

enum MyCustomError: Error {
    case invalidInput
    case resourceNotFound(filename: String) // Associated value for more info
    case operationFailed(code: Int, message: String)
}
class MyAsyncTests: XCTestCase {

    func testNetworkRequestSuccess() {
        // 1. Create an expectation
        let expectation = XCTestExpectation(description: "Network request completes with data")

        let myNetworkService = MyNetworkService() // Assume you have a service that makes network calls

        // 2. Call your asynchronous code
        myNetworkService.fetchData { result in
            switch result {
            case .success(let data):
                // 3. Fulfill the expectation when the asynchronous operation completes successfully
                XCTAssertNotNil(data, "Data should not be nil")
                // Perform other assertions on the data
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Network request failed with error: \(error.localizedDescription)")
                // If the async operation fails, you still need to fulfill or fail the expectation
                // to prevent the test from timing out.
                expectation.fulfill() // Or use isInverted for failure cases
            }
        }

        // 4. Wait for the expectation to be fulfilled
        // The test will pause here until the expectation is fulfilled or the timeout is reached.
        wait(for: [expectation], timeout: 5.0) // 5-second timeout
    }

    // ... more tests
}
// Example of a simple asynchronous service
class MyNetworkService {
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        // Simulate a network request with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let sampleData = String().data(using: .utf8)
            completion(.failure(MyCustomError.invalidInput))
        }
    }
}
//var obj = MyAsyncTests()
//obj.testNetworkRequestSuccess()
/*:
    b. Handling Multiple Expectations:
    If your test involves multiple asynchronous operations that need to complete, you can create multiple expectations and wait for all of them:
 */
func testMultipleAsyncOperations() {
    let expectation1 = XCTestExpectation(description: "First operation completes")
    let expectation2 = XCTestExpectation(description: "Second operation completes")

    let service = MyService()

    service.performOperation1 {
        // ... assertions for operation 1
        expectation1.fulfill()
    }

    service.performOperation2 {
        // ... assertions for operation 2
        expectation2.fulfill()
    }

    let _ = XCTWaiter().wait(for: [expectation1, expectation2], timeout: 10.0)
}
/*:
    c. expectedFulfillmentCount:
    Sometimes, an expectation might be fulfilled multiple times. You can use expectedFulfillmentCount to specify how many times fulfill() needs to be called for the expectation to be considered met.
 */
func testMultipleCallbacks() {
    let expectation = XCTestExpectation(description: "Receives multiple data chunks")
    expectation.expectedFulfillmentCount = 3 // Expect fulfill to be called 3 times

    let dataStreamer = DataStreamer()
    dataStreamer.startStreaming { chunk in
        // Process chunk
        expectation.fulfill()
    }

    let _ = XCTWaiter().wait(for: [expectation], timeout: 5.0)
}
testMultipleCallbacks()
/*:
    d. isInverted Expectation:
    You can set isInverted = true on an XCTestExpectation if you expect a certain event not to happen. If the inverted expectation is fulfilled, the test will fail.
 */
func testErrorShouldNotOccur() {
    let noErrorExpectation = XCTestExpectation(description: "No error should occur")
    noErrorExpectation.isInverted = true // Expect this to NOT be fulfilled

    let problematicService = ProblematicService()
    problematicService.doSomethingThatMightFail { error in
        if error != nil {
            // If an error occurs, fulfill the inverted expectation, causing the test to fail
            noErrorExpectation.fulfill()
        }
    }

    let _ = XCTWaiter().wait(for: [noErrorExpectation], timeout: 2.0)
}
/*:
    6. XCTWaiter (for more control):
    While wait(for:timeout:) on XCTestCase is convenient, XCTWaiter offers more granular control, especially when you need to handle the result of the wait explicitly (e.g., differentiate between a successful completion and a timeout, or waiting for a single specific expectation).
 */
func testWithXCTWaiter() {
    let expectation = XCTestExpectation(description: "Data loaded")
    let service = MyNetworkService()

    service.fetchData { result in
        expectation.fulfill()
    }

    let result = XCTWaiter().wait(for: [expectation], timeout: 5.0)

    switch result {
    case .completed:
        // Expectation was fulfilled
        XCTAssert(true, "Data loaded successfully")
    case .timedOut:
        XCTFail("Expectation timed out")
    case .interrupted:
        XCTFail("Wait was interrupted")
    case .incorrectOrder:
        XCTFail("Wait was incorrectOrder")
    case .invertedFulfillment:
        XCTFail("Wait was invertedFulfillment")
    @unknown default:
        XCTFail("Unknown XCTWaiter.Result")
    }
}
//: ![](XCTest.jpeg)
//: [Next](@next)
