/*:
[Previous](@previous)
# GCD
## Summary

- Sync + Serial: Tasks run one after another, blocking the current thread.
- Async + Serial: Tasks run one after another, but the current thread is not blocked.
- Sync + Concurrent: Tasks run one after another, blocking the current thread.
- Async + Concurrent: Tasks run in parallel, and the current thread is not blocked.
 
- **sync** → "Run this now and wait."
 - **async** → "Schedule this for later, don’t wait."

 
 pause and resume not allowed in GCD
 */
import Foundation
import PlaygroundSupport
public struct Demo {

	private var employee : [Employee]? = nil

    //- Async + Serial: Tasks run one after another, but the current thread is not blocked.
	func callMainThread() {
        print("started")
		DispatchQueue.main.async {
            for _ in 0...5 {
                print("🔴")
            }
			DispatchQueue.main.async {
                for _ in 0...5 {
                    print("⚪️")
                }
                for _ in 0...5 {
                    print("🟡")
                }
			}
            for _ in 0...5 {
                print("🟢")
            }
		}
        print("ended")
	}

    //- Async + Concurrent: Tasks run in parallel, and the current thread is not blocked.
	func callBackgroundThread() {
        print("started")
		DispatchQueue.global().async {
			for _ in 0...5 {
				print("🔴")
			}
			DispatchQueue.global().async {
				for _ in 0...5 {
					print("⚪️")
				}

				for _ in 0...5 {
					print("🟡")
				}
			}
			for _ in 0...5 {
				print("🟢")
			}
		}
        print("ended")
	}

/*:
its a serial queue, thats why? if you used serial queue with sync-async and async-sync result will be same
*/
    //- Sync + Serial: Tasks run one after another, blocking the current thread.
	func serial_sync() {
		let queue = DispatchQueue(label: "serial_sync")
        
        print("start serial queue.sync 1")

		queue.sync {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")
		}
        
        print("end serial queue.sync 1")
        
        print("start serial queue.sync 2")

		queue.sync {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
        
        print("end serial queue.sync 2")
		/*
         start serial queue.sync 1
         🔴 started
         🔴
         🔴
         🔴
         🔴 ended
         end serial queue.sync 1
         start serial queue.sync 2
         ⚪️ started
         ⚪️
         ⚪️
         ⚪️
         ⚪️ ended
         end serial queue.sync 2
		 */
	}
    
    //crash // not crash on two serial queue
    func serial_sync_nested() {
        let queue = DispatchQueue(label: "serial_sync")
        
        print("start serial queue.sync 1")
        queue.sync {
            print("start serial queue.sync 2")
            queue.sync {
                print("⚪️ started")
                for _ in 1...3 {
                    print("⚪️")
                }
                print("⚪️ ended")
            }
            print("end serial queue.sync 2")
        }
        print("end serial queue.sync 1")
    }

    //- Async + Serial: Tasks run one after another, but the current thread is not blocked.
	func serial_async() {
		let queue = DispatchQueue(label: "serial_async")
        
        print("start serial queue.async 1")
        
		queue.async {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")
		}
        
        print("end serial queue.async 1")
        
        print("start serial queue.async 2")

		queue.async {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
        
        print("end serial queue.async 2")
		/*
         start serial queue.async 1
         🔴 started
         end serial queue.async 1
         start serial queue.async 2
         end serial queue.async 2
         🔴
         🔴
         🔴
         🔴 ended
         ⚪️ started
         ⚪️
         ⚪️
         ⚪️
         ⚪️ ended
		 */
	}
    
    func serial_async_nested() {
        let queue = DispatchQueue(label: "serial_async")
        
        print("start serial queue.async 1")
        
        queue.async {
            print("start serial queue.async 2")

            queue.async {
                print("⚪️ started")
                for _ in 1...3 {
                    print("⚪️")
                }
                print("⚪️ ended")
            }
            
            print("end serial queue.async 2")
            
        }
        
        print("end serial queue.async 1")
    }

	func serial_sync_async() {
		let queue = DispatchQueue(label: "serial_sync_async")

        print("start serial queue.sync 1")
		queue.sync {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")
		}
        print("end serial queue.sync 1")

        print("start serial queue.async 2")
		queue.async {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
        print("end serial queue.async 2")
		/*
         start serial queue.sync 1
         🔴 started
         🔴
         🔴
         🔴
         🔴 ended
         end serial queue.sync 1
         start serial queue.async 2
         ⚪️ started
         end serial queue.async 2
         ⚪️
         ⚪️
         ⚪️
         ⚪️ ended
		 */
	}
    
    func serial_sync_async_nested() {
        let queue = DispatchQueue(label: "serial_sync_async")

        print("start serial queue.sync 1")
        queue.sync {
            print("start serial queue.async 2")
            queue.async {
                print("⚪️ started")
                for _ in 1...3 {
                    print("⚪️")
                }
                print("⚪️ ended")
            }
            print("end serial queue.async 2")
        }
        print("end serial queue.sync 1")
    }

	func serial_async_sync() {
		let queue = DispatchQueue(label: "serial_async_sync")
        print("start serial queue.async 1")
		queue.async {
			print("🔴 started")
			for _ in 1...5 {
				print("🔴")
                //sleep(2)
			}
			print("🔴 ended")
		}
        print("end serial queue.async 1")
        print("start serial queue.sync 2")
		queue.sync {
			print("⚪️ started")
			for _ in 1...5 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
        print("end serial queue.sync 2")
		/*
         start serial queue.async 1
         🔴 started
         end serial queue.async 1
         start serial queue.sync 2
         🔴
         🔴
         🔴
         🔴 ended
         ⚪️ started
         ⚪️
         ⚪️
         ⚪️
         ⚪️ ended
         end serial queue.sync 2
		 */
	}
    
    //crash
    func serial_async_sync_nested() {
        let queue = DispatchQueue(label: "serial_async_sync")
        print("start serial queue.async 1")
        queue.async {
            print("start serial queue.sync 2")
            queue.sync {
                print("⚪️ started")
                for _ in 1...5 {
                    print("⚪️")
                }
                print("⚪️ ended")
            }
            print("end serial queue.sync 2")
        }
        print("end serial queue.async 1")
    }
/*:
its a concurrent queue, thats why? if you used consurrent queue with sync-async and async-sync result will be same
*/
    //- Sync + Concurrent: Tasks run one after another, blocking the current thread.
	func concurrent_sync() {
		let queue = DispatchQueue(label: "concurrent_sync", attributes: .concurrent)
        print("start concurrent queue.sync 1")
		queue.sync {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")
		}
        print("end concurrent queue.sync 1")
        print("start concurrent queue.sync 2")
		queue.sync {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
        print("end concurrent queue.sync 2")
		/*
         start concurrent queue.sync 1
         🔴 started
         🔴
         🔴
         🔴
         🔴 ended
         end concurrent queue.sync 1
         start concurrent queue.sync 2
         ⚪️ started
         ⚪️
         ⚪️
         ⚪️
         ⚪️ ended
         end concurrent queue.sync 2
		 */
	}
    
    func concurrent_sync_nested() {
        let queue = DispatchQueue(label: "concurrent_sync", attributes: .concurrent)
        print("start concurrent queue.sync 1")
        queue.sync {
            print("start concurrent queue.sync 2")
            queue.sync {
                print("⚪️ started")
                for _ in 1...3 {
                    print("⚪️")
                }
                print("⚪️ ended")
            }
            print("end concurrent queue.sync 2")
        }
        print("end concurrent queue.sync 1")
    }
    
    //- Async + Concurrent: Tasks run in parallel, and the current thread is not blocked.
	func concurrent_async() {
		let queue = DispatchQueue(label: "concurrent_async", attributes: .concurrent)
        print("start concurrent queue.async 1")
		queue.async {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")
		}
        print("end concurrent queue.async 1")
        print("start concurrent queue.async 2")
		queue.async {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
        print("end concurrent queue.async 2")
		/*
         start concurrent queue.async 1
         🔴 started
         end concurrent queue.async 1
         start concurrent queue.async 2
         ⚪️ started
         🔴
         end concurrent queue.async 2
         🔴
         ⚪️
         🔴
         ⚪️
         🔴 ended
         ⚪️
         ⚪️ ended
		 */
	}
    
    func concurrent_async_nested() {
        let queue = DispatchQueue(label: "concurrent_async", attributes: .concurrent)
        print("start concurrent queue.async 1")
        queue.async {
            print("start concurrent queue.async 2")
            queue.async {
                print("⚪️ started")
                for _ in 1...3 {
                    print("⚪️")
                }
                print("⚪️ ended")
            }
            print("end concurrent queue.async 2")
        }
        print("end concurrent queue.async 1")
    }

	func concurrent_sync_async() {
		let queue = DispatchQueue(label: "concurrent_sync_async", attributes: .concurrent)
        print("start concurrent queue.sync 1")
		queue.sync {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")
		}
        print("end concurrent queue.sync 1")
        print("start concurrent queue.async 2")
		queue.async {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
        print("end concurrent queue.async 2")
		/*
         start concurrent queue.sync 1
         🔴 started
         🔴
         🔴
         🔴
         🔴 ended
         end concurrent queue.sync 1
         start concurrent queue.async 2
         ⚪️ started
         end concurrent queue.async 2
         ⚪️
         ⚪️
         ⚪️
         ⚪️ ended
		 */
	}
    
    func concurrent_sync_async_nested() {
        let queue = DispatchQueue(label: "concurrent_sync_async", attributes: .concurrent)
        print("start concurrent queue.sync 1")
        queue.sync {
            print("start concurrent queue.async 2")
            queue.async {
                print("⚪️ started")
                for _ in 1...3 {
                    print("⚪️")
                }
                print("⚪️ ended")
            }
            print("end concurrent queue.async 2")
        }
        print("end concurrent queue.sync 1")
    }

	func concurrent_async_sync() {
		let queue = DispatchQueue(label: "concurrent_async_sync", attributes: .concurrent)
        print("start concurrent queue.async 1")
		queue.async {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")
		}
        print("end concurrent queue.async 1")
        print("start concurrent queue.sync 2")
		queue.sync {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
        print("end concurrent queue.sync 2")
		/*
         start concurrent queue.async 1
         🔴 started
         end concurrent queue.async 1
         start concurrent queue.sync 2
         ⚪️ started
         🔴
         ⚪️
         🔴
         ⚪️
         🔴
         ⚪️
         🔴 ended
         ⚪️ ended
         end concurrent queue.sync 2
		 */
	}
    
    func concurrent_async_sync_nested() {
        let queue = DispatchQueue(label: "concurrent_async_sync", attributes: .concurrent)
        print("start concurrent queue.async 1")
        queue.async {
            print("start concurrent queue.sync 2")
            queue.sync {
                print("⚪️ started")
                for _ in 1...3 {
                    print("⚪️")
                }
                print("⚪️ ended")
            }
            print("end concurrent queue.sync 2")
        }
        print("end concurrent queue.async 1")
    }
/*:
 **Type:** DispatchWorkItem is a class in Swift.
 
 **Purpose:** It encapsulates a block of code (closure) that you want to perform on a queue, allowing you to control its execution more precisely than just submitting a closure directly.
 
 **Features:**
 - You can cancel a work item before it executes (if not started).
 - You can notify another block to execute when the work item finishes.
 - You can wait for the work item to complete.
 - You can reuse the work item by submitting it to multiple queues.
 */
	func dispatch_work_item() {
        // Create the first work item
        let firstWorkItem = DispatchWorkItem {
            print("First work item is executing")
            // Simulate some work
            for i in 1...3 {
                print("First work item count: \(i)")
                Thread.sleep(forTimeInterval: 1) // Simulate work
            }
            print("First work item completed")
        }

        // Create the second work item
        let secondWorkItem = DispatchWorkItem {
            print("Second work item is executing")
            // Simulate some work
            for i in 1...3 {
                print("Second work item count: \(i)")
                Thread.sleep(forTimeInterval: 1) // Simulate work
            }
            print("Second work item completed")
        }

        // Execute the first work item on a global concurrent queue
        DispatchQueue.global().async(execute: firstWorkItem)

        // Add a dependency: Execute the second work item after the first one completes
        firstWorkItem.notify(queue: DispatchQueue.global(), execute: secondWorkItem)

        // Optionally, you can add a completion handler to the second work item
        secondWorkItem.notify(queue: DispatchQueue.main) {
            print("Second work item has finished executing")
        }
        /*
         First work item is executing
         First work item count: 1
         First work item count: 2
         First work item count: 3
         First work item completed
         Second work item is executing
         Second work item count: 1
         Second work item count: 2
         Second work item count: 3
         Second work item completed
         Second work item has finished executing
         */
	}

	func dispatch_work_item_cancel() {

		var workitem: DispatchWorkItem?

		workitem = DispatchWorkItem {
			debugPrint("⚪️ started")
			for _ in 1...5 {
				guard let wItem = workitem, !wItem.isCancelled else {
					debugPrint("⚪️ work item stop")
					break
				}
				debugPrint("⚪️")
				sleep(1)
			}
			debugPrint("⚪️ ended")
		}

		workitem?.notify(queue: .main, execute: {
			debugPrint("⚪️ task completed")
		})

		let queue = DispatchQueue.global(qos: .utility)
		if let wItem = workitem {
			queue.async(execute: wItem)

			queue.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
				wItem.cancel()
			})
		}
        /*
         "⚪️ started"
         "⚪️"
         "⚪️"
         "⚪️ work item stop"
         "⚪️ ended"
         "⚪️ task completed"
         */
	}
/*:
 ### Key Features of DispatchGroup
 
- **Task Grouping:** You can group multiple tasks and monitor them as a single unit.
- **Synchronization:** You can wait for all tasks in the group to complete before proceeding.
- **Completion Handlers:** You can specify a block of code to execute once all tasks in the group are finished.

### Explanation

- **Creating the Group:** A DispatchGroup is created to manage the tasks.
- **Entering and Leaving the Group:** Each task enters the group when it starts and leaves the group when it finishes.
- **Notify:** The notify method is used to specify a block of code that runs on the main queue once all tasks in the group have completed.

### Benefits

- **Synchronization:** Ensures that you can perform actions only after all grouped tasks are complete.
- **Efficiency:** Helps manage concurrent tasks efficiently without blocking the main thread.
- **Flexibility:** Allows you to group tasks running on different queues and synchronize their completion.
*/
    public func dispatch_group() {
		//A group of tasks that you monitor as a single unit.
		let resource = EmployeeResource()
			//let departmentRequest = DepartmentRequest(userId: employeeId, department: "web")

		resource.getEmployee(userId: 15) { (response) in
			DispatchQueue.main.async {
				//table view reload here
			}
		}
	}
    
    func dispatch_group_and_nested_closure() {
        var arr: [String] = []
        let startTime = Date()

        //problem
        /*callApiA { (responseFromA) in
            callApiB { (responseFromB) in
                callApiC { (responseFromC) in
                    arr.append(responseFromA)
                    arr.append(responseFromB)
                    arr.append(responseFromC)
                    debugPrint(Date().timeIntervalSince(startTime))
                }
            }
        }*/

        //solution
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        callApiA { (responseFromA) in
            arr.append(responseFromA)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        callApiB { (responseFromB) in
            arr.append(responseFromB)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        callApiC { (responseFromC) in
            arr.append(responseFromC)
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            debugPrint(Date().timeIntervalSince(startTime))
        }
    }
/*:
> A **DispatchSemaphore** in iOS is a synchronization tool that helps control access to a resource across multiple execution contexts. It uses a traditional counting semaphore mechanism to manage concurrent access, ensuring that only a specified number of threads can access a resource at the same time.
 
### Problem Solved by DispatchSemaphore
- **Race Conditions:** Multiple threads might try to modify the same data at the same time, leading to unpredictable and incorrect results.

### Key Features of DispatchSemaphore

- **Counting Semaphore:** It maintains a count that represents the number of available resources.
- **Blocking and Signaling:** Threads can wait (block) until a resource becomes available or signal (release) a resource when done.
- **Efficient Implementation:** It only calls down to the kernel when the calling thread needs to be blocked, making it efficient.

### Explanation

- **Creating the Semaphore:** The semaphore is initialized with a count of 2, allowing up to 2 concurrent accesses.
- **Waiting and Signaling:** Each task waits for a resource before starting and signals when it has finished, releasing the resource for other tasks.
- **Concurrency Control:** The semaphore ensures that no more than 2 tasks run concurrently, even though they are dispatched on a global concurrent queue.
 
 ### Benefits

- **Resource Management:** Controls access to limited resources, preventing resource contention.
- **Synchronization:** Ensures that tasks are executed in a controlled manner, avoiding race conditions.
- **Efficiency:** Provides an efficient way to manage concurrency without excessive kernel calls.
*/
	public func dispatch_semaphore() {
		let queue = DispatchQueue(label: "semaphoreDemo", qos: .utility, attributes: .concurrent)

		let semaphore = DispatchSemaphore(value: 1)

		queue.async {
				// Money withdrawal from ATM
			do {
				semaphore.wait()
				let atm = Atm()
				try atm.withDrawAmount(amount: 10000) // withdraw 10K
				atm.printMessage()
				semaphore.signal()

			} catch WithdrawalError.inSufficientAccountBalance {
				semaphore.signal()
				debugPrint("ATM withdrawal failure: The account balance is less than the amount you want to withdraw, transaction cancelled")
			}
			catch {
				semaphore.signal()
				debugPrint("Error")
			}
		}

		queue.async {
				// Money withdrawal from Bank
			do {
				semaphore.wait()
				let bank = Bank()
				try bank.withDrawAmount(amount: 25000) // withdraw 25K
				bank.printMessage()
				semaphore.signal()

			} catch WithdrawalError.inSufficientAccountBalance  {
				semaphore.signal()
				debugPrint("Bank withdrawal failure: The account balance is less than the amount you want to withdraw, transaction cancelled")
			}
			catch{
				semaphore.signal()
				debugPrint("Error")
			}
		}
	}
/*:
> When you initialize a DispatchSemaphore with an integer value, such as DispatchSemaphore(value: 2), the integer value represents the initial count of the semaphore. This count determines how many concurrent accesses to a resource are allowed.

 ### Explanation

- **Initial Count:** The value 2 means that up to 2 threads can access the resource concurrently without being blocked.
- **Wait and Signal:** Each call to wait() decrements the semaphore's count by 1, and each call to signal() increments the count by 1.

 ### How It Works

- **Initialization:** let semaphore = DispatchSemaphore(value: 2) creates a semaphore with an initial count of 2.
- **Wait:** When a thread calls semaphore.wait(), it checks the count:
    - If the count is greater than 0, it decrements the count and proceeds.
    - If the count is 0, the thread is blocked until another thread calls signal().
- **Signal:** When a thread calls semaphore.signal(), it increments the count and potentially unblocks a waiting thread.
 
### Behavior

- **Concurrent Access:** Tasks 1 and 2 can start immediately because the semaphore allows up to 2 concurrent accesses.
- **Blocking:** Task 3 will wait until either Task 1 or Task 2 completes and calls signal(), releasing a resource.

 This mechanism helps manage access to limited resources efficiently and prevents resource contention.
*/
    public func dispatch_semaphore_with_value() {
        let semaphore = DispatchSemaphore(value: 2) // Allow up to 2 concurrent accesses
        
        // Task 1
        DispatchQueue.global().async {
            semaphore.wait() // Wait for a resource
            print("Task 1 started")
            Thread.sleep(forTimeInterval: 2) // Simulate work
            print("Task 1 completed")
            semaphore.signal() // Release the resource
        }
        
        // Task 2
        DispatchQueue.global().async {
            semaphore.wait() // Wait for a resource
            print("Task 2 started")
            Thread.sleep(forTimeInterval: 1) // Simulate work
            print("Task 2 completed")
            semaphore.signal() // Release the resource
        }
        
        // Task 3
        DispatchQueue.global().async {
            semaphore.wait() // Wait for a resource
            print("Task 3 started")
            Thread.sleep(forTimeInterval: 3) // Simulate work
            print("Task 3 completed")
            semaphore.signal() // Release the resource
        }
    }
    
	func priority_inversion_with_dispatch_semaphone() {
		let highPriority = DispatchQueue.global(qos: .userInitiated)
        
		let lowPriority = DispatchQueue.global(qos: .utility)
        
		let defaultPriority = DispatchQueue.global(qos: .default)
        

		let semaphone = DispatchSemaphore(value: 1)

		func printEmoji(queue: DispatchQueue, emoji: String) {
			queue.async {
				debugPrint("waiting")
				semaphone.wait()
				for i in 1...10 {
					debugPrint("\(emoji) \(i)")
				}
				debugPrint("signal")
				semaphone.signal()
			}
		}

		printEmoji(queue: highPriority, emoji: "🚑")
		printEmoji(queue: defaultPriority, emoji: "🚌")
		printEmoji(queue: lowPriority, emoji: "🚙")

	}

	func deadLock_with_dispatch_semaphone() {
		let highPriorityQueue = DispatchQueue.global(qos: .userInitiated)
		let lowPriorityQueue = DispatchQueue.global(qos: .utility)

		let codecat15Semaphore = DispatchSemaphore(value: 1)
		let codecat15BrotherSemaphore = DispatchSemaphore(value: 1)


		func requestForResource(resource: String, prioritySymbol: String, semaphore: DispatchSemaphore)
		{
			debugPrint("\(prioritySymbol) is waiting for resource = \(resource)")
			semaphore.wait(timeout: DispatchTime.now() + 5)
		}

		func prepareBreakfast(queue: DispatchQueue, prioritySymbol: String, firstResource: String, firstSemaphore: DispatchSemaphore, secondResource: String, secondSemaphore: DispatchSemaphore)
		{
			queue.async {

				requestForResource(resource: firstResource, prioritySymbol: prioritySymbol, semaphore: firstSemaphore)

				for i in 0...10 {
					if(i == 4)
					{
						requestForResource(resource: secondResource, prioritySymbol: prioritySymbol, semaphore: secondSemaphore)
					}
					debugPrint("\(prioritySymbol) \(i)")
				}

				debugPrint("signal called")
				firstSemaphore.signal()
				secondSemaphore.signal()
			}
		}

		prepareBreakfast(queue: lowPriorityQueue, prioritySymbol: "🦖", firstResource: "Oil", firstSemaphore: codecat15BrotherSemaphore, secondResource: "Pan", secondSemaphore: codecat15Semaphore)
		prepareBreakfast(queue: highPriorityQueue, prioritySymbol: "🐈", firstResource: "Pan", firstSemaphore: codecat15Semaphore, secondResource: "Oil", secondSemaphore: codecat15BrotherSemaphore)


	}

	public func actor() {
		let phoneStocks = PhoneStocks()
		let queue = DispatchQueue(label: "myQueue", attributes: .concurrent)

		queue.async {
			Task.detached{
				await phoneStocks.purchase(phone: "iPhone 13")
			}

		}

		queue.async {
			Task.detached{
				await phoneStocks.getAvailablePhones()
			}
		}
	}
}

var d1 = Demo()
//d1.callMainThread()
//d1.callBackgroundThread()
//d1.serial_sync()
//d1.serial_sync_nested() //crash
//d1.serial_async()
//d1.serial_async_nested()
//d1.serial_sync_async()
//d1.serial_sync_async_nested()
//d1.serial_async_sync()
//d1.serial_async_sync_nested() //crash
//d1.concurrent_sync()
//d1.concurrent_sync_nested()
//d1.multiple_concurrent_sync()
//d1.concurrent_async()
//d1.concurrent_async_nested()
//d1.concurrent_sync_async()
//d1.concurrent_sync_async_nested()
//d1.concurrent_async_sync()
//d1.concurrent_async_sync_nested()
//d1.dispatch_work_item()
//d1.dispatch_work_item_cancel()
//d1.dispatch_group()
//d1.dispatch_group_and_nested_closure()
//d1.dispatch_semaphore()
//d1.priority_inversion_with_dispatch_semaphone()
//d1.deadLock_with_dispatch_semaphone()
//d1.actor()

PlaygroundPage.current.needsIndefiniteExecution = true

protocol Banking {
	func withDrawAmount(amount: Double) throws;
}

enum WithdrawalError : Error {
	case inSufficientAccountBalance
}

var accountBalance = 30000.00

struct Atm : Banking {

	func withDrawAmount(amount: Double) throws {
		debugPrint("inside atm")

		guard accountBalance > amount else { throw WithdrawalError.inSufficientAccountBalance }

			// Intentional pause : ATM doing some calculation before it can dispense money
		Thread.sleep(forTimeInterval: Double.random(in: 1...3))
		accountBalance -= amount
	}

	func printMessage() {
		debugPrint("ATM withdrawal successful, new account balance = \(accountBalance)")
	}
}

struct Bank : Banking {

	func withDrawAmount(amount: Double) throws {
		debugPrint("inside bank")

		guard accountBalance > amount else { throw WithdrawalError.inSufficientAccountBalance }

			// Intentional pause : Bank person counting the money before handing it over
		Thread.sleep(forTimeInterval: Double.random(in: 1...3))
		accountBalance -= amount
	}

	func printMessage() {
		debugPrint("Bank withdrawal successful, new account balance = \(accountBalance)")
	}
}

func callApiA(completion:@escaping(String)->Void) {
	DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: {
		completion("data from service A")
	})
}

func callApiB(completion:@escaping(String)->Void) {
	DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2), execute: {
		completion("data from service B")
	})
}

func callApiC(completion:@escaping(String)->Void) {
	DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3), execute: {
		completion("data from service C")
	})
}

	// MARK: - User
struct User: Decodable {
	let userName: String
	let userID: Int
	let email: String

	enum CodingKeys: String, CodingKey {
		case userName
		case userID = "userId"
		case email
	}
}

	// MARK: - EmployeeResponse
struct EmployeeResponse: Decodable {
	let errorMessage: String?
	let data: [Employee]?
}

	// MARK: - Employee
struct Employee: Decodable {
	let name, email, id, joining: String
}

struct DepartmentRequest {
	let userId : Int
	let department : String
}

struct HttpUtility {

	static let shared = HttpUtility()
	private init() {}

	public func request<T:Decodable>(urlRequest: URLRequest, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void) {

		URLSession.shared.dataTask(with: urlRequest) { (serverData, urlResponse, error) in
			if(error == nil && serverData != nil){
				do {
					debugPrint(String(data: serverData!, encoding: .utf8))
					let result = try JSONDecoder().decode(T.self, from: serverData!)
					completionHandler(result)
				} catch {
					debugPrint("parser error = \(error.localizedDescription)")
				}
			}
		}.resume()
	}
}

struct ApiResource {
	static let department = URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/Employee/GetEmployee?")
}

struct EmployeeResource {

	func getEmployee(userId: Int, completion: @escaping(_ result: [Employee]?)-> Void)
	{
		let webEmployeeDepartmentRequest = DepartmentRequest(userId: userId, department: "web")
		let mobileDepartmentRequest = DepartmentRequest(userId: userId, department: "mobile")

		let departmentRequest = [webEmployeeDepartmentRequest, mobileDepartmentRequest]
		var employees : [Employee] = []

		let dispatchGroup = DispatchGroup()

		departmentRequest.forEach { (request) in
			dispatchGroup.enter()
			getEmployee(byDepartment: request) { (response) in
				employees.append(contentsOf: (response?.data?.map{$0})!)
				dispatchGroup.leave()
			}
		}

			//        dispatchGroup.enter()
			//        getEmployee(byDepartment: webEmployeeDepartmentRequest) { (response) in
			//            employees.append(contentsOf: (response?.data?.map{$0})!)
			//            dispatchGroup.leave()
			//        }
			//
			//        dispatchGroup.enter()
			//        getEmployee(byDepartment: mobileDepartmentRequest) { (response) in
			//            employees.append(contentsOf: (response?.data?.map{$0})!)
			//            dispatchGroup.leave()
			//        }

		dispatchGroup.notify(queue: .main) {
			completion(employees)
		}
	}


	func getEmployee(byDepartment departmentRequest: DepartmentRequest, completion: @escaping(_ result: EmployeeResponse?) -> Void)
	{
		var request = URLRequest(url: URL(string: "\(ApiResource.department!)Department=\(departmentRequest.department)&UserId=\(departmentRequest.userId)")!)

		request.httpMethod = "get"

		HttpUtility.shared.request(urlRequest: request, resultType: EmployeeResponse.self) { (response) in
			completion(response)
		}
	}
}

actor PhoneStocks {

	var stocks : Array<String> = ["iPhone 13", "Samsung S 21", "Pixel 4" ]
		//    let barrier = DispatchQueue(label: "barrierQueue")

	func getAvailablePhones() {
			// barrier.sync {
		print("available phones for purchase are = \(stocks)")
			//}
	}

	func purchase(phone: String) {

			//barrier.async(flags:.barrier) {
		guard let index = self.stocks.firstIndex(of: phone) else {
			print("no such phone in stock")
			return
		}
		self.stocks.remove(at: index)
		print(" 🎉 Congratulations on purchase of a new \(phone) 🎉 ")
			//}
	}
}


//: [Next](@next)
