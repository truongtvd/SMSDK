
import UIKit

public enum keyUserDefault : String {
    //ads
    case ads
    case adsNotes
    case numberLaunchApps
    
    case removeAds
    
    //rate
    case numberOpenApp //rate app
    case numberNotReallyRateApp //rate app
    case launchApp
    
    //app
    case lastUrlAddress
    
    //settings
    case allowTouchID
    case passwd
    case sync
    case isShowExtension
    case isShowFavoritedFile
}

extension UserDefaults {
    class func save(_ value: Any,key:keyUserDefault){
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    class func plus(_ key:keyUserDefault){
        UserDefaults.save(UserDefaults.int(key) + 1, key: key)
    }
    class func plus(_ name:String){
        if let i = UserDefaults.standard.object(forKey: name) as? Int {
            UserDefaults.standard.set(i+1, forKey: name)
            UserDefaults.standard.synchronize()
        }else{
            UserDefaults.standard.set(1, forKey: name)
            UserDefaults.standard.synchronize()
        }
    }
    class func remove(_ key : keyUserDefault){
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    class func get(_ key : keyUserDefault)->Any?{
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    class func string(_ key : keyUserDefault)->String?{
        if let vl = UserDefaults.standard.string(forKey: key.rawValue) {
            return vl
        }else{
            return nil
        }
    }
    class func bool(_ key : keyUserDefault)->Bool{
        if let vl = UserDefaults.get(key) as? Bool {
            return vl
        }else{
            return false
        }
    }
    class func int(_ key : keyUserDefault)->Int{
        if let vl = UserDefaults.get(key) as? Int {
            return vl
        }else{
            return 0
        }
    }
    
    class func int(_ name : String)->Int{
        if let i = UserDefaults.standard.object(forKey: name) as? Int {
            return i
        }else{
            return 0
        }
    }
    
    
    class func clear(prefix:String) {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key.prefix(prefix.count) == prefix {
                defaults.removeObject(forKey: key)
            }
        }
        defaults.synchronize()
    }
    
    //encode
    class func saveObject(_ object : Any,key : keyUserDefault){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: object)
        self.save(encodedData, key: key)
    }
    class func getObject(_ key : keyUserDefault)->Any?{
        if let decoded  = self.get(key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: decoded)
        }else{
            return nil
        }
    }
}
