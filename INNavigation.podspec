Pod::Spec.new do |spec|
  spec.name         = "INNavigation"
  spec.version = "1.0.0" # auto-generated
  spec.swift_versions = ['5.6'] # auto-generated
  spec.summary      = "TODO: Provide lib's summary."
  spec.description  = <<-DESC
  Library INNavigation
  DESC
  spec.homepage     = "https://github.com/indieSoftware/INNavigation"
  spec.license      = 'MIT'
  spec.author       = { "Sven Korset" => "sven.korset@indie-software.com" }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.ios.deployment_target = "15.0"
  spec.source       = { :git => "https://github.com/indieSoftware/INNavigation.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/INNavigation/**/*.{swift}"
  spec.module_name   = 'INNavigation'
end
