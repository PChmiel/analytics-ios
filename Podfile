
def pods
    pod 'Amplitude-iOS', '~> 2.0.0'
    pod 'Bugsnag', '~> 3.1.0.fork'
    pod 'Countly'
    pod 'CrittercismSDK'
    pod 'FlurrySDK', '~> 4.3.2'
    pod 'GoogleAnalytics-iOS-SDK', '~> 3.0.3c'
    pod 'Localytics-iOS-Client', '~> 2.21.0'
    pod 'Mixpanel', '~> 2.3.2'
    pod 'Tapstream', '~> 2.6'
end

target 'Analytics' do
pods
end

target :AnalyticsTests do
    pods
    pod 'Kiwi', '~> 2.2.3'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
    end
end
