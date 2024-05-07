//
//  MyCartVC.swift
//  Touch E Demo
//
//  Created by Kishan on 08/02/24.
//

import UIKit
import Alamofire

public class MyCartVC: UIViewController {

    static func storyboardInstance() -> MyCartVC {
        return MyCartVC(nibName: "MyCartVC", bundle: Bundle.module)
    }
    @IBOutlet weak var totalItemTitleLBL: UILabel!
    @IBOutlet weak var itemPriceLBL: UILabel!
    @IBOutlet weak var shippingfeeLBL: UILabel!
    @IBOutlet weak var checkOutBTN: UIButtonX!
    @IBOutlet weak var shippingCartLBL: UILabel!
    @IBOutlet weak var cartDataTBL: UITableView!
    @IBOutlet weak var noDataAvlbLBL: UILabel!
    @IBOutlet weak var payBTNWidthCON: NSLayoutConstraint!
    
    public struct Identifiers {
        static let kCartSectionCell = "CartSectionCell"
        static let kCartItemCell = "CartItemCell"
        static let kOrderSummearyCell = "OrderSummearyCell"
        
    }
    var addressListData : AddressData?
    var cartData : CartData?
    var customDataARY = NSMutableArray()
    var jsonResponseARY = NSMutableArray()
    var selectedCartDataID: [Int] = []
    
    var totalCost = 0
    var itemTotalPrice = 0
    var shippingCost = 0
    var totalItemSelect = 0
    var expandCellIndex = -1
    var expandCellSection = -1
    var isCellExpanded = false
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let view = Bundle.module.loadNibNamed("MyCartVC", owner: self, options: nil)?.first as? UIView {
            self.view = view
        }
        if isiPhoneSE() {
            payBTNWidthCON.constant = 120
        } else {
            payBTNWidthCON.constant = 150
        }
        
