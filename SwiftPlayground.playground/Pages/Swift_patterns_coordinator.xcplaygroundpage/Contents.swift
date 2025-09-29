//: [Previous](@previous)
import Foundation
import UIKit
import PlaygroundSupport
// MARK: - 1. Coordinator Protocol

// Defines the basic behavior of any coordinator
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var children: [Coordinator] { get set } // To manage child coordinators (for more complex flows)
    func start() // The entry point for the coordinator's flow
}

// MARK: - 2. MainCoordinator

// This coordinator will manage the initial flow of our app.
class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // When the MainCoordinator starts, it shows ScreenA.
        showScreenA()
    }

    func showScreenA() {
        let vc = ScreenAViewController.instantiate()
        // The view controller needs to tell the coordinator when its job is done.
        // We use a delegate pattern for this.
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false) // Push without animation for initial setup
    }

    func showScreenB() {
        let vc = ScreenBViewController.instantiate()
        vc.coordinator = self // Pass the coordinator for potential future navigation
        navigationController.pushViewController(vc, animated: true)
    }

    // You could add other navigation methods here, like:
    // func showLoginFlow()
    // func showSettings()
    // func navigateBack()
}

// MARK: - 3. View Controllers

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
    // A weak reference to the coordinator to avoid retain cycles.
    weak var coordinator: MainCoordinator?

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
        // Instead of directly pushing ScreenB, we tell the coordinator what we want to do.
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
        // No further navigation from this screen in this simple example
    }
}

// MARK: - 4. Setting up the Coordinator in SceneDelegate/AppDelegate

// This is where you typically kick off your app's flow.

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
    var mainCoordinator: MainCoordinator? // Keep a strong reference to your coordinator

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create a new window
        window = UIWindow(windowScene: windowScene)

        // Create a UINavigationController to serve as the root of our navigation stack.
        let navController = UINavigationController()

        // Initialize the MainCoordinator with the navigation controller.
        mainCoordinator = MainCoordinator(navigationController: navController)

        // Tell the coordinator to start its flow.
        mainCoordinator?.start()

        // Set the navigation controller as the root view controller of the window.
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
        mainCoordinator = MainCoordinator(navigationController: navController)
        mainCoordinator?.start()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }

    // ... other AppDelegate methods
}
*/
//: [Next](@next)
