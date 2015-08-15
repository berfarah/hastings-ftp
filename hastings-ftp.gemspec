# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "hastings-ftp"
  spec.version       = "0.0.1"
  spec.authors       = ["Bernardo Farah"]
  spec.email         = ["ber@bernardo.me"]

  spec.summary       = "FTP protocol implemented for Hastings"
  spec.description   = "Integrates interaction with FTP into Hastings, using "\
                       "familiar APIs"
  spec.homepage      = "http://github.com/berfarah/hastings-ftp"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "yard", "~> 0.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