        GetCartDetail()
        ConfigureTableView()
        GetAddressList()
    }

    @IBAction func closeClick_Action(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func ConfigureTableView(){
        cartDataTBL.delegate = self
        cartDataTBL.dataSource = self
        cartDataTBL.register(UINib(nibName: Identifiers.kCartSectionCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kCartSectionCell)
        cartDataTBL.register(UINib(nibName: Identifiers.kCartItemCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kCartItemCell)
        cartDataTBL.register(UINib(nibName: Identifiers.kOrderSummearyCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kOrderSummearyCell)
    }
    @IBAction func btnProceedToCheckout(_ sender: UIButtonX) {
        if addressListData?.count == nil{
            self.ShowAlert(title: "Error", message: "No shipping address is provided. Go to My Profile > Addresses to add one.")
        } else {
            self.totalCostCalculate()
            if selectedCartDataID.count > 0{
                let vc = CheckOutVC.storyboardInstance()//mainStoryboard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
                vc.modalPresentationStyle = .custom
                vc.selectedCartDataId = selectedCartDataID
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.ShowAlert(title: "Error", message: "Please select product for checkout!")
            }
        }
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
                        ProductDic["isSelected"] = "0"
                        ProductDic["shippingCost"] = addShippingIndex
                        ProductDic["qty"] = "\(qtyCount)"
                        currentARY.add(ProductDic)
                        
                        let tempdic = NSMutableDictionary()
                        tempdic["isAllSelect"] = "0"
                        tempdic["brandName"] = customBrand
                        tempdic["productsARY"] = currentARY
                        self.customDataARY.replaceObject(at: k, with: tempdic)
                        isUpdate = true
                    }
                }
                if isUpdate == false{
                    let tempdic = NSMutableDictionary()
                    tempdic["isAllSelect"] = "0"
                    tempdic["brandName"] = brandName
                    
                    let ProductDic = NSMutableDictionary()
                    ProductDic["products"] = self.cartData?[i]
                    ProductDic["isSelected"] = "0"
                    ProductDic["shippingCost"] = addShippingIndex
                    ProductDic["qty"] = "\(qtyCount)"
                    
                    let productARY = NSMutableArray()
                    productARY.add(ProductDic)
                    
                    tempdic["productsARY"] = productARY
                    self.customDataARY.add(tempdic)
                }
            }else{
                let tempdic = NSMutableDictionary()
                tempdic["isAllSelect"] = "0"
                tempdic["brandName"] = brandName
                
                let ProductDic = NSMutableDictionary()
                ProductDic["products"] = self.cartData?[i]
                ProductDic["isSelected"] = "0"
                ProductDic["shippingCost"] = addShippingIndex
                ProductDic["qty"] = "\(qtyCount)"
                
                let productARY = NSMutableArray()
                productARY.add(ProductDic)
                
                tempdic["productsARY"] = productARY
                self.customDataARY.add(tempdic)
                
            }
            
        }
        print(self.customDataARY)
        self.cartDataTBL.reloadData()
    }
    
    func totalCostCalculate(){
         totalCost = 0
         itemTotalPrice = 0
         shippingCost = 0
         totalItemSelect = 0
         selectedCartDataID.removeAll()
        
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
                    
                    selectedCartDataID.append(cartTempData.id ?? 0)
                }
                
            }
           
        }
        
        itemPriceLBL.text = "US $\(itemTotalPrice)"
        shippingfeeLBL.text = "US $\(shippingCost)"
        //totalPayLBL.text = "US $\(totalCost)"
        totalItemTitleLBL.text = "Items (\(totalItemSelect))"
        checkOutBTN.setTitle("Pay $\(totalCost) USD", for: .normal)
        print(customDataARY.count)
        cartDataTBL.isHidden = customDataARY.count > 0 ? false : true
        noDataAvlbLBL.isHidden = customDataARY.count > 0 ? true : false
        cartDataTBL.reloadData()
    }

}
extension MyCartVC : UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.customDataARY.count //+ 1
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = cartDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kCartSectionCell) as! CartSectionCell
        if section != self.customDataARY.count{
            let currentDic = self.customDataARY.object(at: section) as! NSDictionary
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
                        self.customDataARY.replaceObject(at: section, with: currentDic)
                    }
                    self.totalCostCalculate()
                    self.cartDataTBL.reloadData()
                    
                    
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
                        self.customDataARY.replaceObject(at: section, with: currentDic)
                    }
                    self.totalCostCalculate()
                    self.cartDataTBL.reloadData()
                }
                
            }
            
        }else{
            headerCell.checkBTN.setImage(UIImage(named: "ic_mycart"), for: .normal)
            headerCell.brandNameLBL.text = "Order summary"
        }
        //headerCell.backgroundColor = .red
        return headerCell
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != self.customDataARY.count{
            let currentDic = self.customDataARY.object(at: section) as! NSMutableDictionary
            let dataARY = currentDic.value(forKey: "productsARY") as! NSArray
            return dataARY.count
        }else{
            return 1
        }
        
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != self.customDataARY.count{
            let cell = cartDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kCartItemCell, for: indexPath) as! CartItemCell
            cell.selectionStyle = .none
            let currentDic = self.customDataARY.object(at: indexPath.section) as! NSDictionary
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
                self.customDataARY.replaceObject(at: indexPath.section, with: currentDic)
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
                                self.customDataARY.replaceObject(at: indexPath.section, with: currentDic)
                                self.totalCostCalculate()
                            }else{
                                
                                dataARY.removeObject(at: indexPath.row)//replaceObject(at: indexPath.row, with: productDic)
                                currentDic.setValue(dataARY, forKey: "productsARY")
                                self.customDataARY.replaceObject(at: indexPath.section, with: currentDic)
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
                            self.customDataARY.replaceObject(at: indexPath.section, with: currentDic)
                            self.totalCostCalculate()
                        }else{
                            self.customDataARY.removeObject(at: indexPath.section)
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
                    self.customDataARY.replaceObject(at: indexPath.section, with: currentDic)
                    
                }else{
                    cell.checkBTN.setImage(UIImage(named: "check-box-empty"), for: .normal)
                    productDic.setValue("0", forKey: "isSelected")
                    dataARY.replaceObject(at: indexPath.row, with: productDic)
                    currentDic.setValue(dataARY, forKey: "productsARY")
                    self.customDataARY.replaceObject(at: indexPath.section, with: currentDic)
                    
                }
                self.totalCostCalculate()
            }
            
            if indexPath.row == dataARY.count - 1{
                cell.backUV.layer.cornerRadius = 10
                cell.backUV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            
            cell.cellExpand = {
                self.expandCellIndex = indexPath.row
                self.expandCellSection = indexPath.section
                self.isCellExpanded.toggle()
                self.cartDataTBL.reloadData()
                //self.cartDataTBL.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }else{
            let cell = cartDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kOrderSummearyCell, for: indexPath) as! OrderSummearyCell
            cell.selectionStyle = .none
            cell.backUV.layer.cornerRadius = 10
            cell.backUV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            cell.productCoseLBL.text = "US $\(itemTotalPrice)"
            cell.shippingCoseLBL.text = "US $\(shippingCost)"
            cell.totalCostLBL.text = "US $\(totalCost)"
            cell.itemCountLBL.text = "Items (\(totalItemSelect))"
            cell.proceedBTN.setTitle("Proceed to Checkout (\(totalItemSelect))", for: .normal)
            return cell
        }
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       // if indexPath.section != self.customDataARY.count{
//
//            let currentDic = self.customDataARY.object(at: indexPath.section) as! NSDictionary
//            let dataARY = currentDic.value(forKey: "productsARY") as! NSMutableArray
//            let productDic = dataARY.object(at: indexPath.row) as! NSMutableDictionary
//            let cartTempData = productDic.value(forKey: "products") as! CartDataModel
//
//            if cartTempData.sku?.attributes?.count ?? 0 > 0{
//                let value = ((cartTempData.sku?.attributes?.count ?? 0) % 2)
//                var totalRow = 0
//                if value == 1{
//                    totalRow = ((cartTempData.sku?.attributes?.count ?? 0) + 1) / 2
//                }else{
//                    totalRow = (cartTempData.sku?.attributes?.count ?? 0) / 2
//                }
//
//                return CGFloat(193 + (20 * totalRow))
//            }else{
//                return 178
//            }
//
////        }else{
////            return 180
////        }
    
