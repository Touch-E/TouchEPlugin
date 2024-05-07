//
//  ActorDetailViewController.swift
//  Touch E Demo
//
//  Created by Kishan on 30/01/24.
//

import UIKit
import Alamofire

public class ShowListViewController: UIViewController, UITextFieldDelegate {
    
    static func storyboardInstance() -> ShowListViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: "ShowListViewController") as! ShowListViewController
    }
    
    @IBOutlet weak var searchTF: UITextFieldX!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var logoutPopupView: UIView!
    @IBOutlet weak var cartQTYBTN: UIButtonX!
    @IBOutlet weak var segmentUV: UIViewX!
    @IBOutlet weak var allUV: UIViewX!
    @IBOutlet weak var allLBL: UILabel!
    @IBOutlet weak var movieUV: UIViewX!
    @IBOutlet weak var movieLBL: UILabel!
    @IBOutlet weak var seriesUV: UIViewX!
    @IBOutlet weak var seriesLBL: UILabel!
    @IBOutlet weak var userProfileIMG: UIImageViewX!
    
    var VideoListData : HomeData?
    var cartData : CartData?
    var popupBackgroundView = UIView()
    var dummyViewForAutolayout = UIView()
    
    var filterARY = [HomeListModel]()
    var comedyARY = [HomeListModel]() //HomeListModel?
    var familyARY = [HomeListModel]()
    var actionARY = [HomeListModel]()
    
    var fcomedyARY = [HomeListModel]() //HomeListModel?
    var ffamilyARY = [HomeListModel]()
    var factionARY = [HomeListModel]()
    var isSearching = false
    var selectedType = "All"
    
    public var token = ""
    public var userId = ""
    public var profileTData = NSMutableDictionary()
    
    public struct Identifiers {
        static let kActorDetailTableViewCell = "ActorDetailTableViewCell"
        static let kCategoriesTableViewCell = "CategoriesTableViewCell"
        static let kRecentMovieCell = "RecentMovieCell"
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = Bundle.module.loadNibNamed("ShowListViewController", owner: self, options: nil)?.first as? UIView {
            self.view = view
        }
        
//        UserID = userId
//        headersCommon = [
//            "Authorization": token
//        ]
//        profileData = profileTData
        
    
        ConfigureTableView()
        GetModelDetail()
        
        var image = ""
        image = profileData.value(forKey: "imageUrl") as? String ?? ""
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            userProfileIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            userProfileIMG.contentMode = .scaleAspectFill
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        searchTF.inputAccessoryView = toolbar
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        GetCartDetail()
    }
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Check for changes in size class or traits
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass ||
            traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            self.view.layoutIfNeeded()
            self.tblList.layoutIfNeeded()
            self.tblList.reloadData()
            
            // Update constraints or perform layout changes based on the new size class
           // updateConstraintsForSizeClass()
        }
    }
    
    func ConfigureTableView(){
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.register(UINib(nibName: Identifiers.kActorDetailTableViewCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kActorDetailTableViewCell)
        tblList.register(UINib(nibName: Identifiers.kCategoriesTableViewCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kCategoriesTableViewCell)
        tblList.register(UINib(nibName: Identifiers.kRecentMovieCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kRecentMovieCell)
    }
    
    @IBAction func btnDismissClick(_ sender: Any) {

        let testViewController = ProfileVC()
        self.navigationController?.pushViewController(testViewController, animated: true)
    }
    @IBAction func didcancelTapFrompopupView(_ sender: UIButton) {
        self.logoutPopupView.isHidden = true
    }
    @IBAction func didLogoutTapFrompopupView(_ sender: UIButton) {
        let vc = authStoryboard.instantiateViewController(withIdentifier: "loginNav") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    @IBAction func cartClick_Action(_ sender: Any) {

        let viewcontroller = MyCartVC.storyboardInstance()
        viewcontroller.modalPresentationStyle = .custom
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    @IBAction func segmentClic_Action(_ sender: UIButton) {
        let textColor = UIColor(red: 148/255, green: 160/255, blue: 167/255, alpha: 1)
        let backgroundColor = UIColor(red: 58/255, green: 171/255, blue: 242/255, alpha: 1)
        
        
        if sender.tag == 0{
            allUV.backgroundColor = backgroundColor
            allLBL.textColor = .white
            
            movieUV.backgroundColor = .clear
            movieLBL.textColor = textColor
            
            seriesUV.backgroundColor = .clear
            seriesLBL.textColor = textColor
            
            selectedType = "All"
            
        }else if sender.tag == 1{
            movieUV.backgroundColor = backgroundColor
            movieLBL.textColor = .white
            
            allUV.backgroundColor = .clear
            allLBL.textColor = textColor
            
            seriesUV.backgroundColor = .clear
            seriesLBL.textColor = textColor
            
            selectedType = "Movie"
            
        }else{
            seriesUV.backgroundColor = backgroundColor
            seriesLBL.textColor = .white
            
            movieUV.backgroundColor = .clear
            movieLBL.textColor = textColor
            
            allUV.backgroundColor = .clear
            allLBL.textColor = textColor
            
            selectedType = "VoV"
            
        }
        filterDataFromAry(selectedType: selectedType)
   }
    @objc func doneButtonTapped() {
        view.endEditing(true)
        if searchTF.text!.isEmpty == true{
            isSearching = false
            filterDataFromAry(selectedType: selectedType)
        }
    }
    public func filterDataFromAry(selectedType:String){
        
        filterARY.removeAll()
        actionARY.removeAll()
        comedyARY.removeAll()
        familyARY.removeAll()
        
        if selectedType == "All"{
            filterARY = VideoListData!
        }else{
//            for i in 0..<VideoListData!.count{
//                let tempDataType = VideoListData?[i].type ?? ""
//                if tempDataType == selectedType{
//                    filterARY.append(VideoListData![i])
//                }
//            }
            filterARY = VideoListData?.compactMap { $0.type == selectedType ? $0 : nil } ?? []
        }
        print(filterARY.count)
        for j in 0..<filterARY.count{
            let genresARY = filterARY[j].genres
            for k in 0..<genresARY!.count{
                let genName = genresARY?[k].rawValue ?? ""
                if genName == "Action"{
                    actionARY.append(filterARY[j])
                }
                if genName == "Comedy"{
                    comedyARY.append(filterARY[j])
                }
                if genName == "Family"{
                    familyARY.append(filterARY[j])
                }
                
            }
        }
        if isSearching{
            if searchTF.text!.isEmpty == true{
                isSearching = false
                tblList.reloadData()
            }else{
                updateSearchResults(for: searchTF.text!)
            }
            
        }else{
            tblList.reloadData()
        }
       
    }
    func actionFilterObjects(with query: String) -> [HomeListModel] {
        return actionARY.filter {
            if let name = $0.name {
                return name.lowercased().contains(query.lowercased())
            }
            return false
        }
    }
    func comedyFilterObjects(with query: String) -> [HomeListModel] {
        return comedyARY.filter {
            if let name = $0.name {
                return name.lowercased().contains(query.lowercased())
            }
            return false
        }
    }
    func familyFilterObjects(with query: String) -> [HomeListModel] {
        return familyARY.filter {
            if let name = $0.name {
                return name.lowercased().contains(query.lowercased())
            }
            return false
        }
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (searchTF.text ?? "") + string
        updateSearchResults(for: currentText)
        return true
    }

    // Update your data source based on the search query
    public func updateSearchResults(for query: String) {
        factionARY = actionFilterObjects(with: query)
        fcomedyARY = comedyFilterObjects(with: query)
        ffamilyARY = familyFilterObjects(with: query)
        print(factionARY.count)
        isSearching = true
        tblList.reloadData()
        
        // Reload your UI or update it accordingly
    }
}

extension ShowListViewController : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 1{
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kCategoriesTableViewCell, for: indexPath) as! CategoriesTableViewCell
            cell.VideoList = isSearching ? factionARY : actionARY
            cell.lblVideoCount.text = "Action(\(isSearching ? factionARY.count : actionARY.count))"
            cell.cellSpacing()
            cell.cvCategory.reloadData()
            cell.cvTopCON.constant = 4
        
            cell.MovieClick = { (videoDic) -> Void in
                let viewcontroller = VideoDetailViewController()
                viewcontroller.modalPresentationStyle = .custom
                viewcontroller.VideoListData = videoDic
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                
            }
            return cell
            
        }else if indexPath.row == 2{
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kCategoriesTableViewCell, for: indexPath) as! CategoriesTableViewCell
            cell.VideoList = isSearching ? fcomedyARY : comedyARY
            cell.lblVideoCount.text = "Comedy(\(isSearching ? fcomedyARY.count : comedyARY.count))"
            cell.cellSpacing()
            cell.cvCategory.reloadData()
            cell.cvTopCON.constant = 4
            
            cell.MovieClick = { (videoDic) -> Void in
                let viewcontroller = VideoDetailViewController()
                viewcontroller.modalPresentationStyle = .custom
                viewcontroller.VideoListData = videoDic
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                
            }
            return cell
            
        }else if indexPath.row == 3{
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kCategoriesTableViewCell, for: indexPath) as! CategoriesTableViewCell
            cell.VideoList = isSearching ? ffamilyARY : familyARY
            cell.lblVideoCount.text = "Family(\(isSearching ? ffamilyARY.count : familyARY.count))"
            cell.cellSpacing()
            cell.cvCategory.reloadData()
            cell.cvTopCON.constant = 4
            
            cell.MovieClick = { (videoDic) -> Void in
                let viewcontroller = VideoDetailViewController()
                viewcontroller.modalPresentationStyle = .custom
                viewcontroller.VideoListData = videoDic
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            return cell
            
        }else{
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kRecentMovieCell, for: indexPath) as! RecentMovieCell
            cell.selectionStyle = .none
            cell.Configurecollection()
            cell.VideoList = VideoListData
            cell.pagerControlerPC.numberOfPages = VideoListData?.count ?? 0
            cell.pagerView.reloadData()
            
            cell.videoClick = { (videoDic) -> Void in
                let viewcontroller = VideoDetailViewController()
                viewcontroller.modalPresentationStyle = .custom
                viewcontroller.VideoListData = videoDic
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching {
            if indexPath.row == 1{
                return factionARY.count > 0 ? 215 : 0
            }else if indexPath.row == 2{
                return fcomedyARY.count > 0 ? 215 : 0
            }else if indexPath.row == 3{
                return ffamilyARY.count > 0 ? 215 : 0
            }else{
                return 300
            }
        }else{
            if indexPath.row == 1{
                return actionARY.count > 0 ? 215 : 0
            }else if indexPath.row == 2{
                return comedyARY.count > 0 ? 215 : 0
            }else if indexPath.row == 3{
                return familyARY.count > 0 ? 215 : 0
            }else{
                return 300
            }
        }
    }
    
}

extension ShowListViewController {
    func GetModelDetail(){
        start_loading()
        APIManager.shared.getModelDetail { result in
            switch result {
            case .success(let homeData):
                self.VideoListData = homeData
                self.filterDataFromAry(selectedType: "All")
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
    func GetCartDetail(){
        start_loading()
        APIManager.shared.getCartDetail(userID: UserID) { result in
            switch result {
            case .success(let cartData):
                self.cartData = cartData
                self.cartQTYBTN.setTitle("\(self.cartData?.count ?? 0)", for: .normal)
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
}
