//
//  TouchEPluginVC.swift
//  
//
//  Created by Parth on 26/04/24.
//

import UIKit
import Alamofire
public class TouchEPluginVC: UIViewController {

    public static let shared = TouchEPluginVC()
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    public struct AuthenticationResult {
        public let token: String
        public let userId: String
        public let profileData: NSMutableDictionary
    }
    
    public func userAuthentication(username: String, password: String, completion: @escaping (Result<AuthenticationResult, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
        ]
        let params = [
            "emailAddress": username,
            "password": password
        ] as [String : Any]
        print(params)
        start_loading()
        self.post_api_request_withJson(userLogin, params: params, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    let dic = asJSON as? NSDictionary ?? [:]
                    let error = dic.value(forKey: "message") as? String ?? ""
                    if error == "" {
                        
                        let tokenType = dic.value(forKey: "tokenType") ?? ""
                        let token = dic.value(forKey: "accessToken") ?? ""
                        let userDic = dic.value(forKey: "userDetails") as? NSDictionary
                        profileData = userDic?.mutableCopy() as? NSMutableDictionary ?? [:]
                        save()
                        AuthToken = "\(tokenType) \(token)"
                        UserID = "\(userDic!.value(forKey: "id")!)"
                        
                        headersCommon = [
                            "Authorization": AuthToken
                        ]
                        
                        let result = AuthenticationResult(token: AuthToken, userId: UserID, profileData: profileData)
                        completion(.success(result))
                       
                       
                    }else {
                        //self.ShowAlert(title: "Error", message: response.error?.localizedDescription ?? "Something Went Wrong")
                        if let error = response.error {
                            completion(.failure(error))
                        } else {
                            let defaultError = NSError(domain: "Something Went Wrong", code: 0, userInfo: nil)
                            completion(.failure(defaultError))
                        }
                    }
                } catch {
                    //self.ShowAlert(title: "Error", message: response.error?.localizedDescription ?? "Something Went Wrong")
                    if let error = response.error {
                        completion(.failure(error))
                    } else {
                        let defaultError = NSError(domain: "Something Went Wrong", code: 0, userInfo: nil)
                        completion(.failure(defaultError))
                    }
                }
            case .failure(let error):
                //self.ShowAlert(title: "Error", message: "\(error)")
                completion(.failure(error as Error))
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }

    }
    
    public func validateURLAndToken(urlString: String, token: String, completion: @escaping (Bool, Bool) -> Void) {
        
        if URL(string: urlString) != nil {
            ServerURL = urlString
        }
        
        let isURLValid = URL(string: urlString) != nil
       
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        let url = "\(BaseURLOffice)project/all\(loadContents)"
        AF.request(url, headers: headers).responseDecodable(of: HomeData.self) { response in
            switch response.result {
            case .success:
                completion(isURLValid, true)
            case .failure(let error):
                print(error.localizedDescription)
                if let statusCode = response.response?.statusCode {
                    print("Status code: \(statusCode)")
                    if statusCode == 401{
                        completion(isURLValid, false)
                    }
                }
                completion(false, false)
            }
        }
    }
    
   public func getMovieDetail(completion: @escaping (Result<HomeData, Error>) -> Void) {
        let url = getProject
        AF.request(url, headers: headersCommon).responseDecodable(of: HomeData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCartDataCount(completion: @escaping (Result<CartData, Error>) -> Void) {
        let url = "\(BaseURLOffice)cart/users/\(UserID)/products\(loadContents)"
         AF.request(url, headers: headersCommon).responseDecodable(of: CartData.self) { response in
             switch response.result {
             case .success(let data):
                 completion(.success(data))
             case .failure(let error):
                 completion(.failure(error))
             }
         }
     }
    
    
}
