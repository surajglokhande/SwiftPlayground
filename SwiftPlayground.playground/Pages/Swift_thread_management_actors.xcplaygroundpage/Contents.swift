//: [Previous](@previous)
/*:
 ## Actors
 
 - Used for safely managing shared mutable state.
 - An actor is like a "single-threaded island." It encapsulates its own mutable state, and all interactions with that state must go through the actor.
 - Only one task can modify its state at a time. This prevents race conditions on the actor's internal data.
 - Calling methods on an actor from outside is implicitly async and awaited, ensuring that the caller waits for the actor to process the request
 
 - **Encapsulation:** An actor encapsulates its own internal state (properties) and behavior (methods).
 - **Isolation:** Actor ensures that its internal state can only be accessed and modified by its own methods.
 - **Message Passing (Implicit):** Instead of direct access, other parts of your code communicate with an actor by sending it "messages" (calling its methods). The actor processes these messages one at a time, sequentially, even if multiple messages arrive concurrently. This sequential processing is what guarantees thread safety.
 - **Reentrancy:** Swift actors are reentrant by default. This means that if an await point is encountered within an actor's method, the actor can temporarily suspend its current operation and process other incoming messages. Once the awaited operation completes, the actor resumes its original task. This prevents deadlocks and improves responsiveness.
 - **No Inheritance:** Unlike classes, actors do not support inheritance. This simplifies their concurrency model and avoids complexities associated with shared mutable state across an inheritance hierarchy.
 */
/*:
 Without an Actor (Problematic):
 */
import Foundation
class UnsafeCounter {
    var count: Int = 0
    
    func increment() {
        count += 1 // This is a data race if called concurrently
    }
}

func demonstrateUnsafeCounter() async {
    let unsafeCounter = UnsafeCounter()
    
    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<1000 {
            group.addTask {
                unsafeCounter.increment()
            }
        }
    }
    
    print("UnsafeCounter final count: \(unsafeCounter.count)") // Will likely be less than 1000 due to data races
}
// To run this, you would put it inside an async context, e.g.:
// Task {
//     await demonstrateUnsafeCounter()
// }
//Output:
//UnsafeCounter final count: 1000
/*:
 With an Actor (Thread-Safe Solution):
 */
actor SafeCounter {
    var count: Int = 0
    
    func increment() {
        count += 1
    }
    
    func currentCount() -> Int {
        return count
    }
}

func demonstrateSafeCounter() async {
    let safeCounter = SafeCounter()
    
    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<1000 {
            group.addTask {
                await safeCounter.increment() // Note the 'await'
            }
        }
    }
    
    let finalCount = await safeCounter.currentCount() // Note the 'await'
    print("SafeCounter final count: \(finalCount)") // Will reliably be 1000
}

// To run this, you would put it inside an async context, e.g.:
//Task {
//    await demonstrateSafeCounter()
//}
//Output:
//SafeCounter final count: 1000
/*:
 Another Program
 */
actor BankAccount {
    let accountNumber: Int
    var balance: Double
    
    init(accountNumber: Int, initialDeposit: Double) {
        self.accountNumber = accountNumber
        self.balance = initialDeposit
    }
    
    func deposit(amount: Double) {
        balance += amount
    }
    
    func withdraw(amount: Double) throws {
        guard balance >= amount else {
            throw BankError.insufficientFunds
        }
        balance -= amount
    }
    
    func getBalance() -> Double {
        return balance
    }
}
enum BankError: Error {
    case insufficientFunds
}
let myAccount = BankAccount(accountNumber: 12345, initialDeposit: 100.0)

//reentrant
//print(myAccount.accountNumber) // No await needed for immutable 'let' properties
//Output:
//Current balance: 150.0
//Not enough funds!
//12345
/*:
 Another Example of Actor
 */
// MARK: - Simple Test Harness for Playground

