//
//  SelectedFilterCell.swift
//  
//
//  Created by Jaydip Godhani on 15/04/24.
//

import UIKit

class SelectedFilterCell: UICollectionViewCell {

    @IBOutlet weak var backUV: UIViewX!
    @IBOutlet weak var itemNameLBL: UILabel!
    var closeAction : (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func closeClick_Action(_ sender: UIButton) {
        if let action = closeAction{
            action()
        }
    }
}
