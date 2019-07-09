Pod::Spec.new do |spec|

  spec.name                   = "CBHMemoryKit"
  spec.version                = "1.0.0"
  spec.module_name            = "CBHMemoryKit"

  spec.summary                = "A safer and easy-to-use interface for managing and manipulating memory."
  spec.homepage               = "https://github.com/chris-huxtable/CBHRandomKit"

  spec.license                = { :type => "ISC", :file => "LICENSE" }

  spec.author                 = { "Chris Huxtable" => "chris@huxtable.ca" }
  spec.social_media_url       = "https://twitter.com/@Chris_Huxtable"

  #spec.ios.deployment_target = '9.0'
  spec.osx.deployment_target  = '10.10'

  spec.source                 = { :git => "https://github.com/chris-huxtable/CBHMemoryKit.git", :tag => "v#{spec.version}" }

  spec.requires_arc           = false

  spec.public_header_files    = 'CBHMemoryKit/*.h'
  spec.source_files           = "CBHMemoryKit/*.{h,m}"

end
