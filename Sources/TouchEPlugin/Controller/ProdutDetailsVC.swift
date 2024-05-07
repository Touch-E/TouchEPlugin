//
//  ProdutDetailsVC.swift
//  
//
//  Created by Jaydip Godhani on 09/04/24.
//

import UIKit

public class ProdutDetailsVC: UIViewController {
    
    static func storyboardInstance() -> ProdutDetailsVC {
       // return mainStoryboard.instantiateViewController(withIdentifier: "ProdutDetailsVC") as! ProdutDetailsVC
        return ProdutDetailsVC(nibName: "ProdutDetailsVC", bundle: Bundle.module)
    }
    
    @IBOutlet weak var ProductDataTBL: UITableView!
    @IBOutlet weak var totalPriceLBL: UILabel!
    @IBOutlet weak var buyNowBTNWidthCON: NSLayoutConstraint!
    @IBOutlet weak var addtoCartBTNWidthCON: NSLayoutConstraint!
    @IBOutlet weak var buyNowTrilingCON: NSLayoutConstraint!
    
    public struct Identifiers {
        static let kProductImageDetailsCell = "ProductImageDetailsCell"
        static let kPriceShippingCell = "PriceShippingCell"
        static let kMoreProductTBLCell = "MoreProductTBLCell"
        static let kCustomerReviewTBLCell = "CustomerReviewTBLCell"
        static let kAttributeCell = "AttributeCell"
        
    }
    
    var productData : ProductDataModel?
    var brandDetails : BrandDataModel?
    var addCartData : CartDataModel?
    var addCartProjectID = 0
    var productID = ""
    var isCellExpanded = false
    var shippingSelectIndex = 0
    var SKUIndex = 0
    var productQTY = 1
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GetProdcutDetail()
        ConfigureTableView()
        ProductDataTBL.isHidden = true
        
