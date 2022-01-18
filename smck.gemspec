# frozen_string_literal: true

require_relative 'lib/smck/version'

Gem::Specification.new do |spec|
  spec.name = 'smck'
  spec.version = Smck::VERSION
  spec.authors = ['Patrick Reader']
  spec.email = ['_@pxeger.com']
  spec.license = 'AGPL-3.0-only'

  spec.summary = 'Semantic Markup and Content Kit'
  spec.description = <<~'END DESCRIPTION'
    Smck (Semantic Markup and Content Kit, pronounced like "smack") is a markup system designed for consistent ease-of-use and extensibility.

    Smck uses a YAML-based syntax to describe a Lispy markup DSL which renders content to semantic HTML.
  END DESCRIPTION
  spec.homepage = 'https://github.com/pxeger/smck'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/pxeger/smck'

  # `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.0'
  spec.add_dependency 'psych', '~> 3.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
