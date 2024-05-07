//
//  CartItemCell.swift
//  Touch E Demo
//
//  Created by Kishan on 08/02/24.
//

import UIKit

class CartItemCell: UITableViewCell {

    @IBOutlet weak var checkBTN: UIButton!
    @IBOutlet weak var productIMG: UIImageViewX!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var shippingTF: UITextField!
    @IBOutlet weak var qtyLBL: UILabel!
    @IBOutlet weak var skuLBL: UILabel!
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var attributeCV: UICollectionView!
    @IBOutlet weak var collectionHeightCON: NSLayoutConstraint!
    @IBOutlet weak var productImageLeadingCON: NSLayoutConstraint!
    
    var shippingARY :[Shipping]?
    var attributeARY : [Value]?
    var qtyChange: ((Bool) -> Void)?
    var shippingChange: ((Int) -> Void)?
    let pickerView = UIPickerView()
    var productSelectChange: ((Bool) -> Void)?
    var removeItem: (() -> Void)?
    var cellExpand: (() -> Void)?
    
    public struct Identifiers {
        static let kCartAttributeCVCell = "CartAttributeCVCell"
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Configurecollection()
        pickerView.delegate = self
        pickerView.dataSource = self
        shippingTF.inputView = pickerView
        shippingTF.tintColor = .clear
        
    }
    func Configurecollection(){
        
        attributeCV.delegate = self
        attributeCV.dataSource = self
        attributeCV.register(UINib(nibName: Identifiers.kCartAttributeCVCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kCartAttributeCVCell)
        if let flowLayout = attributeCV.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    func heightCalculate(){
//        if attributeARY?.count ?? 0 > 0{
//            let value = ((attributeARY?.count ?? 0) % 2)
//            var totalRow = 0
//            if value == 1{
//                totalRow = ((attributeARY?.count ?? 0) + 1) / 2
//            }else{
//                totalRow = (attributeARY?.count ?? 0) / 2
//            }
//            collectionHeightCON.constant = CGFloat((25 * totalRow))
//        }else{
//            collectionHeightCON.constant = 0
//        }
        
        let cvWidth = (UIScreen.main.bounds.size.width - 143)
        if let attARY = attributeARY{
            var rowCount = 1
            var itemWidth: Double = 10
            for i in 0..<attARY.count{
                let name = "\(attributeARY?[i].attributeName ?? "") :"
                let valuse = " \(attARY[i].name ?? "")"
                
                let nameWidth = getTextWidth(text: name, font: .systemFont(ofSize: 13))
                let valueWidth = getTextWidth(text: valuse, font: .systemFont(ofSize: 13))
                
                let nametempwidth = Double(nameWidth + valueWidth)
                
                itemWidth = itemWidth + nametempwidth + 10
                
                if itemWidth > cvWidth{
                    rowCount = rowCount + 1
                    itemWidth = 10
                }
            }
            
            self.collectionHeightCON.constant = Double(rowCount * 25)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func checkClick_Action(_ sender: UIButton) {
        if checkBTN.currentImage == UIImage(named: "check-box-empty"){
            if let action = productSelectChange{
                action(true)
            }
        }else{
            if let action = productSelectChange{
                action(false)
            }
        }
        
    }
    @IBAction func minusClick_Action(_ sender: UIButton) {
        if let action = qtyChange {
            action(false)
        }
    }
    @IBAction func plusClick_Action(_ sender: UIButton) {
        if let action = qtyChange {
            action(true)
        }
    }
    @IBAction func removeClick_Action(_ sender: UIButton) {
        if let action = removeItem{
            action()
        }
    }
    @IBAction func drowDownClick_Action(_ sender: UIButton) {
        if let action = cellExpand{
            action()
        }
    }
}
extension CartItemCell  : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            // Return the number of rows in the picker
            return shippingARY?.count ?? 0
        }
        
        // MARK: - UIPickerViewDelegate
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            // Return the title for each row in the picker
            let shippingName = shippingARY?[row].name
            let price = shippingARY?[row].price ?? 0
            return "\(shippingName!) - $\(price)"
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let shippingName = shippingARY?[row].name
            let price = shippingARY?[row].price ?? 0
            shippingTF.text = "\(shippingName!) - $\(price)"
            
            if let action = shippingChange{
                action(row)
            }
        }
        
        // MARK: - UITextFieldDelegate
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // Perform any additional actions when the text field begins editing
        }
}
extension CartItemCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attributeARY?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = attributeCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kCartAttributeCVCell, for: indexPath) as! CartAttributeCVCell
        cell.nameLBL.text = "\(attributeARY?[indexPath.row].attributeName ?? "") :"
        cell.valueLBL.text = " \(attributeARY?[indexPath.row].name ?? "")"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let name = "\(attributeARY?[indexPath.row].attributeName ?? "") :"
        let valuse = " \(attributeARY?[indexPath.row].name ?? "")"
        
        let nameWidth = getTextWidth(text: name, font: .systemFont(ofSize: 13))
        let valueWidth = getTextWidth(text: valuse, font: .systemFont(ofSize: 13))
        let itemHeight = 20
        let nametempwidth = Double(nameWidth + valueWidth)
        return CGSize(width: nametempwidth, height: Double(itemHeight))
    }
    
    func getTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = NSString(string: text).size(withAttributes: attributes)
        return ceil(textSize.width)
    }
    
    
}
