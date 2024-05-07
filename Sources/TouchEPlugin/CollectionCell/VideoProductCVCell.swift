//
//  VideoProductCVCell.swift
//  Touch E Demo
//
//  Created by Parth on 01/03/24.
//

import UIKit

class VideoProductCVCell: UICollectionViewCell {

    @IBOutlet weak var backUV: UIViewX!
    @IBOutlet weak var productImageIMG: UIImageViewX!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var countLBL: UILabelX!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countLBL.clipsToBounds = true
    }

}
