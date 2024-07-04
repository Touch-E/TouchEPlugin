//
//  VideoViewController.swift
//  Touch E Demo
//
//  Created by Kishan on 29/01/24.
//

import UIKit
import AVKit
import Alamofire
import AVFoundation


class VideoViewController: UIViewController {
    
    var VideoString = ""
    var VideoListDic : HomeListModel?
    var VideoData : VideoDataModel?
    var ProductVideoData : ProductVideoModel?
    var mappingData : MappingDataModel?
    var player:AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerItem:AVPlayerItem?
    var sliderDragToPlayPause = false
    var isShown = false
    var LiveTBLStaticHeight = CGFloat(0.0)
    var ind = 0
    var isFirst = true
    var timer: Timer?
    var elapsedTime: TimeInterval = 0.0
    var CTTime = CMTime()
    var productIDArray = [Int]()
    var RRect : CGRect?
    var brandID = ""
    var prodcutARY = [Product]()
    var prodcutARYForCheck = [Product]()
    var tempARY = [String]()
    var currentVideoTime : Double = 0.0
    var videoTouchPoint = CGPoint()
    var filterEventData = [String? : [Event]]()
    var cartData : CartData?
    var currentVolumeValue:Float = 0.0
    var dispatchWorkItem: DispatchWorkItem?
    var acdispatchWorkItem: DispatchWorkItem?
    var productData : Product?
    var draggedCell: UICollectionViewCell?
    var initialIndexPath: IndexPath?
    var dragPlaceholderView: UIView?
    
    
    public struct Identifiers {
        static let kVideoProductCVCell = "VideoProductCVCell"
    }
    var IsActor = false
    var currentItemId = ""
    var isVideoCompeted = false
    
    @IBOutlet weak var VovimageView: UIImageViewX!
    @IBOutlet weak var vovBTN: UIButton!
    //@IBOutlet weak var productsShowCloseIMGView: UIImageView!
    @IBOutlet weak var productCV: UICollectionView!
    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var lblOverallDuration: UILabel!
    @IBOutlet weak var viewBgSeekBar: UIView!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var lblcurrentText: UILabel!
    @IBOutlet weak var backgroundVideoContainer: UIView!
    @IBOutlet weak var cloaseUV: UIView!
    @IBOutlet weak var safeArayUV: UIView!
    @IBOutlet weak var cartCountBTN: UIButtonX!
    @IBOutlet weak var userProfileIMG: UIImageViewX!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeUV: UIViewX!
    @IBOutlet weak var videoTitleLB: UILabel!
    @IBOutlet weak var cartBackUV: UIView!
    @IBOutlet weak var addtoCartBackUV: UIView!
    @IBOutlet weak var bigCartIMG: UIImageViewX!
    @IBOutlet weak var bigCartCountBTN: UIButtonX!
    @IBOutlet weak var addToCartMessageLBL: UILabel!
    
    
    var smallVideoUV: UIView!
    var originalFrame: CGRect!
    var splayer:AVPlayer?
    var splayerLayer: AVPlayerLayer?
    var playerViewController: AVPlayerViewController!
    var smallVideoString = ""
    
    override func viewDidLoad() {
        
        if let view = Bundle.module.loadNibNamed("VideoViewController", owner: self, options: nil)?.first as? UIView {
            self.view = view
        }
        super.viewDidLoad()
        view.layoutIfNeeded()
        VovimageView.isHidden = true
        volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        productCV.addGestureRecognizer(longPressGesture)
        
        cloaseUV.isHidden = false
        viewBgSeekBar.isHidden = false
        safeArayUV.isHidden = false
        addtoCartBackUV.isHidden = true
        scheduleDispatch(after: 8)
      
        smallVideoUV = UIView(frame: CGRect(x: view.frame.size.width - 200, y: 40, width: 150, height: 100))
        smallVideoUV.backgroundColor = .black
        smallVideoUV.layer.cornerRadius = 10
        smallVideoUV.layer.borderColor = UIColor.white.cgColor
        smallVideoUV.layer.borderWidth = 1
        smallVideoUV.clipsToBounds = true
        
        
        view.addSubview(smallVideoUV)
        originalFrame = smallVideoUV.frame
        smallVideoUV.isHidden = true
        
        DispatchQueue.main.async {
            
            var image = ""
            image = profileData.value(forKey: "imageUrl") as? String ?? ""
            if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                self.userProfileIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
                self.userProfileIMG.contentMode = .scaleAspectFill
            }
            self.videoTitleLB.text = self.VideoListDic?.name ?? ""
            self.GetVideoDetail(id: "\(self.VideoListDic?.id ?? 0)")
            self.GetEntitiesDetail(id: "\(self.VideoListDic?.id ?? 0)")
            self.start_loading()
            self.pastVideoPlayer()
            self.centerPlayerLayer()
            self.Configurecollection()
            self.GetCartDetail()
            //self.smallVideoPlayer()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = self.backgroundVideoContainer.bounds
        splayerLayer?.frame = self.smallVideoUV.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cloaseUV.isHidden = false
        viewBgSeekBar.isHidden = false
        safeArayUV.isHidden = false
        scheduleDispatch(after: 4)
        
        if let status = player?.timeControlStatus {
            switch status {
            case .playing:
                print("Player is playing")
            case .paused:
                player!.play()
                ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                resumeTimer()
            case .waitingToPlayAtSpecifiedRate:
                print("Player is waiting to play at specified rate")
            @unknown default:
                print("Unknown timeControlStatus: \(status)")
            }
        } else {
            print("Player is nil")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        ButtonPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        pauseTimer()
        player!.pause()
    
    }
    @objc func playButtonTapped() {
        let viewcontroller = VovVC.storyboardInstance()
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.VideoString = smallVideoString
        OrientationManager.shared.orientationHandler.rotateFlag = true
        let nav = UINavigationController(rootViewController: viewcontroller)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        
    }
    func configrationSmallVideoView(){
        let transparentBlackView = UIImageView(frame: smallVideoUV.bounds)
        smallVideoUV.addSubview(transparentBlackView)
        
        if let videoURL = URL(string: smallVideoString) {
            generateThumbnail(from: videoURL) { thumbnail in
                if let thumbnail = thumbnail {
                    transparentBlackView.image = thumbnail
                    transparentBlackView.contentMode = .scaleAspectFit
                } else {
                    print("Failed to generate thumbnail")
                }
            }
        }
        
        
        let playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        smallVideoUV.addSubview(playButton)
       
        
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: smallVideoUV.centerXAnchor, constant: 0),
            playButton.centerYAnchor.constraint(equalTo: smallVideoUV.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 80),
            playButton.heightAnchor.constraint(equalToConstant: 80)
        ])
