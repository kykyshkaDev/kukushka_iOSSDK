Pod::Spec.new do |s|
  s.name             = 'Kukushka_iOSSDK'
  s.version          = '1.0.0'
  s.summary          = 'Survey'
  s.homepage         = 'https://github.com/kykyshkaDev/kukushka_iOSSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Kukushka" => "https://kykyshka.ru/games" }
  s.source           = { :git => 'https://github.com/kykyshkaDev/kukushka_iOSSDK.git', :tag => s.version.to_s }
  s.social_media_url = ""
  s.ios.deployment_target = '13.0'
  s.source_files  = 'Sources/**/*.{swift,h,m}'
  s.frameworks = '', ''
  s.swift_version     = "5.0"
end
