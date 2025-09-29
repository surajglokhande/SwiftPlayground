//: [Previous](@previous)
/*:
**When to use it:**

 - When you want to provide a simple interface to a complex subsystem.
 - When you want to decouple a client from the implementation of a subsystem.
 - When you want to layer your system, with the Facade acting as an entry point to each layer.

 **Scenario:** Imagine building a "Smart Home" app where you want a single button to "Start Movie Night" or "End Movie Night." This involves coordinating several different devices (subsystems) like a TV, a sound system, and smart lights.
 */
/*:
    Example One
 */
import Foundation // For basic types
import UIKit // For UI example if used in a ViewController

// MARK: - Subsystems (The complex parts)

// 1. Television System
class Television {
    func turnOn() {
        print("Television: Turning on...")
    }

    func turnOff() {
        print("Television: Turning off.")
    }

    func setInput(source: String) {
        print("Television: Setting input to \(source).")
    }
}

// 2. Sound System (Amplifier, Speakers)
class SoundSystem {
    func turnOn() {
        print("SoundSystem: Powering on amplifier.")
    }

    func turnOff() {
        print("SoundSystem: Powering off amplifier.")
    }

    func setVolume(level: Int) {
        print("SoundSystem: Setting volume to \(level).")
    }

    func setMode(mode: String) {
        print("SoundSystem: Setting audio mode to \(mode).")
    }
}

// 3. Projector System
class Projector {
    func turnOn() {
        print("Projector: Warming up...")
    }

    func turnOff() {
        print("Projector: Cooling down.")
    }

    func setInput(source: String) {
        print("Projector: Setting input to \(source).")
    }

    func project(movie: String) {
        print("Projector: Projecting movie: '\(movie)'")
    }
}

// 4. Lighting System
class Lights {
    func dim(to level: Int) {
        print("Lights: Dimming to \(level)% brightness.")
    }

    func brighten() {
        print("Lights: Brightening to 100%.")
    }
}

// MARK: - Facade

// The HomeTheaterFacade provides a simplified interface to the complex home theater system.
class HomeTheaterFacade {
    private let tv: Television
    private let sound: SoundSystem
    private let projector: Projector
    private let lights: Lights

    // The facade is initialized with instances of the subsystems.
    // In a real app, these might be injected or created internally.
    init(tv: Television = Television(),
         sound: SoundSystem = SoundSystem(),
         projector: Projector = Projector(),
         lights: Lights = Lights()) {
        self.tv = tv
        self.sound = sound
        self.projector = projector
        self.lights = lights
    }

    // Simplified method for starting a movie
    func startMovie(movieName: String) {
        print("\n--- Starting Movie: '\(movieName)' ---")
        lights.dim(to: 10)
        projector.turnOn()
        projector.setInput(source: "HDMI 1") // Specific input for movie
        sound.turnOn()
        sound.setVolume(level: 15)
        sound.setMode(mode: "Surround Sound")
        // No need to turn on TV if using projector, but could be an option
        projector.project(movie: movieName)
        print("--- Enjoy your movie! ---\n")
    }

    // Simplified method for ending a movie
    func endMovie() {
        print("\n--- Ending Movie ---")
        projector.turnOff()
        sound.turnOff()
        lights.brighten()
        // If TV was used as well:
        // tv.turnOff()
        print("--- Movie night concluded. ---\n")
    }

    // You can add other simplified operations, like "Play Music"
    func playMusic() {
        print("\n--- Starting Music Playback ---")
        lights.brighten()
        tv.turnOn() // Maybe turn on TV to show music visualizer
        tv.setInput(source: "Spotify App")
        sound.turnOn()
        sound.setVolume(level: 10)
        sound.setMode(mode: "Stereo")
        print("--- Music is playing! ---\n")
    }
}


// MARK: - Client Usage (e.g., in a ViewController)

// A hypothetical iOS ViewController that uses the Facade
class SmartHomeController: UIViewController {

    private var homeTheater: HomeTheaterFacade!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Smart Home"

        // Initialize the facade (usually done once per relevant scope)
        homeTheater = HomeTheaterFacade()

