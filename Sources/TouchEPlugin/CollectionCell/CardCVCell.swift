//
//  CardCVCell.swift
//  Touch E Demo
//
//  Created by Parth on 22/02/24.
//

import UIKit

class CardCVCell: UICollectionViewCell {

    @IBOutlet weak var sepraterLineUV: UIView!
    @IBOutlet weak var topTitleLBL: UILabel!
    @IBOutlet weak var makeDefaultUV: UIView!
    @IBOutlet weak var deleteTitleLBL: UILabel!
    @IBOutlet weak var cardNumberLBL: UILabel!
    @IBOutlet weak var expLBL: UILabel!
    var deleteCardAction:(() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func deleteCradClick_Action(_ sender: UIButton) {
        if let action = deleteCardAction{
            action()
        }
    }
    
}
