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

public var ServerURL = ""
public var BaseURL = "\(ServerURL)/backoffice-user/api/v1/"
public var BaseURLOffice = "\(ServerURL)/backoffice/api/v1/"
public var loadContents = "?loadContents=true&loadHierarchy=true&loadProjects=true&showOnlyPublished=true&loadAsTree=true"

public var userLogin = "\(BaseURL)login\(loadContents)"
public var userRegister = "\(BaseURL)user/register?loadContents=t"
public var getProject  = "\(BaseURLOffice)project/all\(loadContents)"

public var profileData = NSMutableDictionary()
public var AuthToken = ""
public var UserID = ""
public var headersCommon: HTTPHeaders = [
    "Authorization": AuthToken
]

extension UIViewController  {
    
    func post_api_request(_ url: String, params: [String: String]) -> DataRequest {
        return AF.request(url, method: HTTPMethod.post, parameters: params, headers: nil) //,encoding: JSONEncoding.default
    }
    func post_api_request_withJson(_ url: String, params: [String: Any] ,headers: HTTPHeaders? = nil) -> DataRequest {
        return AF.request(url, method: HTTPMethod.post, parameters: params,encoding: JSONEncoding.default, headers: headers)
    }
    func put_api_request_withJson(_ url: String, params: [String: Any] ,headers: HTTPHeaders? = nil) -> DataRequest {
        return AF.request(url, method: HTTPMethod.put, parameters: params,encoding: JSONEncoding.default, headers: headers)
    }
    func post_api_request_without_param(_ url: String) -> DataRequest {
        return AF.request(url, method: HTTPMethod.post, parameters: nil,encoding: JSONEncoding.default, headers: nil)
    }
    func get_api_request_withJson(_ url: String, params: [String: Any]) -> DataRequest {
        return AF.request(url, method: HTTPMethod.get, parameters: params,encoding: URLEncoding.default, headers: nil)

    }
    func get_api_request(_ url: String, headers: HTTPHeaders? = nil) -> DataRequest {
        return AF.request(url, method: .get, headers: headers)
    }
    func options_api_request(_ url: String, headers: HTTPHeaders? = nil) -> DataRequest {
        return AF.request(url, method: .options, headers: headers)
    }
    func delete_api_request(_ url: String, headers: HTTPHeaders? = nil) -> DataRequest {
        return AF.request(url, method: .delete, headers: headers)
    }
    func ShowAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func convertToDictionary<T: Codable>(_ object: T) -> NSDictionary? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            return dictionary
        } catch {
            print("Error converting to dictionary: \(error.localizedDescription)")
            return nil
        }
    }

}

public class APIManager {
    static let shared = APIManager()
    
    //private init() {}
    
    //Get Home Screen Video data
    func getModelDetail(completion: @escaping (Result<HomeData, Error>) -> Void) {
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
    
    //Get Cart data
    func getCartDetail(userID: String, completion: @escaping (Result<CartData, Error>) -> Void) {
        let url = "\(BaseURLOffice)cart/users/\(userID)/products\(loadContents)"
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
