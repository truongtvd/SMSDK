

import UIKit
import MagicMapper
public enum RateConfig: String{
    
    case banner_home
    case banner_gray_color
    case banner_filter
    case start_cam_click_full
    case loop_cam_click_full
    case start_library_click_full
    case loop_library_click_full
    case start_next_click_full
    case loop_next_click_full
    case start_save_click_full
    case loop_save_click_full
    case ad_dialog_start
    case ad_dialog_loop
    case start_sm_ads
    case loop_sm_ads
    static func allCase()->[String]{
        var array:[String] = []
        for f in iterateEnum(RateConfig.self) {
            array.append(f.rawValue)
        }
        return array

    }

}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafePointer(to: &i) {
            $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
        }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}
@objcMembers
public class AdsRate: NSObject,Mappable {
    public var banner_home = 1
    public var banner_gray_color = 1
    public var banner_filter = 1
    public var start_cam_click_full = 3
    public var loop_cam_click_full = 3
    public var start_library_click_full = 2
    public var loop_library_click_full = 2
    public var start_next_click_full = 2
    public var loop_next_click_full = 2
    public var start_save_click_full = 2
    public var loop_save_click_full = 2
    public var ad_dialog_start = 0
    public var ad_dialog_loop = 0
    public var start_sm_ads = 0
    public var loop_sm_ads = 0
}
