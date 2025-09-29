//: [Previous](@previous)
//: # Operation Queue
import Foundation
import PlaygroundSupport
/*:
pause and resume not allowed in GCD
 */
final class CustomOperation: Operation {

	let itemProvider: NSItemProvider?

	init(itemProvider: NSItemProvider?) {
		self.itemProvider = itemProvider
	}

	override func main() {
		guard !isCancelled else { return }
		print("Importing content..")

			// .. import the content using the item provider
	}
}

class Demo {
	func operation_block() {

		let blockOperation = BlockOperation()

		blockOperation.qualityOfService = .utility
		blockOperation.queuePriority = .normal

		blockOperation.addExecutionBlock {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")

		}
		blockOperation.addExecutionBlock {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}
		blockOperation.completionBlock = {
			print("⚪️ and 🔴 finished")
		}
		blockOperation.start()
	}

	func operation_queue() {

		let blockOperation = BlockOperation()

		blockOperation.qualityOfService = .utility
		blockOperation.queuePriority = .normal

		blockOperation.addExecutionBlock {
			print("🔴 started")
			for _ in 1...3 {
				print("🔴")
			}
			print("🔴 ended")

		}
		blockOperation.addExecutionBlock {
			print("⚪️ started")
			for _ in 1...3 {
				print("⚪️")
			}
			print("⚪️ ended")
		}

		blockOperation.completionBlock = {
			print("⚪️ and 🔴 finished")
		}

		let anotherBlockOperation = BlockOperation()
		anotherBlockOperation.addExecutionBlock {
			print("⚫️ started")
			for _ in 1...3 {
				print("⚫️")
			}
			print("⚫️ ended")
		}

		anotherBlockOperation.completionBlock = {
			print("⚫️ finished")
		}

		let operationQueue = OperationQueue()
		operationQueue.qualityOfService = .utility
		operationQueue.addOperation(blockOperation)
		operationQueue.addOperation(anotherBlockOperation)

		//optioanl caller
		//operationQueue.addOperations([blockOperation, anotherBlockOperation], waitUntilFinished: false)
	}

	func dependency_task() {

		/** IMPORTANT!!! DO NOT DISTURB THE ORDER OF DEPARTMENT AND EMPLOYEE **

		 As per user story 1234 we need to send department record first and then employee record so please do not break the sequence here

		 We are using serial queue where sequence matters and if any change is expected in the upcoming release then please make your changes after the employee async

		 If any other entity needs to be synced before department then please write that code above the department serial queue

		 */

		//Problem
//		let serialQueue = DispatchQueue.init(label: "codecat15Example")
//
//		serialQueue.async {
//			let department = Department()
//			department.syncOfflineDepartmentRecords()
//		}
//
//		serialQueue.async {
//			let employee = Employee()
//			employee.syncOfflineEmployeeRecords()
//		}
//
//		serialQueue.async {
//			debugPrint("syncing project record")
//		}

		//solution
		let employeeSyncOperation = BlockOperation()
		employeeSyncOperation.addExecutionBlock {
			let employee = Employee()
			employee.syncOfflineEmployeeRecords()
		}

		let departmentSyncOperation = BlockOperation()
		departmentSyncOperation.addExecutionBlock {
			let department = Department()
			department.syncOfflineDepartmentRecords()
		}

		departmentSyncOperation.addDependency(employeeSyncOperation)

		let operationQueue = OperationQueue()
		operationQueue.addOperation(employeeSyncOperation)
		operationQueue.addOperation(departmentSyncOperation)
	}

	func dispatch_group_with_operation_queue() {

		let group = DispatchGroup()

			// employee block operation
		let employeeBlockOperation = BlockOperation()
		employeeBlockOperation.addExecutionBlock {

			let employeeDataResource = EmployeeDataResource()
			employeeDataResource.getEmployee { (employeeData) in
				employeeData?.forEach({ (employee) in
					debugPrint(employee.name)
				})
			}
		}

			// project block operation
		let projectBlockOperation = BlockOperation()
		projectBlockOperation.addExecutionBlock {
			group.enter()
			let projectResource = ProjectDataResource()
			projectResource.getProject { (projectData) in
				projectData?.forEach({ (project) in
					debugPrint(project.name)
				})
				group.leave()
			}

			group.wait()
		}

			// adding dependency
		employeeBlockOperation.addDependency(projectBlockOperation)

			// creating the operation queue
		let operationQueue = OperationQueue()
		operationQueue.addOperation(employeeBlockOperation)
		operationQueue.addOperation(projectBlockOperation)
	}
}

var d1 = Demo()
//d1.operation_block()
//d1.operation_queue()
//d1.dependency_task()
d1.dispatch_group_with_operation_queue()

PlaygroundPage.current.needsIndefiniteExecution = true


struct Employee {
	func syncOfflineEmployeeRecords() {

		debugPrint("Syncing offline records for employee started")
		Thread.sleep(forTimeInterval: 2)
		debugPrint("Syncing completed for employee")
	}
}

struct Department {
	func syncOfflineDepartmentRecords() {

		debugPrint("Syncing offline records for department started")
		Thread.sleep(forTimeInterval: 2)
		debugPrint("Syncing completed for department")
	}
}

	// MARK: - Employee
struct EmployeeDataResource
{
	func getEmployee(handler:@escaping(_ result: [EmployeeData]?)-> Void)
	{
		debugPrint("inside the get employee function")

		var urlRequest = URLRequest(url: URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/Employee/GetEmployee?Department=mobile&UserId=15")!)
		urlRequest.httpMethod = "get"
		debugPrint("going to call the http utility for employee request")

		HttpUtility.shared.getData(request: urlRequest, response: EmployeeResponse.self) { (result) in
			if(result != nil) {
				debugPrint("got the emloyee response from api")
				handler(result?.data)
			}
		}
	}
}

struct ProjectDataResource
{
	func getProject(handler:@escaping(_ result: [Project]?)-> Void)
	{
		debugPrint("inside the get project function")

		var urlRequest = URLRequest(url: URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/Project/GetProjects")!)
		urlRequest.httpMethod = "get"

		debugPrint("going to call the http utility for Project request")

		HttpUtility.shared.getData(request: urlRequest, response: [Project].self) { (result) in
			if(result != nil) {
				debugPrint("got the project response from api")
				handler(result)
			}
		}
	}
}

struct HttpUtility
{
	static let shared = HttpUtility()
	private init(){}
	func getData<T:Decodable>(request: URLRequest, response: T.Type, handler:@escaping(_ result: T?)-> Void)
	{
		URLSession.shared.dataTask(with: request) { (data, httpUrlResponse, error) in
			if(error == nil && data != nil && data?.count != 0) {
				do {
					let decoder = JSONDecoder()
						// for date formatting
					decoder.dateDecodingStrategy = .iso8601
					let result = try decoder.decode(response, from: data!)
					handler(result)
				} catch  {
					debugPrint(error.localizedDescription)
				}

			}}.resume()
	}
}

struct Project: Decodable {
	let id: Int
	let name, description: String
	let isActive: Bool
	let startDate: Date
	let endDate: Date?

	enum CodingKeys: String, CodingKey {
		case id
		case name,description
		case isActive, startDate, endDate
	}
}

	// MARK: - EmployeeResponse
struct EmployeeResponse: Decodable {
	let errorMessage: String?
	let data: [EmployeeData]?
}

	// MARK: - EmployeeData
struct EmployeeData: Decodable {
	let name, email, id,joining: String
}


//: [Next](@next)
