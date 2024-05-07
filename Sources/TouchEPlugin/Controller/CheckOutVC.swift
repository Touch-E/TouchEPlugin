//
//  CheckOutVC.swift
//  Touch E Demo
//
//  Created by Jaydip Godhani on 01/03/24.
//

import UIKit
import Alamofire

public class CheckOutVC: UIViewController {
    
    static func storyboardInstance() -> CheckOutVC {
        return CheckOutVC(nibName: "CheckOutVC", bundle: Bundle.module)
    }
    
    //MARK: - Outlets
    @IBOutlet weak var tblCartList: UITableView!
    @IBOutlet weak var bgBlurView: UIView!
    @IBOutlet weak var bgSuccessFullOderPopup: UIView!
    
    //MARK: - Variable
    var isPosttoExpand: Bool = false
    var isCartExpand: Bool = false
    
    var customDataARY = NSMutableArray()
    var jsonResponseARY = NSMutableArray()
    
    var totalCost = 0
    var itemTotalPrice = 0
    var shippingCost = 0
    var totalItemSelect = 0
    var expandCellIndex = -1
    var expandCellSection = -1
    var isCellExpanded = false
    var isPaymentExpanded = false
    var addressListData : AddressData?
    var cardListData : CardModel?
    var cartData : CartData?
    var selectedCartData: CartData? = []
    var UTCDate: String = ""
    var isSaveUserData = false
    var productID = ""
    var selectedCartDataId: [Int] = []
    var filteredCartData: [CartData] = []
    
    let shiipingAddress = NSMutableDictionary()
    let billingAddress = NSMutableDictionary()
    var isPayNewCard = false
    var isPayAlreadyCard = false
    var creditCardObj: [String: Any] = [:]
    
    public struct Identifiers {
        static let kCartSectionCell = "CartSectionCell"
        static let kItemTBLCell = "ItemTBLCell"
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        GetCardList()
        GetAddressList()
        GetCartDetail()
        
    }
    
