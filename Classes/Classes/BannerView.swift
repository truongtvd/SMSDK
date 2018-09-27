
import UIKit
import GoogleMobileAds
import FBAudienceNetwork

let ADSHeight:CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 60.0 : 100.0
class BannerView: UIView,GADBannerViewDelegate,FBAdViewDelegate {
    private var admobview:GADBannerView!
    private var facebookview:FBAdView!
    var rootController:UIViewController!
    var ads:Ads!{
        didSet{
            self.initAds()
        }
        
    }
    
    
    private func initAds() {
        if ads.network == "admob" && ads.status == 1 && ads.ads_id != ""{
            admobview = GADBannerView.init(adSize: kGADAdSizeSmartBannerPortrait)
            admobview.adUnitID = ads.ads_id
            admobview.delegate = self
            admobview.rootViewController = rootController!
            admobview.translatesAutoresizingMaskIntoConstraints = false
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            admobview.load(request)
            
            self.addSubview(admobview)
            self.addConstraints([NSLayoutConstraint.init(item: admobview,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .top,
                                                         multiplier: 1.0,
                                                         constant: 5),
                                 NSLayoutConstraint.init(item: admobview,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .bottom,
                                                         multiplier: 1.0,
                                                         constant: -5),
                                 NSLayoutConstraint.init(item: admobview,
                                                         attribute: .left,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .left,
                                                         multiplier: 1.0,
                                                         constant: 0),
                                 NSLayoutConstraint.init(item: admobview,
                                                         attribute: .right,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .right,
                                                         multiplier: 1.0,
                                                         constant: 0)])
        }else if ads.network == "facebook" && ads.status == 1 && ads.ads_id != ""{
            if UIDevice.current.userInterfaceIdiom == .phone{
                facebookview = FBAdView(placementID: ads.ads_id, adSize: kFBAdSizeHeight50Banner, rootViewController: rootController)
            }else{
                facebookview = FBAdView(placementID: ads.ads_id, adSize: kFBAdSizeHeight90Banner, rootViewController: rootController)
            }
            facebookview.delegate = self
            facebookview.loadAd()
            facebookview.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(facebookview)
            
            self.addConstraints([NSLayoutConstraint.init(item: facebookview,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .top,
                                                         multiplier: 1.0,
                                                         constant: 5),
                                 NSLayoutConstraint.init(item: facebookview,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .bottom,
                                                         multiplier: 1.0,
                                                         constant: -5),
                                 NSLayoutConstraint.init(item: facebookview,
                                                         attribute: .left,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .left,
                                                         multiplier: 1.0,
                                                         constant: 0),
                                 NSLayoutConstraint.init(item: facebookview,
                                                         attribute: .right,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .right,
                                                         multiplier: 1.0,
                                                         constant: 0)])
        }
        
    }
    
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
        print(error.code)
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.black

    }

}
