//
//  RecentMovieCell.swift
//  Touch E Demo
//
//  Created by Parth on 19/02/24.
//

import UIKit
import FSPagerView
import SDWebImage
class RecentMovieCell: UITableViewCell {
    
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var pagerControlerPC: UIPageControl!
    @IBOutlet weak var pagerView: FSPagerView!
    
    var VideoList : HomeData?
    var MovieClick : ((_ dic:HomeListModel)-> Void)?
    var ActorClick : ((_ id : Int)-> Void)?
    var brandClick : ((_ id : Int)-> Void)?
    var videoClick : ((_ dic:HomeListModel)-> Void)?
    var index = 0
    var VideoDetail : HomeListModel?
    var actorDetail : [ProjectsCted1]?
    var userARY : [Actor]?
    
    var isVideoDetail = false
    var isActorDetails = false
    

    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    public struct Identifiers {
        static let kMovieItemCVCell = "MovieItemCVCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Configurecollection()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        
    }
    
    func Configurecollection(){

        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.pagerView.transformer = FSPagerViewTransformer(type:.linear)
        self.pagerView.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 266)//self.pagerView.frame.size.applying(transform)  200 width 266 height
        self.pagerView.decelerationDistance = FSPagerView.automaticDistance
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
    }

}

extension RecentMovieCell : FSPagerViewDataSource,FSPagerViewDelegate {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return VideoList?.count ?? 0
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let Dic = VideoList?[index]
        let image = Dic?.images?.first?.url ?? ""
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            cell.imageView?.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.layer.cornerRadius = 8
            cell.imageView?.clipsToBounds = true
         } else {
            print("Failed to encode URL string")
        }
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        if let action = videoClick{
            if let videoItem = VideoList?[index] {
                action(videoItem)
            }
        }
        
    }
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        self.pagerControlerPC.currentPage = pagerView.currentIndex
    }
    
}
