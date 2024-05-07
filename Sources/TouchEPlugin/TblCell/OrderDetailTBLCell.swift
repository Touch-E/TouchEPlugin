//
//  OrderDetailTBLCell.swift
//  
//
//  Created by Jaydip Godhani on 15/04/24.
//

import UIKit
import SDWebImage
import Cosmos

class OrderDetailTBLCell: UITableViewCell {
    
    //MARK: - Outlets
    //@IBOutlet weak var tblAttributesList: UITableView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgProduct: UIImageViewX!
    @IBOutlet weak var lblShipping: UILabel!
    @IBOutlet weak var lblSKU: UILabel!
    @IBOutlet weak var btnRateProduct: UIButton!
    @IBOutlet weak var ratingUV: CosmosView!
    @IBOutlet weak var productPriceLBL: UILabel!
    @IBOutlet weak var attributeCV: UICollectionView!
    @IBOutlet weak var collectionHeightCON: NSLayoutConstraint!
    @IBOutlet weak var yesAttriSepLineIMG: UIImageView!
    
    //MARK: - Variables
    var cellRateProduct : (()->Void)?
    public struct Identifiers {
        static let kCartAttributeCVCell = "CartAttributeCVCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellConfigure()
    }

    func cellConfigure(){
        attributeCV.delegate = self
        attributeCV.dataSource = self
        attributeCV.register(UINib(nibName: Identifiers.kCartAttributeCVCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kCartAttributeCVCell)
        if let flowLayout = attributeCV.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    var productData: ProductElement?{
        didSet{
            var image = ""
            image = "\(productData?.product?.mainImage?.url ?? "")"
            if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                imgProduct.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
                imgProduct.contentMode = .scaleAspectFill
            } else {
                print("Failed to encode URL string")
            }
            lblProductName.text = productData?.product?.name
            lblSKU.text = productData?.sku?.sku
            
            let price = productData?.sku?.price ?? 0
            productPriceLBL.text = "US $\(price)"
        
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnRateProductTapped(_ sender: UIButton) {
        if let action = cellRateProduct{
           action()
       }
    }
    func heightCalculate(){
        let cvWidth = (UIScreen.main.bounds.size.width - 26)
        if let attARY = productData?.sku?.attributes {
            var rowCount = 1
            var itemWidth: Double = 10
            for i in 0..<attARY.count{
                let name = "\(attARY[i].attributeName ?? "") :"
                let valuse = " \(attARY[i].name ?? "")"
                
                let nameWidth = getTextWidth(text: name, font: .systemFont(ofSize: 13))
                let valueWidth = getTextWidth(text: valuse, font: .systemFont(ofSize: 13))
                
                //let collectioviewWidth = (UIScreen.main.bounds.size.width - 26) / 3.3
                let nametempwidth = Double(nameWidth + valueWidth)
//                if nametempwidth < collectioviewWidth{
//                    nametempwidth = collectioviewWidth
//                }
                
                itemWidth = itemWidth + nametempwidth + 10
                
                if itemWidth > cvWidth{
                    rowCount = rowCount + 1
                    itemWidth = 10
                }
            }
            self.collectionHeightCON.constant = Double(rowCount * 25)
        }
        
    }
}

//extension OrderDetailTBLCell: UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return productData?.sku?.attributes?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tblAttributesList.dequeueReusableCell(withIdentifier: "AttributesListTBLCell", for: indexPath) as! AttributesListTBLCell
//        cell.lblTypeValue.text = productData?.sku?.attributes?[indexPath.row].name ?? ""
//        cell.lblType.text = productData?.sku?.attributes?[indexPath.row].type?.rawValue
//        return cell
//    }
//}

extension OrderDetailTBLCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData?.sku?.attributes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = attributeCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kCartAttributeCVCell, for: indexPath) as! CartAttributeCVCell
        cell.nameLBL.text = "\(productData?.sku?.attributes?[indexPath.row].attributeName ?? "") :"
        cell.valueLBL.text = productData?.sku?.attributes?[indexPath.row].name ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let name = "\(productData?.sku?.attributes?[indexPath.row].attributeName ?? "") :"
        let valuse = productData?.sku?.attributes?[indexPath.row].name ?? ""
        
        let nameWidth = getTextWidth(text: name, font: .systemFont(ofSize: 13))
        let valueWidth = getTextWidth(text: valuse, font: .systemFont(ofSize: 13))
        let itemHeight = 20
        
        //let collectioviewWidth = (UIScreen.main.bounds.size.width - 26) / 3.3 //attributeCV.frame.size.width / 3
        let nametempwidth = Double(nameWidth + valueWidth)
//        if nametempwidth < collectioviewWidth{
//            nametempwidth = collectioviewWidth
//        }
        return CGSize(width: nametempwidth, height: Double(itemHeight))
    }
    
    func getTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = NSString(string: text).size(withAttributes: attributes)
        return ceil(textSize.width)
    }
    
    
}
