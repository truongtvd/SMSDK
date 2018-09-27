

import UIKit
import MagicMapper
@objc protocol SMNativeDelegate {
    @objc optional func naviteLoaded(navite:SMAds)
    @objc optional func nativeLoadListed(natives:[SMAds])
    @objc optional func naviteError()
}
class SMNativeAds: NSObject {
    var smAds:SMAds!
    private let  network:SMNetworkOpertator = SMNetworkOpertator()
    var isLoad:Bool = false
    var delegate:SMNativeDelegate!
    
    func load(){
        network.getNative(success: { (json) in
            self.smAds = SMAds(json)
            self.isLoad = true
            if self.delegate != nil{
                self.delegate.naviteLoaded?(navite: self.smAds)
            }
            
        }, failure: { (error) in
            print(error)
            self.isLoad = false
            
            if self.delegate != nil{
                self.delegate.naviteError?()
            }
        })
    }
    func loadList(){
        network.getNativeList(success: { (json) in
            if let code =  json["code"] as? Int{
                if code == 100{
                    let data = json["data"] as? [KeyValue]
                    if data != nil{
                        var arrayAds:[SMAds] = []
                        for item in data!{
                            let sm = SMAds(item)
                            arrayAds.append(sm)
                            
                        }
                        self.isLoad = true

                        if self.delegate != nil{
                            self.delegate.nativeLoadListed?(natives: arrayAds)
                        }
                    }else{
                        self.isLoad = false
                        if self.delegate != nil{
                            self.delegate.naviteError?()
                        }
                    }
                }else{
                    self.isLoad = false
                    if self.delegate != nil{
                        self.delegate.naviteError?()
                    }
                }
                
            }else{
                self.isLoad = false
                if self.delegate != nil{
                    self.delegate.naviteError?()
                }
            }
            
            
        }, failure: { (error) in
            print(error)
            self.isLoad = false
            
            if self.delegate != nil{
                self.delegate.naviteError?()
            }
        })
    }
    
    
}