    func configuration() {
        tblCartList.delegate = self
        tblCartList.dataSource = self
        tblCartList.register(UINib(nibName: "CartItemCell", bundle: Bundle.module), forCellReuseIdentifier: "CartItemCell")
        tblCartList.register(UINib(nibName: "PersonalinformationTBLCell", bundle: Bundle.module), forCellReuseIdentifier: "PersonalinformationTBLCell")
        tblCartList.register(UINib(nibName: "PaymentDetailsTBLCell", bundle: Bundle.module), forCellReuseIdentifier: "PaymentDetailsTBLCell")
        tblCartList.register(UINib(nibName: "OrderSummearyCell", bundle: Bundle.module), forCellReuseIdentifier: "OrderSummearyCell")
        tblCartList.register(UINib(nibName: "PosttoTBLCell", bundle: Bundle.module), forCellReuseIdentifier: "PosttoTBLCell")
        tblCartList.register(UINib(nibName: "CartHeaderView", bundle: Bundle.module), forHeaderFooterViewReuseIdentifier: "CartHeaderView")
        //tblCartList.register(UINib(nibName: "CartSectionCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "CartSectionCell")
        tblCartList.register(UINib(nibName: Identifiers.kCartSectionCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kCartSectionCell)
        tblCartList.register(UINib(nibName: Identifiers.kItemTBLCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kItemTBLCell)
        
        tblCartList.separatorStyle = .none
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPopupCancel(_ sender: UIButton) {
        bgBlurView.isHidden = true
        bgSuccessFullOderPopup.isHidden = true
    }
    @IBAction func btnPopupClose(_ sender: UIButton) {
        bgBlurView.isHidden = true
        bgSuccessFullOderPopup.isHidden = true
    }
    
    @objc func btnSelectAddress(_ sender: UIButtonX) {
        isPosttoExpand.toggle()
        let currentIndex = sender.tag
        let newIndex = 0
        guard currentIndex >= 0 && currentIndex < addressListData?.count ?? 0 else {
            return
        }
        guard newIndex >= 0 && newIndex < addressListData?.count ?? 0 else {
            return
        }
        addressListData?.swapAt(currentIndex, newIndex)
        
        if self.addressListData?.count ?? 0 > 0{
            self.shiipingAddress["country"] = self.addressListData?[currentIndex].shippingAddress?.country ?? ""
            self.shiipingAddress["city"] = self.addressListData?[currentIndex].shippingAddress?.city ?? ""
            self.shiipingAddress["zip"] = self.addressListData?[currentIndex].shippingAddress?.zipcode ?? ""
            self.shiipingAddress["addr"] = self.addressListData?[currentIndex].shippingAddress?.address ?? ""
            self.shiipingAddress["externalId"] = "\(self.addressListData?[currentIndex].shippingAddress?.id ?? 0)"
            
            self.billingAddress["country"] = self.addressListData?[currentIndex].billingAddress?.country ?? ""
            self.billingAddress["city"] = self.addressListData?[currentIndex].billingAddress?.city ?? ""
            self.billingAddress["zip"] = self.addressListData?[currentIndex].billingAddress?.zipcode ?? ""
            self.billingAddress["addr"] = self.addressListData?[currentIndex].billingAddress?.address ?? ""
            self.billingAddress["externalId"] = "\(self.addressListData?[currentIndex].billingAddress?.id ?? 0)"
        }
        
        self.tblCartList.reloadData()
    }
    
    func customArrayCreate(){
        for i in 0..<self.cartData!.count{
            var isUpdate = false
            let brandName = self.cartData?[i].product?.brandName ?? ""
            let qtyCount = self.cartData?[i].count ?? 0
            var addShippingIndex = ""
            let selectShippingId = self.cartData?[i].shipping?.id ?? 0
            for j in 0..<(self.cartData?[i].product?.shippings?.count)!{
                let shippingid = self.cartData?[i].product?.shippings?[j].id ?? 0
                if shippingid == selectShippingId{
                    addShippingIndex = "\(j)"
                }
            }
            
            if self.customDataARY.count > 0{
                for k in 0..<self.customDataARY.count{
                    
                    let tempdic = self.customDataARY.object(at: k) as! NSDictionary
                    let customBrand = "\(tempdic.value(forKey: "brandName")!)"
                    if customBrand == brandName{
                        let currentARY = tempdic.value(forKey: "productsARY") as! NSMutableArray
                        let ProductDic = NSMutableDictionary()
                        ProductDic["products"] = self.cartData?[i]
                        ProductDic["isSelected"] = "1"
                        ProductDic["shippingCost"] = addShippingIndex
                        ProductDic["qty"] = "\(qtyCount)"
                        currentARY.add(ProductDic)
                        
                        let tempdic = NSMutableDictionary()
                        tempdic["isAllSelect"] = "1"
                        tempdic["brandName"] = customBrand
                        tempdic["productsARY"] = currentARY
                        self.customDataARY.replaceObject(at: k, with: tempdic)
                        isUpdate = true
                    }
                }
                if isUpdate == false{
                    let tempdic = NSMutableDictionary()
                    tempdic["isAllSelect"] = "1"
                    tempdic["brandName"] = brandName
                    
                    let ProductDic = NSMutableDictionary()
                    ProductDic["products"] = self.cartData?[i]
                    ProductDic["isSelected"] = "1"
                    ProductDic["shippingCost"] = addShippingIndex
                    ProductDic["qty"] = "\(qtyCount)"
                    
                    let productARY = NSMutableArray()
                    productARY.add(ProductDic)
                    
                    tempdic["productsARY"] = productARY
                    self.customDataARY.add(tempdic)
                }
            }else{
                let tempdic = NSMutableDictionary()
                tempdic["isAllSelect"] = "1"
                tempdic["brandName"] = brandName
                
                let ProductDic = NSMutableDictionary()
                ProductDic["products"] = self.cartData?[i]
                ProductDic["isSelected"] = "1"
                ProductDic["shippingCost"] = addShippingIndex
                ProductDic["qty"] = "\(qtyCount)"
                
                let productARY = NSMutableArray()
                productARY.add(ProductDic)
                
                tempdic["productsARY"] = productARY
                self.customDataARY.add(tempdic)
                
            }
            
        }
        print(self.customDataARY)
        totalCostCalculate()
        self.tblCartList.reloadData()
    }
    
   
    
    
    func totalCostCalculate(){
         totalCost = 0
         itemTotalPrice = 0
         shippingCost = 0
         totalItemSelect = 0
        selectedCartDataId.removeAll()
         
        for i in 0..<self.customDataARY.count{
            
            let currentDic = self.customDataARY.object(at: i) as! NSDictionary
            let dataARY = currentDic.value(forKey: "productsARY") as! NSMutableArray
            
            for k in 0..<dataARY.count{
                let productDic = dataARY.object(at: k) as! NSMutableDictionary
                if productDic.value(forKey: "isSelected") as! String == "1"{
                    let cartTempData = productDic.value(forKey: "products") as! CartDataModel
                    let price = cartTempData.sku?.price ?? 0
                    let qty = Int(productDic.value(forKey: "qty") as! String) ?? 0
                    let itemCost = price * qty
                    itemTotalPrice += itemCost
                    
                    var shippingARY :[Shipping]?
                    shippingARY = cartTempData.product?.shippings
                    let shippingIndex = Int(productDic.value(forKey: "shippingCost") as! String) ?? 0
                    let shippingPrice = shippingARY?[shippingIndex].price ?? 0
                    
                    shippingCost += shippingPrice
                    totalCost = itemTotalPrice + shippingCost
                    totalItemSelect += 1
                    
                    selectedCartDataId.append(cartTempData.id ?? 0)
                }
                
            }
           
        }
        
        tblCartList.reloadData()
    }
    
    func convertToUTCDate(dateString: String) -> String? {
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "MM/dd"
        guard let inputDate = inputDateFormatter.date(from: dateString) else {
            print("Error: Unable to parse the input date")
            exit(1)
        }
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let outputDate = Calendar.current.date(bySetting: .year, value: 2024, of: inputDate)!
            .addingTimeInterval(18 * 60 * 60 + 30 * 60)
        let formattedDate = outputDateFormatter.string(from: outputDate)
        return formattedDate
    }
    
    func getCurrentUTCDate() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: currentDate)
        dateComponents.hour = 18
        dateComponents.minute = 30
        dateComponents.second = 0
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        outputDateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let utcDate = calendar.date(from: dateComponents) {
            return outputDateFormatter.string(from: utcDate)
        } else {
            return "Error: Unable to convert date"
        }
    }
    
    func convertToUTCDatebirth(dateString: String) -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = inputDateFormatter.date(from: dateString) else {
            return nil
        }
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        outputDateFormatter.timeZone = TimeZone(identifier: "UTC")
        return outputDateFormatter.string(from: date)
    }
}

