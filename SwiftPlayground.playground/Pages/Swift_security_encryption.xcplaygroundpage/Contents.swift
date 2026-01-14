//: [Previous](@previous)
/*:
 - 🔐 Understanding Encryption & Decryption in Swift (iOS)
 - 📱 Data security isn't optional—it's essential in any iOS app dealing with user information, authentication, or networking.

 **Here’s a quick guide to how encryption and decryption work in iOS using Swift 👇**
 **🔁 Types of Encryption:**

 - 1. AES (Advanced Encryption Standard) – Symmetric
    - 🔑 Same key is used to encrypt & decrypt data.
    - 📦 Best for local data protection like files, tokens, and sensitive info.

 **✅ Use CryptoKit (iOS 13+)**

 */
import CryptoKit

let key = SymmetricKey(size: .bits256)
let data = "Hello".data(using: .utf8)!

let sealedBox = try! AES.GCM.seal(data, using: key)
let decryptedData = try! AES.GCM.open(sealedBox, using: key)
let decryptedMessage = String(data: decryptedData, encoding: .utf8)
/*:
 **2. RSA (Rivest–Shamir–Adleman) – Asymmetric**
    - 🔐 Public Key ➜ Encrypt
    - 🔓 Private Key ➜ Decrypt

 - ✅ Use SecKey from Security Framework or third-party wrappers like SwiftyRSA
 - 📬 Best for secure communication (e.g. login credentials, certificate pinning).
 
 **🔒 Where to Store Encryption Keys?**

 - ➡️ Use Keychain Services

    - Stores tokens, passwords, symmetric keys securely
    - Persists even if app is uninstalled (unless removed manually)


 **🧪 Bonus: Base64 ≠ Encryption**

 - ⚠️ Base64 is just encoding, not secure.
 - Use it only for safe string representation, not for hiding secrets.


 **💡 Best Practices for iOS App Security**

 - ✅ Use AES for encrypting local data
 - ✅ Use RSA for secure key exchange or communication
 - ✅ Always store keys in Keychain
 - ✅ Never hardcode secrets in app
 - ✅ Use HTTPS with certificate pinning for extra safety

 **🔧 Tools to Explore:**

 - CryptoKit (Apple's modern framework)
 - CommonCrypto (legacy, still used)
 - SwiftyRSA / CryptoSwift (popular community tools)


 - 📢 Whether you're building banking apps, health apps, or just storing login tokens — secure your data like a pro!
 
 ![](encryption.jpeg)
 */
//: [Next](@next)
