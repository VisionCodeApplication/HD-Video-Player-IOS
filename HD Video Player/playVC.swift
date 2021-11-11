//
//  playVC.swift
//  HD Video Player
//
//  Created by iMac on 10/11/21.
//

import UIKit
import AssetsLibrary
import Photos
import AVKit

class playVC: UIViewController {


    @IBOutlet var videoimg: UIImageView!
    @IBOutlet var Pause: UIButton!
    @IBOutlet var play: UIButton!
    @IBOutlet var Backbtn: UIButton!
    @IBOutlet var MainLbl: UILabel!
    
    var count = 1
    var tapcount = 0
    var photos: PHFetchResult<PHAsset>!
    fileprivate var playerLayer: AVPlayerLayer!
    fileprivate var playerLooper: AVPlayerLooper?
    var assetss: PHAsset!
    var player = AVPlayer()
    var tapview = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var user = UserDefaults.standard
        MainLbl.text = user.value(forKey: "name") as! String
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapfunction))
        tapview.addGestureRecognizer(tap)
        Pause.alpha = 0.5
        getAssetFromPhoto()
        update()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if playerLayer != nil{
        if tapcount == 0 {
            tapview.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            self.playerLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }else{
            tapview.frame = CGRect(x: 0, y: 60, width: size.width, height: size.height - 120)
            self.playerLayer.frame = CGRect(x: 0, y: 60, width: size.width, height: size.height - 120)
        }
        }else{
            videoimg.frame = CGRect(x: 20, y: 60, width: size.width - 20, height: size.height - 120)
        }
    }
    
    func getAssetFromPhoto() {
        let options = PHFetchOptions()
        options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: true) ]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        photos = PHAsset.fetchAssets(with: options)
        print(photos)
        assetss = photos!.object(at: count)
        let asset = photos!.object(at: count)
        let width: CGFloat = 150
            let height: CGFloat = 150
            let size = CGSize(width:width, height:height)
    }

    @objc func tapfunction(){
        if tapcount == 0 {
            tapcount = 1
            self.tapview.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width , height: self.videoimg.bounds.height + 10)
            self.playerLayer.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width , height: self.videoimg.bounds.height + 10)
            play.isHidden = false
            Pause.isHidden = false
        }
        else{
            tapcount = 0
            self.tapview.frame = self.view.bounds
            self.playerLayer.frame = self.view.bounds
          //  NVbar.isHidden = true
            play.isHidden = true
            Pause.isHidden = true
        }
    }
    func update(){
        let asset = photos!.object(at: count)
        let width: CGFloat = 374
            let height: CGFloat = 705
            let size = CGSize(width:width, height:height)
        
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, userInfo) -> Void in
            var str = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
            self.videoimg.image = image
            }
    }
    
    func playvideo(){
        tapview.frame = CGRect(x: 0, y: 70, width: self.view.bounds.width , height: self.view.bounds.height - 140 )
        self.view.addSubview(tapview)
        
        if playerLayer != nil {
            // An AVPlayerLayer has already been created for this asset; just play it.
            playerLayer.player!.play()
        } else {
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .automatic
            options.progressHandler = { progress, _, _, _ in
                // Handler might not be called on the main queue, so re-dispatch for UI work.
//                DispatchQueue.main.sync {
//                    self.progressView.progress = Float(progress)
//                }
            }

            // Request an AVPlayerItem for the displayed PHAsset and set up a layer for playing it.
            PHImageManager.default().requestPlayerItem(forVideo: assetss, options: options, resultHandler: { playerItem, _ in
                
                    guard self.playerLayer == nil && playerItem != nil else { return }
                    // Create an AVPlayer and AVPlayerLayer with the AVPlayerItem.
                    //let player: AVPlayer
                    if self.assetss.playbackStyle == .videoLooping {
                        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
                        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem!)
                        self.player = queuePlayer
                    } else {
                        self.player = AVPlayer(playerItem: playerItem)
                    }
                
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerLayer.videoGravity = AVLayerVideoGravity.resize
                self.playerLayer.frame = self.view.bounds
                self.view.layer.addSublayer(self.playerLayer)
                self.player.play()
     
            })
        }
        }
    @IBAction func Backbtnclick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Playbtnclick(_ sender: Any) {
        play.alpha = 0.5
        Pause.alpha = 1
     //   NVbar.isHidden = true
        videoimg.isHidden = true
        play.isHidden = true
        Pause.isHidden = true
        playvideo()
        if tapcount == 1 {
            self.playerLayer.frame = self.view.bounds
        }
        tapcount = 0
    }
    
    @IBAction func Puasebtnclick(_ sender: Any) {
        play.alpha = 1
        Pause.alpha = 0.5
        player.pause()
    }

}
