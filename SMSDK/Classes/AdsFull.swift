
import UIKit
import GoogleMobileAds
import FBAudienceNetwork
typealias AdsClose = ()->Void

public enum AdsType:String {
    case facebook = "facebook"
    case admob = "admob"
    case smads = "smads"
}
public class AdsFull: UIViewController,GADInterstitialDelegate,FBInterstitialAdDelegate,SMInterstitialDelegate {

    private var admobFull:GADInterstitial!
    private var facebookFull:FBInterstitialAd!
    var smFull:SMInterstitial!

    private var ads_id = ""
    private var ads_type:AdsType!
    private var adsClose:AdsClose!
    private var isShow = false
    private var timecount:Timer!

    class func getInstant(ads_id : String,
                          ads_type:AdsType,
                          adsClose:@escaping AdsClose)->AdsFull{
        let st:UIStoryboard = UIStoryboard.init(name: "Ads", bundle: nil)
        let vc:AdsFull = st.instantiateViewController(withIdentifier: "AdsFull") as! AdsFull
        vc.ads_id = ads_id
        vc.ads_type = ads_type
        vc.adsClose = adsClose
        
        return vc
    }
    
    public override func show(_ vc: UIViewController, sender: Any?) {
        vc.present(self, animated: false, completion: nil)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        
         timecount = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.timeEnd), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadAds), userInfo: nil, repeats: false)
//        self.loadAds()
    }
    
    @objc public func loadAds(){
        if ads_type == .facebook{
            facebookFull = FBInterstitialAd(placementID: ads_id)
            facebookFull.delegate = self
            facebookFull.load()
            
        }else if ads_type == .admob{
            admobFull = GADInterstitial(adUnitID: ads_id)
            admobFull.delegate = self
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            admobFull.load(request)
        }else if ads_type == .smads{
            smFull = SMInterstitial()
            smFull.rootViewController = self
            smFull.delegate = self
            smFull.load()

        }
    }
    public func interstitialError() {
        timecount.invalidate()
        self.dismiss(animated: false, completion: nil)
        if self.adsClose != nil{
            self.adsClose()
        }
    }
    public func interstitialDidClick() {
        
    }
    public func interstitialCloseClick() {
        timecount.invalidate()
        self.dismiss(animated: false, completion: {
            
        })
        if self.adsClose != nil{
            self.adsClose()
        }
    }
    public func interstitialLoaded(interstitial: SMInterstitial) {
        self.isShow = true
        timecount.invalidate()
        self.smFull.show()
    }
    public func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        
        self.isShow = true
        timecount.invalidate()
        facebookFull.show(fromRootViewController: self)
    }
    
    public func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      
        self.isShow = true
        timecount.invalidate()
        admobFull.present(fromRootViewController: self)
    }
    
    public func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        timecount.invalidate()
        self.dismiss(animated: false, completion: {
            
        })
        if self.adsClose != nil{
            self.adsClose()
        }
        
    }
    
    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        timecount.invalidate()
        self.dismiss(animated: false, completion: {
//            let continueVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ContinueVC.className) as! ContinueVC
//            
//            UIApplication.shared.keyWindow?.rootViewController?.present(continueVC, animated: false, completion: nil)
        })
        
        if self.adsClose != nil{
            self.adsClose()
        }
        
    }
    
    public func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        timecount.invalidate()
        
        self.dismiss(animated: false, completion: nil)
        if self.adsClose != nil{
            self.adsClose()
        }
    }
    
    public func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        timecount.invalidate()
        self.dismiss(animated: false, completion: {
            if self.adsClose != nil{
                self.adsClose()
            }
        })
        
        
        
    }
    
    @objc func timeEnd() {
        timecount.invalidate()
        if !isShow{
            self.dismiss(animated: false, completion: nil)
            
            if self.adsClose != nil{
                self.adsClose()
                
            }
            
        }
    }
}
