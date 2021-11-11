//
//  VideoPlayerVC.swift
//  HD Video Player
//
//  Created by iMac on 09/11/21.
//

import UIKit
import AssetsLibrary
import Photos
import AVKit
import GoogleMobileAds

class VideoPlayerVC: UIViewController {
    
    var photos: PHFetchResult<PHAsset>!
    var assetss: PHAsset!
    var fileary = ["Video"]
    
    private var interstitial: GADInterstitialAd!
    var baneer:GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAssetFromPhoto()
        Launchbannerad()
        
    }
    func getAssetFromPhoto() {
        let options = PHFetchOptions()
        options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: true) ]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        photos = PHAsset.fetchAssets(with: options)
        print(photos)
    //    photoCollectionView.reloadData() // reload your collectionView
    }
    
    func Launchbannerad(){
        baneer = GADBannerView(adSize: kGADAdSizeBanner)
        baneer.adUnitID = Bannerad
        baneer.rootViewController = self
        addBannerViewToView(baneer)
        baneer.load(GADRequest())
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
    }
    
    @IBAction func Backbtnclick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
extension VideoPlayerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell") as! VideoListCell
        cell.layer.cornerRadius = 10
        cell.filelbl.text = fileary[indexPath.row]
        cell.countlbl.text = "\(photos.count) Videos"
        cell.Cellview.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nxt = storyboard?.instantiateViewController(withIdentifier: "MusicPlayerVC") as! MusicPlayerVC
        navigationController?.pushViewController(nxt, animated: true)
    }
}
