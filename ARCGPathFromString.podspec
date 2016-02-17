#
# Be sure to run `pod lib lint ARCGPathFromString.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ARCGPathFromString"
  s.version          = "1.0.0"
  s.summary          = "Takes in an NSString or NSAttributedString and creates a CGPathRef for that string." 
  s.description      = "This CocoaPod provides methods for creating CGPaths from NSStrings and NSAttributedStrings. A category for UIBezierPath also allows UIBezierPaths to be produced from strings."

  s.homepage         = "https://github.com/aderussell/string-to-CGPathRef"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Adrian Russell" => "adrianrussell@me.com" }
  s.source           = { :git => "https://github.com/aderussell/string-to-CGPathRef.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ade177'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'ARCGPathFromString/*'
  s.resource_bundles = {
    'ARCGPathFromString' => ['Pod/Assets/*.png']
  }
  s.frameworks = 'Foundation', 'CoreText'
end
