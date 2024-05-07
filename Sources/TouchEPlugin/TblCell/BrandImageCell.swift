//
//  BrandImageCell.swift
//  Touch E Demo
//
//  Created by Parth on 14/02/24.
//

import UIKit
import Cosmos
class BrandImageCell: UITableViewCell {

    @IBOutlet weak var brandNameLBL: UILabel!
    @IBOutlet weak var brandRating: CosmosView!
    @IBOutlet weak var reviewLBL: UILabel!
    @IBOutlet weak var desLBL: UILabel!
    @IBOutlet weak var brandImgCV: UICollectionView!
    @IBOutlet weak var pageCV: UIPageControl!
    @IBOutlet weak var readMoreUV: UIView!
    
    var imageArr : [Image]?
    var index = -1
    var readMoreTapped: (() -> Void)?
    
    public struct Identifiers {
        static let kActorimageCollectionViewCell = "ActorimageCollectionViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Configurecollection()
    }
    override func layoutSubviews() {
        brandImgCV.layoutIfNeeded()
        brandImgCV.layoutSubviews()
        //        vcCategoryHeight.constant = cvCategory.layer.bounds.width  / 2 + 44
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func Configurecollection(){
        brandImgCV.delegate = self
        brandImgCV.dataSource = self
        brandImgCV.register(UINib(nibName: Identifiers.kActorimageCollectionViewCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kActorimageCollectionViewCell)
        pageCV.numberOfPages = imageArr?.count ?? 0
        
    }
    @IBAction func readMoreClick_Action(_ sender: Any) {
        readMoreTapped?()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: brandImgCV.contentOffset, size: brandImgCV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = brandImgCV.indexPathForItem(at: visiblePoint)
        print(visibleIndexPath?.row ?? "")
        index = visibleIndexPath?.row ?? (5)
        updateButtonStatus()
        
    }
    func updateButtonStatus(){
        pageCV.currentPage = index
        
    }
    
}
extension BrandImageCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = brandImgCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kActorimageCollectionViewCell, for: indexPath) as! ActorimageCollectionViewCell
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
        return CGSize(width: brandImgCV.layer.bounds.width , height: brandImgCV.layer.bounds.height)
    }
    
    
    
}
