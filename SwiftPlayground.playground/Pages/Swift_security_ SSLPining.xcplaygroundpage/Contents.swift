//: [Previous](@previous)
/*:
 ## SSL Pining
 **Why using SSL Pining?**

 - It helps ensure that your app talks only to the right, trusted server, not any sneaky impostors.When implemented properly, SSL Pinning can be an additional layer of security, providing protections against several attacks.

 - **Defends Against Fake Certificates:** If a bad actor tricks a certificate authority into giving them a fake certificate for your server.
 - **Keeps Things Super Secure:** When attackers try to make your app use a less secure connection.
 - **Protects Sensitive Data:** By making sure the SSL certificate is from a trustworthy source, SSL pinning greatly reduces the risk of hackers getting their hands on sensitive user data.
 - **No More Falling for Phishing:** Phishing attacks that use fake certificates won’t work.
 
 **How SSL Works?**
 
 - The client validates the server’s certificate against a list of trusted Certificate Authorities and makes sure the certificate is unexpired, unrevoked, and that its common name is valid for the server that it is connecting to. If the client trusts the certificate, it creates, encrypts, and sends back a symmetric session key using the server’s public key.
 - The server decrypts the session key using its private key and sends back an acknowledgement encrypted with the session key to start the encrypted session.
 - Now the server and client can exchange messages that are symmetrically encrypted with the shared session key.
 
 **Types of iOS SSL Pining:**

 - Embedding The Certificate: extract the server’s certificate and embed into the app bundle. The network layer compares the server’s certificate with embedded certificate.

 **Embedding the Public Key:**

 - **Grabbing the Public Key:** Taking the public key from the server’s certificate.
 - **Adding it into App:** Put this public key into your app’s code or bundle.
 - **Double-Checking with the Network:** When app talks to the server, it compares the server’s certificate’s public key with the one embedded key. If they match, it’s like a secret code that says, “We’re good to go.”
 
 **There are three types of certificates used during the SSL pinning methods:**

 - **Leaf Certificate:** If the pinned certificate (from the server) expires or breaks, your app stops working until it’s fixed. So, it’s like having a short expiration time, and it directly impacts your app.
 - **Intermediate Certificate:** This requires trust in the CA. As long as the certificate comes from the same provider, any changes to the leaf certificate will not affect the application.
 - **Root Certificate:** This is based on the chain of trust. If the certificate does not match during validation, it checks the issuing CA to see who was authorized until they reach a trusted CA at the top of the chain.
 
 ## Implement iOS SSL Pinning:
 - A few methods with which SSL pinning can be implemented are

 - **NSURLSession:** During the case of an authentication request from the server, the client first requests it for their credentials. The server’s certificate is then compared with those saved in the app bundle, and if it matches, the authentication is granted.All the checks are done manually in this method to implement SSL pinning. An NSURLSession object is first initiated, and the dataTaskWithURL: completion handler: method is used then for the SSL pinning test.
 */
/*:
 **Certificate Pining:** Using Details SSL Certificate Paining
 */
import Foundation
import Security
import CommonCrypto
class SSLPinnedURLSession: NSObject, URLSessionDelegate {
    
    private let pinnedCertificateData: Data
    
    init(pinnedCertificateData: Data) {
        self.pinnedCertificateData = pinnedCertificateData
        super.init()
    }
    
    // MARK: - URLSessionDelegate
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // 1. Check if the challenge is for server trust and get the trust object
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust
        else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        // 2. Use modern API to get the certificate chain
        // SecTrustCopyCertificateChain returns a CFArray, which is bridged to [AnyObject]
        guard let certificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        var certificateFound = false
        
        // 3. Check each certificate in the chain for a match
        for serverCertificate in certificates {
            
            // SecCertificateCopyData returns CFData?, which is bridged to Data?
            guard let serverCertificateData = SecCertificateCopyData(serverCertificate) as Data? else {
                continue // Skip if data cannot be retrieved
            }
            
            // Compare the raw certificate data
            if serverCertificateData == pinnedCertificateData {
                certificateFound = true
                break
            }
        }
        