//        let liveVideoURL = URL(string: VideoString)!
//        getLiveVideoFrameCount(url: liveVideoURL) { frameCount in
//            if let frameCount = frameCount {
//               // print("Estimated frame count:", frameCount)
//            } else {
//              //  print("Failed to retrieve frame count.")
//            }
//        }
    }
    func Configurecollection(){
        productCV.delegate = self
        productCV.dataSource = self
        productCV.register(UINib(nibName: Identifiers.kVideoProductCVCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.kVideoProductCVCell)
        
    }
    @IBAction func cartClick_Action(_ sender: Any) {
        let viewcontroller = MyCartVC.storyboardInstance()
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.isfromVideo = true
        OrientationManager.shared.orientationHandler.rotateFlag = false
        
        let nav = UINavigationController(rootViewController: viewcontroller)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        //self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    @IBAction func profileClick_Action(_ sender: Any) {
        let vc = profileStoryboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.modalPresentationStyle = .custom
        vc.isfromVideo = true
        OrientationManager.shared.orientationHandler.rotateFlag = false
        
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func volumeClick_Actiom(_ sender: UIButton) {
        volumeUV.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            //if self.volumeSlider.value == self.currentVolumeValue{
                self.volumeUV.isHidden = true
            //}
        }
      
    }
    @IBAction func actorBrandClick_Action(_ sender: UIButton) {
        if IsActor{
            let viewcontroller = ActorDetailsVC.storyboardInstance()
            viewcontroller.modalPresentationStyle = .custom
            viewcontroller.actorID = currentItemId
            viewcontroller.isfromVideo = true
            OrientationManager.shared.orientationHandler.rotateFlag = false
            
            let nav = UINavigationController(rootViewController: viewcontroller)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            //self.navigationController?.pushViewController(viewcontroller, animated: true)
        }else{
            let viewcontroller = BrandDetailsVC.storyboardInstance()
            viewcontroller.modalPresentationStyle = .custom
            viewcontroller.brandID = currentItemId
            viewcontroller.isfromVideo = true
            OrientationManager.shared.orientationHandler.rotateFlag = false
            
            let nav = UINavigationController(rootViewController: viewcontroller)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateVideoDetail), userInfo: nil, repeats: true)
    }
    
    @objc func updateVideoDetail() {
        elapsedTime += 0.5
        let currentTimeInSeconds = CMTimeGetSeconds(CTTime)
        if currentTimeInSeconds.isFinite {
            let currentFrameNumber = Int(currentTimeInSeconds * Double(30)) + 1
            checkVOVAvailable(currentFrame: currentFrameNumber)
        }
        updateEventFrames(CTTime)
        
    }
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resumeTimer() {
        // Check if the timer is not already running
        if timer == nil {
            startTimer()
            print("Timer resumed")
        }
    }
    
    func stopTimer() {
        // Stop the timer when needed (e.g., when the view controller is about to be deallocated)
        timer?.invalidate()
    }
    
    deinit {
        // Make sure to stop the timer when the view controller is deallocated
        stopTimer()
    }
    
    
    @IBAction func ButtonPlay(_ sender: Any) {
        print("play Button")
        if player?.rate == 0
        {
            player!.play()
            // self.ButtonPlay.isHidden = true
            ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            resumeTimer()
        } else {
            player!.pause()
            ButtonPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            pauseTimer()
        }
    }
    
    @IBAction func dismissClick(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        ButtonPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        pauseTimer()
        player!.pause()
        OrientationManager.shared.orientationHandler.rotateFlag = false
        self.dismiss(animated: true)
       // self.navigationController?.popViewController(animated: true)
    }
    @objc func dismissPlayerViewController() {
        // Dismiss the AVPlayerViewController
        dismiss(animated: true, completion: nil)
    }
    
    func updateFrames(_ time: CMTime) {
        
    }
    
    func calculateFrameRate(totalFrameCount: Int, duration: Double) -> Double {
        return Double(totalFrameCount) / duration
    }
    
    func hideImage() {
        VovimageView.isHidden = true
    }
    
    func showImage(image: String?) {
        if let encodedUrlString = image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // Use the encoded URL string
            print(encodedUrlString)
            VovimageView.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            VovimageView.isHidden = false
            
            // Schedule the image to hide after the specified duration
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.hideImage()
            }
        } else {
            // Handle the case where encoding fails
            print("Failed to encode URL string")
        }
    }
    