extension CheckOutVC: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.customDataARY.count + 5
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return (isPosttoExpand ? addressListData?.count : 1) ?? 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            let currentSection = (section - 4)
            if currentSection != self.customDataARY.count{
                let currentDic = self.customDataARY.object(at: currentSection) as! NSMutableDictionary
                let dataARY = currentDic.value(forKey: "productsARY") as! NSArray
                return dataARY.count
            }else{
                return 1
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalinformationTBLCell", for: indexPath) as! PersonalinformationTBLCell
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PosttoTBLCell", for: indexPath) as! PosttoTBLCell
            if let name = addressListData?[indexPath.row].name {
                cell.lblHome.text = name
            } else {
                cell.lblHome.text = "No name available"
            }
            
            if let shippingAddress = addressListData?[indexPath.row].shippingAddress {
                let shippingText = "\(shippingAddress.address ?? ""), \(shippingAddress.city ?? ""), \(shippingAddress.country ?? "") - \(shippingAddress.zipcode ?? "")"
                cell.sAddressHome.text = shippingText
            } else {
                cell.sAddressHome.text = "No shipping address available"
            }
            
            if let billingAddress = addressListData?[indexPath.row].billingAddress {
                let billingText = "\(billingAddress.address ?? ""), \(billingAddress.city ?? ""), \(billingAddress.country ?? "") - \(billingAddress.zipcode ?? "")"
                cell.bAddressHome.text = billingText
            } else {
                cell.bAddressHome.text = "No billing address available"
            }
            cell.backUV.layer.cornerRadius = 10
            cell.backUV.clipsToBounds = true
            
            if isPosttoExpand {
                
                if indexPath.row == 0{
                    cell.backUV.layer.cornerRadius = 10
                    cell.backUV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                }else if indexPath.row == (addressListData?.count ?? 0) - 1{
                    cell.backUV.layer.cornerRadius = 10
                    cell.backUV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                }else{
                    cell.backUV.layer.cornerRadius = 0
                }
                cell.btnHomeChange.setTitle("Select", for: .normal)
                cell.sepratorLineUV.isHidden = false
            }else{
                cell.btnHomeChange.setTitle("Change", for: .normal)
                cell.sepratorLineUV.isHidden = true
//                DispatchQueue.main.async {
//                    cell.backUV.layer.cornerRadius = 10
//                    cell.backUV.clipsToBounds = true
//                }
            }
            
            
            cell.btnHomeChange.tag = indexPath.row
            cell.btnHomeChange.addTarget(self, action: #selector(btnSelectAddress), for: .touchUpInside)
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailsTBLCell", for: indexPath) as! PaymentDetailsTBLCell
            cell.selectionStyle = .none
            
            if self.cardListData?.count ?? 0 > 0{
                cell.saveCardUV.isHidden = false
                cell.saveCardUVHeightCON.constant = 53
                
                let dic = cardListData?[0]
                cell.cardNumberLBL.text = dic?.number ?? ""

                let dateString = dic?.expDate ?? "NA"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if let date = dateFormatter.date(from: dateString) {
                    let calendar = Calendar.current
                    let previousDay = calendar.date(byAdding: .day, value: -1, to: date)
                    let components = calendar.dateComponents([.year, .month], from: previousDay ?? Date())
                    if let year = components.year, let month = components.month {
                        let dateString1 = String(format: "%02d/%02d", month, year % 100)
                        print(dateString1) // Output: 03/30
                        cell.expLBL.text = dateString1
                    }
                }
                
                
            }else{
                cell.saveCardUV.isHidden = true
                cell.saveCardUVHeightCON.constant = 0
            }
            cell.addCardClick = { val in
                
                if val == 0{
                    self.isPaymentExpanded = false
                    
                    self.isPayAlreadyCard = false
                    self.isPayNewCard = false
                }else if val == 1{
                    
                    self.isPaymentExpanded = true
                   
                    self.isPayAlreadyCard = false
                    self.isPayNewCard = true
                }else{
                    self.isPaymentExpanded = false
                    
                    self.isPayAlreadyCard = true
                    self.isPayNewCard = false
                }
                self.tblCartList.reloadData()
            }
            cell.saveClike = {
                
//                cardNumber = cell.cardNumberTF.text ?? "".replacingOccurrences(of: " ", with: "")
//                cardHolderName = cell.nameTF.text ?? ""
//                expDate = cell.exDateTF.text ?? ""
//                cvv = cell.cvvTF.text ?? ""
                
                if self.isSaveUserData == false{
                    cell.saveCardCheckImg.image = UIImage(named: "check-box")
                    self.isSaveUserData = true
                } else {
                    cell.saveCardCheckImg.image = UIImage(named: "check-box-empty")
                    self.isSaveUserData = false
                }
            }
            
            return cell
        }else if indexPath.section == 3{
            let cell = tblCartList.dequeueReusableCell(withIdentifier: Identifiers.kItemTBLCell) as! ItemTBLCell
            cell.selectionStyle = .none
            cell.itemIMG.image = UIImage(named: "fnameUser")
            cell.titleLBL.text = "Items"
            return cell
        }else if (indexPath.section - 4) != self.customDataARY.count{
            let cell = tblCartList.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
            //let cell = cartDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kCartItemCell, for: indexPath) as! CartItemCell
            cell.selectionStyle = .none
            cell.checkBTN.isHidden = true
            cell.productImageLeadingCON.constant = 8
            let currentSection = (indexPath.section - 4)
            let currentDic = self.customDataARY.object(at: currentSection) as! NSDictionary
            let dataARY = currentDic.value(forKey: "productsARY") as! NSMutableArray
            
            let productDic = dataARY.object(at: indexPath.row) as! NSMutableDictionary
            let cartTempData = productDic.value(forKey: "products") as! CartDataModel
            cell.nameLBL.text = cartTempData.product?.name
            cell.skuLBL.text = "SKU:\(cartTempData.sku?.sku ?? "")"
            cell.attributeARY = cartTempData.sku?.attributes
            cell.attributeCV.reloadData()
            cell.heightCalculate()

            if cartTempData.product?.shippings!.count ?? 0 > 0{
                let shippingIndex = Int(productDic.value(forKey: "shippingCost") as! String) ?? 0
                let shippingName = cartTempData.product?.shippings?[shippingIndex].name
                let price = cartTempData.product?.shippings?[shippingIndex].price ?? 0
                cell.shippingTF.text = "\(shippingName!) - $\(price)"
            }else{
                cell.shippingTF.text = " Free Shipping"
            }
            
            let image = cartTempData.product?.images?[0].url ?? ""
            if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                // Use the encoded URL string
                print(encodedUrlString)
                cell.productIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
                cell.productIMG.contentMode = .scaleAspectFill
            } else {
                // Handle the case where encoding fails
                print("Failed to encode URL string")
            }

            cell.shippingARY = cartTempData.product?.shippings
            cell.shippingChange = { index in
                productDic.setValue("\(index)", forKey: "shippingCost")
                dataARY.replaceObject(at: indexPath.row, with: productDic)
                currentDic.setValue(dataARY, forKey: "productsARY")
                self.customDataARY.replaceObject(at: currentSection, with: currentDic)
                let qtyValue = Int(productDic.value(forKey: "qty") as! String) ?? 0
                self.addToCart(shippingaddress: index, count: qtyValue, dic: productDic, selectItem: cartTempData, completion: { (success) -> Void in
                    if success {
                        self.totalCostCalculate()
                        print("shippingChange")
                    }
                })
                
            }
            
            
            let price = cartTempData.sku?.price ?? 0
            let qty = Int(productDic.value(forKey: "qty") as! String) ?? 0
            let itemCost = price * qty
            cell.qtyLBL.text = "\(productDic.value(forKey: "qty")!)"
            cell.priceLBL.text = "US $\(itemCost)"
            
            cell.qtyChange = { result in
                var qtyValue = Int("\(cell.qtyLBL.text!)") ?? 0
                let stockCount = cartTempData.sku?.stock ?? 0
                if result{
                    qtyValue += 1
                }else{
                    if qtyValue != 1{
                        qtyValue -= 1
                    }
                }
                if qtyValue > stockCount{
                    let sku = "SKU:\(cartTempData.sku?.sku ?? "")"
                    self.ShowAlert(title: "Error", message: "Order quantity exceeds stock for product \(sku)")
                }else{
                    let shippingIndex = Int(productDic.value(forKey: "shippingCost") as! String) ?? 0
                    self.addToCart(shippingaddress: shippingIndex, count: qtyValue, dic: productDic, selectItem: cartTempData, completion: { (success) -> Void in
                        if success {
                            if qtyValue != 0{
                                cell.qtyLBL.text = "\(qtyValue)"
                                productDic.setValue("\(qtyValue)", forKey: "qty")
                                dataARY.replaceObject(at: indexPath.row, with: productDic)
                                currentDic.setValue(dataARY, forKey: "productsARY")
                                self.customDataARY.replaceObject(at: currentSection, with: currentDic)
                                self.totalCostCalculate()
                            }else{
                                
                                dataARY.removeObject(at: indexPath.row)//replaceObject(at: indexPath.row, with: productDic)
                                currentDic.setValue(dataARY, forKey: "productsARY")
                                self.customDataARY.replaceObject(at: currentSection, with: currentDic)
                                self.totalCostCalculate()
                            }
                            
                        }
                    })
                }
            }
            
            cell.removeItem = {
                self.deleteCartItem(dic: productDic, selectItem: cartTempData, completion: { (success) -> Void in
                    if success {
                        if dataARY.count != 1{
                            dataARY.removeObject(at: indexPath.row)//replaceObject(at: indexPath.row, with: productDic)
                            currentDic.setValue(dataARY, forKey: "productsARY")
                            self.customDataARY.replaceObject(at: currentSection, with: currentDic)
                            self.totalCostCalculate()
                        }else{
                            self.customDataARY.removeObject(at: currentSection)
                            self.totalCostCalculate()
                        }
                            
                    }
                })
            }
           
            
            
            if currentDic.value(forKey: "isAllSelect") as! String == "0"{
                if productDic.value(forKey: "isSelected") as! String == "0"{
                    cell.checkBTN.setImage(UIImage(named: "check-box-empty"), for: .normal)
                }else{
                    cell.checkBTN.setImage(UIImage(named: "check-box"), for: .normal)
                }
            }else{
                cell.checkBTN.setImage(UIImage(named: "check-box"), for: .normal)
            }
            
            
            cell.productSelectChange = { status in
                if status{
                    cell.checkBTN.setImage(UIImage(named: "check-box"), for: .normal)
                    productDic.setValue("1", forKey: "isSelected")
                    dataARY.replaceObject(at: indexPath.row, with: productDic)
                    currentDic.setValue(dataARY, forKey: "productsARY")
                    self.customDataARY.replaceObject(at: currentSection, with: currentDic)
                    
                }else{
                    cell.checkBTN.setImage(UIImage(named: "check-box-empty"), for: .normal)
                    productDic.setValue("0", forKey: "isSelected")
                    dataARY.replaceObject(at: indexPath.row, with: productDic)
                    currentDic.setValue(dataARY, forKey: "productsARY")
                    self.customDataARY.replaceObject(at: currentSection, with: currentDic)
                    
                }
                self.totalCostCalculate()
            }
            
            if indexPath.row == dataARY.count - 1{
                cell.backUV.layer.cornerRadius = 10
                cell.backUV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            
            cell.cellExpand = {
                self.expandCellIndex = indexPath.row
                self.expandCellSection = currentSection
                self.isCellExpanded.toggle()
                self.tblCartList.reloadData()
                //self.cartDataTBL.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummearyCell", for: indexPath) as! OrderSummearyCell
            cell.selectionStyle = .none
            cell.productCoseLBL.text = "US $\(itemTotalPrice)"
            cell.shippingCoseLBL.text = "US $\(shippingCost)"
            cell.totalCostLBL.text = "US $\(totalCost)"
            cell.itemCountLBL.text = "Items (\(totalItemSelect))"
            cell.proceedBTN.setTitle("Proceed to Checkout (\(totalItemSelect))", for: .normal)
            cell.proceesButtonClike = {
//                self.conformsOrders()
                self.checkCardDetailsFill()
            }
            return cell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 || section == 1 || section == 2 || section == 3 {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CartHeaderView") as! CartHeaderView
            switch section {
            case 0:
                headerView.lblName.text = "Personal information"
                headerView.itemImage.image = UIImage(named: "fnameUser")
            case 1:
                headerView.lblName.text = "Post to"
                headerView.itemImage.image = UIImage(named: "Addresses")
            case 2:
                headerView.lblName.text = "Payment details"
                headerView.itemImage.image = UIImage(named: "ic_parymentCard")
            default:
                headerView.lblName.text = ""
                headerView.itemImage.image = UIImage(named: "")
            }
            return headerView
        }else{
            
            if (section - 4) != self.customDataARY.count{
                let headerCell = tblCartList.dequeueReusableCell(withIdentifier: Identifiers.kCartSectionCell) as! CartSectionCell
                let currentSection = section - 4
                let currentDic = self.customDataARY.object(at: currentSection) as! NSDictionary
                
                headerCell.checkBTN.isHidden = true
                headerCell.brandNameLeftCON.constant = 8
                headerCell.brandNameLBL.text = "\(currentDic.value(forKey: "brandName")!)"
                
                if currentDic.value(forKey: "isAllSelect") as! String == "0"{
                    headerCell.checkBTN.setImage(UIImage(named: "check-box-empty"), for: .normal)
                }else{
                    headerCell.checkBTN.setImage(UIImage(named: "check-box"), for: .normal)
                }
                headerCell.brandSelectChange = { status in
                    if status{
                        headerCell.checkBTN.setImage(UIImage(named: "check-box"), for: .normal)
                        currentDic.setValue("1", forKey: "isAllSelect")
                        let dataARY = currentDic.value(forKey: "productsARY") as! NSMutableArray
                        for i in 0..<dataARY.count{
                            let productDic = dataARY.object(at: i) as! NSMutableDictionary
                            productDic.setValue("1", forKey: "isSelected")
                            dataARY.replaceObject(at: i, with: productDic)
                            currentDic.setValue(dataARY, forKey: "productsARY")
                            self.customDataARY.replaceObject(at: currentSection, with: currentDic)
                        }
                        self.totalCostCalculate()
                        self.tblCartList.reloadData()
                        
                        
                    }else{
                        headerCell.checkBTN.setImage(UIImage(named: "check-box-empty"), for: .normal)
                        currentDic.setValue("0", forKey: "isAllSelect")
                        //self.customDataARY.replaceObject(at: section, with: currentDic)
                        
                        let dataARY = currentDic.value(forKey: "productsARY") as! NSMutableArray
                        for i in 0..<dataARY.count{
                            let productDic = dataARY.object(at: i) as! NSMutableDictionary
                            productDic.setValue("0", forKey: "isSelected")
                            dataARY.replaceObject(at: i, with: productDic)
                            currentDic.setValue(dataARY, forKey: "productsARY")
                            self.customDataARY.replaceObject(at: currentSection, with: currentDic)
                        }
                        self.totalCostCalculate()
                        self.tblCartList.reloadData()
                    }
                    
                }
                return headerCell
            }else{
                let cell = tblCartList.dequeueReusableCell(withIdentifier: Identifiers.kItemTBLCell) as! ItemTBLCell
                cell.itemIMG.image = UIImage(named: "ic_mycart")
                cell.titleLBL.text = "Order summary"
                return cell
            }
            
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == 1 || section == 2 {
            return 45
        }else if section == 3{
            return 0
        }else{
            if (section - 4) != self.customDataARY.count{
                return 35
            }else{
                return 45
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 120
        }else if indexPath.section == 1{
            return UITableView.automaticDimension
        }else if indexPath.section == 2{
            if self.cardListData?.count ?? 0 > 0{
                return self.isPaymentExpanded ? 339 : 165
            }else{
                return self.isPaymentExpanded ? 286 : 112
            }
        }else if indexPath.section == 3{
            return 45
        }else if (indexPath.section - 4) != self.customDataARY.count{
            if isCellExpanded {
                let currentSection = indexPath.section - 4
                if expandCellIndex == indexPath.row && expandCellSection == currentSection{
                    let currentDic = self.customDataARY.object(at: currentSection) as! NSDictionary
                    let dataARY = currentDic.value(forKey: "productsARY") as! NSMutableArray
                    let productDic = dataARY.object(at: indexPath.row) as! NSMutableDictionary
                    let cartTempData = productDic.value(forKey: "products") as! CartDataModel
                    
                    if cartTempData.sku?.attributes?.count ?? 0 > 0{
                        
                        let cvWidth = (UIScreen.main.bounds.size.width - 143)
                        var rowCount = 1
                        if let attARY = cartTempData.sku?.attributes{
                            var itemWidth: Double = 0
                            for i in 0..<attARY.count{
                                let name = "\(attARY[i].attributeName ?? "") :"
                                let valuse = " \(attARY[i].name ?? "")"
                                
                                let nameWidth = getTextWidth(text: name, font: .systemFont(ofSize: 13))
                                let valueWidth = getTextWidth(text: valuse, font: .systemFont(ofSize: 13))
                                
                                let nametempwidth = Double(nameWidth + valueWidth)
                                
                                itemWidth = itemWidth + nametempwidth + 10
                                
                                if itemWidth > cvWidth{
                                    rowCount = rowCount + 1
                                    itemWidth = 0
                                }
                            }
                        }
                        return CGFloat(190 + (20 * rowCount))
                    }else{
                        return 178
                    }
                }else{
                    return 110
                }
            }else{
                return 110
            }
        }else{
            return 190
        }
        
    }

    func getTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = NSString(string: text).size(withAttributes: attributes)
        return ceil(textSize.width)
    }
    
    func updateRowHeightsAndReloadTableView() {
        UIView.animate(withDuration: 0.8) {
            self.tblCartList.beginUpdates()
            self.tblCartList.endUpdates()
        }
    }
}
extension CheckOutVC {
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
                        
                        if self.addressListData?.count ?? 0 > 0{
                            self.shiipingAddress["country"] = self.addressListData?[0].shippingAddress?.country ?? ""
                            self.shiipingAddress["city"] = self.addressListData?[0].shippingAddress?.city ?? ""
                            self.shiipingAddress["zip"] = self.addressListData?[0].shippingAddress?.zipcode ?? ""
                            self.shiipingAddress["addr"] = self.addressListData?[0].shippingAddress?.address ?? ""
                            self.shiipingAddress["externalId"] = "\(self.addressListData?[0].shippingAddress?.id ?? 0)"
                            
                            self.billingAddress["country"] = self.addressListData?[0].billingAddress?.country ?? ""
                            self.billingAddress["city"] = self.addressListData?[0].billingAddress?.city ?? ""
                            self.billingAddress["zip"] = self.addressListData?[0].billingAddress?.zipcode ?? ""
                            self.billingAddress["addr"] = self.addressListData?[0].billingAddress?.address ?? ""
                            self.billingAddress["externalId"] = "\(self.addressListData?[0].billingAddress?.id ?? 0)"
                        }
                        
                        self.tblCartList.reloadData()
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
//                        if self.cardListData?.count ?? 0 > 0{
//                            let dic = self.cardListData?[0]
//                            cardNumber = dic?.number ?? ""
//                            expDate = dic?.expDate ?? ""
//                            self.isPayAlreadyCard = true
//                        }
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
    func GetCartDetail(){
        
        start_loading()
        self.get_api_request("https://api-cluster.system.touchetv.com/backoffice/api/v1/cart/users/\(UserID)/products?loadContents=true&loadHierarchy=true&loadProjects=true&showOnlyPublished=true&loadAsTree=true", headers: headersCommon).responseDecodable(of: CartData.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(CartData.self, from: responseData)
                        self.cartData = welcome
                        let filter = self.cartData?.filter { self.selectedCartDataId.contains($0.id ?? 0) }
                        self.cartData = filter
                        self.customArrayCreate()
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
    func checkCardDetailsFill(){
        if isPayNewCard{
            if cardHolderName == ""{
                self.ShowAlert(title: "", message: "Please enter cardholder name!")
            }else if cardNumber == ""{
                self.ShowAlert(title: "", message: "Please enter card number!")
            }else if expDate == ""{
                self.ShowAlert(title: "", message: "Please enter card expiry date!")
            }
//            else if cvv == ""{
//                self.ShowAlert(title: "", message: "Please enter card cvv!")
//            }
            else{
                
                creditCardObj = [
                    "cvv": cvv,
                    "expDate": "2030-03-09T18:30:00.000Z",
                    "expiration": "2030-03-09T18:30:00.000Z",
                    "number": cardNumber.replacingOccurrences(of: " ", with: ""),
                    "name": cardHolderName,
                    "isSaved" : isSaveUserData,
                    "cardType" : 1
                ]
                
                GetCartDetailForConformOrder()
            }
        }else if isPayAlreadyCard{
            
            let dic = self.cardListData?[0]
            cardNumber = dic?.number ?? ""
            expDate = dic?.expDate ?? ""
            
            creditCardObj = [
                "cvv": cvv,
                "expDate": expDate,
                "externalId": dic?.externalID ?? "",
                "id": "\(dic?.id ?? 0)",
                "number": cardNumber.replacingOccurrences(of: " ", with: ""),
                "name": "",
                "isSaved" : false
            ]
            
            GetCartDetailForConformOrder()
        }else{
            self.ShowAlert(title: "", message: "Please select payment method!")
        }
    }
    func GetCartDetailForConformOrder(){
        
        start_loading()
        self.get_api_request("https://api-cluster.system.touchetv.com/backoffice/api/v1/cart/users/\(UserID)/products?loadContents=true&loadHierarchy=true&loadProjects=true&showOnlyPublished=true&loadAsTree=true", headers: headersCommon).responseDecodable(of: CartData.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(CartData.self, from: responseData)
                        self.cartData = welcome
                        let filter = self.cartData?.filter { self.selectedCartDataId.contains($0.id ?? 0) }
                        self.cartData = filter
                        self.conformsOrders()
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
    
    func conformsOrders() {
        
        var Order: [[String: Any]] = []
        if let count = cartData?.count {
            for i in 0..<count{
                //let orderCartData = convertToDictionary(selectedCartData?[i])
                let shopID = cartData?[i].product?.brandID ?? 0
                var isAlreayFound = false
                var findIndex = 0
                
                for k in 0..<Order.count{
                    let tempDic = Order[k] as NSDictionary
                    let alreayShopid = Int(tempDic.value(forKey: "shop") as! Int)
                    if shopID == alreayShopid{
                        
                        let productPrice = cartData?[i].total ?? 0
                        let productShipping = cartData?[i].shipping?.price ?? 0
                        
                        let alreayTotalCost = Int(tempDic.value(forKey: "price") as! String)
                        
                        let cTotalCost = productPrice + productShipping + alreayTotalCost!
                        
                        let prodcut = convertToDictionary(cartData?[i])
                        let productMutableDictionary = NSMutableDictionary(dictionary: prodcut!)
                        print(productMutableDictionary)
                        
                        productMutableDictionary["billingAddress"] = billingAddress
                        productMutableDictionary["shippingAddress"] = shiipingAddress
                        
                        var productARY: [[String: Any]] = tempDic.value(forKey: "products") as! [[String: Any]]
                        productARY.append(productMutableDictionary as! [String : Any])
                        
                        let dict: [String: Any] = [
                            "shop": shopID,
                            "price": "\(cTotalCost)",
                            "products": productARY,
                            "status": "new",
                            "date": getCurrentUTCDate(),
                        ]
                        Order.append(dict)
                        findIndex = k
                        isAlreayFound = true
                    }
                }
                
                if isAlreayFound == false{
                    
                    let productPrice = cartData?[i].total ?? 0
                    let productShipping = cartData?[i].shipping?.price ?? 0
                    
                    let cTotalCost = productPrice + productShipping
                    
                    let prodcut = convertToDictionary(cartData?[i])
                    let productMutableDictionary = NSMutableDictionary(dictionary: prodcut!)
                    print(productMutableDictionary)
                    
                    productMutableDictionary["billingAddress"] = billingAddress
                    productMutableDictionary["shippingAddress"] = shiipingAddress
                    
                    var productARY: [[String: Any]] = []
                    productARY.append(productMutableDictionary as! [String : Any])
                    
                    let dict: [String: Any] = [
                        "shop": shopID,
                        "price": "\(cTotalCost)",
                        "products": productARY,
                        "status": "new",
                        "date": getCurrentUTCDate(),
                    ]
                    Order.append(dict)
                }else{
                    Order.remove(at: findIndex)
                }
            }
        }
        
        let userDetail: [String: Any] = [
            "firstname": profileData.value(forKey: "firstName") ?? "NA",
            "lastname": profileData.value(forKey: "lastName") ?? "NA",
            "email": profileData.value(forKey: "emailAddress")!,
            "phone": profileData.value(forKey: "phoneNumber") ?? "NA",
            "gender": profileData.value(forKey: "sex") ?? "NA",
            "birth": convertToUTCDatebirth(dateString: profileData.value(forKey: "created") as! String) ?? "" ,
            "id": Int(UserID) ?? 0,
            "name": cardHolderName,
            "expDate":"2030-03-09T18:30:00.000Z",
            "cvv": cvv,
            "number": "4111111111111111"
        ]
        let parameters: [String: Any] = [
            "credit": creditCardObj,
            "orders": Order,
            "user": userDetail,
            "userId": Int(UserID) ?? 0
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                
//                let headers: HTTPHeaders = [
//                    "Authorization": AuthToken,
//                    "Content-Type": "application/json"
//                ]
                start_loading()
                AF.request("https://api-cluster.system.touchetv.com/backoffice/api/v1/order/request", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headersCommon).responseData { response in
                    if let request = response.request {
                            if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
                                print("Request Parameters: \(bodyString)")
                            }
                        }
                    switch response.result {
                    case .success(let value):
                        self.GetProdcutDetail()
                    case .failure(let error):
                        print("Error:", error)
                    }
                    
                    DispatchQueue.main.async {
                        self.stop_loading()
                    }
                }
            }
        } catch {
            print("Error converting to JSON:", error)
        }
    }
    
    func GetProdcutDetail() {
        
        start_loading()
        AF.request("https://api-cluster.system.touchetv.com/backoffice/api/v1/cart/users/\(UserID)/products", method: .get, headers: headersCommon).responseData { response in
            switch response.result {
            case .success(let value):
                let alertController = UIAlertController(title: "", message: "Payment Successful!", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
//                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "homeNavigationCON") as! UINavigationController
//                    UIApplication.shared.windows.first?.rootViewController = vc
//                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                    if let viewControllers = self.navigationController?.viewControllers {
                        if viewControllers.count >= 2 {
                            let targetViewController = viewControllers[viewControllers.count - 3]
                            self.navigationController?.popToViewController(targetViewController, animated: true)
                        }
                    }
                    
                }
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            case .failure(let error):
                print("Error:", error.localizedDescription)
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    func addToCart(shippingaddress: Int, count: Int, dic: NSMutableDictionary ,selectItem:CartDataModel,completion: @escaping (Bool) -> Void){
        
        let personDict = convertToDictionary(selectItem.product)
        let skuDict = convertToDictionary(selectItem.sku)
        let shippingDict = convertToDictionary(selectItem.product?.shippings?[shippingaddress])
        
        
        let params = [
            "count":"\(count)",
            "id":"\(selectItem.id ?? 0)",
            "price":"\(selectItem.sku?.price ?? 0)",
            "product":personDict!,
            "shipping":shippingDict!,
            "projectId":"6",
            "agreement":1,
            "sku":skuDict!,
            "total":"\(selectItem.sku?.price ?? 0)"
        ] as [String : Any]
        
        start_loading()
        self.put_api_request_withJson("https://api-cluster.system.touchetv.com/backoffice/api/v1/cart/users/\(UserID)/products/\(selectItem.id ?? 0)", params: params, headers: headersCommon).responseJSON(completionHandler: { response in
            print(response.result)
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("Error converting to dictionary: \(error.localizedDescription)")
                completion(false)
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        })
    }
    func deleteCartItem(dic: NSMutableDictionary ,selectItem:CartDataModel,completion: @escaping (Bool) -> Void){
        
        start_loading()
        self.delete_api_request("https://api-cluster.system.touchetv.com/backoffice/api/v1/cart/users/\(UserID)/products/\(selectItem.id ?? 0)", headers: headersCommon).responseData { response in
            print(response.result)
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("Error converting to dictionary: \(error.localizedDescription)")
                completion(true)
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
}
