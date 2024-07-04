//
//  VovVC.swift
//  Touch E Demo
//
//  Created by Parth on 24/06/24.
//

import UIKit
import AVKit
import Alamofire
import AVFoundation

class VovVC: UIViewController {
    
    static func storyboardInstance() -> VovVC {
        return VovVC(nibName: "VovVC", bundle: Bundle.module)
    }
    var VideoString = ""
    var VideoListDic : HomeListModel?
    var player:AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerItem:AVPlayerItem?
    var sliderDragToPlayPause = false
    var isShown = false
    var timer: Timer?
    var elapsedTime: TimeInterval = 0.0
    var CTTime = CMTime()
    var productIDArray = [Int]()
    var RRect : CGRect?
    var brandID = ""
    var tempARY = [String]()
    var currentVideoTime : Double = 0.0
    var videoTouchPoint = CGPoint()
    var filterEventData = [String? : [Event]]()
    var currentVolumeValue:Float = 0.0
    var dispatchWorkItem: DispatchWorkItem?

    var IsActor = false
    var currentItemId = ""
    var isVideoCompeted = false
    
   
    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var lblOverallDuration: UILabel!
    @IBOutlet weak var viewBgSeekBar: UIView!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var lblcurrentText: UILabel!
    @IBOutlet weak var backgroundVideoContainer: UIView!
    @IBOutlet weak var cloaseUV: UIView!
    @IBOutlet weak var safeArayUV: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeUV: UIViewX!
    @IBOutlet weak var videoTitleLB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        if let view = Bundle.module.loadNibNamed("VovVC", owner: self, options: nil)?.first as? UIView {
            self.view = view
        }
        
        volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        
        cloaseUV.isHidden = false
        viewBgSeekBar.isHidden = false
        safeArayUV.isHidden = false
        //scheduleDispatch(after: 8)
      

        DispatchQueue.main.async {
            self.videoTitleLB.text = self.VideoListDic?.name ?? ""
            self.start_loading()
            self.pastVideoPlayer()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = self.backgroundVideoContainer.bounds
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cloaseUV.isHidden = false
        viewBgSeekBar.isHidden = false
        safeArayUV.isHidden = false
        //scheduleDispatch(after: 4)
    }
    override func viewWillDisappear(_ animated: Bool) {
        ButtonPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        pauseTimer()
        player!.pause()
    
    }
    @IBAction func volumeClick_Actiom(_ sender: UIButton) {
        volumeUV.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            //if self.volumeSlider.value == self.currentVolumeValue{
                self.volumeUV.isHidden = true
            //}
        }
      
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateVideoDetail), userInfo: nil, repeats: true)
    }
    
    @objc func updateVideoDetail() {
        elapsedTime += 0.5
       
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
        //rotate_flag = false
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
    
    
    func pastVideoPlayer() {
        
        let url = URL(string: VideoString)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        self.backgroundVideoContainer.layer.addSublayer(playerLayer!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        // Add playback slider
        playbackSlider.minimumValue = 0
        
        playbackSlider.addTarget(self, action: #selector(VovVC.playbackSliderValueChanged(_:)), for: .valueChanged)
        
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
        player!.volume = sender.value
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
   
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        ButtonPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        playbackSlider.setValue(0, animated: true)
        playbackSliderValueChanged(playbackSlider)
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        backgroundVideoContainer.subviews.forEach { $0.removeFromSuperview() }
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