        if isiPhoneSE() {
            buyNowTrilingCON.constant = 10
            buyNowBTNWidthCON.constant = 95
            addtoCartBTNWidthCON.constant = 95
        } else {
            buyNowTrilingCON.constant = 25
            buyNowBTNWidthCON.constant = 120
            addtoCartBTNWidthCON.constant = 120
        
        }
    }
    func ConfigureTableView(){
        
        ProductDataTBL.delegate = self
        ProductDataTBL.dataSource = self
        ProductDataTBL.register(UINib(nibName: Identifiers.kProductImageDetailsCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kProductImageDetailsCell)
        ProductDataTBL.register(UINib(nibName: Identifiers.kPriceShippingCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kPriceShippingCell)
        ProductDataTBL.register(UINib(nibName: Identifiers.kMoreProductTBLCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kMoreProductTBLCell)
        ProductDataTBL.register(UINib(nibName: Identifiers.kCustomerReviewTBLCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kCustomerReviewTBLCell)
        ProductDataTBL.register(UINib(nibName: Identifiers.kAttributeCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kAttributeCell)
        ProductDataTBL.separatorStyle = .none
        
    }
    @IBAction func closeClick_Action(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Check for changes in size class or traits
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass ||
            traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            self.view.layoutIfNeeded()
            self.ProductDataTBL.layoutIfNeeded()
            self.ProductDataTBL.reloadData()
            
        }
    }
    func findSKUProd(selectedValuse : NSMutableArray){
        for i in 0..<self.productData!.productSkus!.count {
            let attributeARY = self.productData!.productSkus![i].attributes!
            let trauARY = NSMutableArray()
            if attributeARY.count > 0 && attributeARY.count == selectedValuse.count{
                for j in 0..<selectedValuse.count{
                    let selectValue = "\(selectedValuse[j])"
                    let objvalue = attributeARY[j].name ?? ""
                    if selectValue == objvalue{
                        trauARY.add(true)
                    }
                }
            }
            
            if trauARY.count == selectedValuse.count{
                let allTrue = trauARY.allSatisfy { $0 as! Bool == true }
                if allTrue {
                    self.SKUIndex = i
                    return
                }
            }
            
             
        }
    }
    @IBAction func buynowClick_Action(_ sender: UIButton) {
        self.buyNowAddToCart(qty: "\(productQTY)") { success, error in
            if success {
                print(self.addCartProjectID)
                var selectedCartDataId: [Int] = []
                selectedCartDataId.append(self.addCartProjectID)
                if selectedCartDataId.count > 0{
                    let vc = CheckOutVC.storyboardInstance()//mainStoryboard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
                    vc.modalPresentationStyle = .custom
                    vc.selectedCartDataId = selectedCartDataId
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.ShowAlert(title: "Error", message: "Please select product for checkout!")
                }
            } else {
               self.ShowAlert(title: "Error", message: error?.localizedDescription ?? "Unknown error occurred")
            }
        }

    }
    @IBAction func addToCartClick_Action(_ sender: UIButton) {
            self.addToCart(qty: "\(productQTY)")
    }
    
}
extension ProdutDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = ProductDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kProductImageDetailsCell, for: indexPath) as! ProductImageDetailsCell
            cell.selectionStyle = .none
            cell.descriptionLBL.text = productData?.info ?? ""
            
            let maxSize = CGSize(width: cell.descriptionLBL.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            let labelSize = (cell.descriptionLBL.text! as NSString).boundingRect(with: maxSize,
                                                                                 options: .usesLineFragmentOrigin,
                                                                                 attributes: [NSAttributedString.Key.font: cell.descriptionLBL.font],
                                                                                 context: nil).size
            let textHeight = ceil(labelSize.height)
            cell.readMoreUV.isHidden = textHeight < 20 ? true : false
            cell.brandNameLBL.text = productData?.brandName ?? ""
            cell.nameLBL.text = productData?.name ?? ""
            cell.skuLBL.text = productData?.productSkus![0].sku ?? ""
            cell.pageControl.numberOfPages = productData?.images?.count ?? 0
            cell.imageArr = productData?.images
            cell.totalReviewLBL.text = "(\(Int(productData?.reviewsCnt ?? 0)) Review)"
            cell.ratingLBL.text = "\(productData?.rating ?? 0)"
            cell.ratingUV.rating = Double(productData?.rating ?? 0)
            cell.productIMGCV.reloadData()
            
            cell.readMoreTapped = { [weak self] in
                self?.isCellExpanded.toggle()
                self?.ProductDataTBL.beginUpdates()
                self?.ProductDataTBL.endUpdates()
                self?.ProductDataTBL.reloadData()
            }
            return cell
        }else if indexPath.row == 1{
            let cell = ProductDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kAttributeCell, for: indexPath) as! AttributeCell
            cell.selectionStyle = .none
            if productData?.attGroups?.count ?? 0 > 0{
                cell.attributeARY = productData?.attGroups
                cell.attributeTBL.reloadData()
                
                DispatchQueue.main.async {
                    self.findSKUProd(selectedValuse: cell.selectedValuse)
                }
                
                cell.editAttribute = { (mainIndex, subIndex) in
                    self.findSKUProd(selectedValuse: cell.selectedValuse)
                }
            }
            return cell
            
        }else if indexPath.row == 2{
            
            let cell = ProductDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kPriceShippingCell, for: indexPath) as! PriceShippingCell
            cell.selectionStyle = .none
            cell.priceLBL.text = "US $\(productData?.productSkus![0].price ?? 0)"
            
            if productData?.shippings!.count ?? 0 > 0{
                let shippingName = productData?.shippings?[0].name
                let price = productData?.shippings?[0].price ?? 0
                cell.stausSelected = "\(shippingName!) - $\(price)"
            }else{
                cell.stausSelected = " Free Shipping"
            }
            
            cell.shippingARY = productData?.shippings
            cell.shippingFeeLBL.text = "US $\(productData?.shippings?[0].price ?? 0)"
            cell.itemCV.reloadData()
            
            let qtyValue = Int("\(cell.qtyLBL.text!)") ?? 0
            let productPrice = self.productData?.productSkus![0].price ?? 0
            let itemPrice = qtyValue * productPrice
            cell.priceLBL.text = "US $\(itemPrice)"
            
            let shippingPrice = self.productData?.shippings?[self.shippingSelectIndex].price ?? 0
            let totalPrice = itemPrice + shippingPrice
            cell.totalPayLBL.text = "US $\(totalPrice)"
            
            self.totalPriceLBL.text = "US $\(totalPrice)"
            
            cell.qtyChange = { result in
                let stockCount = self.productData?.productSkus?[self.SKUIndex].stock ?? 0
                var qtyValue = Int("\(cell.qtyLBL.text!)") ?? 0
                if result{
                    qtyValue += 1
                }else{
                    if qtyValue != 0{
                        qtyValue -= 1
                    }
                }
                if qtyValue != 0{
                    if qtyValue > stockCount{
                        let sku = "SKU:\(self.productData?.productSkus?[self.SKUIndex].sku ?? "")"
                        self.ShowAlert(title: "Error", message: "Order quantity exceeds stock for product \(sku)")
                    }else{
                        cell.qtyLBL.text = "\(qtyValue)"
                        self.productQTY = qtyValue
                        
                        let productPrice = self.productData?.productSkus![0].price ?? 0
                        let itemPrice = qtyValue * productPrice
                        cell.priceLBL.text = "US $\(itemPrice)"
                        
                        let shippingPrice = self.productData?.shippings?[self.shippingSelectIndex].price ?? 0
                        let totalPrice = itemPrice + shippingPrice
                        cell.totalPayLBL.text = "US $\(totalPrice)"
                        
                        self.totalPriceLBL.text = "US $\(totalPrice)"
                        
                    }
                }
                
            }
            cell.shippingChange = { selectIndex in
                self.shippingSelectIndex = selectIndex
                cell.shippingFeeLBL.text = "US $\(self.productData?.shippings?[selectIndex].price ?? 0)"
                
                let qtyValue = Int("\(cell.qtyLBL.text!)") ?? 0
                let productPrice = self.productData?.productSkus![0].price ?? 0
                let itemPrice = qtyValue * productPrice
                cell.priceLBL.text = "US $\(itemPrice)"
                
                let shippingPrice = self.productData?.shippings?[self.shippingSelectIndex].price ?? 0
                let totalPrice = itemPrice + shippingPrice
                cell.totalPayLBL.text = "US $\(totalPrice)"
                
                self.totalPriceLBL.text = "US $\(totalPrice)"
                
            }
            cell.addToCart = {
                let qtyValue = Int("\(cell.qtyLBL.text!)") ?? 0
                self.addToCart(qty: "\(qtyValue)")
            }
            cell.buyNowAction = {
                
                let qtyValue = Int("\(cell.qtyLBL.text!)") ?? 0
                self.buyNowAddToCart(qty: "\(qtyValue)") { success, error in
                    if success {
                        print(self.addCartProjectID)
                        var selectedCartDataId: [Int] = []
                        selectedCartDataId.append(self.addCartProjectID)
                        if selectedCartDataId.count > 0{
                            let vc = CheckOutVC.storyboardInstance()//mainStoryboard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
                            vc.modalPresentationStyle = .custom
                            vc.selectedCartDataId = selectedCartDataId
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            self.ShowAlert(title: "Error", message: "Please select product for checkout!")
                        }
                    } else {
                       self.ShowAlert(title: "Error", message: error?.localizedDescription ?? "Unknown error occurred")
                    }
                }
            }
            
            return cell
        }else if indexPath.row == 3{
            let cell = ProductDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kMoreProductTBLCell, for: indexPath) as! MoreProductTBLCell
            cell.selectionStyle = .none
            cell.productARY = brandDetails?.products
            cell.productCV.reloadData()
            
            cell.prodcutClick = { indexp in
                let viewcontroller = ProdutDetailsVC.storyboardInstance()
                viewcontroller.modalPresentationStyle = .custom
                let prodID = self.brandDetails?.products?[indexp].id ?? 0
                viewcontroller.productID = "\(prodID)"
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                //self.present(viewcontroller, animated: true, completion: nil)
            }
            cell.storeClick = {
                let brandid = self.productData?.brandID ?? 0
                let viewcontroller = BrandDetailsVC.storyboardInstance()
                viewcontroller.modalPresentationStyle = .custom
                viewcontroller.brandID = "\(brandid)"
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            return cell
        }else{
            let cell = ProductDataTBL.dequeueReusableCell(withIdentifier: Identifiers.kCustomerReviewTBLCell, for: indexPath) as! CustomerReviewTBLCell
            cell.selectionStyle = .none
            cell.reviewCountLBL.text = "Customer Reviews (\(Int( productData?.reviewsCnt ?? 0)))"
            cell.reviewARY = productData?.reviews
            cell.sepreatLineUV.isHidden = true
            cell.reviewCV.reloadData()
            return cell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return isCellExpanded ? UITableView.automaticDimension : 250
        }else if indexPath.row == 1{
            if productData?.attGroups?.count ?? 0 > 0{
                let size = (90 * Int(productData?.attGroups?.count ?? 0)) + 32
                return CGFloat(size)
            }else{
                return 0
            }
            
        }else if indexPath.row == 2{
            return 240.0
        }else if indexPath.row == 3{
            return 225.0
        }else{
            if Int( self.productData?.reviewsCnt ?? 0) > 0{
                return 128.0
            }else{
                return 0
            }
            
        }
      }
    
}