//    @objc func orientationChanged() {
//        let orientation = UIDevice.current.orientation
//
//        switch orientation {
//        case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
//            //updatePlayerLayerFrame()
//            centerPlayerLayer()
//
//            for subview in backgroundVideoContainer.subviews {
//                var removeID = 0
//                for i in 0..<prodcutARYForCheck.count{
//                    var checkAvailable = false
//                    let proid = prodcutARYForCheck[i].id ?? 0
//
//                    if proid == subview.tag{
//                        for j in 0..<prodcutARY.count{
//                            let ppid = prodcutARY[j].id ?? 0
//                            if ppid == proid{
//                                checkAvailable = true
//                            }
//                        }
//                        if checkAvailable == false{
//                            self.prodcutARY.append(prodcutARYForCheck[i])
//                            self.productCV.reloadData()
//                            removeID = subview.tag
//                            subview.removeFromSuperview()
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 8) { // 0.01 seconds delay (10 milliseconds)
//                                if let indexToRemove = self.prodcutARY.firstIndex(where: { $0.id == removeID }) {
//                                    self.prodcutARY.remove(at: indexToRemove)
//                                    self.productCV.reloadData()
//                                }
//                                if let indexToRemove = self.prodcutARYForCheck.firstIndex(where: { $0.id == removeID }) {
//                                    self.prodcutARYForCheck.remove(at: indexToRemove)
//
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        default:
//            break
//        }
//    }
    
    func centerPlayerLayer() {
//        guard let playerLayer = playerLayer else {
//            return
//        }
//        view.layoutIfNeeded()
//        // Center the player layer within the view's bounds
//        let viewBounds = view.bounds
//        let layerSize = CGSize(width: viewBounds.width - 20, height: viewBounds.height - 20) // Adjust the size if needed
//        playerLayer.bounds = CGRect(origin: .zero, size: layerSize)
//        playerLayer.position = CGPoint(x: viewBounds.midX, y: viewBounds.midY)
//
//        // Adjust the frame if you want to keep the aspect ratio
//        playerLayer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    func pastVideoPlayer() {
        
        let url = URL(string: VideoString)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        
//        self.backgroundVideoContainer.backgroundColor = .yellow
        self.backgroundVideoContainer.layer.addSublayer(playerLayer!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.backgroundVideoContainer.addGestureRecognizer(tapGesture)
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        // Add playback slider
        playbackSlider.minimumValue = 0
        
        playbackSlider.addTarget(self, action: #selector(VideoViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        playbackSlider.isContinuous = true
        playbackSlider.tintColor = UIColor.white
        
        start_loading()
        
        if self.sliderDragToPlayPause == false {
            player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.player!.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    self.playbackSlider.value = Float ( time );
                    self.lblcurrentText.text = self.stringFromTimeInterval(interval: time)
                    if (time > 0) {
                        self.CTTime = CMTime
                        self.updateFrames(CMTime)
                        self.stop_loading()
                    }
                }
                
                self.playbackSlider.isContinuous = true
                let duration : CMTime = playerItem.asset.duration
                let seconds : Float64 = CMTimeGetSeconds(duration)
                self.lblOverallDuration.text = self.stringFromTimeInterval(interval: seconds)
                self.playbackSlider.maximumValue = Float(seconds)
                
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    //debugPrint("IsBuffering")
                } else {
                   // debugPrint("Buffering completed")
                }
            }
            player?.play()
            ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            startTimer()
            
            
            
            // Added For vloume
            player!.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.old, .new], context: nil)
            player!.volume = 0.5

            volumeSlider.minimumValue = 0.0
            volumeSlider.maximumValue = 1.0
            volumeSlider.value = player!.volume // Set initial value to current volume
            currentVolumeValue = player!.volume
            volumeSlider.addTarget(self, action: #selector(volumeChanged(_:)), for: .valueChanged)

        }
    }
    
    @objc func volumeChanged(_ sender: UISlider) {
        //volumeSlider.setThumbImage(nil, for: .normal)
        player!.volume = sender.value
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            if self.volumeSlider.value == self.currentVolumeValue{
//                self.volumeUV.isHidden = true
//            }else{
//                self.currentVolumeValue = sender.value
//            }
//        }
    }
    
    // Observer method to handle player status changes
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        if keyPath == #keyPath(AVPlayer.status) {
            // When player status changes to ready to play, start playing the audio
            if player!.status == .readyToPlay {
                player!.play()
            }
        }
    }
    
    @IBAction func addCardClose_Action(_ sender: UIButton) {
        hideAddCartAll()
    }
    func hideAddCartAll(){
        self.addToCartMessageLBL.text = ""
        self.addtoCartBackUV.isHidden = true
        self.cloaseUV.isHidden = true
        self.safeArayUV.isHidden = true
        self.bigCartIMG.isHidden = false
        self.bigCartIMG.image = UIImage(named: "videoCart")
    }
   
    func acscheduleDispatch(after interval: TimeInterval) {
        accancelDispatch()

        let workItem = DispatchWorkItem { [weak self] in
            self?.achideViews()
        }
        
        acdispatchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: workItem)
    }

    func accancelDispatch() {
        if let workItem = acdispatchWorkItem {
            workItem.cancel()
        }
    }

    @objc func achideViews() {
        hideAddCartAll()
    }
    
    
    func scheduleDispatch(after interval: TimeInterval) {
        cancelDispatch()

        let workItem = DispatchWorkItem { [weak self] in
            self?.hideViews()
        }
        
        dispatchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: workItem)
    }

    func cancelDispatch() {
        if let workItem = dispatchWorkItem {
            workItem.cancel()
        }
    }

    @objc func hideViews() {
        self.cloaseUV.isHidden = true
        self.viewBgSeekBar.isHidden = true
        self.safeArayUV.isHidden = true
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {

        
        if cloaseUV.isHidden {
            cloaseUV.isHidden = false
            viewBgSeekBar.isHidden = false
            safeArayUV.isHidden = false
            scheduleDispatch(after: 4)
        } else {
            scheduleDispatch(after: 4)
            
        }

       // if UIDevice.current.userInterfaceIdiom == .pad {
            let touchPointInBackgroundContainer = gesture.location(in: backgroundVideoContainer)
            var videoFrame = CGRect()
            videoFrame = playerLayer!.videoRect
            if videoFrame.contains(touchPointInBackgroundContainer) {
                if let hitLayer = findHitLayer(at: touchPointInBackgroundContainer) {
                    let touchPointInHitLayer = hitLayer.convert(touchPointInBackgroundContainer, from: backgroundVideoContainer.layer)
                    videoTouchPoint = touchPointInHitLayer
                    self.findEventOnTouch()
                }
            }
//        }else{
//            let touchPointInBackgroundContainer = gesture.location(in: backgroundVideoContainer)
//            if let hitLayer = findHitLayer(at: touchPointInBackgroundContainer) {
//
//                let touchPointInHitLayer = hitLayer.convert(touchPointInBackgroundContainer, from: backgroundVideoContainer.layer)
//
//                if hitLayer.frame.contains(touchPointInBackgroundContainer) {
//                    videoTouchPoint = touchPointInHitLayer
//                    self.findEventOnTouch() //anb cmt
//                } else {
//                    print("Touch point is outside the specified frame range.")
//                }
//            }
//        }
        
    }
    
    func findHitLayer(at point: CGPoint) -> CALayer? {
        for sublayer in playerLayer?.sublayers ?? [] {
            if let hitLayer = sublayer.hitTest(point) {
                if let templayer = hitLayer.hitTest(point) {
                    return templayer
                }
                return hitLayer
            }
        }
        return nil
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        ButtonPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        playbackSlider.setValue(0, animated: true)
        playbackSliderValueChanged(playbackSlider)
       // stopTimer() //anb cmt
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        prodcutARY.removeAll()
        prodcutARYForCheck.removeAll()
        backgroundVideoContainer.subviews.forEach { $0.removeFromSuperview() }
        productCV.reloadData()
    }
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func convertLastDigitToDecimalPoint(number: Int) -> String {
        var numberString = String(number)
        if let lastCharacter = numberString.last {
            numberString = String(numberString.dropLast()) + "." + String(lastCharacter)
        }
        return numberString
    }
    
}


