import Foundation
import Alamofire
import MagicMapper
import AdSupport

public var testBundle = Bundle.main.bundleIdentifier!

public class SMNetworkOpertator{
    private var orientation = ""
    private var device_type = "iphone"
    var baseParam:[String:Any]!
    
    
    public init() {
        if UIDevice.current.orientation.isLandscape {
            orientation = "landscape"
        }else{
            orientation = "portrait"
        }
        if UIDevice.current.userInterfaceIdiom == .pad{
            device_type = "ipad"
        }else{
            device_type = "iphone"
        }
        baseParam = ["package_name":testBundle,
            "lang":NSLocale.preferredLanguages[0],
            "location":(Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? "",
            "orientation":orientation,
            "device_type":device_type,
            "ios_version":"\(UIDevice.current.systemVersion)",
            "ifa":"\(ASIdentifierManager.shared().advertisingIdentifier.uuidString)",
            "uuid":"\((UIDevice.current.identifierForVendor?.uuidString)!)",
            "system":"ios",
            "sdk_version":"1.0"]
//        print(baseParam)
    }
    public func getResponse(_ url:String ,success:@escaping (KeyValue) -> Void,failure:@escaping (Error) -> Void){
        Alamofire.request(url)
            .responseJSON {response in
                switch (response.result){
                case.success(let data):
                    success(data as! KeyValue)
                    
                    break
                    
                case .failure(let error):
                    failure(error)
                    break
                }
                
        }
    }
    
    public func getBanner(success:@escaping (KeyValue) -> Void,failure:@escaping (Error) -> Void){
        var params:[String:Any] = baseParam
        params.updateValue("banner", forKey: "ad_format")
        print(params)
        Alamofire.request(kUrl,method: .get, parameters: params)
            .responseJSON {response in
                switch (response.result){
                case.success(let data):
                    success(data as! KeyValue)
                    
                    break
                    
                case .failure(let error):
                    failure(error)
                    break
                }
                
        }
    }
    public func getFull(type:String,success:@escaping (KeyValue) -> Void,failure:@escaping (Error) -> Void){
        var params:[String:Any] = baseParam
        params.updateValue(type, forKey: "ad_format")
        Alamofire.request(kUrl,method: .get, parameters: params)
            .responseJSON {response in
                switch (response.result){
                case.success(let data):
                    success(data as! KeyValue)
                    
                    break
                    
                case .failure(let error):
                    failure(error)
                    break
                }
                
        }
    }
    public func getNative(success:@escaping (KeyValue) -> Void,failure:@escaping (Error) -> Void){
        var params:[String:Any] = baseParam
        params.updateValue("native", forKey: "ad_format")
        Alamofire.request(kUrl,method: .get, parameters: params)
            .responseJSON {response in
                switch (response.result){
                case.success(let data):
                    success(data as! KeyValue)
                    
                    break
                    
                case .failure(let error):
                    failure(error)
                    break
                }
                
        }
    }
    public func getNativeList(success:@escaping (KeyValue) -> Void,failure:@escaping (Error) -> Void){
        var params:[String:Any] = baseParam
        params.updateValue("native_list", forKey: "ad_format")
        Alamofire.request(kUrl,method: .get, parameters: params)
            .responseJSON {response in
                switch (response.result){
                case.success(let data):
                    success(data as! KeyValue)
                    
                    break
                    
                case .failure(let error):
                    failure(error)
                    break
                }
                
        }
    }
    public func openLink(url:String,success:@escaping (KeyValue) -> Void,failure:@escaping (Error) -> Void){
        
        Alamofire.request(url,method: .get, parameters: nil)
            .responseJSON {response in
                switch (response.result){
                case.success(let data):
                    success(data as! KeyValue)
                    
                    break
                    
                case .failure(let error):
                    failure(error)
                    break
                }
                
        }
    }
}
