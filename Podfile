# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'
workspace 'converterapp.xcworkspace'

use_frameworks!

def shared_pods
  pod 'Alamofire'
  pod 'FirebaseAnalytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/RemoteConfig'
  pod 'FirebaseAuth'
  pod 'Swinject'
end

target 'converterapp' do
  xcodeproj 'converterapp'
  pod 'SwiftGen', '~> 6.0'
  pod 'Charts', '~> 4.1.0'
  shared_pods
end

target 'converterappCore' do
  xcodeproj 'Modules/converterappCore/converterappCore.xcodeproj'
  shared_pods
end
