//
//  AddAddressVC.swift
//  Touch E Demo
//
//  Created by Parth on 22/02/24.
//

import UIKit
import Alamofire
class AddAddressVC: UIViewController {
    
    static func storyboardInstance() -> AddAddressVC {
        return AddAddressVC(nibName: "AddAddressVC", bundle: Bundle.module)
    }
    
    @IBOutlet weak var nameTF: UITextFieldX!
    @IBOutlet weak var sCountryTF: UITextFieldX!
    @IBOutlet weak var sCityTF: UITextFieldX!
    @IBOutlet weak var sZipcodeTF: UITextFieldX!
    @IBOutlet weak var sAddressTF: UITextFieldX!
    @IBOutlet weak var bCountryTF: UITextFieldX!
    @IBOutlet weak var bCityTF: UITextFieldX!
    @IBOutlet weak var bZipCodeTF: UITextFieldX!
    @IBOutlet weak var baddressTF: UITextFieldX!
    @IBOutlet weak var selectionIMG: UIImageView!
    @IBOutlet weak var primaryIMG: UIImageView!
    
    var countryDataList = [AddressCountry]()
    var countryNameList: [String] = []
    var cityNameList: [String] = []
    var selectedCountry = ""
    var addressData : AddressDataModel?
    var isUpdate = false
    var isPrimaryAddress = false
    var isSameShippingAddress = false
    