/// A basic function to run a test and print its result.
/// This simulates a test case for a Playground environment.
func runTest(named testName: String, _ testBlock: @escaping () async -> Bool) async {
    print("--- Running Test: \(testName) ---")
    let success = await testBlock()
    if success {
        print("✅ PASSED: \(testName)")
    } else {
        print("❌ FAILED: \(testName)")
    }
    print("----------------------------------\n")
}

// MARK: - Concurrent Counter Implementations

/// Represents a counter that is NOT thread-safe.
/// Multiple concurrent access attempts will likely lead to a race condition.
class UnsafeCounterOne {
    var count: Int = 0

    /// Increments the counter. This operation is not atomic.
    func increment() {
        // Simulate some work or context switching that could lead to a race condition
        let currentCount = count
        // A very small delay to increase the chance of race condition in Playground
        // In real-world, this happens without explicit delays.
        // Thread.sleep(forTimeInterval: 0.000001)
        count = currentCount + 1
        //print("UnsafeCounterOne count: \(count)")
    }
}

/// Represents a counter that IS thread-safe using Swift's `actor`.
/// Actors ensure that mutable state within them is accessed serially, preventing race conditions.
actor SafeCounterOne {
    var count: Int = 0

    /// Increments the counter. Because this is an `actor`, this method is implicitly isolated
    /// and ensures that only one task can modify `count` at a time.
    func increment() {
        count += 1
        //print("SafeCounterOne count: \(count)")
    }

    /// A synchronous method to get the current count.
    /// This is necessary because `count` itself is part of the actor's isolated state.
    func currentCount() -> Int {
        return count
    }
}

// MARK: - Concurrency Test Cases

/// Test case for the `UnsafeCounter` to demonstrate a race condition.
/// We expect this test to fail (i.e., the final count will not be 10,000) due to concurrent updates.
func testUnsafeCounterConcurrency() async -> Bool {
    let unsafeCounter = UnsafeCounterOne()
    let numberOfIncrements = 10_000
    let numberOfTasks = 100 // Spawning multiple tasks

    // Create an array of tasks that will concurrently increment the counter
    var tasks: [Task<Void, Never>] = []
    for _ in 0..<numberOfTasks {
        let task = Task {
            // Each task will increment the counter multiple times
            for _ in 0..<(numberOfIncrements / numberOfTasks) {
                unsafeCounter.increment()
            }
        }
        tasks.append(task)
    }

    // Wait for all tasks to complete
    for task in tasks {
        await task.value // Await each task to ensure completion
    }

    // Check if the final count is as expected
    // Due to race conditions, it's highly probable this will NOT be true.
    let expectedCount = numberOfIncrements
    let finalCount = unsafeCounter.count
    print("Unsafe Counter: Expected \(expectedCount), Got \(finalCount)")

    return finalCount == expectedCount
}

/// Test case for the `SafeCounter` (actor) to demonstrate thread safety.
/// We expect this test to pass (i.e., the final count will be 10,000) because the actor handles concurrency safely.
func testSafeCounterConcurrency() async -> Bool {
    let safeCounter = SafeCounterOne()
    let numberOfIncrements = 10_000
    let numberOfTasks = 100 // Spawning multiple tasks

    // Create an array of tasks that will concurrently increment the actor's counter
    var tasks: [Task<Void, Never>] = []
    for _ in 0..<numberOfTasks {
        let task = Task {
            // Each task will increment the actor's counter multiple times
            // The `await` keyword is crucial here because `increment()` is an async actor method.
            for _ in 0..<(numberOfIncrements / numberOfTasks) {
                await safeCounter.increment()
            }
        }
        tasks.append(task)
    }

    // Wait for all tasks to complete
    for task in tasks {
        await task.value // Await each task to ensure completion
    }

    // Check if the final count is as expected.
    // Because `currentCount()` is an async actor method, we must `await` it.
    let expectedCount = numberOfIncrements
    let finalCount = await safeCounter.currentCount()
    print("Safe Counter: Expected \(expectedCount), Got \(finalCount)")

    return finalCount == expectedCount
}

// MARK: - Run All Tests

