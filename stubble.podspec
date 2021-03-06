Pod::Spec.new do |s|
  s.name                  = "stubble"
  s.version               = "1.0.2"
  s.summary               = "An iOS mocking framework in the spirit of Mockito."
  s.homepage              = "https://github.com/Stubble/stubble"
  s.documentation_url     = "http://stubble.github.io"
  s.license               = { :type => 'MIT license', :file => 'license.txt' }
  s.authors               = 'JARinteractive', 'micahhainline', 'thejonhall', 'johnhainline'
  s.platform              = :ios
  s.ios.deployment_target = "6.0"
  s.source                = { :git => "https://github.com/Stubble/stubble.git", :tag => 'Release_1.0.2' }
  s.source_files          = "Stubble/**/*.{h,m}"
  s.xcconfig              = { 'OTHER_LDFLAGS' => '-lObjC' }
  s.requires_arc          = true
end
