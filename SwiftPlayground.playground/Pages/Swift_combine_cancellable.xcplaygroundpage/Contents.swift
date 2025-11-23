//: [Previous](@previous)
/*:
 ## Cancellable
 - **AnyCancellable** is a type-erasing cancellable object that automatically calls cancel() when deinitialized
 - **Automatic Cancellation**
    - Calls cancel() automatically when deinitialized
    - Helps prevent memory leaks
    - Ensures proper cleanup of resources
 - **Manual cancellation is NOT required for:**
    - Local scope subscriptions
    - Simple class properties that will be cleaned up on deinit
 - **Manual cancellation is recommended for:**
    - Early cancellation requirements (user-initiated cancellation)
    - Resource-intensive operations
    - Clear state management
    - Multiple subscription scenarios
 - **Best Practices:**
    - Store cancellable as a property if subscription should persist
    - Use explicit cancellation when immediate resource cleanup is needed
    - Cancel existing subscription before creating a new one
    - Set to nil after cancellation for clear state management
 - **.store(in: cancellable)**
    - **Required:** When managing multiple subscriptions in a Set
    - **Optional:** For single subscriptions stored in a property
    - **Recommended:** For better code organization and maintenance
 */
import Foundation
import Combine
class ViewModel {
    // Single cancellable
    private var cancellable: AnyCancellable?
    
    // Multiple cancellables
    private var cancellables = Set<AnyCancellable>()
    
    func subscribe() {
        // Store single subscription
        cancellable = [1, 2, 3, 4].publisher
            .sink { value in
                print(value)
            }
        
        // Store in set of cancellables
        ["1", "2", "3", "4"].publisher
            .sink { value in
                print(value)
            }
            .store(in: &cancellables)
    }
}
