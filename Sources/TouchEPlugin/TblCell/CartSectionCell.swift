//
//  CartSectionCell.swift
//  Touch E Demo
//
//  Created by Kishan on 08/02/24.
//

import UIKit

class CartSectionCell: UITableViewCell {

    @IBOutlet weak var checkBTN: UIButton!
    @IBOutlet weak var brandNameLBL: UILabel!
    @IBOutlet weak var backUV: UIView!
    var brandSelectChange: ((Bool) -> Void)?
    @IBOutlet weak var brandNameLeftCON: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backUV.layer.cornerRadius = 10
        backUV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func checkClick_Action(_ sender: UIButton) {
        if checkBTN.currentImage == UIImage(named: "check-box-empty"){
            if let action = brandSelectChange{
                action(true)
            }
        }else{
            if let action = brandSelectChange{
                action(false)
            }
        }
    }
    
}
