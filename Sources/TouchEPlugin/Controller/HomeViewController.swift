//
//  HomeViewController.swift
//  
//
//  Created by Jaydip Godhani on 16/04/24.
//

import UIKit
import SDWebImage
import AVKit

public class HomeViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    var VideoListData : HomeData?

    @IBOutlet weak var cvVideoCollection: UICollectionView!
    var playerViewController: AVPlayerViewController?
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
          return .portrait
      }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
      setupCollection()
        cvVideoCollection.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func setupCollection(){
     
       
        cvVideoCollection.register(UINib(nibName: "VideoListCVCell", bundle: Bundle.module), forCellWithReuseIdentifier: "VideoListCVCell")
        cvVideoCollection.delegate = self
        cvVideoCollection.dataSource = self
      
    }
    

    public override func viewDidDisappear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }

}



extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VideoListData?.count ?? 0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvVideoCollection.dequeueReusableCell(withReuseIdentifier: "VideoListCVCell", for: indexPath) as! VideoListCVCell
        
        let Dic = VideoListData?[indexPath.row]
        let image = Dic?.images?.first?.url ?? ""
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // Use the encoded URL string
            print(encodedUrlString)
            cell.imgVideo.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
           
        } else {
            // Handle the case where encoding fails
            print("Failed to encode URL string")
        }
        cell.lblTitle.text = Dic?.name ?? ""
//        }

        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cvVideoCollection.bounds.width / 3, height: cvVideoCollection.bounds.width / 2)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewcontroller = mainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        viewcontroller.VideoString = VideoListData?[indexPath.row].videoURL ?? ""
        viewcontroller.VideoListDic = VideoListData?[indexPath.row]
        viewcontroller.modalPresentationStyle = .overFullScreen
//        self.navigationController?.pushViewController(viewcontroller, animated: true)
        self.present(viewcontroller, animated: true, completion: nil)
        
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
         print("Video Finished")
        let orientation = UIInterfaceOrientationMask.portrait
           UIViewController.attemptRotationToDeviceOrientation()
           UIDevice.current.setValue(1, forKey: "orientation")
         //        wait for load splash video for time
         DispatchQueue.main.asyncAfter(deadline: .now()+1) {
             //navigate to home when video finished
             
             self.dismiss(animated: true, completion: nil)
         }
     }
    func playerViewControllerDidDismiss(_ playerViewController: AVPlayerViewController) {
            // This method is called when the player view is dismissed
            print("Player view dismissed")
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")

            // Add your custom action here
        }
}


class LandscapeAVPlayerViewController: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}
