//: [Previous](@previous)
import UIKit
import Foundation
import PlaygroundSupport
// MARK: - 1. Coordinator Protocol (No Change)

// Defines the basic behavior of any coordinator
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var children: [Coordinator] { get set } // To manage child coordinators (for more complex flows)
    func start() // The entry point for the coordinator's flow
}

// MARK: - 2. Factory Pattern Implementation

// Step 1: Define the Factory Protocol
// This protocol declares the factory methods for creating different view controllers.
protocol ViewControllerFactory {
    func makeScreenAViewController() -> ScreenAViewController
    func makeScreenBViewController() -> ScreenBViewController
    // Add more factory methods for other view controllers as needed
}

// Step 2: Implement the Concrete Factory
// This concrete factory knows how to instantiate each specific view controller.
class AppViewControllerFactory: ViewControllerFactory {
    func makeScreenAViewController() -> ScreenAViewController {
        // Here's where the actual instantiation logic lives.
        // It could be from a Storyboard, a XIB, or programmatically.
        let vc = ScreenAViewController.instantiate()
        // You could also inject dependencies into the VC here if needed
        return vc
    }

    func makeScreenBViewController() -> ScreenBViewController {
        let vc = ScreenBViewController.instantiate()
        return vc
    }
}


// MARK: - 3. MainCoordinator (Modified to use the Factory)

// This coordinator will manage the initial flow of our app.
class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []

    // New: The coordinator now depends on a ViewControllerFactory protocol.
    private let factory: ViewControllerFactory

    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory // Store the factory instance
    }

    func start() {
        showScreenA()
    }

    func showScreenA() {
        // New: Use the factory to create ScreenAViewController
        let vc = factory.makeScreenAViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func showScreenB() {
        // New: Use the factory to create ScreenBViewController
        let vc = factory.makeScreenBViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - 4. View Controllers (No Change to their internal logic, just `Storyboarded` protocol)

// Helper to instantiate view controllers from Storyboard (common in UIKit)
protocol Storyboarded: AnyObject {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".").last!
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main) // Assuming "Main.storyboard"
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

// Screen A
class ScreenAViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator? // Still needs to communicate back to its coordinator

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        title = "Screen A"
        setupButton()
    }

    private func setupButton() {
        let button = UIButton(type: .system)
        button.setTitle("Go to Screen B", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToScreenBTapped), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func goToScreenBTapped() {
        coordinator?.showScreenB()
    }
}

// Screen B
class ScreenBViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Screen B"
    }
}

// MARK: - 5. Setting up in SceneDelegate/AppDelegate (Modified to use the Factory)

/*
   To run this code in an Xcode project:
   1. Create a new "iOS App" project (UIKit App Delegate).
   2. Replace the contents of your `SceneDelegate.swift` with the code below.
   3. In `Main.storyboard`:
      a. Select `ViewController`.
      b. In the Identity Inspector (right panel), set its "Class" to `ScreenAViewController`.
      c. Add a new `UIViewController` to the storyboard.
      d. In the Identity Inspector, set its "Class" to `ScreenBViewController` and its "Storyboard ID" to `ScreenBViewController`. (Crucial for `instantiate()`)
      e. Make sure `Is Initial View Controller` is *unchecked* for all view controllers in the storyboard, as the `SceneDelegate` will manage the root.
*/

// --- SceneDelegate.swift ---

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController()

        // New: Create the concrete factory instance
        let appFactory = AppViewControllerFactory()

        // New: Initialize the MainCoordinator with the navigation controller AND the factory
        mainCoordinator = MainCoordinator(navigationController: navController, factory: appFactory)

        mainCoordinator?.start()

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    // ... other SceneDelegate methods
}


// --- AppDelegate.swift (if not using SceneDelegate, e.g., older projects) ---
/*
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()

        let appFactory = AppViewControllerFactory() // Create the factory

        mainCoordinator = MainCoordinator(navigationController: navController, factory: appFactory) // Pass the factory
        mainCoordinator?.start()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }

    // ... other AppDelegate methods
}
*/
//: [Next](@next)
