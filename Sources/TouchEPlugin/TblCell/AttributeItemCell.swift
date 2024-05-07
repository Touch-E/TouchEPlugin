//
//  AttributeItemCell.swift
//  Touch E Demo
//
//  Created by Kishan on 12/02/24.
//

import UIKit

class AttributeItemCell: UITableViewCell {

    @IBOutlet weak var itemNameLBL: UILabel!
    @IBOutlet weak var itemCV: UICollectionView!
    @IBOutlet weak var sepLineUV: UIView!
    
    public struct Identifiers {
        static let kOrderStatusCell = "OrderStatusCell"
    }
    
    var attributeValueARY :[Value]?
    var attributeChangeIndex : ((Int) -> Void)?
    var stausSelected = ""
    var isColor = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Configurecollection()
    }
    func Configurecollection(){
        itemCV.delegate = self
        itemCV.dataSource = self
        itemCV.register(UINib(nibName: Identifiers.kOrderStatusCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kOrderStatusCell)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hexStringToUIColor(hex: String) -> UIColor? {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension AttributeItemCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  attributeValueARY?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kOrderStatusCell, for: indexPath) as! OrderStatusCell
        if isColor{
            let colorName = attributeValueARY?[indexPath.row].value ?? ""
            if let colorTemp = hexStringToUIColor(hex: "\(colorName)") {
                cell.backUV.backgroundColor = colorTemp
            } else {
                print("Invalid hex color string from API")
            }
            cell.dotUV.isHidden = true
            cell.statusName.isHidden = true
            cell.backUV.borderWidth = 2
            
            let borderColor = UIColor(red: 58/255, green: 171/255, blue: 242/255, alpha: 1)
            let shippingName = attributeValueARY?[indexPath.row].name ?? ""
            if stausSelected == shippingName {
                cell.backUV.borderColor = borderColor
            } else {
                cell.backUV.borderColor = .clear
            }
        }else{
            let shippingName = attributeValueARY?[indexPath.row].name
            cell.statusName.text  = "\(shippingName!)"
            cell.dotUV.isHidden = true
            cell.nameLBLLeftCON.constant = 15
            cell.backUV.borderWidth = 2
            
            let borderColor = UIColor(red: 58/255, green: 171/255, blue: 242/255, alpha: 1)

            if stausSelected == shippingName {
                cell.backUV.borderColor = borderColor
            } else {
                cell.backUV.borderColor = .clear
            }
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let shippingName = attributeValueARY?[indexPath.row].name
        let nameValue = "\(shippingName!)"
        stausSelected = nameValue
        if let action = attributeChangeIndex{
            action(indexPath.row)
        }
        itemCV.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isColor{
            return CGSize(width: 50 , height: 35)
        }else{
            let cell = itemCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kOrderStatusCell, for: indexPath) as! OrderStatusCell
            let shippingName = attributeValueARY?[indexPath.row].name
            cell.statusName.text = shippingName
            
            let labelWidth = cell.statusName.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: cell.statusName.frame.height)).width
            let padding: CGFloat = 45.0
            
            return CGSize(width: labelWidth + padding , height: 35)
        }
        
    }
    
}
