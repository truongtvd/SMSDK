

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
    var banner_home = 1
    var banner_gray_color = 1
    var banner_filter = 1
    var start_cam_click_full = 3
    var loop_cam_click_full = 3
    var start_library_click_full = 2
    var loop_library_click_full = 2
    var start_next_click_full = 2
    var loop_next_click_full = 2
    var start_save_click_full = 2
    var loop_save_click_full = 2
    var ad_dialog_start = 0
    var ad_dialog_loop = 0
    var start_sm_ads = 0
    var loop_sm_ads = 0
}
