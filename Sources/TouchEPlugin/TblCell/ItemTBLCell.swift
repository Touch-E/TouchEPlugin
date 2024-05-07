//
//  ItemTBLCell.swift
//  
//
//  Created by Jaydip Godhani on 16/04/24.
//

import UIKit

class ItemTBLCell: UITableViewCell {

    @IBOutlet weak var itemIMG: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
