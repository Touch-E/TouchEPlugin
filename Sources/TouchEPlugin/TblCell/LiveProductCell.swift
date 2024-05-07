//
//  LiveProductCell.swift
//  Viou-iOS
//
//  Created by Mac on 24/05/22.
//

import UIKit

public class LiveProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension LiveProductCell {
    func configureCell(_ data : Actor) {
      
        priceLabel.text = data.name ?? ""
        let placeholderImage = UIImage(named: "placeholdeImgWhite")!
        if data.images?.first?.url != "" {
            let url = URL(string: data.images?.first?.url ?? "")!
            productImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }else {
            productImageView.image = UIImage(named: "")
        }
    }
}