//    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if isCellExpanded {
            if expandCellIndex == indexPath.row && expandCellSection == indexPath.section{
                let currentDic = self.customDataARY.object(at: indexPath.section) as! NSDictionary
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
        
        
    }
    
    func getTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = NSString(string: text).size(withAttributes: attributes)
        return ceil(textSize.width)
    }

}

extension MyCartVC {
    func GetCartDetail(){
        start_loading()
        self.get_api_request("\(BaseURLOffice)cart/users/\(UserID)/products\(loadContents)", headers: headersCommon).responseDecodable(of: CartData.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(CartData.self, from: responseData)
                        self.cartData = welcome
                        self.shippingCartLBL.text = "Shopping Cart (\(self.cartData?.count ?? 0))"
                        if self.cartData?.count ?? 0 > 0{
                            self.cartDataTBL.isHidden = false
                            self.noDataAvlbLBL.isHidden = true
                        }else{
                            self.cartDataTBL.isHidden = true
                            self.noDataAvlbLBL.isHidden = false
                        }
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
                       "projectId":projectID,
                       "agreement":1,
                       "sku":skuDict!,
                       "total":"\(selectItem.sku?.price ?? 0)"
        ] as [String : Any]
        //print(params)
        start_loading()
        self.put_api_request_withJson("\(BaseURLOffice)cart/users/\(UserID)/products/\(selectItem.id ?? 0)", params: params, headers: headersCommon).responseJSON(completionHandler: { response in
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
        self.delete_api_request("\(BaseURLOffice)cart/users/\(UserID)/products/\(selectItem.id ?? 0)", headers: headersCommon).responseData { response in
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
    //delete_api_request
    
//    func postExampleWithAuthorizationToken() {
//        // 1. Create a URL with the API endpoint
//        guard let url = URL(string: "https://api-cluster.system.touchetv.com/backoffice/api/v1/cart/users/\(UserID)/products") else {
//            print("Invalid URL")
//            return
//        }
//
//        // 2. Create a URLRequest
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // Add your authorization token to the request headers
//        let authToken = "your_auth_token"
//        request.setValue("\(AuthToken)", forHTTPHeaderField: "Authorization")
//
//        // Add any parameters or JSON body to the request
//        let personDict = convertToDictionary(self.cartData?[0].product)
//        let skuDict = convertToDictionary(self.cartData?[0].sku)
//
//        let parameters = [
//            "count":"1",
//            "id":"639",
//            "price":"\(self.cartData?[0].sku?.price ?? 0)",
//            "product":personDict!,
//            "projectId":"6",
//            "agreement":1,
//            "sku":skuDict!,
//            "total":"1500"
//        ] as [String : Any]
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
//        } catch {
//            print("Error creating JSON data: \(error)")
//            return
//        }
//
//        // 3. Use URLSession to send the request
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            // 4. Handle the response
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
//            if let data = data {
//                // Parse and handle the data received from the server
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("Response JSON: \(json)")
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
//            }
//        }
//
//        task.resume()
//    }
    
}
