//
//  OrderCell.swift
//  Touch E Demo
//
//  Created by Parth on 23/02/24.
//

import UIKit

class OrderCell: UITableViewCell {

    var orderAction : (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func orderClick_Action(_ sender: UIButton) {
        if let action = orderAction{
            action()
        }
    }
    
}
