Pod::Spec.new do |s|
  s.name         = "TTLiveAgentWidget"
  s.version      = "0.1.2"
  s.summary      = "Live agent widget for iOS written in swift."
  s.homepage     = "https://github.com/tappytaps/TTLiveAgentWidget"
  s.license      = 'MIT'
  s.author       = {'TappyTaps s.r.o.' => 'http://tappytaps.com'}
  s.source       = { :git => 'https://github.com/tappytaps/TTLiveAgentWidget.git',  :tag => "#{s.version}"}
  s.ios.deployment_target = '8.0'
  s.requires_arc = 'true'
  s.source_files = 'Pod/Classes/**/*'
  s.resources = 'Pod/Resources/**/*.png'
end