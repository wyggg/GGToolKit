#
# Be sure to run `pod lib lint GGToolKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name             = 'GGToolKit'
	s.version          = '1.0.5'
	s.summary          = '自用工具类.'

	# This description is used to generate tags and improve search results.
	#   * Think: What does it do? Why did you write it? What is the focus?
	#   * Try to keep it short, snappy and to the point.
	#   * Write the description between the DESC delimiters below.
	#   * Finally, don't worry about the indent, CocoaPods strips it!

	s.description      = <<-DESC
	TODO: Add long description of the pod here.
	DESC

	s.homepage         = 'https://github.com/wyggg/GGToolKit'
	# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'yg' => '773678819@qq.com' }
	s.source           = { :git => 'https://github.com/wyggg/GGToolKit.git', :tag => s.version.to_s }
	# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

	s.ios.deployment_target = '11.0'

	s.source_files = 'GGToolKit/Classes/**/*'

	# s.resource_bundles = {
	#   'GGTools' => ['GGTools/Assets/*.png']
	# }

	# s.public_header_files = 'Pod/Classes/**/*.h'
	s.frameworks = 'UIKit'
end
