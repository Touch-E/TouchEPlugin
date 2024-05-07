//
//  OrderListCell.swift
//  
//
//  Created by Jaydip Godhani on 16/04/24.
//

import UIKit

class OrderListCell: UITableViewCell {

    @IBOutlet weak var orderNOLBL: UILabel!
    @IBOutlet weak var orderDateLBL: UILabel!
    @IBOutlet weak var totalPurchaseLBL: UILabel!
    var cellViewButton : (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    @IBAction func viewClick_Action(_ sender: UIButton) {
//        if let action = cellViewButton{
//           action()
//       }
//    }
    
}
