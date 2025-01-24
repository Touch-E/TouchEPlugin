//
//  Constant.swift
//  level777
//
//  Created by TBI-iOS-02 on 23/03/20.
//  Copyright © 2020 TBI-iOS-02. All rights reserved.
//

import UIKit
import AVFoundation
//import NVActivityIndicatorView
//import Alamofire

let DefaultAnimationDuration: TimeInterval        = 0.3

var window: UIWindow?
public let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
public let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
public let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)

public typealias JSONArray = [[String : Any]]
public typealias JSONDictionary = [String : Any]
public let ScreenHeight = UIScreen.main.bounds.height
public let ScreenWidth = UIScreen.main.bounds.width
public var LoadeSize = CGSize(width: 45, height: 45)
//public var profileData = NSMutableDictionary()
public var placeholderImg = UIImage(named: "")


var UserToken = ""
var userTID = ""
var profileTData = NSMutableDictionary()
var Default = UserDefaults.standard


func save() {
    let archivedObject = NSKeyedArchiver.archivedData(withRootObject: profileTData)
    Default.set(archivedObject, forKey: "profileData")
}

func retrive() {
    if let archivedObject = Default.object(forKey:"profileData") as? Data {
        profileTData = NSMutableDictionary(dictionary: NSKeyedUnarchiver.unarchiveObject(with: archivedObject) as! NSDictionary)
    }
}

extension String {
    func isValidEmail() -> Bool {
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
           let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           return emailPredicate.evaluate(with: self)
       }
   
}


extension UIViewController  {

    func ShowAlert1(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
