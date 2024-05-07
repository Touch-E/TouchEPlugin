//
//  VideoDetailViewController.swift
//  Touch E Demo
//
//  Created by Kishan on 31/01/24.
//

import UIKit

public class VideoDetailViewController: UIViewController {
    
    
    static func storyboardInstance() -> VideoDetailViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
    }
    
    @IBOutlet weak var tblList: UITableView!
    
    public var VideoListData : HomeListModel?
    var isCellExpanded = false
    public struct Identifiers {
        static let kActorDetailTableViewCell = "ActorDetailTableViewCell"
        static let kCategoriesTableViewCell = "CategoriesTableViewCell"
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = Bundle.module.loadNibNamed("VideoDetailViewController", owner: self, options: nil)?.first as? UIView {
            self.view = view
        }
        
        projectID = "\(VideoListData?.id ?? 0)"
        ConfigureTableView()
    }
    
    func ConfigureTableView(){
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.register(UINib(nibName: Identifiers.kActorDetailTableViewCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kActorDetailTableViewCell)
        tblList.register(UINib(nibName: Identifiers.kCategoriesTableViewCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kCategoriesTableViewCell)
    }
    
    @IBAction func btnDismissClick(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Check for changes in size class or traits
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass ||
            traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            self.view.layoutIfNeeded()
            self.tblList.layoutIfNeeded()
            self.tblList.reloadData()
            
            // Update constraints or perform layout changes based on the new size class
           // updateConstraintsForSizeClass()
        }
    }
    @IBAction func playClick_Action(_ sender: UIButton) {
        let viewcontroller = VideoViewController()//mainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        viewcontroller.VideoString = self.VideoListData?.videoURL ?? ""
        viewcontroller.VideoListDic = self.VideoListData
        viewcontroller.brandID = "\(self.VideoListData?.brands?[0].id ?? 0)"
        viewcontroller.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        //self.present(viewcontroller, animated: true, completion: nil)
    }
    
}

