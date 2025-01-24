# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'MyColorMemoApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'RealmSwift', '~> 10.39'

  # Pods for MyColorMemoApp

  target 'MyColorMemoAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MyColorMemoAppUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name.start_with?('Realm')
        target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
          config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
          config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
      end
    end
  end
end
