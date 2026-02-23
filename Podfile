platform :ios, '17.0'

target 'InoxoftTT' do
  use_frameworks! :linkage => :static

  # Networking
  pod 'Alamofire', '~> 5.9'

  # Database
  pod 'RealmSwift', '~> 10.50'

  # Image Loading
  pod 'Kingfisher', '~> 7.12'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
