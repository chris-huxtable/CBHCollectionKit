Pod::Spec.new do |spec|

  spec.name                   = "CBHCollectionKit"
  spec.version                = "0.1.0"
  spec.module_name            = "CBHCollectionKit"

  spec.summary                = "A collection of easy-to-use  and safer primitive and object based collections."
  spec.homepage               = "https://github.com/chris-huxtable/CBHCollectionKit"

  spec.license                = { :type => "ISC", :file => "LICENSE" }

  spec.author                 = { "Chris Huxtable" => "chris@huxtable.ca" }
  spec.social_media_url       = "https://twitter.com/@Chris_Huxtable"

  #spec.ios.deployment_target = '9.0'
  spec.osx.deployment_target  = '10.10'

  spec.source                 = { :git => "https://github.com/chris-huxtable/CBHCollectionKit.git", :tag => "v#{spec.version}" }

  spec.requires_arc           = true

  spec.public_header_files    = 'CBHCollectionKit/**/*.h'
  spec.private_header_files   = 'CBHCollectionKit/**/_*.h'
  spec.source_files           = "CBHCollectionKit/*.{h,m}"

end
