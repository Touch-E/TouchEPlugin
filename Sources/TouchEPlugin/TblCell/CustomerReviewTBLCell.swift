//
//  CustomerReview.swift
//  Touch E Demo
//
//  Created by Kishan on 07/02/24.
//

import UIKit

class CustomerReviewTBLCell: UITableViewCell {

    @IBOutlet weak var reviewCountLBL: UILabel!
    @IBOutlet weak var reviewCV: UICollectionView!
    @IBOutlet weak var sepreatLineUV: UIView!
    
    var reviewARY : [Review]?
    public struct Identifiers {
        static let kcustomerReviewCVCell = "customerReviewCVCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Configurecollection()
    }
    func Configurecollection(){
        reviewCV.delegate = self
        reviewCV.dataSource = self
        reviewCV.register(UINib(nibName: Identifiers.kcustomerReviewCVCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kcustomerReviewCVCell)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension CustomerReviewTBLCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewARY?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reviewCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kcustomerReviewCVCell, for: indexPath) as! customerReviewCVCell
        cell.ratingCountLBL.text = "\(reviewARY?[indexPath.row].rating ?? 0)"
        cell.ratingUV.rating = Double(reviewARY?[indexPath.row].rating ?? 0)
        cell.nameLBL.text = reviewARY?[indexPath.row].userName ?? ""
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let action = imageClick {
//            action()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 210 , height: 80)
    }
    
    
    
}
