//
//  EditProfileVC.swift
//  Touch E Demo
//
//  Created by Jaydip Godhani on 22/02/24.
//

import UIKit
import AVFoundation
import Alamofire
//import AWSMobileClientXCF

class EditProfileVC: UIViewController {
    
    static func storyboardInstance() -> EditProfileVC {
        return EditProfileVC(nibName: "EditProfileVC", bundle: Bundle.module)
    }
    
    @IBOutlet weak var txtFirstName: UITextFieldX!
    @IBOutlet weak var txtLastName: UITextFieldX!
    @IBOutlet weak var txtPhoneNumber: UITextFieldX!
    @IBOutlet weak var txtCurrentDate: UITextFieldX!
    @IBOutlet weak var txtGender: UITextFieldX!
    @IBOutlet weak var txtLanguage: UITextFieldX!
    @IBOutlet weak var txtCurrency: UITextFieldX!
    @IBOutlet weak var imgProfileImage: UIImageViewX!
    @IBOutlet weak var btnselectedProfilePic: UIButton!
    @IBOutlet weak var bgLogoutPopUpView: UIView!
    @IBOutlet weak var bgChangeAvatarPopUpView: UIView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var bgBlurView: UIView!
    
    let datePicker = UIDatePicker()
    let genderPickerView = UIPickerView()
    let languagePickerView = UIPickerView()
    let currencyPickerView = UIPickerView()
    
    //var profileDataView = NSMutableDictionary()
    var hideEmailText = ""
    var currentDateby = ""
    var currentDateFirst = ""
    var currentDateSecound = ""
    //    var genderPickerView: UIPickerView!
    let genderCategory = ["Male", "Female", "Other"]
    var lanuageName = [""]
    var currencyName = [""]
    
    var s3UploadImagePath = ""
    var selectedImgUrl = ""
    
