# TouchEPlugin

## Overview

`TouchEPlugin` is a Swift package designed to streamline the integration of touch-based interactions within your iOS applications. 

## SDK supported features

1. Login to custom server
2. Display list of movies/tv shows available on server
3. Movie detail page
4. Detailed Movie character page
5. Purchase Product from which showed in movie
6. Additional features to like Drag & Drop directly from movie to purchase product
7. Add product to Cart
8. Movie screen includes Vov (Video over video)
9. SDK includes User info screen
10. Order history with user Rating
 
## Installation

To integrate TouchEPlugin into your Swift project, you can use the Swift Package Manager, which is integrated into the Swift compiler. Follow the steps below to add TouchEPlugin as a dependency.

## Using Swift Package Manager

1. Open your project in Xcode.
2. Navigate to `File` > `Swift Packages` > `Add Package Dependency....`
3. Enter the URL of the `TouchEPlugin` repository: `https://github.com/Kishan-Italiya/TouchEPlugin.git`.
4. Choose the main branch for the package.
5. Add the package to your project.

Alternatively, you can add the dependency directly in your `Package.swift` file:

```swift
.package(url: "https://github.com/Kishan-Italiya/TouchEPlugin.git", branch: "main"),
```

## Usage

### Initial Setup

To get started with `TouchEPlugin`, you need to configure it in your `AppDelegate.swift` file. This involves importing the framework, validating the server URL, and checking the user token.

### Step-by-Step Setup in AppDelegate.swift

1. Import the TouchEPlugin Framework

   Add the following import statement at the top of your `AppDelegate.swift` file:

```swift
import TouchEPlugin
```
2. Validate URL and Token

   In the `application(_:didFinishLaunchingWithOptions:)` method, validate the server URL and the user token as shown below:
 
```swift
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let urlString = "https://api-cluster.system.touchetv.com"
        var userToken = "" // If user already login assign save token here.
        
        TouchEPluginVC.shared.validateURLAndToken(urlString: urlString, token: userToken) { isURLValid, isTokenValid in
            if isURLValid && isTokenValid {
            
                 // if the user already login then assign save user data to package data profileData,UserID, headersCommon like below example 
            
                    if let archivedObject = UserDefaults.standard.object(forKey:"profileData") as? Data {
                        profileData = NSMutableDictionary(dictionary: NSKeyedUnarchiver.unarchiveObject(with: archivedObject) as! NSMutableDictionary)
                    }
                    
                    if let userID = UserDefaults.standard.string(forKey: "userID") {
                        UserID = userID
                    }
                    
                    headersCommon = [
                        "Authorization": userToken
                    ]
                    
                    //Write here Home Screen Navigation code
                    
                } else {
                    print(isURLValid ? "Your Token invalid" : "URL is invalid")
                    
                    //Write here Login screen Navigation code
                }
                self.window?.makeKeyAndVisible()
        }
        
        return true
    }
```

## User Authentication and Profile Data Handling
 
To authenticate a user and manage their profile data, you can use the `userAuthentication` method provided by `TouchEPlugin`.

### User Login

The `userAuthentication` method takes a username and password, then returns a result indicating success or failure.

```swift
TouchEPluginVC.shared.userAuthentication(username: txtFieldEmail.text ?? "", password: txtFieldPassword.text ?? "") { result in
        switch result {
        case .success(let resultValue):
            print("Operation successful: \(resultValue)")
                
            UserToken = resultValue.token
            UserDefaults.standard.set(UserToken, forKey: "userToken")
            
            userTID = resultValue.userId
            UserDefaults.standard.set(userTID, forKey: "userID")

            profileTData = resultValue.profileData
            save()
                
            //Write here Home Screen Navigation code
                
        case .failure(let error):
            print("Error: \(error)")
        }
}
//Use save method for save user profile data
func save() {
    let archivedObject = NSKeyedArchiver.archivedData(withRootObject: profileTData)
    Default.set(archivedObject, forKey: "profileData")
}
```
## Retrieving Movie List and Cart Data

To fetch movie lists and cart data, you can use the `getMovieDetail` and `getCartDataCount` methods respectively.

### Get Movie List Data

```swift
var VideoListData : HomeData?
var CartDataARY : CartData?
    
TouchEPluginVC.shared.getMovieDetail { result in
    switch result {
    case .success(let homeData):
        self.VideoListData = homeData
        self.dataTBL.reloadData()
    case .failure(let error):
        print("Error: \(error)")
    }
}
```
### Get Cart Data Count

```swift          
TouchEPluginVC.shared.getCartDataCount { result in
    switch result {
    case .success(let cartData):
        self.CartDataARY = cartData
        self.cartCountBTN.setTitle("\(self.CartDataARY?.count ?? 0)", for: .normal)
    case .failure(let error):
        print("Error: \(error)")
    }
}        
```
## Screen Navigation

`TouchEPlugin` supports navigation to various screens in your app, such as movie details, cart, and profile screens.

### Navigate to Movie Details Screen

```swift 
let viewcontroller = VideoDetailViewController()
viewcontroller.modalPresentationStyle = .custom
viewcontroller.VideoListData = VideoListData[SelectedIndex]
self.navigationController?.pushViewController(viewcontroller, animated: true)
```
### Navigate to My Cart Screen

```swift  
let viewcontroller = MyCartVC()
self.navigationController?.pushViewController(viewcontroller, animated: true)
```
### Navigate to My Profile Screen

```swift  
let viewcontroller = ProfileVC()
self.navigationController?.pushViewController(viewcontroller, animated: true)
```
