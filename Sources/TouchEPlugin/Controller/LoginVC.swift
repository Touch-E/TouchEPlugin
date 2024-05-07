//
//  LoginVC.swift
//  
//
//  Created by Parth on 26/04/24.
//

import UIKit
import Alamofire

public class LoginVC: UIViewController {

    public static let shared = LoginVC()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    public struct AuthenticationResult {
//        public let token: String
//        public let userId: String
//        public let profileData: NSMutableDictionary
//    }
//    
//    public func userAuth(username: String, password: String, completion: @escaping (Result<AuthenticationResult, Error>) -> Void) {
//        
//        let headers: HTTPHeaders = [
//        ]
//        let params = [
//            "emailAddress": username,
//            "password": password
//        ] as [String : Any]
//        print(params)
//        start_loading()
//        self.post_api_request_withJson(userLogin, params: params, headers: headers).responseData { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    let asJSON = try JSONSerialization.jsonObject(with: data)
//                    let dic = asJSON as? NSDictionary ?? [:]
//                    let error = dic.value(forKey: "message") as? String ?? ""
//                    if error == "" {
//                        
//                        let tokenType = dic.value(forKey: "tokenType") ?? ""
//                        let token = dic.value(forKey: "accessToken") ?? ""
//                        let userDic = dic.value(forKey: "userDetails") as? NSDictionary
//                        profileData = userDic?.mutableCopy() as? NSMutableDictionary ?? [:]
//                        save()
//                        AuthToken = "\(tokenType) \(token)"
//                        UserID = "\(userDic!.value(forKey: "id")!)"
//                        
//                        headersCommon = [
//                            "Authorization": AuthToken
//                        ]
//                        
//                        let result = AuthenticationResult(token: AuthToken, userId: UserID, profileData: profileData)
//                        completion(.success(result))
//                       
//                       
//                    }else {
//                        //self.ShowAlert(title: "Error", message: response.error?.localizedDescription ?? "Something Went Wrong")
//                        if let error = response.error {
//                            completion(.failure(error))
//                        } else {
//                            let defaultError = NSError(domain: "Something Went Wrong", code: 0, userInfo: nil)
//                            completion(.failure(defaultError))
//                        }
//                    }
//                } catch {
//                    //self.ShowAlert(title: "Error", message: response.error?.localizedDescription ?? "Something Went Wrong")
//                    if let error = response.error {
//                        completion(.failure(error))
//                    } else {
//                        let defaultError = NSError(domain: "Something Went Wrong", code: 0, userInfo: nil)
//                        completion(.failure(defaultError))
//                    }
//                }
//            case .failure(let error):
//                //self.ShowAlert(title: "Error", message: "\(error)")
//                completion(.failure(error as Error))
//            }
//            DispatchQueue.main.async {
//                self.stop_loading()
//            }
//        }
//
//    }
}
