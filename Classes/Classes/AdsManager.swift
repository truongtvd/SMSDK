
import UIKit
import MagicMapper

public class AdsManager: NSObject {
    static public var share:AdsManager = AdsManager()
    let _count = "_count"
    var adsId:AdsId = AdsId()
    var adsRate:AdsRate = AdsRate()
    //get ads
    func getAdsAndNote(complete:@escaping ()->Void){
        AdsNetwork.shared.getAdsId(bundle_id: Bundle.main.bundleIdentifier!, complete: {
            AdsNetwork.shared.getAdsConfig(bundle_id: Bundle.main.bundleIdentifier!, complete: {
                complete()
            }, failure: {
                complete()
            })
        }) {
            //loi
            complete()
        }
        
    }
    func smNative(_ vc:UIViewController, loadAd: @escaping ()-> Void){ //template 1
        UserDefaults.plus(.numberLaunchApps)
        
        let start = adsRate.ad_dialog_start
        let loop = adsRate.ad_dialog_loop
        
        if UserDefaults.int(.numberLaunchApps) == adsRate.ad_dialog_start {
//            self.smNative = SMNativeAds()
//            self.smNative?.delegate = self
//            self.smNative?.load()
            loadAd()

        }else{
            if start == 0 || loop == 0{
                
            }else if UserDefaults.int(.numberLaunchApps) % (start + loop) == 0,
                UserDefaults.int(.numberLaunchApps) > 0 {
                
                UserDefaults.save(adsRate.ad_dialog_start, key: .numberLaunchApps)
//                self.smNative = SMNativeAds()
//                self.smNative?.delegate = self
//                self.smNative?.load()
                loadAd()
            }else{
                
            }
        }
    }
    
    //reset lai toan bo gia tri rate cua ads, va duoc goi khi ung dung duoc khoi tao
    func rateDefault(){
        let userDefault = UserDefaults.standard
        let adsRate = AdsRate()
        let mirrored_object = Mirror(reflecting: adsRate)
        for  attr in mirrored_object.children {
            if let property_name = attr.label as String! {
                userDefault.set( Int.init(from: attr.value), forKey: property_name)
                userDefault.synchronize()
            }
        }
        for item in RateConfig.allCase(){
            UserDefaults.standard.set(1, forKey: item + _count)
            UserDefaults.standard.synchronize()
            
        }
    }
    
    func getAppId(adsid: AdsId)->String{
        let mirrored_object = Mirror(reflecting: adsid)
        for  attr in mirrored_object.children {
            if let json = attr.value as? KeyValue{
                let app_id = json["app_id"] as! String
                return app_id
            }

        }
        return ""
    }
    
    
    
    //khi lay duoc config moi tu server
    func addRate(rate:AdsRate!) {
        adsRate = rate
        let userDefault = UserDefaults.standard
        let mirrored_object = Mirror(reflecting: adsRate)
        for  attr in mirrored_object.children {
            if let property_name = attr.label as String! {
                print("\(property_name) : \(attr.value)")
                userDefault.set( Int.init(from: attr.value), forKey: property_name)
                userDefault.synchronize()
            }
        }
    }
    
    func showBanner(ads:Ads,rateConfig : RateConfig) -> Bool {
        let userDefault = UserDefaults.standard
        let bannerStatus = userDefault.integer(forKey: rateConfig.rawValue)
        if bannerStatus > 0 && ads.ads_id != "" && ads.status == 1{
            return true
        }
        return false
    }
    
