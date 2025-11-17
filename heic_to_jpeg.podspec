#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint heic_to_jpeg.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'heic_to_jpeg'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to convert HEIC bytes to JPEG bytes.'
  s.description      = <<-DESC
A Flutter plugin to convert HEIC bytes to JPEG bytes on Android, iOS and Web.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'App Zone' => 'slavis.dev@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'ios/Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