extension VideoViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prodcutARY.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kVideoProductCVCell, for: indexPath) as! VideoProductCVCell
        let productDic = prodcutARY[indexPath.row]
        let image = productDic.mainImage?.url ?? ""
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            cell.productImageIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            cell.productImageIMG.contentMode = .scaleAspectFill
        } else {
            print("Failed to encode URL string")
        }
        cell.titleLBL.text = "$\(productDic.productSkus?.first?.price ?? 0)"
        cell.countLBL.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDic = prodcutARY[indexPath.row]
        let viewcontroller = ProdutDetailsVC.storyboardInstance()
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.productID = "\(productDic.id!)"
        viewcontroller.isfromVideo = true
        OrientationManager.shared.orientationHandler.rotateFlag = false
        
        let nav = UINavigationController(rootViewController: viewcontroller)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        //self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50 , height: 50)
    }
    
    
    
}
//MARK :- Show Product on touch
extension VideoViewController{
    
    func findEventOnTouch(){
        let tempTime:Double = currentVideoTime
        for (_, models) in filterEventData {
            
            for index in 0..<models.count - 1 {
                let currentEvent = models[index]
                let nextEvent = models[index + 1]
                
                if let currentEventTime = currentEvent.t, let nextEventTime = nextEvent.t {
                    
                    let formattedEventTime = convertLastDigitToDecimalPoint(number: currentEventTime)
                    let timeRangeStart = Double(formattedEventTime)
                    
                    let EformattedEventTime = convertLastDigitToDecimalPoint(number: nextEventTime)
                    let timeRangeEnd = Double(EformattedEventTime)
                    
                    if tempTime >= timeRangeStart! && tempTime <= timeRangeEnd! {
                        
                        if models[index].type?.rawValue == "I" {
                            var tempEventARY = [Event]()
                            if let events = VideoData?.events {
                                for event in events {
                                    guard let eventID = event.id, let eventTime = event.t else {
                                        continue
                                    }
                                    
                                    if eventID == currentEvent.id && eventTime >= currentEventTime && eventTime <= nextEventTime {
                                        tempEventARY.append(event)
                                    }
                                }
                            }
                            
                            for j in 0..<(tempEventARY.count - 1){
                                let fEvent = tempEventARY[j]
                                let nEvent = tempEventARY[j + 1]
                                
                                if let fEventT = fEvent.t, let eEventT = nEvent.t {
                                    let fEventTime = convertLastDigitToDecimalPoint(number: fEventT)
                                    let fStart = Double(fEventTime)
                                    
                                    let eEventTime = convertLastDigitToDecimalPoint(number: eEventT)
                                    let eEnd = Double(eEventTime)
                                    
                                    if tempTime >= fStart! && tempTime <= eEnd! {
                                        DispatchQueue.main.async {
                                            self.matchEventFrame(event: fEvent)
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
    func matchEventFrame(event : Event){
        let widhth = event.r?[2] ?? 0.0
        let Height = event.r?[3] ?? 0.0
        let ViewX = event.r?[0] ?? 0.0
        let ViewY = event.r?[1] ?? 0.0
        
        let eventCoordinates = CGRect(x: ViewX, y: ViewY, width: widhth, height: Height)
        
        if eventCoordinates.contains(videoTouchPoint) {
            self.checkTouchDataWithMapping(eventId: Int(event.id ?? 0), orignalEventId: Int(event.eventID ?? 0))
        }
        
    }
    func checkTouchDataWithMapping(eventId:Int, orignalEventId : Int){
  
        mappingData?.mapping.flatMap { mappingData in
            mappingData.first { $0.interactiveAreaID == eventId }
        }.map { mappingObject in
            if let objectType = mappingObject.type, let entityId = mappingObject.entityID {
                if objectType == "Product" {
                    findTouchProductObject(id: entityId, eventID: eventId, orignalEventId: orignalEventId)
                } else {
                    findPersonObject(id: entityId, eventID: eventId)
                }
            }
        }
    }
    
    func findTouchProductObject(id:Int, eventID: Int, orignalEventId : Int){
        ProductVideoData?.products.flatMap { products in
            products.first { $0.id == id }
        }.map { product in
            findTouchEventForObject(id: id, product: product, eventID: eventID, orignalEventId: orignalEventId)
        }

    }
    
    func findTouchEventForObject(id:Int, product : Product, eventID: Int, orignalEventId : Int){
        VideoData?.events?.compactMap { event in
            guard let proId = event.eventID else {
                return nil
            }

            if proId == orignalEventId {
                return event
            }

            return nil
        }.forEach { validEvent in
            showProduct(id: id, eventObj: validEvent, tempProduct: product, eventID: eventID)
        }

    }
    
    func isDevicePortrait() -> Bool {
        return UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
    }

    func isDeviceLandscape() -> Bool {
        return UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
    }
}
//MARK :- Show Product by time
extension VideoViewController{
    
    func updateEventFrames(_ time: CMTime) {
        let currentFrame = Double(time.seconds)
        let formattedString = String(format: "%.1f", currentFrame)
        let currentDoubleSecond = Double(formattedString)
        //print("Video Current Second \(currentDoubleSecond)")
        currentVideoTime = currentDoubleSecond ?? 0
        let minTime = currentDoubleSecond!// + 1
        // let maxTime = currentDoubleSecond!
        
        if let events = VideoData?.events {
            for (_, event) in events.enumerated() {
                let eventTime = Int(event.t ?? 0)
                let formattedEventTime = convertLastDigitToDecimalPoint(number: eventTime)
                let eventTimeDouble = Double(formattedEventTime)

                if event.type?.rawValue == "I" {
//                    if eventTimeDouble! == minTime {//maxTime && eventTimeDouble! <= minTime {
//                        print(Int(event.id ?? 0))
//                        DispatchQueue.main.async {
//                            self.checkDataWithMapping(eventId: Int(event.id ?? 0), etime: eventTime)
//                        }
//                    }
                }else{
                    if event.type?.rawValue == "O"{
                        if eventTimeDouble! == minTime {
                            self.checkDataWithMappingForRemoveItem(id: Int(event.id ?? 0), etime: eventTime)
                        }
                    }

                }
            }
        }
        
    }
    func checkDataWithMapping(eventId:Int, etime: Int){
        
        mappingData?.mapping.flatMap { mappingData in
            mappingData.first { $0.interactiveAreaID == eventId }
        }.map { mappingObject in
            if let objectType = mappingObject.type, let entityId = mappingObject.entityID {
                if objectType == "Product" {
                    findProductObject(id: entityId, etime: etime, eventID: eventId)
                } else {
                    findPersonObject(id: entityId, eventID: eventId)
                }
            }
        }
    }
    
    func findProductObject(id:Int, etime: Int, eventID: Int){
        ProductVideoData?.products.flatMap { products in
            products.first { $0.id == id }
        }.map { product in
            findEventForObject(id: id, product: product, etime: etime, eventID: eventID)
        }
        
    }
    func findEventForObject(id:Int, product : Product, etime: Int, eventID: Int){
        
        VideoData?.events?.compactMap { event in
            guard let proId = event.id, let ctime = event.t else {
                return nil
            }
            
            if proId == eventID && ctime == etime {
                return event
            }
            return nil
        }.forEach { validEvent in
            showProduct(id: id, eventObj: validEvent, tempProduct: product, eventID: eventID)
        }
        
        
    }
    func findPersonObject(id:Int, eventID : Int){
        var isfound = false
        if let foundPerson = ProductVideoData?.directors?.first(where: { $0.id == id }) {
            findPersonEventObject(id: id, person: foundPerson, eventID: eventID)
            isfound = true
        }
        
        if isfound == false{
            if let foundPerson = ProductVideoData?.actors?.first(where: { $0.id == id }) {
                findPersonEventObject(id: id, person: foundPerson, eventID: eventID)
                isfound = true
            }
        }
        
    }
    func findPersonEventObject(id:Int, person : Ctor, eventID : Int){
        if let events = VideoData?.events {
            for (_, event) in events.enumerated() {
                let ceventID = Int(event.id ?? 0)
                if ceventID == eventID{
                    print(eventID)
                    showPerson(person: person)
                }
            }
        }
    }
    
    //MARK :- Remove Product Step
    
    func checkDataWithMappingForRemoveItem(id:Int, etime: Int){
        
        mappingData?.mapping.flatMap { mappingData in
            mappingData.first { $0.interactiveAreaID == id }
        }.map { mappingObject in
            if let objectType = mappingObject.type, let entityId = mappingObject.entityID {
                if objectType == "Product" {
                    findRemoveProductObject(id: entityId, etime: etime, eventID: id)
                } else {
                    removePerson(id: id)
                }
            }
        }
    }
    
    func findRemoveProductObject(id:Int, etime: Int, eventID: Int){
        ProductVideoData?.products.flatMap { products in
            products.first { $0.id == id }
        }.map { product in
            removeProduct(id: id, eventID: eventID, prodcut: product)
        }
        
    }
    
    
    func showPerson(person : Ctor){
        let image = person.mainImage?.url ?? ""
        VovimageView.isHidden = false
        IsActor = true
        currentItemId = "\(person.id ?? 0)"
        if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            VovimageView.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
            VovimageView.contentMode = .scaleAspectFill
        }
    }
    func removePerson(id:Int){
        VovimageView.image = nil
    }
    
    func showProduct(id:Int, eventObj : Event, tempProduct : Product, eventID :Int){
        
        let imageUrl = tempProduct.mainImage?.url ?? ""
        if let encodedUrlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            let widhth = eventObj.r?[2] ?? 0.0
            let Height = eventObj.r?[3] ?? 0.0
            let ViewX = eventObj.r?[0] ?? 0.0
            let ViewY = eventObj.r?[1] ?? 0.0
            
            let serverCoordinates = CGRect(x: ViewX, y: ViewY, width: widhth, height: Height)
//            let deviceAspectRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
//
//            let deviceCoordinates = mapServerCoordinatesToDevice(serverCoordinates: serverCoordinates, deviceAspectRatio: deviceAspectRatio)
//            print(deviceCoordinates)
            
            
            var isAvaialable = false
            for i in 0..<self.prodcutARYForCheck.count{
                let pid = self.prodcutARYForCheck[i].id
                if pid == tempProduct.id{
                    isAvaialable = true
                    break
                }
            }
            
            let videoHeight = VideoData?.height ?? 0
            let videoWidth = VideoData?.width ?? 0
            
            if isAvaialable == false{
                var videoFrame = CGRect()
                videoFrame = playerLayer!.videoRect
                
                
                let subX = (videoFrame.width * serverCoordinates.origin.x) / CGFloat(videoWidth)
                let subY = (videoFrame.height * serverCoordinates.origin.y) / CGFloat(videoHeight)
                
                var mainX = (backgroundVideoContainer.frame.width * subX) / CGFloat(videoFrame.width) //- 30
                var mainY = (backgroundVideoContainer.frame.height * subY) / CGFloat(videoFrame.height) //- 30
                
                //let minuesWidth = (videoFrame.width * serverCoordinates.width) / CGFloat(videoWidth)

                if isDevicePortrait() {
                    mainX = mainX - 40
                } else if isDeviceLandscape() {
                    mainX = mainX - 80
                }
                
                if mainX <= 0{
                    mainX = 0
                }else if mainX >= videoFrame.width{
                    mainX = videoFrame.width - 50
                }
                
                if mainY <= videoFrame.origin.y{
                    mainY = videoFrame.origin.y + 8
                }else if mainY >= (videoFrame.height + videoFrame.origin.y){
                    mainY = (videoFrame.height + videoFrame.origin.y) - 50
                }
                
                
                var  customView = TopImageBottomLabelView()
                
                if isDevicePortrait() {
                    customView = TopImageBottomLabelView(frame: CGRect(x: mainX, y: mainY, width: 40, height: 30))
                } else if isDeviceLandscape() {
                    customView = TopImageBottomLabelView(frame: CGRect(x: mainX, y: mainY, width: 80, height: 80))
                }
                
                
                let deviceCoordinates = CGRect(x: mainX, y: mainY, width: 80, height: 80)
                customView.configure(image: encodedUrlString, productDic: tempProduct, Const: deviceCoordinates)
                customView.tag = id
                backgroundVideoContainer.addSubview(customView)
                
                self.prodcutARYForCheck.append(tempProduct)
                
                let brandID = tempProduct.brandID ?? 0
                if let foundPerson = ProductVideoData?.brands?.first(where: { $0.id == brandID }) {
                    let image = foundPerson.images?[0].url ?? ""
                    VovimageView.isHidden = false
                    IsActor = false
                    currentItemId = "\(brandID)"
                    if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        VovimageView.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
                    }
                }
                
                customView.tapAction = {
                    self.pauseTimer()
                    self.player!.pause()
                    self.ButtonPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    
                    let viewcontroller = ProdutDetailsVC.storyboardInstance()
                    viewcontroller.modalPresentationStyle = .custom
                    viewcontroller.productID = "\(tempProduct.id!)"
                    viewcontroller.isfromVideo = true
                    OrientationManager.shared.orientationHandler.rotateFlag = false
                    
                    let nav = UINavigationController(rootViewController: viewcontroller)
                    nav.isNavigationBarHidden = true
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }
                
                customView.panAction = {
                    let targetRadius: CGFloat = 50.0 // Set your desired radius
                    if self.isView(customView, withinRadius: targetRadius, of: self.bigCartIMG) {
                        print("within")
                        customView.removeFromSuperview()
                        self.productData = tempProduct
                        self.bigCartIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
                        self.addToCart(qty: "1") { success in
                            if success {
                                self.bigCartIMG.isHidden = true
                                self.addToCartMessageLBL.text = "Product was added in your cart!"
                                self.GetCartDetail()
                                self.acscheduleDispatch(after: 2)
                            } else {
                                
                            }
                        }
                    } else {
                        self.hideAddCartAll()
                    }
                    
                }
                
                customView.productDragCountinueAction = {
                    self.cloaseUV.isHidden = false
                    self.addtoCartBackUV.isHidden = false
                    self.safeArayUV.isHidden = false
                    self.viewBgSeekBar.isHidden = true
                }
                
            }
            
        } else {
            print("Failed to encode URL string")
        }
        
    }
    
    func removeProduct(id:Int, eventID: Int, prodcut:Product){
        for subview in backgroundVideoContainer.subviews {
            
            // DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if subview.tag == id{
                if let viewToRemove = subview.viewWithTag(id) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        self.acscheduleDispatch(after: 2)
                        self.animatePositionChange(tempView: viewToRemove, tempProduct: prodcut)
                    }
                } else {
                    print("View with tag \(id) not found.")
                }
            }
            //}
        }
    }
    func animatePositionChange(tempView:UIView, tempProduct : Product) {
        let newX: CGFloat = 20//50 + CGFloat(self.prodcutARY.count * 50)
        let newY: CGFloat = 50 + CGFloat(self.prodcutARY.count * 50)//self.cloaseUV.frame.origin.y
        
        UIView.animate(withDuration: 1.0, animations: {
            tempView.frame.origin = CGPoint(x: newX, y: newY)
        }) { (completed) in
            if completed {
                tempView.removeFromSuperview()
                self.prodcutARY.append(tempProduct)
                self.productCV.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) { // 0.01 seconds delay (10 milliseconds)
                    if let indexToRemove = self.prodcutARY.firstIndex(where: { $0.id == tempProduct.id }) {
                        self.prodcutARY.remove(at: indexToRemove)
                        self.productCV.reloadData()
                    }
                    if let indexToRemove = self.prodcutARYForCheck.firstIndex(where: { $0.id == tempProduct.id }) {
                        self.prodcutARYForCheck.remove(at: indexToRemove)
                        
                    }
                    
                }
                
            }
        }
    }
    
    func isView(_ view: UIView, withinRadius radius: CGFloat, of targetView: UIView) -> Bool {
        let viewCenter = backgroundVideoContainer.convert(view.center, from: view.superview)
        let targetCenter = backgroundVideoContainer.convert(targetView.center, from: targetView.superview)
        
        let distance = sqrt(pow(viewCenter.x - targetCenter.x, 2) + pow(viewCenter.y - targetCenter.y, 2))
        
        return distance <= radius
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
           let location = gesture.location(in: view)

           switch gesture.state {
           case .began:
               guard let selectedIndexPath = productCV.indexPathForItem(at: gesture.location(in: productCV)) else { return }
               guard let cell = productCV.cellForItem(at: selectedIndexPath) else { return }
               startDragging(cell, from: selectedIndexPath)
           case .changed:
               updateDragging(at: location)
           case .ended:
               endDragging(at: location)
           default:
               cancelDragging()
           }
       }
    

    func startDragging(_ cell: UICollectionViewCell, from indexPath: IndexPath) {
        
        self.cloaseUV.isHidden = false
        self.addtoCartBackUV.isHidden = false
        self.safeArayUV.isHidden = false
        self.viewBgSeekBar.isHidden = true
        self.acscheduleDispatch(after: 4)
        
        
        initialIndexPath = indexPath
        draggedCell = cell
        self.productData = prodcutARY[initialIndexPath!.item]
        
        // Take a snapshot of the cell and add it to the main view
        if let cellSnapshot = cell.snapshotView(afterScreenUpdates: true) {
            cellSnapshot.frame = view.convert(cell.frame, from: productCV)
            view.addSubview(cellSnapshot)
            dragPlaceholderView = cellSnapshot
            cell.isHidden = true
        }
    }
    
    func updateDragging(at location: CGPoint) {
        guard let placeholderView = dragPlaceholderView else { return }
        placeholderView.center = location
    }
    
    func endDragging(at location: CGPoint) {
        guard let initialIndexPath = initialIndexPath, let draggedCell = draggedCell, let placeholderView = dragPlaceholderView else {
            cancelDragging()
            return
        }
        
        let targetRadius: CGFloat = 50.0
        let isWithinRadius = isView(placeholderView, withinRadius: targetRadius, of: bigCartIMG)
        
        placeholderView.removeFromSuperview()
        
        if isWithinRadius {
            // Remove the item from the data source and delete the item from the collection view
            if prodcutARY.count > 0{
                productCV.performBatchUpdates({
                    // prodcutARY.remove(at: initialIndexPath.item)
                    productCV.deleteItems(at: [initialIndexPath])
                    
                    if let index = self.prodcutARY.firstIndex(where: { $0.id == self.productData?.id }) {
                        self.prodcutARY.remove(at: index)
                    }
                    
                    let image = self.productData?.mainImage?.url ?? ""
                    if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        self.bigCartIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
                        self.bigCartIMG.contentMode = .scaleAspectFill
                    } else {
                        print("Failed to encode URL string")
                    }
                    
                    self.addToCart(qty: "1") { success in
                        if success {
                            self.bigCartIMG.isHidden = true
                            self.addToCartMessageLBL.text = "Product was added in your cart!"
                            self.GetCartDetail()
                        } else {
                            
                        }
                    }
                    draggedCell.isHidden = false
                }, completion: nil)
                
            }else{
                let image = self.productData?.mainImage?.url ?? ""
                if let encodedUrlString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    self.bigCartIMG.sd_setImage(with: URL(string: encodedUrlString), placeholderImage: placeholderImg)
                    self.bigCartIMG.contentMode = .scaleAspectFill
                } else {
                    print("Failed to encode URL string")
                }
                
                self.addToCart(qty: "1") { success in
                    if success {
                        self.bigCartIMG.isHidden = true
                        self.addToCartMessageLBL.text = "Product was added in your cart!"
                        self.GetCartDetail()
                    } else {
                        
                    }
                }
            }
        } else {
            self.hideAddCartAll()
            draggedCell.isHidden = false
        }
        
        self.draggedCell = nil
        self.initialIndexPath = nil
        self.dragPlaceholderView = nil
    }
    
    func cancelDragging() {
        guard let draggedCell = draggedCell, let placeholderView = dragPlaceholderView else { return }
        
        placeholderView.removeFromSuperview()
        draggedCell.isHidden = false
        
        self.draggedCell = nil
        self.initialIndexPath = nil
        self.dragPlaceholderView = nil
    }

}
extension VideoViewController {
    
