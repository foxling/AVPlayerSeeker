Pod::Spec.new do |s|
  s.name     = 'AVPlayerSeeker'
  s.version  = '1.0'
  s.ios.deployment_target   = '8.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'AVPlayer seek smoothly to time'
  s.homepage = 'https://github.com/foxling/AVPlayerSeeker'
  s.author   = { 'foxling' => 'i.foxling@gmail.com' }
  s.requires_arc = true
  s.source   = {
    :git => 'https://github.com/foxling/AVPlayerSeeker.git',
    :branch => 'master',
    :tag => s.version.to_s
  }
  s.source_files = 'AVPlayerSeekToTime/Sources/*.swift'
  s.frameworks = 'AVFoundation'
end
