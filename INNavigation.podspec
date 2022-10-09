Pod::Spec.new do |spec|
  spec.name         = "INNavigation"
 spec.version = "1.0.2" # auto-generated
 spec.swift_versions = ['5.6'] # auto-generated
  spec.summary      = "A navigation helper build on top of SwiftUI's new NavigationView feature."
  spec.homepage     = "https://github.com/indieSoftware/INNavigation"
  spec.author       = { "Sven Korset" => "sven.korset@indie-software.com" }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.ios.deployment_target = "15.0"
  spec.source       = { :git => "https://github.com/indieSoftware/INNavigation.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/INNavigation/**/*.{swift}"
  spec.module_name   = 'INNavigation'
  spec.dependency 'INCommons'
end
