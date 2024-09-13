//
//  MovieTBLCell.swift
//  ExampleApp
//
//  Created by Parth on 26/04/24.
//

import UIKit
import SDWebImage
import TouchEPlugin
class MovieTBLCell: UITableViewCell {

    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var movieListCV: UICollectionView!
    
    
    var MovieClick : ((_ dic:HomeListModel)-> Void)?
    
    public struct Identifiers {
        static let kCategoryCVCell = "CategoryCVCell" 
    }
    
    var VideoList : HomeData?
    override func awakeFromNib() {
        super.awakeFromNib()
        Configurecollection ()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func Configurecollection(){
        movieListCV.delegate = self
        movieListCV.dataSource = self
        movieListCV.register(UINib(nibName: Identifiers.kCategoryCVCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.kCategoryCVCell)
    }
}
extension MovieTBLCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  VideoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieListCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kCategoryCVCell, for: indexPath) as! CategoryCVCell
        let Dic = VideoList?[indexPath.row]
        let image = Dic?.images?.first?.url ?? ""
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            cell.imagIV.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            cell.imagIV.contentMode = .scaleAspectFill
            cell.imagIV.layer.cornerRadius = 4
        } else {
            print("Failed to encode URL string")
        }
        cell.titleLBL.text = ""//Dic?.name ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let action = MovieClick {
            if let videoItem = VideoList?[indexPath.row] {
                action(videoItem)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: movieListCV.layer.bounds.height / 1.5 , height: movieListCV.layer.bounds.height)
    }
    
    
    
}
