Pod::Spec.new do |s|
  s.name = 'AVPlayerSeeker'
  s.version = '1.0'
  s.summary = 'AVPlayer seek smoothly to time.'
  s.homepage = 'https://github.com/foxling/AVPlayerSeeker'
  s.license = 'MIT'
  s.platform = :ios, '8.0'
  s.author = 'LING YE'

  s.source = { :git => 'https://github.com/foxling/AVPlayerSeeker.git', :tag => '1.0' }
  s.source_files = 'AVPlayerSeekToTime/Sources/*.swift'

  s.frameworks = 'AVFoundation'
  s.requires_arc = true
end
