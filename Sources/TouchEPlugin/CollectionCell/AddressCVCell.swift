//
//  AddressCVCell.swift
//  Touch E Demo
//
//  Created by Parth on 21/02/24.
//

import UIKit

class AddressCVCell: UICollectionViewCell {

    
    @IBOutlet weak var primaryAdsLBL: UILabel!
    @IBOutlet weak var sepraterLineUV: UIView!
    
    @IBOutlet weak var addressTypeLBL: UILabel!
    @IBOutlet weak var sAddressLBL: UILabel!
    @IBOutlet weak var sZipCodeLBL: UILabel!
    @IBOutlet weak var sCityLBL: UILabel!
    @IBOutlet weak var sCountryLBL: UILabel!
    
    @IBOutlet weak var baddressLBL: UILabel!
    @IBOutlet weak var bZipCodeLBL: UILabel!
    @IBOutlet weak var bCityLBL: UILabel!
    @IBOutlet weak var bCountryLBL: UILabel!
    
    @IBOutlet weak var primaryUV: UIView!
    @IBOutlet weak var onlyPrimaryUV: UIView!
    @IBOutlet weak var makePrimaryUV: UIView!
    @IBOutlet weak var deleteBTN: UIButton!
    @IBOutlet weak var selectionIMG: UIImageView!
    var makePrimaryAction:(() -> Void)?
    var deleteClickAction:(() -> Void)?
    var editClickAction:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func makePrimaryClick_Action(_ sender: UIButton) {
        if let action = makePrimaryAction{
            action()
        }
    }
    @IBAction func deleteClick_Action(_ sender: UIButton) {
        if let action = deleteClickAction{
            action()
        }
    }
    @IBAction func editClick_Action(_ sender: UIButton) {
        if let action = editClickAction{
            action()
        }
    }
    
}
