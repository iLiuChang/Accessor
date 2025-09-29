Pod::Spec.new do |s|
  s.name         = "Accessor"
  s.version      = "1.0.0"
  s.summary      = "NSBundleResourceRequest extension"
  s.homepage     = "https://github.com/iLiuChang/Accessor"
  s.license      = "MIT"
  s.authors      = { "iLiuChang" => "iliuchang@foxmail.com" }
  s.platform     = :ios, "13.0"
  s.source       = { :git => "https://github.com/iLiuChang/Accessor.git", :tag => s.version }
  s.requires_arc = true
  s.swift_version = "5.0"
  s.source_files = "Source/*.{swift}"
end