    let sCountryPicker = UIPickerView()
    let sCityPickerView = UIPickerView()
    let bCountryPicker = UIPickerView()
    let bCityPickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if isUpdate{
            
            nameTF.text = addressData?.name ?? ""
            sAddressTF.text = addressData?.shippingAddress?.address ?? ""
            sZipcodeTF.text = addressData?.shippingAddress?.zipcode ?? ""
            sCityTF.text = addressData?.shippingAddress?.city ?? ""
            sCountryTF.text = addressData?.shippingAddress?.country ?? ""
            
            baddressTF.text = addressData?.billingAddress?.address ?? ""
            bZipCodeTF.text = addressData?.billingAddress?.zipcode ?? ""
            bCityTF.text = addressData?.billingAddress?.city ?? ""
            bCountryTF.text = addressData?.billingAddress?.country ?? ""
        }
        setPickerViewUI()
        getCountryList()
    }
    @IBAction func backClick_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func makeSameClick_Action(_ sender: UIButton) {
        isSameShippingAddress.toggle()
        if isSameShippingAddress{
            if nameTF.text!.isEmpty {
                ShowAlert(title: "Error", message: "Please enter address name.")
            }else if sCountryTF.text!.isEmpty {
                ShowAlert(title: "Error", message: "Please enter shipping country.")
            }else if sCityTF.text!.isEmpty {
                ShowAlert(title: "Error", message: "Please enter shipping city.")
            }else if sZipcodeTF.text!.isEmpty {
                ShowAlert(title: "Error", message: "Please enter shipping zip code.")
            }else if sAddressTF.text!.isEmpty {
                ShowAlert(title: "Error", message: "Please enter shipping address.")
            }else{
                baddressTF.text = sAddressTF.text
                bZipCodeTF.text = sZipcodeTF.text
                bCityTF.text = sCityTF.text
                bCountryTF.text = sCountryTF.text
                selectionIMG.image =  UIImage(named: "check-box")
            }
            
        }else{
            selectionIMG.image =  UIImage(named: "check-box-empty")
        }
    }
    @IBAction func cancelClick_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func makePrimaryClick(_ sender: UIButton) {
        isPrimaryAddress.toggle()
        primaryIMG.image = isPrimaryAddress ? UIImage(named: "check-box") : UIImage(named: "check-box-empty")
    }
    @IBAction func saveClick_Action(_ sender: UIButton) {
        if nameTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter address name.")
        }else if sCountryTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter shipping country.")
        }else if sCityTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter shipping city.")
        }else if sZipcodeTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter shipping zip code.")
        }else if sAddressTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter shipping address.")
        }else if bCountryTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter billing country.")
        }else if bCityTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter billing city.")
        }else if bZipCodeTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter billing zip code.")
        }else if baddressTF.text!.isEmpty {
            ShowAlert(title: "Error", message: "Please enter billing address.")
        }else{
            if isUpdate{
                updateAddress()
            }else{
                addNewAddress()
            }
        }
        
    }
    func setPickerViewUI(){
        sCountryPicker.delegate = self
        sCountryPicker.dataSource = self
        sCountryTF.inputView = sCountryPicker
        
        sCityPickerView.delegate = self
        sCityPickerView.dataSource = self
        sCityTF.inputView = sCityPickerView
        
        bCountryPicker.delegate = self
        bCountryPicker.dataSource = self
        bCountryTF.inputView = bCountryPicker
        
        bCityPickerView.delegate = self
        bCityPickerView.dataSource = self
        bCityTF.inputView = bCityPickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        
        sCountryTF.inputAccessoryView = toolbar
        sCityTF.inputAccessoryView = toolbar
        sCountryTF.delegate = self
        sCityTF.delegate = self
        
        bCountryTF.inputAccessoryView = toolbar
        bCityTF.inputAccessoryView = toolbar
        bCountryTF.delegate = self
        bCityTF.delegate = self
    }
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}
extension AddAddressVC {
    func addNewAddress(){
        
        
        let shiipingAddress = NSMutableDictionary()
        shiipingAddress["country"] = sCountryTF.text!
        shiipingAddress["city"] = sCityTF.text!
        shiipingAddress["zipcode"] = sZipcodeTF.text!
        shiipingAddress["address"] = sAddressTF.text!
        
        let billingAddress = NSMutableDictionary()
        billingAddress["country"] = bCountryTF.text
        billingAddress["city"] = bCityTF.text
        billingAddress["zipcode"] = bZipCodeTF.text
        billingAddress["address"] = baddressTF.text
        
        let params = ["name":nameTF.text!,
                      "shippingAddress":shiipingAddress,
                      "billingAddress":billingAddress,
                      "primary":isPrimaryAddress
        ] as [String : Any]
        //print(params)
        start_loading()
        self.post_api_request_withJson("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/user/\(UserID)/address", params: params, headers: headersCommon).responseData { response in
            print(response.result)
            switch response.result {
            case .success:
                self.navigationController?.popViewController(animated: true)
                self.ShowAlert(title: "Successful operation", message: "Address details added successfully")
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    func updateAddress(){
        
        
        let shiipingAddress = NSMutableDictionary()
        shiipingAddress["id"] = addressData?.shippingAddress?.id ?? ""
        shiipingAddress["country"] = sCountryTF.text!
        shiipingAddress["city"] = sCityTF.text!
        shiipingAddress["zipcode"] = sZipcodeTF.text!
        shiipingAddress["address"] = sAddressTF.text!
        
        let billingAddress = NSMutableDictionary()
        billingAddress["id"] = addressData?.billingAddress?.id ?? ""
        billingAddress["country"] = bCountryTF.text
        billingAddress["city"] = bCityTF.text
        billingAddress["zipcode"] = bZipCodeTF.text
        billingAddress["address"] = baddressTF.text
        
        let params = [
            "id":"\(addressData?.id ?? 0)",
            "name":nameTF.text!,
            "shippingAddress":shiipingAddress,
            "billingAddress":billingAddress,
            "primary":isPrimaryAddress
        ] as [String : Any]
        //print(params)
        start_loading()
        self.put_api_request_withJson("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/user/\(UserID)/address/\(addressData?.id ?? 0)", params: params, headers: headersCommon).responseData { response in
            print(response.result)
            switch response.result {
            case .success:
                //self.ShowAlert(title: "Successful", message: "Address details save successfully")
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
    func getCountryList() {
//        countryDataList.removeAll()
//        cityNameList.removeAll()
        start_loading()
        let headers: HTTPHeaders = [
            "Authorization": AuthToken
        ]
        let url = "https://countriesnow.space/api/v0.1/countries/population/cities"
        let request = get_api_request(url, headers: headers)
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value) {
                        let decoder = JSONDecoder()
                        let countryData = try decoder.decode(AddressCountry.self, from: jsonData)
                        self.countryDataList.append(countryData)
                        let allCountryNames = self.getCountryNames()
                        self.countryNameList = allCountryNames
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    func getCountryNames() -> [String] {
        var countryNames: Set<String> = Set()
        for countryData in countryDataList {
            if let data = countryData.data {
                for datum in data {
                    if let country = datum.country {
                        countryNames.insert(country)
                    }
                }
            }
        }
        return Array(countryNames)
    }

    func getCities(for country: String) -> [String] {
        var cities: [String] = []
        for countryData in countryDataList {
            if let data = countryData.data {
                for datum in data {
                    if let city = datum.city, datum.country == country {
                        cities.append(city)
                    }
                }
            }
        }
        return cities
    }

}

extension AddAddressVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == sCityTF {
            if cityNameList.count == 0 {
                let alert = UIAlertController(title: "Please Select Country", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        }
    }
}


extension AddAddressVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == sCountryPicker{
            return 1
        }else if pickerView == sCityPickerView{
            return 1
        }else if pickerView == bCountryPicker{
            return 1
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sCountryPicker{
            return countryNameList.count
        }else if pickerView == sCityPickerView{
            return cityNameList.count
        }else if pickerView == bCountryPicker{
            return countryNameList.count
        } else {
            return cityNameList.count
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == sCountryPicker{
            return countryNameList[row]
        }else if pickerView == sCityPickerView{
            return cityNameList[row]
        }else if pickerView == bCountryPicker{
            return countryNameList[row]
        } else {
            return cityNameList[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sCountryPicker{
            sCountryTF.text = countryNameList[row]
            selectedCountry = countryNameList[row]
            cityNameList.removeAll()
            let cityName = self.getCities(for: self.selectedCountry)
            self.cityNameList = cityName
        }else if pickerView == sCityPickerView{
            sCityTF.text = cityNameList[row]
        }else if pickerView == bCountryPicker{
            bCountryTF.text = countryNameList[row]
            selectedCountry = countryNameList[row]
            cityNameList.removeAll()
            let cityName = self.getCities(for: self.selectedCountry)
            self.cityNameList = cityName
        } else {
            bCityTF.text = cityNameList[row]
        }
    }
}