        // Setup UI buttons to trigger actions
        setupButtons()
    }

    private func setupButtons() {
        let startMovieButton = UIButton(type: .system)
        startMovieButton.setTitle("Start Movie Night", for: .normal)
        startMovieButton.addTarget(self, action: #selector(startMovieTapped), for: .touchUpInside)

        let endMovieButton = UIButton(type: .system)
        endMovieButton.setTitle("End Movie Night", for: .normal)
        endMovieButton.addTarget(self, action: #selector(endMovieTapped), for: .touchUpInside)

        let playMusicButton = UIButton(type: .system)
        playMusicButton.setTitle("Play Music", for: .normal)
        playMusicButton.addTarget(self, action: #selector(playMusicTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [startMovieButton, endMovieButton, playMusicButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Button Actions (Client Interactions)

    @objc private func startMovieTapped() {
        print("Client (SmartHomeController): User wants to start movie night!")
        homeTheater.startMovie(movieName: "Inception") // Single call to the facade
    }

    @objc private func endMovieTapped() {
        print("Client (SmartHomeController): User wants to end movie night!")
        homeTheater.endMovie() // Single call to the facade
    }

    @objc private func playMusicTapped() {
        print("Client (SmartHomeController): User wants to play music!")
        homeTheater.playMusic() // Single call to the facade
    }
}

/*
// To run this in an Xcode project:
// 1. Create a new "iOS App" project (UIKit App Delegate).
// 2. Replace the contents of your `SceneDelegate.swift` (or `AppDelegate.swift`)
//    with the following to set `SmartHomeController` as the root.

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SmartHomeController() // Set your Facade client as root
        window?.makeKeyAndVisible()
    }
    // ... other SceneDelegate methods
}
*/

// MARK: - Example of Usage (without a full UI)
// You can also run this in a Swift Playground to see the output.

 print("--- Testing Home Theater Facade ---")
 let myHomeTheater = HomeTheaterFacade()

 myHomeTheater.startMovie(movieName: "The Matrix")

 print("\n------------------------------\n")

 myHomeTheater.endMovie()

 print("\n------------------------------\n")

 myHomeTheater.playMusic()
/*:
    Example Two
 */
// MARK: - Subsystem Components

class AudioSession {
    func configureAudioSession() {
        print("AudioSession: Configuring audio session settings.")
        // Complex logic for setting up audio session
    }

    func activateAudioSession() {
        print("AudioSession: Activating audio session.")
        // Complex logic for activating
    }

    func deactivateAudioSession() {
        print("AudioSession: Deactivating audio session.")
        // Complex logic for deactivating
    }
}

class AudioInput {
    func setupMicrophoneInput() {
        print("AudioInput: Setting up microphone input.")
        // Complex logic for microphone setup
    }

    func calibrateInput() {
        print("AudioInput: Calibrating audio input levels.")
        // Complex logic for calibration
    }
}

class SoundPlayer {
    func loadSoundFile(named fileName: String) {
        print("SoundPlayer: Loading sound file: \(fileName).")
        // Complex logic for loading sound
    }

    func play() {
        print("SoundPlayer: Playing sound.")
        // Complex logic for playing sound
    }

    func stop() {
        print("SoundPlayer: Stopping sound.")
        // Complex logic for stopping sound
    }
}
// MARK: - Facade

class AudioManagerFacade {
    private let audioSession: AudioSession
    private let audioInput: AudioInput
    private let soundPlayer: SoundPlayer

    init() {
        self.audioSession = AudioSession()
        self.audioInput = AudioInput()
        self.soundPlayer = SoundPlayer()
    }

    // Simplified interface for playing a sound
    func playSound(fileName: String) {
        print("\nAudioManagerFacade: Preparing to play sound '\(fileName)'...")
        audioSession.configureAudioSession()
        audioSession.activateAudioSession()
        audioInput.setupMicrophoneInput() // Maybe needed for recording, or just general audio setup
        soundPlayer.loadSoundFile(named: fileName)
        soundPlayer.play()
        print("AudioManagerFacade: Sound playback initiated for '\(fileName)'.")
    }

    // Simplified interface for stopping sound and cleaning up
    func stopSoundAndCleanup() {
        print("\nAudioManagerFacade: Stopping sound and cleaning up...")
        soundPlayer.stop()
        audioSession.deactivateAudioSession()
        print("AudioManagerFacade: Cleanup complete.")
    }

    // Another high-level operation
    func recordAudio() {
        print("\nAudioManagerFacade: Preparing to record audio...")
        audioSession.configureAudioSession()
        audioSession.activateAudioSession()
        audioInput.setupMicrophoneInput()
        audioInput.calibrateInput()
        print("AudioManagerFacade: Audio recording setup complete.")
    }
}
// MARK: - Client Usage

let audioManager = AudioManagerFacade()

// Client can now play a sound with a single method call
audioManager.playSound(fileName: "background_music.mp3")

// And stop/cleanup with another single call
audioManager.stopSoundAndCleanup()

// Or record audio
audioManager.recordAudio()
//: [Next](@next)
