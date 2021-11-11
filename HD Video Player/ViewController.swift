//
//  ViewController.swift
//  HD Video Player
//
//  Created by iMac on 09/11/21.
//

import UIKit
import GoogleMobileAds

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}

class ViewController: UIViewController {
    
    private var interstitial: GADInterstitialAd!
    var baneer:GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Launchbannerad()
        LaunchInterstitialAd()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
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
    
    @IBAction func StartbtnClick(_ sender: UIButton) {
        showInterstitialAd()
        let nxt = storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        navigationController?.pushViewController(nxt, animated: true)
    }
    
    @IBAction func Sharebtnclick(_ sender: UIButton) {
        let url = URL(string: ShareAppID)
        UIApplication.shared.open(url!, options: [:] , completionHandler: nil)
    }
    
    @IBAction func Ratebtnclick(_ sender: UIButton) {
        let url = URL(string: RateAppID)
        UIApplication.shared.open(url!, options: [:] , completionHandler: nil)
    }
    
    @IBAction func Morebtnclick(_ sender: UIButton) {
        let url = URL(string: MoreAppID)
        UIApplication.shared.open(url!, options: [:] , completionHandler: nil)
    }
}
