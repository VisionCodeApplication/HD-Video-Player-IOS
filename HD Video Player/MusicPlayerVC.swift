//
//  MusicPlayerVC.swift
//  HD Video Player
//
//  Created by iMac on 09/11/21.
//

import UIKit
import AssetsLibrary
import Photos
import AVKit
import GoogleMobileAds


class MusicPlayerVC: UIViewController {
    
    var photos: PHFetchResult<PHAsset>!
    private var interstitial: GADInterstitialAd!
    var baneer:GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAssetFromPhoto()
        Launchbannerad()
        LaunchInterstitialAd()
    }

    func getAssetFromPhoto() {
        let options = PHFetchOptions()
        options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: true) ]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        photos = PHAsset.fetchAssets(with: options)
        print(photos)
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
    
    private func LaunchInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: instrsitialad,
                                        request: request,
                              completionHandler: { [self] ad, error in
                                if let error = error {
                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                  return
                                }
                                interstitial = ad
                              })
    }

    private func showInterstitialAd() {
        if interstitial != nil {
            interstitial.present(fromRootViewController: self)
            LaunchInterstitialAd()
        }
    }
    
    @IBAction func Backbtnclick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
extension MusicPlayerVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListFile") as! MusicListFile
        let asset = photos!.object(at: indexPath.row)
        let width: CGFloat = 150
            let height: CGFloat = 150
            let size = CGSize(width:width, height:height)
        
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, userInfo) -> Void in
            var str = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
            cell.Cellview.layer.cornerRadius = 10
            cell.Musicfilelbl.text = asset.value(forKey: "filename") as! String
            cell.img.image = image
            cell.Musictimelbl.text = str
            }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nxt = storyboard?.instantiateViewController(withIdentifier: "playVC") as! playVC
        nxt.count = indexPath.row
        let asset = photos!.object(at: indexPath.row)
        var user = UserDefaults.standard
        user.setValue(asset.value(forKey:"filename"), forKey: "name")
        navigationController?.pushViewController(nxt, animated: true)
        showInterstitialAd()
    }
}
