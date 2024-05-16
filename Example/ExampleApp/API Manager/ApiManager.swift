//
//  ApiManager.swift
//  NGO APP
//
//  Created by Kishan on 17/07/23.
//

import Foundation
import UIKit
import AVFoundation
import NVActivityIndicatorView
import Alamofire

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


extension UIViewController  {

    func ShowAlert1(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
   

}
