source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '15.0'
use_frameworks!
workspace 'INNavigation'

# Pods used for development only.
def development_pods
  # A linter to gather code metrics and enforce Swift style and conventions.
  # https://github.com/realm/SwiftLint
  # License: MIT
  pod 'SwiftLint'

  # Formats the Swift code to be consistent with the coding style guidelines.
  # https://github.com/nicklockwood/SwiftFormat
  # License: MIT
  pod 'SwiftFormat/CLI'
end

def lib_pods
  # This library provides common functionalities for every iOS app.
  # https://github.com/indieSoftware/INCommons
  # License: MIT
  pod 'INCommons'
end

target 'INNavigation' do
  development_pods
  lib_pods
end

target 'INNavigationExample' do
  development_pods
end

# Post install

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Ignore any warnings from pods.
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
      config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = "YES"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = "15.0"
    end
  end
end



