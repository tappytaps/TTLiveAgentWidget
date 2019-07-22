Pod::Spec.new do |s|
  s.name         = "TTLiveAgentWidget"
  s.version      = "0.1.2"
  s.summary      = "Live agent widget for iOS written in swift."
  s.homepage     = "https://github.com/tappytaps/TTLiveAgentWidget"
  s.license      = 'MIT'
  s.author       = {'TappyTaps s.r.o.' => 'http://tappytaps.com'}
  s.source       = { :git => 'https://github.com/tappytaps/TTLiveAgentWidget.git',  :tag => "#{s.version}"}
  s.ios.deployment_target = '10.0'
  s.source_files = 'Sources/**/*'
end