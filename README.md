# TouchEPlugin

## Installation

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding [TouchEPlugin](https://github.com/github/cmark-gfm) as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.

```swift
.package(url: "https://github.com/Kishan-Italiya/TouchEPlugin.git", branch: "main"),
```

## Usage

### Import Package 
In AppDelegate.swift, just import TouchEPlugin framework and enable TouchEPlugin. 

After that First check your server URL is valid or not and User are already login or not in TouchEPlugin using validateURLAndToken method.
 
```swift
import IQKeyboardManagerSwift

@UIApplicationMain
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let urlString = "https://api-cluster.system.touchetv.com"
        var userToken = ""
        
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

### Login 
Login using userAuthentication method in which you have to just passed username and password.

After successfully login save user data in your project like below example.

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
                self.ShowAlert1(title: "Error", message: "Wrong Username and Password")
            }
    }
    //Use save method for save user profile data
    func save() {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: profileTData)
        Default.set(archivedObject, forKey: "profileData")
    }
```
### Get Movie list Data
Get movie list using getMovieDetail method 

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
            self.ShowAlert1(title: "Error", message: "\(error.localizedDescription)")
        }
    }
    
    //Use this method for get my cart count         
    TouchEPluginVC.shared.getCartDataCount { result in
        switch result {
        case .success(let cartData):
            self.CartDataARY = cartData
            self.cartCountBTN.setTitle("\(self.CartDataARY?.count ?? 0)", for: .normal)
        case .failure(let error):
            self.ShowAlert1(title: "Error", message: "\(error.localizedDescription)")
        }
    }
        
```
### Navigation to Movie Details Screen

```swift 
    let viewcontroller = VideoDetailViewController()
    viewcontroller.modalPresentationStyle = .custom
    viewcontroller.VideoListData = VideoListData[SelectedIndex]
    self.navigationController?.pushViewController(viewcontroller, animated: true)
```
### Navigation to My Cart Screen

```swift 
    let viewcontroller = MyCartVC()
    self.navigationController?.pushViewController(viewcontroller, animated: true)
```