    func countAddNativeAds(rateConfig : RateConfig) -> Int {
        let userDefault = UserDefaults.standard
        let bannerStatus = userDefault.integer(forKey: rateConfig.rawValue)
        return bannerStatus
    }
    func showNativeAds(rateConfig : RateConfig) -> String {
        let ads = adsId.native_advanced
        let userDefault = UserDefaults.standard
        let bannerStatus = userDefault.integer(forKey: rateConfig.rawValue)
        if bannerStatus > 0 && ads.ads_id != "" && ads.status == 1 && ads.network == "admob"{
            return "admob"
        }else if bannerStatus > 0 && ads.ads_id != "" && ads.status == 1 && ads.network == "facebook"{
            return "facebook"
        }
        return "none"
    }
    func showStartLoopFull(_ viewcontroller: UIViewController,
                           ads:Ads,
                           rateStartConfig: RateConfig,
                           rateLoopConfig:RateConfig,
                           complete:@escaping ()->Void){
        let userDefault = UserDefaults.standard
        
        let start = userDefault.integer(forKey: rateStartConfig.rawValue)
        let loop = userDefault.integer(forKey: rateLoopConfig.rawValue)
        
        let startCount = userDefault.integer(forKey: rateStartConfig.rawValue + _count)
        let loopCount = userDefault.integer(forKey: rateLoopConfig.rawValue + _count)
        
        if startCount > start{
            //thuc hien check loop
            if loopCount == loop{
                resetCount(key: rateLoopConfig.rawValue + _count)
                //hien thi quang cao va complete
                if ads.network == "admob" && ads.status == 1 && ads.ads_id != ""{
                    let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .admob, adsClose: {
                    complete()
                    })
                    adsFull.show(viewcontroller, sender: nil)
                }else if ads.network == "facebook" && ads.status == 1 && ads.ads_id != ""{
                    let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .facebook, adsClose: {
                        complete()
                    })
                    adsFull.show(viewcontroller, sender: nil)
                }else if ads.network == "smads" && ads.status == 1{
                    let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .smads, adsClose: {
                        complete()
                    })
                    adsFull.show(viewcontroller, sender: nil)

                }else{
                    complete()
                }
            }else{
                plusCount(key: rateLoopConfig.rawValue + _count, value: loopCount)
                complete()
            }
        }else{
            //check show start
            if startCount == start{
                plusCount(key: rateStartConfig.rawValue + _count, value: startCount)
                //hien thi quang cao va complete
                if ads.network == "admob" && ads.status == 1 && ads.ads_id != ""{
                    let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .admob, adsClose: {
                        complete()
                    })
                    adsFull.show(viewcontroller, sender: nil)
                }else if ads.network == "facebook" && ads.status == 1 && ads.ads_id != ""{
                    let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .facebook, adsClose: {
                        complete()
                    })
                    adsFull.show(viewcontroller, sender: nil)
                }else if ads.network == "smads" && ads.status == 1{
                    let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .smads, adsClose: {
                        complete()
                    })
                    adsFull.show(viewcontroller, sender: nil)

                }else{
                    complete()
                }
                
            }else{
                plusCount(key: rateStartConfig.rawValue + _count, value: startCount)
                complete()
                
            }
        }
    }
    
    
    func showFull(_ viewcontroller: UIViewController,
                  ads:Ads,
                  rateConfig: RateConfig,
                  complete:@escaping ()->Void){
        let userDefault = UserDefaults.standard
        let start = userDefault.integer(forKey: rateConfig.rawValue)
        let startCount = userDefault.integer(forKey: rateConfig.rawValue + _count)
        if startCount == start{
            //thuc hien check loop
            resetCount(key: rateConfig.rawValue + _count)
            //hien thi quang cao va complete
            if ads.network == "admob" && ads.status == 1 && ads.ads_id != ""{
                let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .admob, adsClose: {
                    complete()
                })
                adsFull.show(viewcontroller, sender: nil)
            }else if ads.network == "facebook" && ads.status == 1 && ads.ads_id != ""{
                let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .facebook, adsClose: {
                    complete()
                })
                adsFull.show(viewcontroller, sender: nil)
            }else if ads.network == "smads" && ads.status == 1{
                let adsFull = AdsFull.getInstant(ads_id: ads.ads_id, ads_type: .smads, adsClose: {
                    complete()
                })
                adsFull.show(viewcontroller, sender: nil)
                
            }else{
                complete()
            }
            
        }else{
            plusCount(key: rateConfig.rawValue + _count, value: startCount)
            complete()
            
        }
    }
    func plusCount(key:String,value:Int){
        UserDefaults.standard.set(value + 1, forKey: key)
        UserDefaults.standard.synchronize()
    }
    func resetCount(key:String)  {
        UserDefaults.standard.set(1, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
}
