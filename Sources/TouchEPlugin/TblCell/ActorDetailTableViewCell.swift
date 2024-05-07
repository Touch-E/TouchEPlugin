//
//  ActorDetailTableViewCell.swift
//  Touch E Demo
//
//  Created by Kishan on 30/01/24.
//

import UIKit

 class ActorDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblGenre: UILabelX!
    @IBOutlet weak var lblYear: UILabelX!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblMoviewInfo: UILabel!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cvImageLIst: UICollectionView!
    @IBOutlet weak var readMoreUV: UIView!
    @IBOutlet weak var ageUV: UIView!
    @IBOutlet weak var heightUV: UIView!
    @IBOutlet weak var generCV: UICollectionView!
     var readMoreTapped: (() -> Void)?
     var index = -1
     var imageArr : [Image]?
     var gebneArr : [Genre]?
     var imageClick : (()-> Void)?
     var yearTxt = ""
     public struct Identifiers {
         static let kActorimageCollectionViewCell = "ActorimageCollectionViewCell"
         static let kGenresTBLCell = "GenresTBLCell"
         
     }
     
     override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
         Configurecollection()
     }
     
     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
         
         // Configure the view for the selected state
     }
     override func layoutSubviews() {
         cvImageLIst.layoutIfNeeded()
         cvImageLIst.layoutSubviews()
         //        vcCategoryHeight.constant = cvCategory.layer.bounds.width  / 2 + 44
     }
     @IBAction func readMoreClick(_ sender: Any) {
             readMoreTapped?()
     }
     func configure(with content: String, isExpanded: Bool) {
         lblDesc.text = content
         //readMoreButton.isHidden = isExpanded
     }
     func Configurecollection(){
         cvImageLIst.delegate = self
         cvImageLIst.dataSource = self
//         cvImageLIst.register(UINib(nibName: Identifiers.kActorimageCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.kActorimageCollectionViewCell)
         cvImageLIst.register(UINib(nibName: Identifiers.kActorimageCollectionViewCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kActorimageCollectionViewCell)
         pageControl.numberOfPages = imageArr?.count ?? 0
         
         generCV.delegate = self
         generCV.dataSource = self
         generCV.register(UINib(nibName: Identifiers.kGenresTBLCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kGenresTBLCell)
         
     }
     
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let visibleRect = CGRect(origin: cvImageLIst.contentOffset, size: cvImageLIst.bounds.size)
         let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
         let visibleIndexPath = cvImageLIst.indexPathForItem(at: visiblePoint)
         print(visibleIndexPath?.row ?? "")
         index = visibleIndexPath?.row ?? (5)
         updateButtonStatus()
         
     }
     func updateButtonStatus(){
         pageControl.currentPage = index
         
     }
     
 }

 extension ActorDetailTableViewCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == cvImageLIst{
             return imageArr?.count ?? 0
         }else{
             return  gebneArr?.count ?? 0 > 0 ? (gebneArr?.count ?? 0) + 1 : 0
         }
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == cvImageLIst{
         let cell = cvImageLIst.dequeueReusableCell(withReuseIdentifier: Identifiers.kActorimageCollectionViewCell, for: indexPath) as! ActorimageCollectionViewCell
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
         }else{
             let cell = generCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kGenresTBLCell, for: indexPath) as! GenresTBLCell
             if indexPath.row == 0{
                 cell.titleLBL.text = yearTxt
             }else{
                 cell.titleLBL.text = gebneArr?[indexPath.row - 1].rawValue ?? ""
             }
             return cell
         }
     }
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == cvImageLIst{
             if let action = imageClick {
                 action()
             }
         }else{
             
         }
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == cvImageLIst{
             return CGSize(width: cvImageLIst.layer.bounds.width , height: cvImageLIst.layer.bounds.height)
         }else{
             return CGSize(width: 70 , height: 25)
         }
     }
 }