        // 4. Complete the challenge based on the pinning result
        if certificateFound {
            // Pinning successful: continue with the connection
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            // Pinning failed: cancel the connection
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
/*:
 **Public Key Pining:**
 */
class PublicKeyPinner: NSObject, URLSessionDelegate {
    
    private let pinnedPublicKeyHashes: Set<String>
    
    init(publicKeyHashes: [String]) {
        self.pinnedPublicKeyHashes = Set(publicKeyHashes)
        super.init()
    }
    
    // MARK: - URLSessionDelegate
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust
        else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        var publicKeyFound = false
        
        // Use modern SecTrustCopyCertificateChain API
        if let certificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] {
            
            for certificate in certificates {
                // Use modern SecCertificateCopyKey
                guard let publicKey = SecCertificateCopyKey(certificate) else {
                    continue
                }
                
                // Use modern SecKeyCopyExternalRepresentation
                // Note: SecKeyCopyExternalRepresentation returns a CFData?, which bridges to Data?
                guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
                    continue
                }
                
                let keyHash = sha256(data: publicKeyData)
                
                if pinnedPublicKeyHashes.contains(keyHash) {
                    publicKeyFound = true
                    break
                }
            }
        }
        
        if publicKeyFound {
            // The challenge is successful
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            // Pinning failed
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    // MARK: - Hashing Function (Using CommonCrypto, if CryptoKit is not an option)
    
    // This function is generally not deprecated, but using CryptoKit (iOS 13+) is preferred.
    private func sha256(data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
             _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        // Base64 encoding the raw hash data
        return Data(hash).base64EncodedString()
    }
}
/*:
 ## Certificate Management
 **Extracting Certificate Information**
 
 To implement SSL pinning, you need to extract certificate data from your server:

 //Get certificate from server
 openssl s_client -connect yourserver.com:443 -servername yourserver.com < /dev/null | openssl x509 -outform DER > certificate.der

 //Get public key hash
 openssl s_client -connect yourserver.com:443 -servername yourserver.com < /dev/null | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
 
 **Storing Certificates in Your App Bundle**
 */
class CertificateManager {
    static func loadCertificate(named name: String) -> Data? {
        guard let path = Bundle.main.path(forResource: name, ofType: "cer"),
              let certificateData = NSData(contentsOfFile: path) else {
            return nil
        }
        return certificateData as Data
    }
    
    static func loadPublicKeyHashes() -> [String] {
        // Load from plist or hardcode
        return [
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="
        ]
    }
}
/*:
 **Best Practices**
 
 **1. Pin Multiple Certificates**
 - Always pin at least two certificates — your current certificate and a backup:
 */
let pinnedHashes = [
    "currentCertificateHash",
    "backupCertificateHash"
]
/*:
 **2. Use Public Key Pinning**
 - Public key pinning is more flexible than certificate pinning as it survives certificate renewals when the same key pair is used.
 
 **3. Implement Proper Error Handling**
 */
func handleSSLPinningFailure(error: Error) {
    // Log the failure for security monitoring
    SecurityLogger.logSSLPinningFailure(error: error)
    
    // Show appropriate user message
    showSecurityAlert(message: "Connection security could not be verified")
    
    // Potentially fall back to alternative endpoints or offline mode
}
/*:
 **4. Certificate Rotation Strategy**
 */
class CertificateRotationManager {
    private let primaryHashes: [String]
    private let backupHashes: [String]
    
