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

## Author

truongtvd, truong@smartmove.vn

## License

SMSDK is available under the MIT license. See the LICENSE file for more info.