    func GetEntitiesDetail(id:String){
        
        let headers: HTTPHeaders = [
            "Authorization": AuthToken ,
            "content-type": "application/json;charset=UTF-8"
        ]
        
        start_loading()
        self.get_api_request("\(BaseURLOffice)video/\(id)/entities\(loadContents)", headers: headers).responseDecodable(of: ProductVideoModel.self) { response in
            //            print(response)
            if response.error != nil {
                self.ShowAlert(title: "Error", message: response.error?.localizedDescription ?? "Something Went Wrong")
            }else{
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(ProductVideoModel.self, from: responseData)
                        self.ProductVideoData = welcome
                     } catch {
                        self.ShowAlert(title: "Error", message: "Failed to decode response: \(error.localizedDescription)")
                    }
                }else{
                    self.ShowAlert(title: "Error", message: "Something Went Wrong")
                }
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
    func GetProductMappingDetail(productmappingID : Int){
        
        let headers: HTTPHeaders = [
            "Authorization": AuthToken
        ]
        start_loading()
        self.get_api_request("\(BaseURLOffice)product-mapping/\(productmappingID)\(loadContents)", headers: headers).responseDecodable(of: MappingDataModel.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(MappingDataModel.self, from: responseData)
                        self.mappingData = welcome
                    } catch {
                        self.ShowAlert(title: "Error", message: "Failed to decode response: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    
    func GetVideoDetail(id:String){
        
        let headers: HTTPHeaders = [
            "Authorization": AuthToken ,
            "content-type": "application/json;charset=UTF-8"
        ]
        
        var params = [String : Any]()
        params["operatorId"] = "1"
        
//        if id == "22"{
//            params["cachedScreeningFileId"] = "7"
//        }else{
//            params["cachedScreeningFileId"] = "3"
//        }
        
        print(params)
        self.post_api_request_withJson("\(BaseURLOffice)video/\(id)\(loadContents)", params: params, headers: headers).responseDecodable(of: VideoDataModel.self) { response in
            //            print(response)
            if response.error != nil {
                self.ShowAlert(title: "Error", message: response.error?.localizedDescription ?? "Something Went Wrong")
            }else{
                if let responseData = response.data {
                    do {
                        let welcome = try JSONDecoder().decode(VideoDataModel.self, from: responseData)
                        self.isFirst = false
                        self.VideoData = welcome
                        let productmappingID = self.VideoData?.screeningFile?.productMappingID ?? 0
                        self.GetProductMappingDetail(productmappingID: productmappingID)
                        self.getStatusList()
                    } catch {
                        self.ShowAlert(title: "Error", message: "Failed to decode response: \(error.localizedDescription)")
                    }
                    
                }else{
                    self.ShowAlert(title: "Error", message: "Something Went Wrong")
                }
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
    func getStatusList(){
        
        filterEventData = Dictionary(grouping: VideoData?.events ?? [], by: { String($0.id ?? 0) })
    
        for (processStatus, models) in filterEventData {
           let filteredModels = models.filter { $0.type != .empty }
            let sortedModels = filteredModels.sorted { (model1, model2) in
                return (model1.t ?? 0) < (model2.t ?? 0)
            }
            print("Sorted Models: \(sortedModels)")
            filterEventData[processStatus] = sortedModels
        }
    }
    func GetCartDetail(){
        start_loading()
        APIManager.shared.getCartDetail(userID: UserID) { result in
            switch result {
            case .success(let cartData):
                self.cartData = cartData
                self.cartCountBTN.setTitle("\(self.cartData?.count ?? 0)", for: .normal)
                self.bigCartCountBTN.setTitle("\(self.cartData?.count ?? 0)", for: .normal)
            case .failure(let error):
                self.ShowAlert(title: "Error", message: "\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.stop_loading()
            }
        }
    }
}


import UIKit

class TopImageBottomLabelView: UIView {
    var Cordi: CGRect?
    var tapAction: (() -> Void)?
    var panAction: (() -> Void)?
    var productDragCountinueAction: (() -> Void)?
    
    func isDevicePortrait() -> Bool {
        return UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
    }

    func isDeviceLandscape() -> Bool {
        return UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
    }
    
    let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor(red: 58/255, green: 171/255, blue: 242/255, alpha: 1).cgColor
        //view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .black
        view.layer.borderWidth = 1.5
        return view
    }()
    
    let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 5
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let labelsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 1
        
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.numberOfLines = 1
        return label
    }()
    
    let PriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.numberOfLines = 1
        label.backgroundColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupGesture()
    }
    
    private func commonInit() {
        // Add the content view
        addSubview(contentView)
        
        // Add the top image view to the content view
        contentView.addSubview(topImageView)
        
        // Add the labels container view to the content view
        contentView.addSubview(labelsContainerView)
        contentView.addSubview(PriceLabel)
        
        // Add both labels to the labels container view
        labelsContainerView.addSubview(bottomLabel)
        labelsContainerView.addSubview(descLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        PriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if isDevicePortrait() {
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Cordi?.origin.x ?? 0.0),
                contentView.topAnchor.constraint(equalTo: topAnchor, constant: Cordi?.origin.y ?? 0.0),
                contentView.widthAnchor.constraint(equalTo: widthAnchor, constant: Cordi?.size.width ?? 0.0),
                contentView.heightAnchor.constraint(equalTo: heightAnchor, constant: Cordi?.size.height ?? 0.0 + 20),
                
                topImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                topImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                topImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                topImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
                
                PriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                PriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
                PriceLabel.widthAnchor.constraint(equalToConstant: 40),
                PriceLabel.heightAnchor.constraint(equalToConstant: 20),
                
                labelsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  4),
                labelsContainerView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 4),
                labelsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -4),
                labelsContainerView.heightAnchor.constraint(equalToConstant: 0),
                
                bottomLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
                bottomLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor,constant: 0),
                bottomLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
                bottomLabel.heightAnchor.constraint(equalToConstant: 0),
                
                descLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
                descLabel.topAnchor.constraint(equalTo: bottomLabel.topAnchor,constant: 15),
                descLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
                descLabel.heightAnchor.constraint(equalToConstant: 0),
            ])
        }else{
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Cordi?.origin.x ?? 0.0),
                contentView.topAnchor.constraint(equalTo: topAnchor, constant: Cordi?.origin.y ?? 0.0),
                contentView.widthAnchor.constraint(equalTo: widthAnchor, constant: Cordi?.size.width ?? 0.0),
                contentView.heightAnchor.constraint(equalTo: heightAnchor, constant: Cordi?.size.height ?? 0.0 + 20),
                
                topImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                topImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                topImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                topImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant:  -20),
                
                PriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                PriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
                PriceLabel.widthAnchor.constraint(equalToConstant: 40),
                PriceLabel.heightAnchor.constraint(equalToConstant: 20),
                
                labelsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  4),
                labelsContainerView.topAnchor.constraint(equalTo: topImageView.bottomAnchor),
                labelsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -4),
                labelsContainerView.heightAnchor.constraint(equalToConstant: 20),
                
                bottomLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
                bottomLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor,constant: 0),
                bottomLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
                bottomLabel.heightAnchor.constraint(equalToConstant: 20),
                
                descLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
                descLabel.topAnchor.constraint(equalTo: bottomLabel.topAnchor,constant: 15),
                descLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
                descLabel.heightAnchor.constraint(equalToConstant: 0),
            ])
        }
        
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        let translation = gestureRecognizer.translation(in: view.superview)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gestureRecognizer.setTranslation(.zero, in: view.superview)
        
        if gestureRecognizer.state == .ended {
            panAction?()
        }else{
            productDragCountinueAction?()
        }
        
    }
    @objc private func viewTapped() {
        // Handle tap action here
        tapAction?()
        // You can perform any action you want when the view is tapped
    }
    
    func configure(image: String, productDic: Product, Const: CGRect) {
        topImageView.sd_setImage(with: URL(string: image), placeholderImage: placeholderImg)
        bottomLabel.text = productDic.name ?? ""
        descLabel.text = productDic.brandName ?? ""
        PriceLabel.text = "$\(productDic.productSkus?.first?.price ?? 0)"
        Cordi = Const
        setupConstraints()
        
    }
}

