
import Foundation
import UIKit


public extension UIViewController{
    func showAds(banner:BannerView,height:NSLayoutConstraint,config:RateConfig){
        let ads = AdsManager.share.adsId.banner
        banner.rootController = self
        banner.ads = ads
        if AdsManager.share.showBanner(ads: ads, rateConfig: config){
            height.constant = ADSHeight
        }else{
            height.constant = 0
            
        }
    }
}
