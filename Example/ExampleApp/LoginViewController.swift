//
//  LoginViewController.swift
//  Touch E Demo
//
//  Created by Kishan on 29/01/24.
//

import UIKit
import Alamofire
import TouchEPlugin

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtFieldEmail: UITextFieldX!
    @IBOutlet weak var txtFieldPassword: UITextFieldX!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldEmail.text = "kishanchecker123@gmail.com"
        txtFieldPassword.text = "Kishan@123"
        
        let profileViewController = ProfileVC()
        profileViewController.logoutTap = {
            print("log")
        }
        
    }
    
    
    @IBAction func btnForgotPasswordClick(_ sender: Any) {
        //        let viewController = RegisterViewController.storyboardInstance()
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnLoginClick(_ sender: Any) {
        
        if txtFieldEmail.text!.isEmpty {
            ShowAlert1(title: "Error", message: "Please enter Email.")
            
        } else if !txtFieldEmail.text!.isValidEmail() {
            ShowAlert1(title: "Error", message: "Please enter valid Email.")
            
        }else if txtFieldPassword.text!.isEmpty {
            
            ShowAlert1(title: "Error", message: "Please enter Password.")
        }else {
            LoginAPI()
            
        }
    }
}

extension LoginViewController {
    func LoginAPI(){
        
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
                let testViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(testViewController, animated: true)
                
            case .failure(let error):
                print("Error: \(error)")
                self.ShowAlert1(title: "Error", message: "Wrong Username and Password")
            }
        }
       
    }
}
