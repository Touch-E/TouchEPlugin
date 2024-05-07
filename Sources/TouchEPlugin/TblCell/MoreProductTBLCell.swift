//
//  MoreProductTBLCell.swift
//  Touch E Demo
//
//  Created by Kishan on 07/02/24.
//

import UIKit

class MoreProductTBLCell: UITableViewCell {

    @IBOutlet weak var productCV: UICollectionView!
    var productARY : [Product]?
    var prodcutClick : ((Int) -> Void)?
    var storeClick : (() -> Void)?
    @IBOutlet weak var gotoSotreBTN: UIButton!
    public struct Identifiers {
        static let kMoreProductCell = "MoreProductCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Configurecollection()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func Configurecollection(){
        productCV.delegate = self
        productCV.dataSource = self
        productCV.register(UINib(nibName: Identifiers.kMoreProductCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kMoreProductCell)
        
    }
    @IBAction func gotoStoreClick_Action(_ sender: UIButton) {
        if let action = storeClick{
            action()
        }
    }
    
}
extension MoreProductTBLCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productARY?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kMoreProductCell, for: indexPath) as! MoreProductCell
        cell.priceLBL.text = "$\(productARY?[indexPath.row].productSkus?[0].price ?? 0)"
        let labelWidth = cell.priceLBL.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: cell.priceLBL.frame.height)).width
        cell.priceLBLWidthCON.constant = labelWidth + 10
        cell.priceLBL.layer.cornerRadius = 8
        cell.priceLBL.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        cell.priceLBL.clipsToBounds = true

        cell.nameLBL.text = productARY?[indexPath.row].name ?? ""
        
        let image = productARY?[indexPath.row].images?[0].url ?? ""
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // Use the encoded URL string
            print(encodedUrlString)
            cell.productIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            cell.productIMG.contentMode = .scaleAspectFill
        } else {
            // Handle the case where encoding fails
            print("Failed to encode URL string")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let action = prodcutClick {
            action(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productCV.layer.bounds.height / 1.5 , height: productCV.layer.bounds.height)
    }
    
    
    
}