extension VideoViewController {
    
    func addToCart(qty: String, completion: @escaping (Bool) -> Void) {
        guard let personDict = convertToDictionary(self.productData),
              let skuDict = convertToDictionary(self.productData?.productSkus?[0]),
              let shippingDict = convertToDictionary(self.productData?.shippings?[0]) else {
            completion(false)
            return
        }

        let params: [String: Any] = [
            "count": qty,
            "price": "\(productData?.productSkus?[0].price ?? 0)",
            "product": personDict,
            "projectId": projectID,
            "shipping": shippingDict,
            "agreement": 1,
            "sku": skuDict
        ]

        print(params)
        start_loading()
        self.post_api_request_withJson("\(BaseURLOffice)cart/users/\(UserID)/products", params: params, headers: headersCommon).responseJSON { response in
            print(response.result)
            DispatchQueue.main.async {
                self.stop_loading()
            }

            if response.response?.statusCode == 404 {
                DispatchQueue.main.async {
                    if let json = response.value as? [String: Any],
                       let message = json["message"] as? String {
                        self.ShowAlert(title: "Error", message: message)
                    } else {
                        self.ShowAlert(title: "Error", message: "Not found. The resource doesn't exist.")
                    }
                    completion(false)
                }
                return
            }

            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    completion(true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.ShowAlert(title: "Error", message: error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
}

extension VideoViewController {
    
    func smallVideoPlayer() {
        
//        let url = URL(string: smallVideoString)
//        let playerItem1: AVPlayerItem = AVPlayerItem(url: url!)
//        splayer = AVPlayer(playerItem: playerItem1)
//        splayerLayer = AVPlayerLayer(player: splayer)
//        splayerLayer?.videoGravity = .resizeAspect
//
//        self.smallVideoUV.layer.addSublayer(splayerLayer!)
        
        
//        splayer?.play()
        self.configrationSmallVideoView()
     }
    
    func checkVOVAvailable(currentFrame: Int) {
        guard let vovs = VideoData?.vovs else {
            smallVideoUV.isHidden = true
            return
        }
        
        var isShow = false
        var shortVideoData: Vov?
        
        for cvov in vovs {
            guard let startFrame = cvov.startFrame, let endFrame = cvov.endFrame else {
                continue
            }
            
            if currentFrame >= startFrame && currentFrame <= endFrame {
                isShow = true
                shortVideoData = cvov
                break // Exit loop early since we found a matching VOV
            }
        }
        
        if isShow {
            if let videoURL = shortVideoData?.relatedProjects?.first?.videoURL {
                smallVideoString = videoURL
                smallVideoPlayer()
                smallVideoUV.isHidden = false
            } else {
                smallVideoUV.isHidden = true
            }
        } else {
            smallVideoUV.isHidden = true
        }
    }
    
    func generateThumbnail(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 1, preferredTimescale: 60) // Capture the thumbnail at the 1-second mark
        DispatchQueue.global().async {
            do {
                let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("Error generating thumbnail: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func getLiveVideoFrameCount(url: URL, completion: @escaping (Int?) -> Void) {
        let asset = AVURLAsset(url: url)
        
        // Load the asset asynchronously to get properties like duration and tracks
        asset.loadValuesAsynchronously(forKeys: ["duration", "tracks"]) {
            var durationInSeconds: Double = 0
            var frameRate: Float = 0
            
            // Retrieve duration
            var error: NSError?
            let durationStatus = asset.statusOfValue(forKey: "duration", error: &error)
            if durationStatus == .loaded {
                durationInSeconds = CMTimeGetSeconds(asset.duration)
            } else {
                print("Failed to load duration:", error?.localizedDescription ?? "Unknown error")
            }
            
            // Retrieve frame rate
            let trackKey = "tracks"
            let tracksStatus = asset.statusOfValue(forKey: trackKey, error: &error)
            if tracksStatus == .loaded {
                if let videoTrack = asset.tracks(withMediaType: .video).first {
                    frameRate = videoTrack.nominalFrameRate
                }
            } else {
                print("Failed to load tracks:", error?.localizedDescription ?? "Unknown error")
            }
            
            // Calculate estimated frame count
            var estimatedFrameCount: Int?
            if frameRate > 0 && durationInSeconds > 0 {
                estimatedFrameCount = Int(durationInSeconds * Double(frameRate))
            }
            
            // Return the result on the main queue
            DispatchQueue.main.async {
                completion(estimatedFrameCount)
            }
        }
    }
    
}
