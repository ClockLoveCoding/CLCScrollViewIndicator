Pod::Spec.new do |s|
  s.name             = 'CLCScrollViewIndicator'
  s.version          = '0.1.5'
  s.summary          = 'Custom scrollView Indicator.'

  s.description      = <<-DESC
  CLCScrollViewIndicator is a custom scrollView Indicator which can change the appearance and realize resident.
                       DESC

  s.homepage         = 'https://github.com/ClockLoveCoding/CLCScrollViewIndicator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'ClockLoveCoding'
  s.source           = { :git => 'https://github.com/ClockLoveCoding/CLCScrollViewIndicator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'CLCScrollViewIndicator/Classes/**/*'
end
