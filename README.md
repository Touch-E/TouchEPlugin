# TouchEPlugin

## Installation

To integrate TouchEPlugin into your Swift package, add the following dependency to your Package.swift file:

```swift
.package(url: "https://github.com/Kishan-Italiya/TouchEPlugin.git", branch: "main"),
```

## Usage

### Setup in AppDelegate.swift
First, import the TouchEPlugin framework and validate the server URL and user token in your application(_:didFinishLaunchingWithOptions:) method:
 
```swift
import TouchEPlugin

@UIApplicationMain
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

### User Authentication and Profile Data Handling 
Login using userAuthentication method and save user data upon successful login:

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
### Retrieving Movie List and Cart Data
Fetch movie list and cart data using getMovieDetail and getCartDataCount methods:

```swift
var VideoListData : HomeData?
var CartDataARY : CartData?
    
//use this method for get movie list 
TouchEPluginVC.shared.getMovieDetail { result in
    switch result {
    case .success(let homeData):
        self.VideoListData = homeData
        self.dataTBL.reloadData()
    case .failure(let error):
        print("Error: \(error)")
    }
}
    
//Use this method for get my cart count         
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
### Navigation Examples
Navigate to different screens within your app:

```swift 
// Navigate to Movie Details Screen
let viewcontroller = VideoDetailViewController()
viewcontroller.modalPresentationStyle = .custom
viewcontroller.VideoListData = VideoListData[SelectedIndex]
self.navigationController?.pushViewController(viewcontroller, animated: true)
 
// Navigate to My Cart Screen
let viewcontroller = MyCartVC()
self.navigationController?.pushViewController(viewcontroller, animated: true)

// Navigate to My Profile Screen
let viewcontroller = ProfileVC()
self.navigationController?.pushViewController(viewcontroller, animated: true)
```
