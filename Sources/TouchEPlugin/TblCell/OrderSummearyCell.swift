//
//  OrderSummearyCell.swift
//  Touch E Demo
//
//  Created by Kishan on 08/02/24.
//
import UIKit

class OrderSummearyCell: UITableViewCell {

    
    @IBOutlet weak var backUV: UIViewX!
    @IBOutlet weak var productCoseLBL: UILabel!
    @IBOutlet weak var shippingCoseLBL: UILabel!
    @IBOutlet weak var totalCostLBL: UILabel!
    @IBOutlet weak var itemCountLBL: UILabel!
    @IBOutlet weak var proceedBTN: UIButtonX!
    
    var proceesButtonClike: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnProceedTap(_ sender: Any) {
        if let action = proceesButtonClike{
            action()
        }
    }
}