    var region = ""
    var accessKeyID = ""
    var secretKey = ""
    var bucketName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLanguage()
        getCurrency()
        getCurrentDate()
        setPickerViewUI()
        fillUserData()
    }
    func setPickerViewUI(){
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        txtGender.inputView = genderPickerView
        
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        txtCurrentDate.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        
        txtCurrentDate.inputAccessoryView = toolbar
        
        // Set the text field delegate
        txtCurrentDate.delegate = self
    }
    @objc func doneButtonTapped() {
        // Dismiss the date picker when done button is tapped
        view.endEditing(true)
        
        // Handle selected date if needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        txtCurrentDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    func maskEmailAddress(email: String) -> String {
        // Split the email address into username and domain parts
        let components = email.components(separatedBy: "@")
        
        guard components.count == 2 else {
            // Invalid email format
            return email
        }
        
        // Get the username and domain
        let username = components[0]
        let domain = components[1]
        
        // Mask the username
        let maskedUsername = maskString(string: username)
        
        // Reconstruct the masked email address
        return "\(maskedUsername)@\(domain)"
    }
    func maskString(string: String) -> String {
        // If the string is shorter than 2 characters, just return it as is
        guard string.count > 1 else {
            return string
        }
        
        // Get the first character of the string
        let firstCharacter = string.prefix(1)
        
        // Repeat the first character and append '*' for the rest of the characters
        let maskedString = "\(firstCharacter)" + String(repeating: "*", count: string.count - 1)
        
        return maskedString
    }
    
    func fillUserData(){
        //let dic = profileData.value(forKey: "userDetails") as! NSDictionary
        txtFirstName.text = "\(profileData.value(forKey: "firstName") ?? "NA")"
        txtLastName.text = "\(profileData.value(forKey: "lastName") ?? "NA")"
        txtGender.text = "\(profileData.value(forKey: "sex") ?? "NA")"
        txtPhoneNumber.text = "\(profileData.value(forKey: "phoneNumber") ?? "NA")"
        txtLanguage.text = "\(profileData.value(forKey: "language") ?? "NA")"
        txtCurrency.text = "\(profileData.value(forKey: "currency") ?? "NA")"
        
        let email = "\(profileData.value(forKey: "emailAddress")!)"
        lblUserEmail.text = email
        hideEmailText = maskEmailAddress(email: email)
        lblEmailAddress.text = hideEmailText
        
        let dateString = "\(profileData.value(forKey: "created") ?? "NA")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            if let year = components.year, let month = components.month, let day = components.day {
                //print("Year: \(year), Month: \(month), Day: \(day)")
                txtCurrentDate.text = "\(year)-\(month)-\(day)"
            }
        }
        
        var image = ""
        image = profileData.value(forKey: "imageUrl") as? String ?? ""
        
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // Use the encoded URL string
            print(encodedUrlString)
            imgProfileImage.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            imgProfileImage.contentMode = .scaleAspectFill
            btnselectedProfilePic.setTitle("", for: .normal)
        } else {
            // Handle the case where encoding fails
            print("Failed to encode URL string")
        }
        
        
    }
    
    
    
    
    //MARK: - Get Current Date
    func getCurrentDate(){
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: currentDate)
        currentDateby = date
        
        let currentDate1 = Date()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyyMMdd"
        let date1 = dateFormatter1.string(from: currentDate1)
        currentDateFirst = date1
        
        let currentDate2 = Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyyMMdd'T'HHmmssSSSZ"
        let date2 = dateFormatter2.string(from: currentDate2)
        currentDateSecound = date2
    }
    
    
    //MARK: - Back Button Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Change Password Action
    @IBAction func btnChangePassword(_ sender: UIButton) {
        //        bgBlurView.isHidden = false
        //        bgLogoutPopUpView.isHidden = false
        //        bgLogoutPopUpView.alpha = 0
        //        tblList.alpha = 1
        //        // Make the logout popup view visible
        //        bgLogoutPopUpView.isHidden = false
        //
        //        // Perform animation to make the logout popup view appear gradually
        //        UIView.animate(withDuration: 0.3) {
        //            self.bgLogoutPopUpView.alpha = 1
        //            self.tblList.alpha = 0.2
        //        }
        let vc = profileStoryboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        //                vc.profileData = profileData
        vc.modalPresentationStyle = .custom
        if let userIdValue = profileData.value(forKey: "id") as? Int {
            vc.userId = userIdValue
        } else {
            vc.userId = 0 // or any default value you want to assign when the value is not an integer
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - Save Button Action
    @IBAction func btnSave(_ sender: UIButton) {
        if selectedImgUrl != "" {
            getS3Response()
          //  imageUploading()
        } else {
            editProfile()
        }
    }
    
    //MARK: - Gender Button Action
    @IBAction func btnGenderBottomSheert(_ sender: Any) {
        //        let alert = UIAlertController(title: "Selecte Your Gender", message: nil, preferredStyle: .actionSheet)
        //        let male = UIAlertAction(title: "Male", style: .default) { _ in
        //            self.txtGender.text = "Male"
        //        }
        //        let female = UIAlertAction(title: "Female", style: .default) { _ in
        //            self.txtGender.text = "Female"
        //        }
        //        let other = UIAlertAction(title: "Other", style: .default) { _ in
        //            self.txtGender.text = "Other"
        //        }
        //        alert.addAction(male)
        //        alert.addAction(female)
        //        alert.addAction(other)
        //        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Selected Proflie Pic Action
    @IBAction func btnselectedProfilePic(_ sender: UIButton){
        bgBlurView.isHidden = false
        bgChangeAvatarPopUpView.isHidden = false
    }
    @IBAction func btnCamera(_ sender: UIButton) {
        if self.isCameraAvailable() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Camera is not available", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func btnGallery(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnAvatarPopupCancel(_ sender: UIButton) {
        bgBlurView.isHidden = true
        bgChangeAvatarPopUpView.isHidden = true
    }
    //MARK: - Camera check Methods
    func isCameraAvailable() -> Bool {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil
    }
    //MARK: - Logout Button Action
    @IBAction func btnLogout(_ sender: UIButton){
        
    }
    
    @IBAction func btnPopUpCancel(_ sender: UIButton){
        bgBlurView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.bgLogoutPopUpView.alpha = 0.0 // Make the view transparent
            self.tblList.alpha = 1
        }) { (completed) in
            self.bgLogoutPopUpView.isHidden = true
        }
    }
    
    @IBAction func btnPopUpOkay(_ sender: UIButton){
        bgBlurView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.tblList.alpha = 1
            self.bgLogoutPopUpView.alpha = 0.0 // Make the view transparent
        }) { (completed) in
            self.bgLogoutPopUpView.isHidden = true
        }
    }
}
//MARK: - ImagePicker And Camera Delegate Methods
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imgProfileImage.image = pickedImage
            btnselectedProfilePic.setTitle("", for: .normal)
        }
        if let imageURL = info[.imageURL] as? URL {
            selectedImgUrl = imageURL.path
        }
        bgBlurView.isHidden = true
        bgChangeAvatarPopUpView.isHidden = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
