//
//  ProfileVC.swift
//  Touch E Demo
//
//  Created by Parth on 21/02/24.
//

import UIKit
import Alamofire
public class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileTBL: UITableView!
    @IBOutlet weak var logoutPopupView: UIView!
    
   public var logoutTap :(()->())?
    public struct Identifiers {
        static let kAccountDetailsCell = "AccountDetailsCell"
        static let kAddressCell = "AddressCell"
        static let kPaymentCardCell = "PaymentCardCell"
        static let kOrderCell = "OrderCell"
        
    }
    
    var addressListData : AddressData?
    var cardListData : CardModel?
    var isCellExpanded = false
    var isAddressExpanded = false
    var isCardExpanded = false
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let view = Bundle.module.loadNibNamed("ProfileVC", owner: self, options: nil)?.first as? UIView {
            self.view = view
            
        }
        ConfigureTableView()
    }
    @IBAction func backClick_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    public override func viewWillAppear(_ animated: Bool) {
        GetAddressList()
        GetCardList()
    }
    func ConfigureTableView(){
        
        profileTBL.delegate = self
        profileTBL.dataSource = self
        profileTBL.separatorStyle = .none
        profileTBL.register(UINib(nibName: Identifiers.kAccountDetailsCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kAccountDetailsCell)
        profileTBL.register(UINib(nibName: Identifiers.kAddressCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kAddressCell)
        profileTBL.register(UINib(nibName: Identifiers.kPaymentCardCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kPaymentCardCell)
        profileTBL.register(UINib(nibName: Identifiers.kOrderCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kOrderCell)
    }
    @IBAction func logoutClick_Action(_ sender: UIButton) {
        self.logoutPopupView.isHidden = false
        
    }
    @IBAction func didcancelTapFrompopupView(_ sender: UIButton) {
        self.logoutPopupView.isHidden = true
    }
    @IBAction func didLogoutTapFrompopupView(_ sender: UIButton) {
        logoutTap?()
//        let vc = authStoryboard.instantiateViewController(withIdentifier: "loginNav") as! UINavigationController
//        UIApplication.shared.windows.first?.rootViewController = vc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        navigationController?.popToRootViewController(animated: true)
    }
    
}
extension ProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = profileTBL.dequeueReusableCell(withIdentifier: Identifiers.kAccountDetailsCell, for: indexPath) as! AccountDetailsCell
            cell.selectionStyle = .none
            
            let dic = profileData
            cell.emailLBL.text = "\(dic.value(forKey: "emailAddress")!)"
            cell.fnameLBL.text = "\(dic.value(forKey: "firstName") ?? "NA")"
            cell.snameLBL.text = "\(dic.value(forKey: "lastName") ?? "NA")"
            cell.genderLBL.text = "\(dic.value(forKey: "sex") ?? "NA")"
            cell.mobileLBL.text = "\(dic.value(forKey: "phoneNumber") ?? "NA")"
            cell.langLBL.text = "\(dic.value(forKey: "language") ?? "NA")"
            cell.currencyLBL.text = "\(dic.value(forKey: "currency") ?? "NA")"
            
            let dateString = "\(dic.value(forKey: "created") ?? "NA")"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: dateString) {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: date)
                if let year = components.year, let month = components.month, let day = components.day {
                    //print("Year: \(year), Month: \(month), Day: \(day)")
                    cell.eventDateLBL.text = "\(year)-\(month)-\(day)"
                }
            }
            
            var image = ""
            image = dic.value(forKey: "imageUrl") as? String ?? ""
            
            if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                // Use the encoded URL string
                print(encodedUrlString)
                cell.profileIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
                cell.profileIMG.contentMode = .scaleAspectFill
            } else {
                // Handle the case where encoding fails
                print("Failed to encode URL string")
            }
            
            cell.cellExpand = {
                self.isCellExpanded.toggle()
                self.profileTBL.beginUpdates()
                self.profileTBL.endUpdates()
                self.profileTBL.reloadData()
                //self.cartDataTBL.reloadRows(at: [indexPath], with: .automatic)
            }
            
            cell.cellEdit = {
                let vc = EditProfileVC.storyboardInstance()
//                vc.profileData = profileData
                vc.modalPresentationStyle = .custom
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell
        }else if indexPath.row == 1{
            let cell = profileTBL.dequeueReusableCell(withIdentifier: Identifiers.kAddressCell, for: indexPath) as! AddressCell
            cell.selectionStyle = .none
            cell.addressListData = addressListData
            cell.addressCV.reloadData()
            cell.addressCV.isHidden = self.isAddressExpanded ? false : true
            
            
            cell.cellExpand = {
                self.isAddressExpanded.toggle()
                self.profileTBL.beginUpdates()
                self.profileTBL.endUpdates()
                self.profileTBL.reloadData()
                //self.cartDataTBL.reloadRows(at: [indexPath], with: .automatic)
            }
            cell.changeAddressAction = { indexx in
                self.updatePrimaryAddress(indexx: indexx)
            }
            cell.deleteAddressAction = { indexx in
                self.deleteAddress(indexx: indexx)
            }
            cell.addAddressAction = {
                let vc = AddAddressVC.storyboardInstance()
                vc.modalPresentationStyle = .custom
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.editAddressAction = { indexx in
                let vc = AddAddressVC.storyboardInstance()
                vc.modalPresentationStyle = .custom
                vc.addressData = self.addressListData?[indexx]
                vc.isUpdate = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }else if indexPath.row == 2{
            let cell = profileTBL.dequeueReusableCell(withIdentifier: Identifiers.kPaymentCardCell, for: indexPath) as! PaymentCardCell
            cell.selectionStyle = .none
            cell.cardListData = cardListData
            cell.cardListCV.reloadData()
            
            cell.cellExpand = {
                self.isCardExpanded.toggle()
                self.profileTBL.beginUpdates()
                self.profileTBL.endUpdates()
                self.profileTBL.reloadData()
                
                if self.isCardExpanded{
                    cell.cardListCV.isHidden = self.cardListData?.count ?? 0 > 0 ? false : true
                    cell.noPaymentLBL.isHidden = self.cardListData?.count ?? 0 > 0 ? true : false
                }else{
                    cell.noPaymentLBL.isHidden = true
                    cell.cardListCV.isHidden = true
                }
            }
            
            cell.deleteCardActionM = { indexx in
                self.deleteCard(indexx: indexx)
            }
            return cell
        }else{
            let cell = profileTBL.dequeueReusableCell(withIdentifier: Identifiers.kOrderCell, for: indexPath) as! OrderCell
            cell.selectionStyle = .none
            cell.orderAction = {
                let vc = OrderListVC.storyboardInstance()
                vc.modalPresentationStyle = .custom
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return isCellExpanded ? 290 : 50
        }else if indexPath.row == 1{
            return isAddressExpanded ? 382 : 50
        }else if indexPath.row == 2{
            return isCardExpanded ? 350 : 50
        }else{
            return 50
        }
    }
    
}

extension ProfileVC {
    
    func GetAddressList(){
        
        start_loading()
        self.get_api_request("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/user/\(UserID)/address/", headers: headersCommon).responseDecodable(of: AddressData.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(AddressData.self, from: responseData)
                        self.addressListData = welcome.sorted { $0.primary ?? false && !($1.primary ?? false) }
                        self.profileTBL.reloadData()
                    } catch {
                        self.ShowAlert(title: "Error", message: "Failed to decode response: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
    func updatePrimaryAddress(indexx: Int){
        
        let shippingAddress = convertToDictionary(self.addressListData?[indexx].shippingAddress)
        let billingAddress = convertToDictionary(self.addressListData?[indexx].billingAddress)
    
        let params = [
            "id":"\(self.addressListData?[indexx].id ?? 0)",
                       "name":"\(self.addressListData?[indexx].name ?? "")",
                       "shippingAddress":shippingAddress!,
                       "billingAddress":billingAddress!,
                       "primary":true
        ] as [String : Any]
        //print(params)
        start_loading()
        self.put_api_request_withJson("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/user/\(UserID)/address/\(self.addressListData?[indexx].id ?? 0)", params: params, headers: headersCommon).responseData { response in
            print(response.result)
            switch response.result {
            case .success:
                self.GetAddressList()
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
    func deleteAddress(indexx: Int){
        start_loading()
        self.delete_api_request("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/user/\(UserID)/address/\(self.addressListData?[indexx].id ?? 0)", headers: headersCommon).responseData { response in
            print(response.result)
            switch response.result {
            case .success:
                self.GetAddressList()
            case .failure(let error):
                print("Error converting to dictionary: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
    func GetCardList(){
        
        start_loading()
        self.get_api_request("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/user/\(UserID)/creditCards", headers: headersCommon).responseDecodable(of: CardModel.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(CardModel.self, from: responseData)
                        self.cardListData = welcome
                        self.profileTBL.reloadData()
                    } catch {
                        self.ShowAlert(title: "Error", message: "Failed to decode response: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
    func deleteCard(indexx: Int){
        start_loading()
        self.delete_api_request("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/user/\(UserID)/creditCards/\(self.cardListData?[indexx].id ?? 0)", headers: headersCommon).responseData { response in
            print(response.result)
            switch response.result {
            case .success:
                self.GetCardList()
            case .failure(let error):
                print("Error converting to dictionary: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
}