// The top-level code in a Swift Playground implicitly runs in an asynchronous context
// if it contains `await` calls.
//Task {
//    await runTest(named: "Unsafe Counter Race Condition Test", testUnsafeCounterConcurrency)
//    await runTest(named: "Safe Counter (Actor) Concurrency Test", testSafeCounterConcurrency)
//}

/*
Expected Output in the Playground Console (the 'Unsafe' test might vary slightly but will likely fail):

--- Running Test: Unsafe Counter Race Condition Test ---
Unsafe Counter: Expected 10000, Got 9978 // This number will likely be less than 10000 and vary
❌ FAILED: Unsafe Counter Race Condition Test
----------------------------------

--- Running Test: Safe Counter (Actor) Concurrency Test ---
Safe Counter: Expected 10000, Got 10000
✅ PASSED: Safe Counter (Actor) Concurrency Test
----------------------------------
*/
/*:
 Example to reentrant
 */
enum DownloadError: Error {
    case invalidURL
    case downloadFailed
    case alreadyDownloading
}

actor DownloadManager {
    private var activeDownloads: [URL: Task<Data, Error>] = [:]
    
    func startDownload(url: URL) async throws -> Data {
        // 1. Check if already downloading (actor's isolated state)
        if activeDownloads[url] != nil {
            throw DownloadError.alreadyDownloading
        }
        
        print(" DownloadManager: Starting download for \(url.lastPathComponent)")
        
        // 2. Create a Task for the download and store it
        let downloadTask = Task {
            // Simulate a network request
            try await Task.sleep(nanoseconds: UInt64.random(in: 1_000_000_000...3_000_000_000)) // Simulate 1-3 second network delay
            if url.lastPathComponent == "error.txt" {
                throw DownloadError.downloadFailed
            }
            let data = "Simulated data for \(url.lastPathComponent)".data(using: .utf8)!
            print(" DownloadManager: Finished simulated download for \(url.lastPathComponent)")
            return data
        }
        print("activeDownloads[url] = downloadTask")
        activeDownloads[url] = downloadTask
        
        do {
            // 3. AWAIT POINT: The actor's execution for this 'startDownload' method suspends here.
            //    During this suspension, the actor is FREE to process other messages!
            let data = try await downloadTask.value
            activeDownloads[url] = nil // Remove from active downloads
            print(" DownloadManager: Download for \(url.lastPathComponent) completed and removed from active.")
            return data
        } catch {
            activeDownloads[url] = nil // Ensure cleanup even on error
            print(" DownloadManager: Download for \(url.lastPathComponent) failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func isDownloading(url: URL) -> Bool {
        return activeDownloads[url] != nil
    }
    
    // A method to simulate a quick check
    func getStatus(for url: URL) -> String {
        if isDownloading(url: url) {
            return "Downloading"
        } else {
            return "Not Downloading"
        }
    }
}
struct ReentrancyExample {
    static func main() async {
        let manager = DownloadManager()
        
        let url1 = URL(string: "https://sample-files.com/downloads/documents/pdf/sample-pdf-a4-size-65kb.pdf")!
        let url2 = URL(string: "https://sample-files.com/downloads/documents/pdf/sample-pdf-a4-size.pdf")!
        //let url3 = URL(string: "https://sample-files.com/downloads/documents/pdf/sample-text-only-pdf-a4-size.pdf")!
        
        print("--- Starting Downloads ---")
        
        // Task 1: Start download for file1.txt
        Task {
            do {
                print(" Task 1: Requesting download for file1.txt")
                let data = try await manager.startDownload(url: url1)
                print(" Task 1: Downloaded \(String(data: data, encoding: .utf8)!)")
            } catch {
                print(" Task 1: Error downloading file1.txt: \(error.localizedDescription)")
            }
        }
        
        // Give Task 1 a moment to start and hit its await point
        print("Give Task 1 a moment to start and hit its await point")
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        // Task 2: Start download for file2.txt - This will run concurrently!
        Task {
            do {
                print(" Task 2: Requesting download for file2.txt")
                let data = try await manager.startDownload(url: url2)
                print(" Task 2: Downloaded \(String(data: data, encoding: .utf8)!)")
            } catch {
                print(" Task 2: Error downloading file2.txt: \(error.localizedDescription)")
            }
        }
        
        // Task 3: Immediately check status of file1.txt - This demonstrates the actor
        //         being available while Task 1 is suspended.
        Task {
            print(" Task 3: Checking status of file1.txt while it's theoretically 'awaiting'")
            let status = await manager.getStatus(for: url1) // Quick, non-suspending call
            print(" Task 3: Status of file1.txt: \(status)")
        }
        
        // Wait for all tasks to potentially finish
        try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds to let things complete
        print("--- All tasks complete or timed out ---")
    }
}
//Task {
//    await ReentrancyExample.main()
//}
//Output:
//--- Starting Downloads ---
// Task 1: Requesting download for file1.txt
// DownloadManager: Starting download for sample-pdf-a4-size-65kb.pdf
// Task 2: Requesting download for file2.txt
// Task 3: Checking status of file1.txt while it's theoretically 'awaiting'
// DownloadManager: Starting download for sample-pdf-a4-size.pdf
// Task 3: Status of file1.txt: Downloading
// DownloadManager: Finished simulated download for sample-pdf-a4-size.pdf
// DownloadManager: Finished simulated download for sample-pdf-a4-size-65kb.pdf
// DownloadManager: Download for sample-pdf-a4-size.pdf completed and removed from active.
// Task 2: Downloaded Simulated data for sample-pdf-a4-size.pdf
// DownloadManager: Download for sample-pdf-a4-size-65kb.pdf completed and removed from active.
// Task 1: Downloaded Simulated data for sample-pdf-a4-size-65kb.pdf
//--- All tasks complete or timed out ---

actor Logger {
    private var messageBuffer: [String] = []
    private var uploadCount = 0
    
    // Method to add a log message
    func log(_ message: String) {
        messageBuffer.append("[\(Date())] \(message)")
        print("Logger: Added message: \(message)")
    }
    
    // Method to simulate uploading logs
    func uploadLogs() async {
        guard !messageBuffer.isEmpty else {
            print("Logger: No messages to upload.")
            return
        }
        
        let logsToUpload = messageBuffer
        messageBuffer = [] // Clear buffer after taking logs
        
        print("Logger: Starting upload of \(logsToUpload.count) messages. (Upload #\(uploadCount + 1))")
        
        // --- AWAIT POINT BEGINS ---
        // Simulate a network upload that takes a few seconds
        // The actor will suspend here, making itself available for other tasks.
        do {
            try await Task.sleep(nanoseconds: UInt64(2 * 1_000_000_000)) // Simulate 2-second upload
            print("Logger: Successfully uploaded \(logsToUpload.count) messages. (Upload #\(uploadCount + 1))")
            uploadCount += 1
        } catch {
            print("Logger: Upload interrupted or failed: \(error.localizedDescription)")
            // In a real app, you might re-add logs to buffer or handle differently
            messageBuffer.append(contentsOf: logsToUpload) // Put them back if upload failed
        }
        // --- AWAIT POINT ENDS ---
        
        print("Logger: UploadLogs method completed.")
    }
    
    // Method to get current buffer size - a quick, synchronous operation
    func getBufferSize() -> Int {
        return messageBuffer.count
    }
    
    // Method to get upload count - a quick, synchronous operation
    func getUploadCount() -> Int {
        return uploadCount
    }
}
struct ReentrancyDemo {
    static func main() async {
        let logger = Logger()
        
        print("--- Scenario Start ---")
        
        // Task 1: Start a log upload
        Task {
            print("[Task 1] Calling uploadLogs...")
            await logger.uploadLogs()
            print("[Task 1] uploadLogs finished.")
        }
        
        // Give Task 1 a moment to start and hit its 'await' point
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Task 2: Log several messages *while Task 1 is suspended in uploadLogs*
        Task {
            print("[Task 2] Logging messages while upload is theoretically ongoing...")
            await logger.log("User logged in.")
            await logger.log("Item added to cart.")
            await logger.log("User clicked 'Checkout'.")
            print("[Task 2] Finished logging messages.")
        }
        
        // Task 3: Periodically check the logger's buffer size and upload count
        Task {
            print("[Task 3] Starting periodic status checks...")
            for i in 1...3 {
                try? await Task.sleep(nanoseconds: UInt64(0.8 * 1_000_000_000)) // Check every 0.8 seconds
                let bufferSize = await logger.getBufferSize()
                let uploads = await logger.getUploadCount()
                print("[Task 3] Check #\(i): Buffer size: \(bufferSize), Uploads completed: \(uploads)")
            }
            print("[Task 3] Finished periodic checks.")
        }
        
        // Keep the main task alive long enough for everything to complete
        try? await Task.sleep(nanoseconds: UInt64(5 * 1_000_000_000)) // Wait 5 seconds
        print("--- Scenario End ---")
    }
}
//Task {
//    await ReentrancyDemo.main()
//}

/*:
 **Key Benefits of Actors:**
 
 - **Automatic Data Race Prevention:** You don't need to manually use locks, mutexes, or semaphores. The actor model handles this complexity for you.
 - **Simplified Concurrency Reasoning:** By encapsulating mutable state, actors make it easier to reason about the flow of data and avoid unexpected side effects in concurrent code.
 - **Improved Code Clarity:** The explicit await when interacting with an actor clearly indicates that you are crossing an isolation boundary and potentially waiting for an operation to complete.
 - **Reentrancy:** As mentioned, actors are reentrant, preventing common deadlock scenarios that can plague other concurrency models.
 
 **When to Use Actors:**
 
 Whenever you have mutable shared state that needs to be accessed or modified by multiple concurrent tasks.
 For managing caches, shared resources (like network connections or databases), or central data stores in your application.
 To implement the "active object" pattern, where an object has its own thread of control.
 
 In Swift's concurrency model, the nonisolated and isolated keywords are used to explicitly manage actor isolation and interactions, providing more fine-grained control over how parts of an actor or functions interacting with actors behave.
 
 Let's break them down:
 
 ## 1. nonisolated Keyword
 
 The nonisolated keyword is used within an actor to mark properties or methods that do not require actor isolation. This means they can be accessed synchronously from outside the actor without using await.
 
 **Why would you use nonisolated?**
 
 - **Are immutable (let properties):** Since a let property cannot be changed after initialization, there's no risk of a data race when multiple concurrent tasks read its value. Allowing direct access avoids unnecessary await calls.
 */
actor User {
    let id: UUID // Immutable property
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    nonisolated var userId: UUID { // Marked as nonisolated
        return id // Can access 'id' because it's immutable
    }
    
    func updateName(newName: String) { // This is an isolated method
        self.name = newName
    }
}

let user = User(id: UUID(), name: "Alice")
let userIdValue = user.userId // No await needed for nonisolated let property
//print(userIdValue)
// await user.updateName(newName: "Bob") // Await needed for isolated var or method
/*:
 - **Do not access or modify any mutable isolated state of the actor:** If a method performs an operation that doesn't involve the actor's var properties or doesn't call other isolated methods, it doesn't need to be protected by actor isolation.
 */
actor MathActor {
    private var calculationCount: Int = 0 // Isolated state
    
    // This method is nonisolated because it doesn't touch calculationCount
    // and doesn't call other isolated methods.
    nonisolated func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    func incrementCalculationCount() { // This is an isolated method
        calculationCount += 1
    }
}

let mathActor = MathActor()
let sum = mathActor.add(5, 3) // No await needed for nonisolated method
//print(sum)
// await mathActor.incrementCalculationCount() // Await needed
/*:
 - **Conform to non-Sendable protocols (with caution):** Sometimes you might need an actor to conform to a protocol whose requirements involve types that are not Sendable. If you mark the conformance as nonisolated, it indicates that the protocol methods will not access isolated state, but it implies that these methods might not be thread-safe in a general context, so use with extreme care.
 
 ## 2. isolated Keyword
 
 The isolated keyword is used in function or closure parameter lists to declare that a parameter refers to an actor instance and that the function/closure body will execute within the isolation context of that actor.
 
 **Why would you use isolated?**
 
 - To avoid await when passing an actor into a function/closure: Normally, if you pass an actor instance to a regular async function, any calls to its isolated members inside that function would still require await. By marking the actor parameter as isolated, you tell the compiler that the function body effectively "borrows" the actor's isolation, allowing synchronous access to its isolated state.
 
 - For safer, optimized actor interactions: It's a way to explicitly state that a particular piece of code is running on or within the context of a specific actor, giving it privileged synchronous access.
 */
/*:
 Eaxmple of isolated
 */
actor BankAccountOne {
    var balance: Double
    
    init(initialBalance: Double) {
        self.balance = initialBalance
    }
    
    func deposit(amount: Double) {
        balance += amount
        print("Deposited \(amount). New balance: \(balance)")
    }
    
    func withdraw(amount: Double) {
        if balance >= amount {
            balance -= amount
            print("Withdrew \(amount). New balance: \(balance)")
        } else {
            print("Insufficient funds to withdraw \(amount).")
        }
    }
    
    // A method to perform multiple operations *within* the actor's isolation
    func performTransactions(transactions: [(type: String, amount: Double)]) {
        for transaction in transactions {
            if transaction.type == "deposit" {
                deposit(amount: transaction.amount)
            } else if transaction.type == "withdraw" {
                withdraw(amount: transaction.amount)
            }
        }
    }
}

// Function that takes an 'isolated' BankAccount parameter
// This function itself is not an actor, but it operates *on* the bank account
// within the bank account's isolation domain.
func processAccountTransactions(
    for account: isolated BankAccountOne, // 'account' is an isolated parameter
    operations: [(type: String, amount: Double)]
) {
    // Inside this function, we can directly call isolated methods on 'account'
    // without using 'await' because this function is now "isolated to" 'account'.
    print("Processing transactions for account...")
    account.performTransactions(transactions: operations) // No await here!
    print("Finished processing transactions.")
}

struct IsolatedKeywordDemo {
    static func main() async {
        let myAccount = BankAccountOne(initialBalance: 100.0)
        
        // Call the function passing the actor.
        // We still need 'await' *here* because the call to 'processAccountTransactions'
        // is coming from a non-isolated context.
        await processAccountTransactions(
            for: myAccount,
            operations: [
                ("deposit", 50.0),
                ("withdraw", 20.0),
                ("deposit", 10.0)
            ]
        )
        
        let finalBalance = await myAccount.balance // Accessing isolated var from outside requires await
        print("Final balance: \(finalBalance)")
        
        // Example of direct interaction requiring await:
        // await myAccount.deposit(amount: 200)
    }
}
Task {
    await IsolatedKeywordDemo.main()
}
//Output:
//Processing transactions for account...
//Deposited 50.0. New balance: 150.0
//Withdrew 20.0. New balance: 130.0
//Deposited 10.0. New balance: 140.0
//Finished processing transactions.
//Final balance: 140.0
/*:
 **Practical Use Cases for isolated:**
 
 - **Helper functions:** When you have a complex sequence of operations that need to be performed on an actor, defining a helper function that takes the actor as an isolated parameter can clean up code and avoid repetitive awaits.
 
 - **Bridging to non-async code (with caution):** In very specific scenarios, you might use isolated to pass an actor into a closure that's called from non-async code, but this often requires careful consideration to avoid deadlocks or blocking the actor's executor. This is generally a more advanced pattern and not recommended for typical use.
 
 In summary, nonisolated declares that a part of an actor is not protected by its isolation, while isolated declares that a function/closure is operating within the isolation context of a specific actor instance. Both keywords are powerful tools for managing concurrency and actor behavior in Swift.
 */
//: [Next](@next)