//MARK: - TextFiald Delegate Methods
extension EditProfileVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtCurrentDate {
            // Programmatically select the date text field to show the date picker
            datePicker.date = Date() // Set initial date if needed
            datePicker.maximumDate = Date() // Set maximum date if needed
        }
    }
    
}

extension EditProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == genderPickerView{
            return 1
        } else if pickerView == languagePickerView {
            return 1
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPickerView{
            return genderCategory.count
        } else if pickerView == languagePickerView {
            return lanuageName.count
        } else {
            return currencyName.count
        }
        
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerView{
            return genderCategory[row]
        } else if pickerView == languagePickerView  {
            return lanuageName[row]
        } else {
            return currencyName[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPickerView{
            txtGender.text = genderCategory[row]
        } else if pickerView == languagePickerView {
            txtLanguage.text = lanuageName[row]
        } else {
            txtCurrency.text = currencyName[row]
        }
    }
}


extension EditProfileVC {
    func getLanguage(){
        
        
        let params = [ : ] as [String : Any]
        print(params)
        start_loading()
        
        self.get_api_request("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/config/languages", headers: headersCommon).responseDecodable(of: StringResponseModel.self) { [self] response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(StringResponseModel.self, from: responseData)
                        lanuageName = welcome
                        languagePickerView.delegate = self
                        languagePickerView.dataSource = self
                        txtLanguage.inputView = languagePickerView
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
    
    func getCurrency(){
        
        let params = [ : ] as [String : Any]
        print(params)
        start_loading()
        
        self.get_api_request("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/config/currencies", headers: headersCommon).responseDecodable(of: StringResponseModel.self) { [self] response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(StringResponseModel.self, from: responseData)
                        currencyName = welcome
                        currencyPickerView.delegate = self
                        currencyPickerView.dataSource = self
                        txtCurrency.inputView = currencyPickerView
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
    
    func getS3Response() {
        
        let url = "\(BaseURLOffice)config/params/s3"
        let request = get_api_request(url, headers: headersCommon)
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                let value = value as! [String: Any]
                self.region = value["s3.region"] as! String
                self.accessKeyID = value["s3.accessKeyID"] as! String
                self.secretKey = value["s3.secretKey"] as! String
                self.bucketName = value["s3.bucketName"] as! String
                self.imageUploadingS3(accessKey: self.accessKeyID, secretKey: self.secretKey)
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func imageUploadingS3(accessKey: String, secretKey: String){
 //       start_loading()
//    var imgData = Data()
//        if let image = imgProfileImage.image {
//                        if let imageData = image.jpegData(compressionQuality: 0.8) {
//                            imgData = imageData
//                        }
//                    }
//
//        let uuid = UUID()
//
//        let randomString = uuid.uuidString.replacingOccurrences(of: "-", with: "")
//
//        s3UploadImagePath = "images/\(randomString).png"
//        let bucketName = "touche-backoffice"
//        let region = AWSRegionType.EUWest1
//
//        AWSMobileClient.default().getTokens { (tokens, error) in
//           // if let tokens = tokens {
//                let credentialsProvider = AWSStaticCredentialsProvider(
//                    accessKey: accessKey,
//                    secretKey: secretKey
//                )
//                let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
//                AWSServiceManager.default().defaultServiceConfiguration = configuration
//
//                let transferUtility = AWSS3TransferUtility.default()
//                let uploadExpression = AWSS3TransferUtilityUploadExpression()
//
//                let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) in
//                    if let error = error {
//                        print("Error uploading image: \(error.localizedDescription)")
//                    } else {
//                        print("Image uploaded successfully")
//
//                        // Retrieve the URL from task.response
//                        if let url = task.response?.url {
//                            print("Uploaded URL: \(url)")
//                            let imagePath = url.deletingQuery()
//                            print("Image Path: \(imagePath)")
//                            DispatchQueue.main.async {
//                                self.stop_loading()
//                                self.editProfile()
//
//                            }
//
//                        } else {
//                            print("Uploaded URL not available")
//                        }
//                    }
//                }
//
//                transferUtility.uploadData(
//                    imgData,
//                    bucket: bucketName,
//                    key: self.s3UploadImagePath,
//                    contentType: "image/png",
//                    expression: uploadExpression,
//                    completionHandler: completionHandler
//                )
////            } else if let error = error {
////                print("Error getting tokens: \(error)")
////            }
//        }
    }
    
    func editProfile(){
        //let dic = profileData.value(forKey: "userDetails") as! NSDictionary
        let dob = convertDateString(txtCurrentDate.text ?? "")
        let currentDatebyCreated = convertDateString(currentDateby)
        
        var imgPath = ""
        if selectedImgUrl != "" {
            imgPath = "https://touche-backoffice.s3.amazonaws.com/\(s3UploadImagePath)"
        } else {
            imgPath = profileData.value(forKey: "imageUrl") as? String ?? ""
        }
        
        let params = [
            "id": profileData.value(forKey: "id") ?? "NA",
            "externalId":profileData.value(forKey: "externalId") ?? "NA",
            "firstName": txtFirstName.text ?? "",
            "lastName": txtLastName.text ?? "",
            "emailAddress": lblUserEmail.text ?? "",
            "changePasswordCode":profileData.value(forKey: "changePasswordCode") ?? "NA",
            "phoneNumber": txtPhoneNumber.text ?? "",
            "sex": txtGender.text ?? "",
            "dateOfBirth":dob ?? "",
            "imageUrl": imgPath,
            "language": txtLanguage.text ?? "",
            "currency": txtCurrency.text ?? "",
            "created": currentDatebyCreated ?? "",
        ] as [String : Any]
        
        print(params)
        start_loading()
        
        self.post_api_request_withJson("https://api-cluster.system.touchetv.com/backoffice-user/api/v1/user/save\(loadContents)", params: params, headers: headersCommon).responseData { response in
            print(response.result)
            switch response.result {
            case .success(let data):
                do {
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    let dic = asJSON as? NSDictionary ?? [:]
                    let error = dic.value(forKey: "message") as? String ?? ""
                    if error == "" {
                        
                        profileData = dic.mutableCopy() as? NSMutableDictionary ?? [:]
                        save()
                        self.fillUserData()
                        self.ShowAlert(title: "Touch-E", message: "Profile update successfully")
                        
                    }else {
                        self.ShowAlert(title: "Error", message: response.error?.localizedDescription ?? "Something Went Wrong")
                    }
                } catch {
                    self.ShowAlert(title: "Error", message: response.error?.localizedDescription ?? "Something Went Wrong")
                }
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
                   
    }
    
    func convertDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convert the string to a Date object
        if let date = dateFormatter.date(from: dateString) {
            // Convert the date to the desired format
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

extension URL {
    func deletingQuery() -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.query = nil
        return components?.url
    }
}



typealias StringResponseModel = [String]
