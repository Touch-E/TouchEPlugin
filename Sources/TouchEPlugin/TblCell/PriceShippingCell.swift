//
//  PriceShippingCell.swift
//  Touch E Demo
//
//  Created by Kishan on 07/02/24.
//

import UIKit

class PriceShippingCell: UITableViewCell {

   
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var qtyLBL: UILabel!
    @IBOutlet weak var itemCV: UICollectionView!
    @IBOutlet weak var shippingFeeLBL: UILabel!
    @IBOutlet weak var totalPayLBL: UILabel!
    
    public struct Identifiers {
        static let kOrderStatusCell = "OrderStatusCell"
    }
    var stausSelected = ""
    var shippingARY :[Shipping]?
    var qtyChange: ((Bool) -> Void)?
    var shippingChange: ((Int) -> Void)?
    var addToCart: (() -> Void)?
    var buyNowAction: (() -> Void)?
    
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
    @IBAction func inusClick_Action(_ sender: UIButton) {
        if let action = qtyChange {
            action(false)
        }
       
    }
    @IBAction func plusClick_Action(_ sender: UIButton) {
        if let action = qtyChange {
            action(true)
        }
    }
    @IBAction func addtocartClick_Action(_ sender: UIButton) {
        if let action = addToCart {
            action()
        }
    }
    @IBAction func buyClick_Action(_ sender: UIButton) {
        if let action = buyNowAction{
            action()
        }
    }
    
    @IBAction func shippingChange_Action(_ sender: UIButton) {
//        if let action = shippingChange{
//            action()
//        }
    }
    
}

extension PriceShippingCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  shippingARY?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kOrderStatusCell, for: indexPath) as! OrderStatusCell
        
        let shippingName = shippingARY?[indexPath.row].name
        let price = shippingARY?[indexPath.row].price ?? 0
        cell.statusName.text = "\(shippingName!) - $\(price)"
        
        cell.dotUV.isHidden = true
        cell.nameLBLLeftCON.constant = 15
        cell.backUV.borderWidth = 2
        
        let borderColor = UIColor(red: 58/255, green: 171/255, blue: 242/255, alpha: 1)
        
        if stausSelected == "\(shippingName!) - $\(price)" {
            cell.backUV.borderColor = borderColor
        } else {
            cell.backUV.borderColor = .clear
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shippingName = shippingARY?[indexPath.row].name
        let price = shippingARY?[indexPath.row].price ?? 0
        stausSelected = "\(shippingName!) - $\(price)"
        if let action = shippingChange{
            action(indexPath.row)
        }
        itemCV.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = itemCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kOrderStatusCell, for: indexPath) as! OrderStatusCell
        
        let shippingName = shippingARY?[indexPath.row].name
        let price = shippingARY?[indexPath.row].price ?? 0
        cell.statusName.text = "\(shippingName!) - $\(price)"
        
        let labelWidth = cell.statusName.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: cell.statusName.frame.height)).width
        let padding: CGFloat = 45.0
        
        return CGSize(width: labelWidth + padding , height: 35)
    }
    
}
