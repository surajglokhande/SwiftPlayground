//: [Previous](@previous)
/*:
 
 - **Integration testing:** focuses on testing how different units or modules of your application interact and work together as a group. It verifies the interfaces and data flow between these integrated components.
 
    - **Scope:** Multiple integrated units or modules.
 
 - **Regression testing:** is the process of re-running existing tests (which can include unit tests, integration tests, and even UI tests) to ensure that recent code changes (e.g., bug fixes, new features, refactoring) have not introduced new bugs or caused existing, previously working functionalities to "regress" or break.
 
    - **Scope:** The entire application or significant parts of it, depending on the change. It covers both individual units and integrated systems.
 
 - **Unit testing:** focuses on testing the smallest individual components or "units" of your code in isolation. A "unit" typically refers to a single function, method, or class.
 
    - **Scope:** Individual functions, methods, or classes.
 
 */
import XCTest
import Testing
extension Tag {
    @Tag static var price: Self
    @Tag static var topSuiteOne: Self
    @Tag static var topSuiteTwo: Self
    @Tag static var topSuiteThree: Self
}

@Suite("This is the swift testing Suite one", .tags(.topSuiteOne))
struct SwiftTesingApp {
    @Test("", .tags(.price))
    func testExample() throws {
        
        //old
        #warning("XCTest")
        let actual = "Hello, World!"
        let expected = "Hello, World!"
        XCTAssertEqual(actual, expected, "actual is the same as expected")
        
        //new
        #warning("Swift tesing")
        #expect(actual == expected)
    }
}

@Suite("This is the swift testing Suite Two", .tags(.topSuiteTwo), .serialized)
struct SwiftTesingTwoApp {
    @Test
    func test1() {
        
    }
    @Test
    func test2() {
        
    }
    @Test
    func test3() {
        
    }
}

@Suite("This is the swift testing Suite Three", .tags(.topSuiteThree))
struct SwiftTesingThreeApp {
    @Test("this is the swift testing with multiple arguments", arguments: [(1, 2), (3, 4), (5, 6)])
    func test1(paramOne: Int, paramTwo: Int) {
        #expect(paramOne == paramTwo)
    }
}

@Suite("This is the swift testing Suite Four")
struct SwiftTesingFourApp {
    @Test
    func test1() {
        withKnownIssue("this is a known issue", isIntermittent: true) {
            #expect(true)
        }
    }
}
class HeavyTask {
    func run() {
        //
    }
}

@Suite("This is the swift testing Suite Five")
struct SwiftTesingFiveApp {
    @Test(.timeLimit(.minutes(1)))
    func test1() {
        let result = HeavyTask().run()
        //#expect(result == .finished)
    }
}

//: ![](XCTest.jpeg)
//: [Next](@next)
