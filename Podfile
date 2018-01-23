use_frameworks!

platform :ios, '10.0'

target 'ImitationTown' do
    pod 'RxSwift',    '3.0.0-rc.1'
    pod 'RxCocoa',    '3.0.0-rc.1'
    pod 'SnapKit',    '~> 3.0.2'
    pod 'Kingfisher', '~> 3.1.3'
    pod 'Gifu'
    pod 'Alamofire', '~> 4.0.1'
    pod 'HandyJSON', '~> 1.6.1'
    pod 'SVProgressHUD'
    pod 'AMap3DMap'
    pod 'AMapLocation'
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end