extension ProdutDetailsVC {
    func GetProdcutDetail(){
        let params = [ : ] as [String : Any]
        print(params)
        start_loading()
    
        self.get_api_request("\(BaseURLOffice)product/\(productID)/view\(loadContents)", headers: headersCommon).responseDecodable(of: ProductDataModel.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(ProductDataModel.self, from: responseData)
                        self.productData = welcome
                        let brandid = self.productData?.brandID ?? 0
                        self.GetRelatedProduct(brandid: "\(brandid)")
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
    func GetRelatedProduct(brandid : String){
        let params = [ : ] as [String : Any]
        print(params)
        start_loading()
    
        self.get_api_request("\(BaseURLOffice)brand/\(brandid)/view\(loadContents)", headers: headersCommon).responseDecodable(of: BrandDataModel.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(BrandDataModel.self, from: responseData)
                        self.brandDetails = welcome
                        self.ProductDataTBL.isHidden = false
                        self.ProductDataTBL.reloadData()
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
    func addToCart(qty:String){
        let personDict = convertToDictionary(self.productData)
        let skuDict = convertToDictionary(self.productData?.productSkus?[self.SKUIndex])
        let shippingDict = convertToDictionary(self.productData?.shippings?[self.shippingSelectIndex])
       
        let params = [
            "count":qty,
            "price":"\(productData?.productSkus![0].price ?? 0)",
            "product":personDict!,
            "projectId":projectID,
            "shipping":shippingDict!,
            "agreement":1,
            "sku":skuDict!
        ] as [String : Any]
        
        print(params)
        start_loading()
        self.post_api_request_withJson("\(BaseURLOffice)cart/users/\(UserID)/products", params: params, headers: headersCommon).responseJSON(completionHandler: { response in
            print(response.result)
            switch response.result {
            case .success:
                self.ShowAlert(title: "Success", message: "Product successfully add in cart!")
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        })
    }
    func buyNowAddToCart(qty: String, completion: @escaping (Bool, Error?) -> Void) {
        let personDict = convertToDictionary(self.productData)
        let skuDict = convertToDictionary(self.productData?.productSkus?[self.SKUIndex])
        let shippingDict = convertToDictionary(self.productData?.shippings?[self.shippingSelectIndex])
       
        let params = [
            "count": qty,
            "price": "\(productData?.productSkus![0].price ?? 0)",
            "product": personDict!,
            "projectId": projectID,
            "shipping": shippingDict!,
            "agreement": 1,
            "sku": skuDict!
        ] as [String : Any]
        
        print(params)
        start_loading()
        self.post_api_request_withJson("\(BaseURLOffice)cart/users/\(UserID)/products", params: params, headers: headersCommon).responseDecodable(of: CartDataModel.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(CartDataModel.self, from: responseData)
                        self.addCartData = welcome
                        self.addCartProjectID = self.addCartData?.id ?? 0
                    } catch {
                        self.ShowAlert(title: "Error", message: "Failed to decode response: \(error.localizedDescription)")
                    }
                }
                completion(true, nil) // Call the completion handler with success
            case .failure(let error):
                completion(false, error) // Call the completion handler with failure and error
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
}
