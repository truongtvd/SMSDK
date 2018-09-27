
import UIKit
import Alamofire
import GoogleMobileAds
import MagicMapper
public class AdsNetwork: NSObject {
    
    static public var shared: AdsNetwork = AdsNetwork()
    
    public func getAdsId(bundle_id:String,
                  complete:@escaping ()->Void,
                  failure:@escaping ()->Void){
        let params:[String:Any] = ["package_name":bundle_id]
        Alamofire.request("http://ads.appboom.co/v2/get.php" ,method: .get, parameters: params)
            .responseJSON {response in
                switch (response.result){
                case.success(let data):
                    let json = data as! KeyValue
//                    print(json)
                    if let error = json["error"] as? Int{
                        if error == 0{
                            if let data = json["data"] as? KeyValue{
                                let adsID = AdsId(data)
                                AdsManager.share.adsId = adsID
                                if AdsManager.share.getAppId(adsid: adsID) != ""{
                                    GADMobileAds.configure(withApplicationID: AdsManager.share.getAppId(adsid: adsID))
                                }
                            }
                        }
                    }
                    complete()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    failure()
                    break
            }
        }
    }
    public func getAdsConfig(bundle_id:String,
                  complete:@escaping ()->Void,
                  failure:@escaping ()->Void){
        let params:[String:Any] = ["package_name":bundle_id]
        Alamofire.request("http://nodedata.appboom.co/get.php" ,method: .get, parameters: params)
            .responseJSON {response in
                switch (response.result){
                case.success(let data):
                    let json = data as! KeyValue
//                     print(json)
                    if let error = json["error"] as? Int{
                        if error == 0{
                            if let data = json["data"] as? KeyValue{
                                AdsManager.share.addRate(rate: AdsRate(data))
                            }
                        }
                    }
                    complete()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    failure()
                    break
                }
        }
    }
    
    
}
