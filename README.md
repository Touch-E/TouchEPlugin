# TouchEPlugin

## Installation

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding [TouchEPlugin](https://github.com/github/cmark-gfm) as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.

```swift
.package(url: "https://github.com/Kishan-Italiya/TouchEPlugin.git", branch: "main"),
```

## Usage

In AppDelegate.swift, just import TouchEPlugin framework and enable TouchEPlugin. 
 
```swift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate 
TouchEPluginVC.shared.validateURLAndToken(urlString: urlString, token: userToken) { isURLValid, isTokenValid in
if isURLValid && isTokenValid {
if let archivedObject = UserDefaults.standard.object(forKey:"profileData") as? Data {
profileData = NSMutableDictionary(dictionary: NSKeyedUnarchiver.unarchiveObject(with: archivedObject) as! NSMutableDictionary)
}

if let userID = UserDefaults.standard.string(forKey: "userID") {
UserID = userID
}

headersCommon = [
"Authorization": userToken
]

let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
let vc  = storyboard.instantiateViewController(withIdentifier: "HomeNavigation") as! UINavigationController
self.window?.rootViewController = vc
} else {
print(isURLValid ? "Your Token invalid" : "URL is invalid")
let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
let vc  = storyboard.instantiateViewController(withIdentifier: "loginNavigation") as! UINavigationController
self.window?.rootViewController = vc
}
self.window?.makeKeyAndVisible()
}
}
```swift
