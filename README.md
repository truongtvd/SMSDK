# SMSDK

[![CI Status](https://img.shields.io/travis/truongtvd/SMSDK.svg?style=flat)](https://travis-ci.org/truongtvd/SMSDK)
[![Version](https://img.shields.io/cocoapods/v/SMSDK.svg?style=flat)](https://cocoapods.org/pods/SMSDK)
[![License](https://img.shields.io/cocoapods/l/SMSDK.svg?style=flat)](https://cocoapods.org/pods/SMSDK)
[![Platform](https://img.shields.io/cocoapods/p/SMSDK.svg?style=flat)](https://cocoapods.org/pods/SMSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
```ruby
xcode 9
ios 9.0
Swift 4.0
```
## Installation

SMSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod 'SMSDK', :git => 'https://github.com/truongtvd/SMSDK.git'
```
## Example

Full with silder
```ruby
let smfull = SMInterstitial()
smfull.rootViewController = self
smfull.slider = true
smfull.delegate = self
smfull.load()
```
Delegate
```ruby
func interstitialLoaded(interstitial:SMInterstitial)
func interstitialError()
func interstitialDidClick()
func interstitialCloseClick()
```

Dialog Cross Ads
```ruby
self.smnative = SMNativeAds()
self.smnative.delegate = self
self.smnative.load()
```
Delegate of SMNativeAds
```ruby
func naviteLoaded(navite: SMAds) {
//Native loaded

if AdsManager.share.adsRate.ad_dialog_start == 0 && AdsManager.share.adsRate.ad_dialog_loop == 0{
return
}
let alertQC = UIAlertController.init(title: navite.name, message: navite.desc, preferredStyle: .alert)
alertQC.addAction(UIAlertAction(title: "Download Now", style: .default, handler: { (action) in
let smnet = SMNetworkOpertator()
smnet.openLink(url: navite.link, success: { (json) in
if let link = json["link"] as? String{
let uri = URL.init(string: link)
if  uri?.scheme == "itms"{
UIApplication.shared.openURL(uri!)

}
}
}) { (error) in
self.dismiss(animated: true) {
}
}

}))
alertQC.addAction(UIAlertAction(title: "No, Thank you", style: .default, handler: { (action) in

}))
self.present(alertQC, animated: true, completion: nil)
}
```

## Author

truongtvd, truong@smartmove.vn

## License

SMSDK is available under the MIT license. See the LICENSE file for more info.