    func validateCertificate(_ certificateHash: String) -> Bool {
        return primaryHashes.contains(certificateHash) ||
               backupHashes.contains(certificateHash)
    }
}
/*:
 **5. Environment-Specific Configuration**
 */
#if DEBUG
let pinnedCertificates = TestCertificates.developmentCertificates
#elseif STAGING
let pinnedCertificates = TestCertificates.stagingCertificates
#else
let pinnedCertificates = ProductionCertificates.productionCertificates
#endif
/*:
 ## Testing SSL Pinning
 **1. Unit Testing**
 */
import XCTest

class SSLPinningTests: XCTestCase {
    
    func testValidCertificatePinning() {
        let expectation = self.expectation(description: "Valid certificate should succeed")
        
        let pinnedSession = SSLPinnedURLSession(pinnedCertificateData: validCertificateData)
        // Test with valid certificate
        
        expectation.fulfill()
        waitForExpectations(timeout: 10.0)
    }
    
    func testInvalidCertificatePinning() {
        let expectation = self.expectation(description: "Invalid certificate should fail")
        
        let pinnedSession = SSLPinnedURLSession(pinnedCertificateData: validCertificateData)
        // Test with invalid certificate - should fail
        
        expectation.fulfill()
        waitForExpectations(timeout: 10.0)
    }
}
/*:
 **2. Integration Testing**
 
 Use tools like Charles Proxy or mitmproxy to test SSL pinning:

 - Install a proxy tool
 - Configure your device to use the proxy
 - Install the proxy’s certificate on the device
 - Attempt to intercept your app’s traffic
 - Verify that SSL pinning prevents the interception
 
 ## Common Challenges and Solutions
 **1. Certificate Expiration**
 
 **Problem:**
 - Hard-coded certificates expire, causing the app to break.
 
 **Solution:**
 - Use public key pinning instead of certificate pinning
 - Implement remote certificate updates
 - Always pin backup certificates
 
 **2. CDN and Load Balancer Issues**
 
 **Problem:**
 - CDNs and load balancers may present different certificates.
 
 Solution:
 */
let evaluators: [String: ServerTrustEvaluator] = [
    "api.yourserver.com": PublicKeysTrustEvaluator(keys: primaryKeys),
    "cdn.yourserver.com": PublicKeysTrustEvaluator(keys: cdnKeys),
    "backup.yourserver.com": PublicKeysTrustEvaluator(keys: backupKeys)
]
/*:
 **3. Development and Testing**
 
 **Problem:**
 - SSL pinning interferes with development tools.
 
 **Solution:**
 */
class NetworkConfiguration {
    static var sslPinningEnabled: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["SSL_PINNING_ENABLED"] == "true"
        #else
        return true
        #endif
    }
}
/*:
 **4. Emergency Bypass**
 - Implement a secure bypass mechanism for emergencies:
 */
class EmergencyBypassManager {
    private let remoteConfigService: RemoteConfigService
    
    func shouldBypassSSLPinning() -> Bool {
        // Check remote configuration with proper authentication
        return remoteConfigService.getEmergencyBypassFlag() &&
               validateBypassAuthenticity()
    }
    
    private func validateBypassAuthenticity() -> Bool {
        // Implement cryptographic validation of bypass command
        return true
    }
}
/*:
 ## Performance Considerations
 SSL pinning adds minimal overhead to network requests:
 */
class PerformanceOptimizedPinner {
    private let certificateCache = NSCache<NSString, NSData>()
    
    func getCachedCertificate(for host: String) -> Data? {
        return certificateCache.object(forKey: host as NSString) as Data?
    }
    
    func cacheCertificate(_ data: Data, for host: String) {
        certificateCache.setObject(data as NSData, forKey: host as NSString)
    }
}
/*:
 ## Security Considerations
 **Secure Certificate Storage:**
 Store certificates in the app bundle, not in user-accessible locations
 
 **Code Obfuscation:**
 Obfuscate certificate validation logic to prevent tampering
 
 **Anti-Tampering:**
 Implement checks to detect if SSL pinning has been disabled
 Logging: Log SSL pinning failures for security monitoring
 */
//: [Next](@next)
