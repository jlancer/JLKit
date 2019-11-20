#
#  Be sure to run `pod spec lint JLKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name         = 'JLKit'
    s.version      = '0.0.1'
    s.summary      = '基于Cocoa Framework的一组常用以及通用组件和方法'
    s.homepage     = 'https://github.com/jlancer/JLKit'
    s.license      = 'MIT'
    s.authors      = {'jlancer' => 'j_lancer@163.com'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://github.com/jlancer/JLKit.git', :tag => s.version}
    s.requires_arc = true

    s.subspec 'JLCategory' do |ss|
        ss.source_files = 'JLKit/Classes/JLCategory/**/*.{h,m,mm,c}'
        ss.requires_arc = false
        ss.requires_arc = ['JLKit/Classes/JLCategory/**/*.{m,mm}']
        ss.frameworks   = 'Foundation'
        ss.frameworks   = 'UIKit'
        ss.frameworks   = 'CoreText'
        ss.frameworks   = 'QuartzCore'
        ss.frameworks   = 'AdSupport'
        ss.frameworks   = 'SystemConfiguration'
        ss.dependency     'Typeset'
    end

    s.subspec 'JLController' do |ss|
        ss.source_files = 'JLKit/Classes/JLController/**/*.{h,m,mm,c}'
        ss.frameworks   = 'Foundation'
        ss.frameworks   = 'UIKit'
        ss.frameworks   = 'JavaScriptCore'
        ss.frameworks   = 'WebKit'
        ss.frameworks   = 'SafariServices'
        ss.dependency     'SDWebImage'
        ss.dependency     'BlocksKit'
        ss.dependency     'JLKit/JLCategory'
    end

    s.subspec 'JLLBS' do |ss|
        ss.source_files = 'JLKit/Classes/JLLBS/**/*.{h,m,mm,c}'
        ss.resources    = 'JLKit/Classes/JLLBS/**/*.{png,jpg,json,plist,xib,bundle}'
        ss.frameworks   = 'Foundation'
        ss.frameworks   = 'UIKit'
        ss.frameworks   = 'CoreLocation'
        ss.frameworks   = 'MapKit'
    end

    s.subspec 'JLNetwork' do |ss|
        ss.source_files = 'JLKit/Classes/JLNetwork/**/*.{h,m,mm,c}'
        ss.frameworks   = 'Foundation'
        ss.frameworks   = 'CoreTelephony'
        ss.frameworks   = 'SystemConfiguration'
        ss.libraries    = 'resolv.9'
        ss.dependency     'AFNetworking'
    end

    s.subspec 'JLStorage' do |ss|
        ss.source_files = 'JLKit/Classes/JLStorage/**/*.{h,m,mm,c}'
        ss.frameworks   = 'Foundation'
        ss.dependency     'YYModel'
        ss.dependency     'JSONModel'
        ss.dependency     'MJExtension'
    end

    s.subspec 'JLWidget' do |ss|
        ss.source_files = 'JLKit/Classes/JLWidget/**/*.{h,m,mm,c}'
        ss.resources    = 'JLKit/Classes/JLWidget/**/*.{png,jpg,json,plist,xib,bundle,gif}'
        ss.frameworks   = 'Foundation'
        ss.frameworks   = 'UIKit'
        ss.frameworks   = 'ImageIO'
        ss.frameworks   = 'QuartzCore'
        ss.dependency     'SDWebImage'
        ss.dependency     'FLAnimatedImage'
        ss.dependency     'Masonry'
        ss.dependency     'BlocksKit'
        ss.dependency     'MJRefresh'
        ss.dependency     'CHTCollectionViewWaterfallLayout'
        ss.dependency     'UICollectionViewLeftAlignedLayout'
        ss.dependency     'JLKit/JLCategory'
    end

end
