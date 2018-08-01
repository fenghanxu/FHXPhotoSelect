#
# Be sure to run `pod lib lint FHXPhotoSelect.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FHXPhotoSelect'
  s.version          = '0.1.2'
  s.summary          = 'A short description of FHXPhotoSelect.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fenghanxu/FHXPhotoSelect'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fenghanxu' => '1162851277@qq.com' }
  s.source           = { :git => 'https://github.com/fenghanxu/FHXPhotoSelect.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.public_header_files = ["Sources/FHXPhotoSelect.h"]
  s.source_files = ["Sources/**","Sources/*/**","Sources/*/*/**"]

  s.resource_bundles = {
    'Asserts' => ['Asserts.bundle/*.png']
  }

  s.requires_arc = true

  s.frameworks = 'UIKit','Photos'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.2' }

end
