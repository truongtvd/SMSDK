
import UIKit
import StoreKit
public enum RateShow:String{
    case launchCountRate
    case done
    case fill
    
}
public var canShow = true
public class RateManager: NSObject {
    static public var shared:RateManager =  RateManager()
    
    public func rateLaunch(_ viewController:UIViewController,rateshow:RateShow){
        
        let currentCount = UserDefaults.standard.integer(forKey: rateshow.rawValue)
        print(currentCount)
        if currentCount == 2{
            if canShow{
                showRating(viewController,rateshow: rateshow)
                canShow = false
            }
        }else if currentCount == 5{
            if canShow{
                showRating(viewController,rateshow: rateshow)
                canShow = false
            }
        }else if currentCount == 8{
            if canShow{
                showRating(viewController,rateshow: rateshow)
                canShow = false
            }
        }
        UserDefaults.standard.set(currentCount+1, forKey:rateshow.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    
    public func rateDone(_ viewController:UIViewController,rateshow:RateShow){
        let currentCount = UserDefaults.standard.integer(forKey: rateshow.rawValue)
        if currentCount == 0{
            if canShow{
                showRating(viewController,rateshow: rateshow)
                canShow = false
            }
        }
        UserDefaults.standard.set(currentCount+1, forKey:rateshow.rawValue)
        UserDefaults.standard.synchronize()
    }
    public func rateFill(_ viewController:UIViewController,rateshow:RateShow){
        let currentCount = UserDefaults.standard.integer(forKey: rateshow.rawValue)
        if currentCount == 0{
            if canShow{
                showRating(viewController,rateshow: rateshow)
                canShow = false
            }
        }
        UserDefaults.standard.set(currentCount+1, forKey:rateshow.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    public func rateListen(_ viewController:UIViewController,rateshow:RateShow){
        let currentCount = UserDefaults.standard.integer(forKey: rateshow.rawValue)
        if currentCount == 9{
            if canShow{
                showRating(viewController,rateshow: rateshow)
                canShow = false
            }
        }
        UserDefaults.standard.set(currentCount+1, forKey:rateshow.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    public func showRating(_ viewController:UIViewController,rateshow:RateShow){
        if #available(iOS 10.3, *){
            let alert = UIAlertController(title: "Rate us", message: "Do you want rate me?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No, thanks", style: .default, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                SKStoreReviewController.requestReview()

                UserDefaults.standard.set(100, forKey:rateshow.rawValue)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(true, forKey: "notShowAgain")
                UserDefaults.standard.synchronize()
            }))
            viewController.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Rate us", message: "Do you want rate me?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No, thanks", style: .default, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + kAppId)
                UIApplication.shared.openURL(appStoreURL! as URL)
                UserDefaults.standard.set(100, forKey:rateshow.rawValue)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(true, forKey: "notShowAgain")
                UserDefaults.standard.synchronize()
            }))
            viewController.present(alert, animated: true, completion: nil)
        }
        print("showRate")

    }
}
