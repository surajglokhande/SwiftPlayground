//: [Previous](@previous)
/*:
 **1. Device Registration & Token Exchange**

 - Before a notification can be sent, the device must "check in" with both Apple and Firebase.

 - APNs Token: Your app requests a device token from Apple. APNs returns a unique device_token.

 - FCM Token: The Firebase SDK takes that Apple device_token and sends it to the FCM backend.

 - **Token Mapping:** FCM generates a unique FCM_registration_token and links it to that specific device's APNs token in its database. This allows you to send a single message that FCM can "translate" for Apple.

 **2. Message Initiation**

 - When you want to send a notification (via the Firebase Console or your own backend), you send a request to the FCM Backend. This request includes:

 - The Target (a specific FCM token, a topic, or a user segment).

 - The Payload (title, body, and custom data).

 **3. Handover to APNs**

 - FCM doesn't send the message to the iPhone directly. Instead:

 - FCM looks up the mapped APNs device token for the target.

 - It packages the message into the Apple-specific JSON format (4 KB limit).

 - It forwards this request to APNs using the APNs Authentication Key (.p8 file) you uploaded to the Firebase Console.

 **4. Delivery via Persistent Connection**

 - Each iOS device maintains a persistent, encrypted connection to Apple's servers.

 - APNs identifies the device and pushes the notification over this existing connection.

 - The iOS System receives the packet. If the app is in the background or killed, the OS displays the alert automatically.

 **5. App Processing**

 - **Foreground:** If the app is open, the FCM SDK captures the message via the userNotificationCenter(_:willPresent:...) delegate method.

 - **Background/Tapped:** When a user taps the notification, the userNotificationCenter(_:didReceive:...) method is triggered, allowing your app to read custom data (like a deep link URL).
 */
/*:
 ![](push_notification.png)

 iOS - 4 lines limit(178 characters).
 Apple Push Notification service (APNs) refuses a notification if the total size of its payload exceeds the following limits:
 For Voice over Internet Protocol (VoIP) notifications, the maximum payload size is 5 KB (5120 bytes).
 For all other remote notifications, the maximum payload size is 4 KB (4096 bytes).
 Listing 1 A remote notification payload for showing an alert
 {
    “aps” : {
       “alert” : {
          “title” : “Game Request”,
          “subtitle” : “Five Card Draw”
          “body” : “Bob wants to play poker”,
       },
       “category” : “GAME_INVITATION”
    },
    “gameID” : “12345678”
 }
 Listing 2 A remote notification payload for playing a sound
 {
    “aps” : {
       “badge” : 9
       “sound” : “bingbong.aiff”
    },
    “messageID” : “ABCDEFGHIJ”
 }
 */
//: [Next](@next)