extension VideoDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kActorDetailTableViewCell, for: indexPath) as! ActorDetailTableViewCell
            
            cell.lblDesc.text = VideoListData?.info ?? ""
            
            let maxSize = CGSize(width: cell.lblDesc.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            let labelSize = (cell.lblDesc.text! as NSString).boundingRect(with: maxSize,
                                                                     options: .usesLineFragmentOrigin,
                                                                     attributes: [NSAttributedString.Key.font: cell.lblDesc.font],
                                                                     context: nil).size
            let textHeight = ceil(labelSize.height)
            
            
            cell.readMoreUV.isHidden = textHeight < 20 ? true : false
            cell.lblGenre.text = VideoListData?.genres?.first?.rawValue ?? ""
            cell.lblYear.text = "\(VideoListData?.year ?? 0)"
            cell.yearTxt = "\(VideoListData?.year ?? 0)"
            
            cell.lblGenre.isHidden = true
            cell.lblYear.isHidden = true
            cell.gebneArr = VideoListData?.genres
            cell.lblMoviewInfo.text = VideoListData?.type ?? ""
            cell.lblMovieTitle.text = VideoListData?.name ?? ""
            cell.pageControl.numberOfPages = VideoListData?.images?.count ?? 0
            cell.imageArr = VideoListData?.images
            cell.cvImageLIst.reloadData()
            
            cell.readMoreTapped = { [weak self] in
                self?.isCellExpanded.toggle()
                self?.tblList.beginUpdates()
                //self?.tblList.reloadRows(at: [indexPath], with: .none)
                self?.tblList.endUpdates()
                self?.tblList.reloadData()
                
            }
            
            return cell
        }else if indexPath.row == 1{
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kCategoriesTableViewCell, for: indexPath) as! CategoriesTableViewCell
            if VideoListData?.actors?.count ?? 0 > 0{
                cell.VideoDetail = VideoListData
                cell.isVideoDetail = true
                cell.index = indexPath.row
                cell.userARY = VideoListData?.actors
                let title = "Actors"
                let count = VideoListData?.actors?.count ?? 0
                cell.lblVideoCount.text = "\(title) (\(count))"
                cell.cvCategory.reloadData()
                
                cell.ActorClick = { (actorID) -> Void in
                    let viewcontroller = ActorDetailsVC.storyboardInstance()
                    viewcontroller.modalPresentationStyle = .custom
                    viewcontroller.actorID = "\(actorID)"
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                }
            }
            
            return cell
            
        }else if indexPath.row == 2{
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kCategoriesTableViewCell, for: indexPath) as! CategoriesTableViewCell
            if VideoListData?.directors?.count ?? 0 > 0{
                cell.VideoDetail = VideoListData
                cell.isVideoDetail = true
                cell.index = indexPath.row
                cell.userARY = VideoListData?.directors
                let title = "Directores"
                let count = VideoListData?.directors?.count ?? 0
                cell.lblVideoCount.text = "\(title) (\(count))"
                cell.cvCategory.reloadData()
                
                cell.ActorClick = { (actorID) -> Void in
                    let viewcontroller = ActorDetailsVC.storyboardInstance()
                    viewcontroller.modalPresentationStyle = .custom
                    viewcontroller.actorID = "\(actorID)"
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                }
            }
            return cell
        }else if indexPath.row == 3{
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kCategoriesTableViewCell, for: indexPath) as! CategoriesTableViewCell
            if VideoListData?.producers?.count ?? 0 > 0{
                cell.VideoDetail = VideoListData
                cell.isVideoDetail = true
                cell.index = indexPath.row
                cell.userARY = VideoListData?.producers
                let title = "Producers"
                let count = VideoListData?.producers?.count ?? 0
                cell.lblVideoCount.text = "\(title) (\(count))"
                cell.cvCategory.reloadData()
                
                cell.ActorClick = { (actorID) -> Void in
                    let viewcontroller = ActorDetailsVC.storyboardInstance()
                    viewcontroller.modalPresentationStyle = .custom
                    viewcontroller.actorID = "\(actorID)"
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                }
            }
            return cell
        }else {
            
            let cell = tblList.dequeueReusableCell(withIdentifier: Identifiers.kCategoriesTableViewCell, for: indexPath) as! CategoriesTableViewCell
            cell.VideoDetail = VideoListData
            cell.isVideoDetail = true
            cell.index = indexPath.row
            let title = "Brands"
            cell.brandARY = VideoListData?.brands
            let count = VideoListData?.brands?.count ?? 0
            cell.lblVideoCount.text = "\(title) (\(count))"
            cell.cvCategory.reloadData()
            
            cell.brandClick = { (actorID) -> Void in
                let viewcontroller = BrandDetailsVC.storyboardInstance()
                viewcontroller.modalPresentationStyle = .custom
                viewcontroller.brandID = "\(actorID)"
                //self.present(viewcontroller, animated: true, completion: nil)
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            
            return cell
        }
        
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return isCellExpanded ? UITableView.automaticDimension : 250
        }else if indexPath.row == 1{
            if VideoListData?.actors?.count ?? 0 > 0{
                return 200
            }
            return 0
            
        }else if indexPath.row == 2{
            if VideoListData?.directors?.count ?? 0 > 0{
                return 200
            }
            return 0
        }else if indexPath.row == 3{
            if VideoListData?.producers?.count ?? 0 > 0{
                return 200
            }
            return 0
        }else {
            return 200
        }
        
    }
    
}
class SemiTransparentPresentationController: UIPresentationController {
    private var backgroundView: UIView!
    
    override func presentationTransitionWillBegin() {
        // Add a background view with a light gray color
        backgroundView = UIView(frame: containerView?.bounds ?? .zero)
        backgroundView.backgroundColor = UIColor(white: 0.8, alpha: 0.5) // Light gray with 50% opacity
        containerView?.insertSubview(backgroundView, at: 0)
        
        // Fade in the background view
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.backgroundView.alpha = 1.0
            }, completion: nil)
        } else {
            backgroundView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // Fade out the background view during dismissal
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.backgroundView.alpha = 0.0
            }, completion: nil)
        } else {
            backgroundView.alpha = 0.0
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.bounds ?? .zero
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView?.bounds ?? .zero
    }
}


class SemiTransparentTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SemiTransparentPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransparentAnimatedTransitioning(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransparentAnimatedTransitioning(isPresenting: false)
    }
}

class TransparentAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        if isPresenting {
            containerView.addSubview(toView)
            toView.alpha = 0.0
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = self.isPresenting ? 1.0 : 0.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
