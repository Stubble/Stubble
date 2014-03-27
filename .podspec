Pod::Spec.new do |spec|
  spec.name         = 'Stubble'
  spec.version      = '0.0.1'
  spec.license      =  :type => 'BSD' 
  spec.homepage     = 'https://github.com/SuperWes/stubble'
  spec.authors      =  'Jon Hall' => '' 
  spec.summary      = 'An iOS mocking framework in the spirit of Mockito.'
  spec.source       =  :git => 'https://github.com/SuperWes/stubble.git', :tag => 'v0.0.1' 
  spec.source_files = 'Stubble/*.{h,m}'
  spec.requires_arc = true
end

