//
//  AppDelegate.swift
//  ExampleApp
//
//  Created by Parth on 18/04/24.
//

import UIKit
import TouchEPlugin
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let urlString = "https://api-cluster.system.touchetv.com"
        var userToken = ""//"Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI0MSIsInVzZXJSb2xlcyI6WyJWSUVXRVIiXSwib3JnSWRzIjpbMV0sImlhdCI6MTcwNzI3OTE4MSwiZXhwIjoxNzA3MzY5MTgxfQ.vLJ73Ei6jklWSCPGHY54Tpluom1hgCH0cgXPjrvjrPvdg8792SJOWlFx8ojpOAF1-ZVP8cdGqwGmkfMse8n9ow"
        if let retrievedString = UserDefaults.standard.string(forKey: "userToken") {
            userToken = retrievedString
        } else {
            userToken = ""
        }
        
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
        
        return true
    }

    


}

