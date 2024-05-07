//
//  ProductImageDetailsCell.swift
//  Touch E Demo
//
//  Created by Kishan on 07/02/24.
//

import UIKit
import Cosmos
class ProductImageDetailsCell: UITableViewCell {

    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var brandNameLBL: UILabel!
    @IBOutlet weak var totalReviewLBL: UILabelX!
    @IBOutlet weak var ratingLBL: UILabelX!
    @IBOutlet weak var skuLBL: UILabel!
    @IBOutlet weak var productIMGCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var descriptionLBL: UILabel!
    @IBOutlet weak var readMoreUV: UIView!
    @IBOutlet weak var ratingUV: CosmosView!
    var imageArr : [Image]?
    var index = -1
    var readMoreTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Configurecollection()
    }
    override func layoutSubviews() {
        productIMGCV.layoutIfNeeded()
        productIMGCV.layoutSubviews()
        //        vcCategoryHeight.constant = cvCategory.layer.bounds.width  / 2 + 44
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public struct Identifiers {
        static let kActorimageCollectionViewCell = "ActorimageCollectionViewCell"
    }
    @IBAction func readMoreClick(_ sender: Any) {
            readMoreTapped?()
    }
    func Configurecollection(){
        productIMGCV.delegate = self
        productIMGCV.dataSource = self
        productIMGCV.register(UINib(nibName: Identifiers.kActorimageCollectionViewCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kActorimageCollectionViewCell)
        pageControl.numberOfPages = imageArr?.count ?? 0
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: productIMGCV.contentOffset, size: productIMGCV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = productIMGCV.indexPathForItem(at: visiblePoint)
        print(visibleIndexPath?.row ?? "")
        index = visibleIndexPath?.row ?? (5)
        updateButtonStatus()
        
    }
    func updateButtonStatus(){
        pageControl.currentPage = index
    }
}
extension ProductImageDetailsCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productIMGCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kActorimageCollectionViewCell, for: indexPath) as! ActorimageCollectionViewCell
        let Dic = imageArr?[indexPath.row]
        let image = Dic?.url ?? ""
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // Use the encoded URL string
            print(encodedUrlString)
            cell.imgActor.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            cell.imgActor.contentMode = .scaleAspectFill
        } else {
            // Handle the case where encoding fails
            print("Failed to encode URL string")
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let action = imageClick {
//            action()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productIMGCV.layer.bounds.width , height: productIMGCV.layer.bounds.height)
    }
    
    
    
}
