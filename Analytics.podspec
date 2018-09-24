Pod::Spec.new do |s|
    s.name            = "Analytics"
    s.version         = "0.9.8.3"
    s.summary         = "Samba modified Segment.io analytics and marketing tools library for iOS. Removed dependence on segment.io dashboard and services."
    s.homepage        = "https://github.com/SambaTVMobile/analytics-ios"
    s.license         = { :type => "MIT", :file => "License.md" }
    s.author          = { "Segment.io" => "friends@segment.io" }
    s.source          = { :http => "https://github.com/PChmiel/analytics-ios/releases/download/0.9.8.3/Analytics.zip", :flatten => true }
    s.platform        = :ios, '6.0'
    s.vendored_frameworks  = 'Analytics.framework'
    s.frameworks      = 'Foundation', 'UIKit', 'CoreData', 'SystemConfiguration',
    'QuartzCore', 'CFNetwork', 'AdSupport', 'CoreTelephony', 'Security', 'CoreGraphics'
    s.libraries       = 'sqlite3', 'z'
    s.xcconfig        = { 'OTHER_LDFLAGS' => '-ObjC' }
end
