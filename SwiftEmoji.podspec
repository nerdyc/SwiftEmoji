Pod::Spec.new do |spec|
  spec.name = "SwiftEmoji"
  spec.version = "1.0.0"
  spec.summary = "Emoji regular expressions in Swift."
  spec.homepage = "https://github.com/nerdyc/SwiftEmoji"
  spec.license = { type: 'MIT', file: 'LICENSE.txt' }
  spec.authors = { "Christian Niles" => 'christian@nerdyc.com' }
  spec.social_media_url = "http://twitter.com/nerdyc"

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'
  spec.tvos.deployment_target = '9.0'
  spec.watchos.deployment_target = '2.0'
    
  spec.source = { git: "https://github.com/nerdyc/SwiftEmoji.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "Sources/*.swift"
end