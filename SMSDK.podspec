#
# Be sure to run `pod lib lint SMSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SMSDK'
  s.version          = '0.1.2'
  s.summary          = 'A short description of SMSDK.'
  s.swift_version    = '4.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This description is used to generate tags and improve search results'

  s.homepage         = 'https://github.com/truongtvd/SMSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'truongtvd' => 'truong@smartmove.vn' }
  s.source           = { :git => 'https://github.com/truongtvd/SMSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Classes/Classes/**/*'
  # s.resource_bundles = {
  #   'SMSDK' => ['SMSDK/Assets/*.png']
  # }
  s.static_framework = true
#  s.public_header_files = 'Classes/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.ios.dependency 'Alamofire'
  s.ios.dependency 'MagicMapper'
  s.ios.dependency 'FBAudienceNetwork'
  s.ios.dependency 'Google-Mobile-Ads-SDK'
end
